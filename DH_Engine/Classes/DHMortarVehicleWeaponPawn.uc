//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHMortarVehicleWeaponPawn extends DHVehicleWeaponPawn
    abstract;

struct DigitSet
{
    var Material    DigitTexture;
    var IntBox      TextureCoords[11];
};

var     DHMortarVehicleWeapon   Mortar;       // just a reference to the mortar VW actor, for convenience & to avoid lots of casts

// Deploying, aiming & firing
var     class<DHMortarWeapon>   WeaponClass;  // the weapon class for the carried mortar inventory item
var     float       UndeployingDuration;      // needs literal as server doesn't have HUDOverlay actor & so can't use GetAnimDuration on it
var     bool        bTraversing;              // player is currently adjusting traverse aim
var     float       ElevationAdjustmentDelay; // seconds between individual elevation adjustments
var     float       LastElevationTime;        // records last time elevation was adjusted, so ElevationAdjustmentDelay can be applied
var     bool        bPendingFire;             // player has fired & mortar is about to fire

// Operator ('Driver') animations
const   IdleAnimIndex = 0;
const   FiringAnimIndex = 1;
const   UnflinchAnimIndex = 2;

var     name        DriverFiringAnim;         // anim for player operator when firing
var     name        DriverUnflinchAnim;       // anim for operator when returning to normal pose after flinching when firing
var     byte        CurrentAnimationIndex;    // index for current mortar & operator anims (set by owning client & replicated to server, which replicates to other clients)
var     byte        OldAnimationIndex;        // clientside record of last CurrentAnimationIndex, so net client can tell when server has replicated a new anim

// 1st person HUD overlay animations
var     name        OverlayIdleAnim;
var     name        OverlayFiringAnim;
var     name        OverlayKnobRaisingAnim;
var     name        OverlayKnobLoweringAnim;
var     name        OverlayKnobIdleAnim;
var     name        OverlayKnobTurnLeftAnim;
var     name        OverlayKnobTurnRightAnim;
var     name        OverlayUndeployingAnim;
var     float       OverlayKnobLoweringAnimRate;
var     float       OverlayKnobRaisingAnimRate;
var     float       OverlayKnobTurnAnimRate;

// HUD
var     texture     HUDArcTexture;           // the elevation display
var     TexRotator  HUDArrowTexture;         // indicator icon for current elevation
var     texture     HUDHighExplosiveTexture; // ammo icon for HE rounds
var     texture     HUDSmokeTexture;         // ammo icon for smoke rounds
var     DigitSet    Digits;                  // numerals for showing ammo count

// Clientside flags to do certain things when certain actors are received, to fix problems caused by replication timing issues
var     bool        bNeedToInitializeDriver;     // do some player set up when we receive the Driver actor
var     bool        bInitializedVehicleAndGun;   // done some set up when had received both the VehicleBase & Gun actors
var     bool        bNeedToStoreVehicleRotation; // set StoredVehicleRotation when we receive the VehicleBase actor

replication
{
    // Variables the server will replicate to all clients except the one that owns this actor
    reliable if (bNetDirty && !bNetOwner && Role == ROLE_Authority)
        CurrentAnimationIndex;

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerFire, ServerSetCurrentAnimationIndex, ServerUndeploying;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************* ACTOR INITIALISATION & KEY ENGINE EVENTS  *****************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified for net client to flag if bNeedToInitializeDriver
simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if (Role < ROLE_Authority && bDriving)
    {
        bNeedToInitializeDriver = true;
    }
}

// Modified to play animations on the mortar & operator, when a new value is received by net client, & to remove stuff not relevant to a mortar (as not multi-position)
// Matt: also to call set up functionality that requires the Vehicle, VehicleWeapon and/or player pawn actors (just after vehicle spawns via replication)
// This controls common and sometimes critical problems caused by unpredictability of when & in which order a net client receives replicated actor references
// Functionality is moved to series of Initialize-X functions, for clarity & to allow easy subclassing for anything that is vehicle-specific
simulated function PostNetReceive()
{
    // Need to play animations on the mortar & operator
    if (CurrentAnimationIndex != OldAnimationIndex)
    {
        OldAnimationIndex = CurrentAnimationIndex;
        PlayThirdPersonAnimations();
    }

    // Initialize anything we need to do from the VehicleWeapon actor, or in that actor
    if (!bInitializedVehicleGun)
    {
        if (Gun != none)
        {
            bInitializedVehicleGun = true;
            InitializeVehicleWeapon();
        }
    }
    // Fail-safe so if we somehow lose our Gun reference after initializing, we unset our flags & are then ready to re-initialize when we receive Gun again
    else if (Gun == none)
    {
        bInitializedVehicleGun = false;
        bInitializedVehicleAndGun = false;
    }

    // Initialize anything we need to do from the Vehicle actor, or in that actor
    if (!bInitializedVehicleBase)
    {
        if (VehicleBase != none)
        {
            bInitializedVehicleBase = true;
            InitializeVehicleBase();
        }
    }
    // Fail-safe so if we somehow lose our VehicleBase reference after initializing, we unset our flags & are then ready to re-initialize when we receive VehicleBase again
    else if (VehicleBase == none)
    {
        bInitializedVehicleBase = false;
        bInitializedVehicleAndGun = false;
    }

    // Fix 'driver' attachment position - on replication, AttachDriver() only works if client has received MortarVehicleWeapon actor, which it may not have yet
    // Client then receives Driver attachment & RelativeLocation through replication, but this is unreliable & sometimes gives incorrect positioning
    // As a fix, if player pawn has flagged bNeedToAttachDriver (meaning attach failed), we call AttachDriver() here
    if (bNeedToInitializeDriver && Driver != none && Gun != none)
    {
        bNeedToInitializeDriver = false;

        if (DHPawn(Driver) != none && DHPawn(Driver).bNeedToAttachDriver)
        {
            DetachDriver(Driver);
            AttachDriver(Driver);
            DHPawn(Driver).bNeedToAttachDriver = false;
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  *******************************  VIEW/DISPLAY  ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

simulated function SpecialCalcFirstPersonView(PlayerController PC, out actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local rotator WeaponAimRot;

    ViewActor = self;

    if (Gun != none)
    {
        WeaponAimRot = rotator(vector(Gun.CurrentAim) >> Gun.Rotation);
        WeaponAimRot.Roll = Gun.Rotation.Roll;

        // Custom aim update
        if (PC != none)
        {
            PC.WeaponBufferRotation.Yaw = WeaponAimRot.Yaw;
            PC.WeaponBufferRotation.Pitch = WeaponAimRot.Pitch;
        }

        // Set camera location & rotation
        CameraLocation = Gun.GetBoneCoords(CameraBone).Origin + (FPCamPos >> WeaponAimRot);
        CameraRotation = rotator(Gun.GetBoneCoords(CameraBone).XAxis);
        CameraRotation.Roll = 0; // make the mortar view have no roll

        // Finalise the camera with any shake
        if (PC != none)
        {
            CameraLocation = CameraLocation + (PC.ShakeOffset >> PC.Rotation);
            CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
        }
    }
}

// Modified to draw the mortar 1st person overlay & HUD information, including elevation, traverse & ammo
// Also to fix bug where HUDOverlay would be destroyed if function called before net client received Controller reference through replication
simulated function DrawHUD(Canvas C)
{
    local PlayerController PC;
    local vector           Loc;
    local float            HUDScale, Elevation, Traverse;
    local int              SizeX, SizeY, RoundIndex;
    local byte             Quotient, Remainder;
    local string           TraverseString;

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView)
    {
        if (HUDOverlay != none && !Level.IsSoftwareRendering() && Mortar != none)
        {
            // Draw HUDOverlay
            HUDOverlay.SetLocation(PC.CalcViewLocation + (HUDOverlayOffset >> PC.CalcViewRotation));
            HUDOverlay.SetRotation(PC.CalcViewRotation);
            C.DrawActor(HUDOverlay, false, true, HUDOverlayFOV);

            if (PC.myHUD == none || PC.myHUD.bHideHUD)
            {
                return;
            }

            // Set drawing font & scale
            C.Font = class'DHHud'.static.GetSmallerMenuFont(C);
            HUDScale = C.SizeY / 1280.0;

            // Get elevation & traverse
            Elevation = Mortar.Elevation;
            Traverse = class'UUnits'.static.UnrealToDegrees(Mortar.CurrentAim.Yaw);

            if (Traverse > 180.0) // convert to +/-
            {
                Traverse -= 360.0;
            }

            Traverse = -Traverse; // Matt: all the yaw stuff seems back to front !

            TraverseString = "T: ";

            if (Traverse > 0.0) // add a + at the beginning to explicitly state a positive rotation
            {
                TraverseString $= "+";
            }

            TraverseString $= String(Traverse);

            // Draw current round type icon
            RoundIndex = Mortar.GetFireMode();

            if (Mortar.HasAmmo(RoundIndex))
            {
                C.SetDrawColor(255, 255, 255, 255);
            }
            else
            {
                C.SetDrawColor(128, 128, 128, 255);
            }

            C.SetPos(HUDScale * 256.0, C.SizeY - HUDScale * 256.0);

            if (RoundIndex == 0)
            {
                C.DrawTile(HUDHighExplosiveTexture, 128.0 * HUDScale, 256.0 * HUDScale, 0.0, 0.0, 128.0, 256.0);
            }
            else
            {
                C.DrawTile(HUDSmokeTexture, 128.0 * HUDScale, 256.0 * HUDScale, 0.0, 0.0, 128.0, 256.0);
            }

            // Draw current round type quantity
            C.SetPos(384.0 * HUDScale, C.SizeY - (160.0 * HUDScale));

            if (Mortar.MainAmmoCharge[RoundIndex] < 10)
            {
                Quotient = Mortar.MainAmmoCharge[RoundIndex];

                SizeX = Digits.TextureCoords[Quotient].X2 - Digits.TextureCoords[Quotient].X1;
                SizeY = Digits.TextureCoords[Quotient].Y2 - Digits.TextureCoords[Quotient].Y1;

                C.DrawTile(Digits.DigitTexture, 40.0 * HUDScale, 64.0 * HUDScale, Digits.TextureCoords[Mortar.MainAmmoCharge[RoundIndex]].X1,
                    Digits.TextureCoords[Mortar.MainAmmoCharge[RoundIndex]].Y1, SizeX, SizeY);
            }
            else
            {
                Quotient = Mortar.MainAmmoCharge[RoundIndex] / 10;
                Remainder = Mortar.MainAmmoCharge[RoundIndex] % 10;

                SizeX = Digits.TextureCoords[Quotient].X2 - Digits.TextureCoords[Quotient].X1;
                SizeY = Digits.TextureCoords[Quotient].Y2 - Digits.TextureCoords[Quotient].Y1;

                C.DrawTile(Digits.DigitTexture, 40.0 * HUDScale, 64.0 * HUDScale, Digits.TextureCoords[Quotient].X1, Digits.TextureCoords[Quotient].Y1, SizeX, SizeY);

                SizeX = Digits.TextureCoords[Remainder].X2 - Digits.TextureCoords[Remainder].X1;
                SizeY = Digits.TextureCoords[Remainder].Y2 - Digits.TextureCoords[Remainder].Y1;

                C.DrawTile(Digits.DigitTexture, 40.0 * HUDScale, 64.0 * HUDScale, Digits.TextureCoords[Remainder].X1, Digits.TextureCoords[Remainder].Y1, SizeX, SizeY);
            }

            // Draw current round type name
            C.SetDrawColor(255, 255, 255, 255);
            C.SetPos(HUDScale * 8.0, C.SizeY - (HUDScale * 96.0));
            C.DrawText(Mortar.ProjectileClass.default.Tag);

            // Draw the elevation indicator icon
            C.SetPos(0.0, C.SizeY - (256.0 * HUDScale));
            C.DrawTile(HUDArcTexture, 256.0 * HUDScale, 256.0 * HUDScale, 0.0, 0.0, 512.0, 512.0);

            HUDArrowTexture.Rotation.Yaw = class'UUnits'.static.DegreesToUnreal(Elevation + 180.0);
            Loc.X = Cos(class'UUnits'.static.DegreesToRadians(Elevation)) * 256.0;
            Loc.Y = Sin(class'UUnits'.static.DegreesToRadians(Elevation)) * 256.0;
            C.SetPos(HUDScale * (Loc.X - 32.0), C.SizeY - (HUDScale * (Loc.Y + 32.0)));
            C.DrawTile(HUDArrowTexture, 64.0 * HUDScale, 64.0 * HUDScale, 0.0, 0.0, 128.0, 128.0);

            // Draw elevation & traverse text
            C.SetDrawColor(255, 255, 255, 255);
            C.SetPos(HUDScale * 8.0, C.SizeY - (HUDScale * 32.0));
            C.DrawText("E:" @ String(Elevation));

            C.SetDrawColor(255, 255, 255, 255);
            C.SetPos(HUDScale * 8.0, C.SizeY - (HUDScale * 64.0));
            C.DrawText(TraverseString);
        }
    }
}

// From ROTankCannonPawn
simulated function bool PointOfView()
{
    return false;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ****************************** MORTAR DEPLOY/ENTRY ***************************** //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to transfer player's mortar ammo to the mortar when player enters
function KDriverEnter(Pawn P)
{
    DriverEnterTransferAmmunition(P);

    super.KDriverEnter(P);

    GotoState('Idle');
}

// Modified to add mortar hints
// Matt: also to work around various net client problems caused by replication timing issues (also removes some multi-position stuff that isn't relevant to mortar)
simulated function ClientKDriverEnter(PlayerController PC)
{
    local DHPlayer DHP;

    // Fix possible replication timing problems on a net client
    // Server passed the PC with this function, so we can safely set new Controller here, even though may take a little longer for new Controller value to replicate
    // And we know new Owner will also be the PC & new net Role will AutonomousProxy, so we can set those too, avoiding problems caused by variable replication delay
    if (Role < ROLE_Authority && PC != none)
    {
        Controller = PC; // e.g. DrawHUD() can be called before Controller is replicated
        SetOwner(PC);
        Role = ROLE_AutonomousProxy;
    }

    // StoredVehicleRotation appears redundant as not used anywhere in UScript, but is used by native code (e.g. without it a cannon pawn gets unwanted camera swivelling)
    // Sometimes I have noticed an unwanted swivel when deploying a mortar, & similar to a spawn vehicle the mortar actors all spawn & replicate in a jumble when you deploy
    if (VehicleBase != none)
    {
        StoredVehicleRotation = VehicleBase.Rotation;
    }
    else
    {
        bNeedToStoreVehicleRotation = true;
    }

    super(VehicleWeaponPawn).ClientKDriverEnter(PC);

    GotoState('Idle');

    if (PC != none)
    {
        PC.SetFOV(WeaponFOV);

        DHP = DHPlayer(PC);

        // A range of hints on how to use mortars
        if (DHP != none)
        {
            DHP.QueueHint(7, false);
            DHP.QueueHint(8, false);
            DHP.QueueHint(9, false);
            DHP.QueueHint(10, false);
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  *************************** MORTAR UNDEPLOYING & EXIT ************************** //
///////////////////////////////////////////////////////////////////////////////////////

// New replicated client-to-server function called when player undeploys mortar, to send server to state Undeploying
function ServerUndeploying()
{
    if (!IsInState('Undeploying'))
    {
        GotoState('Undeploying');
    }
}

// New function to exit mortar, give player back his mortar inventory item, & maybe destroy mortar vehicle actors (some server modes have to wait until client finishes exiting)
function Undeploy()
{
    local DHMortarWeapon W;
    local PlayerController PC;

    if (Role == ROLE_Authority && IsInState('Undeploying'))
    {
        PC = PlayerController(Controller);
        W = Spawn(WeaponClass, PC.Pawn);

        global.KDriverLeave(true); // normally an empty function in any state derived from state Busy, so call the normal, non-state function instead

        W.GiveTo(PC.Pawn);

        // Standalone or owning listen server destroys mortar vehicle (& so all associated actors) immediately, as ClientKDriverLeave() will already have executed locally
        // Dedicated server or non-owning listen server instead waits until owning net client executes ClientKDriverLeave() & calls ServerDestroyMortar() on server
        if (IsLocallyControlled() && DHMortarVehicle(VehicleBase) != none)
        {
            DHMortarVehicle(VehicleBase).ServerDestroyMortar();
        }
    }
}

function bool KDriverLeave(bool bForceLeave)
{
    local Pawn P;

    P = Driver;

    if (super.KDriverLeave(bForceLeave))
    {
        DriverLeaveAmmunitionTransfer(P);

        if (DHPawn(P) != none)
        {
            DHPawn(P).CheckIfMortarCanBeResupplied();
        }

        if (P != none && DHPlayer(P.Controller) != none)
        {
            DHPlayer(P.Controller).ClientToggleDuck();
        }

        GotoState(''); // reset state for the next person who gets on the mortar

        return true;
    }

    return false;
}

// Modified to match player's rotation to where mortar is aimed, & to destroy mortar if player just undeployed
simulated function ClientKDriverLeave(PlayerController PC)
{
    local rotator NewRotation;

    super.ClientKDriverLeave(PC);

    if (PC != none)
    {
        if (Gun != none && Gun.WeaponFireAttachmentBone != '' && PC.Pawn != none)
        {
            NewRotation = Gun.GetBoneRotation(Gun.WeaponFireAttachmentBone);
            NewRotation.Pitch = 0;
            NewRotation.Roll = 0;
            PC.Pawn.SetRotation(NewRotation);
        }

        PC.FixFOV();
    }

    // If undeploying, owning net client now tells server to destroy mortar vehicle (& so all associated actors), as we've completed vehicle exit/unpossess process
    if (Role < ROLE_Authority && IsInState('Undeploying') && DHMortarVehicle(VehicleBase) != none)
    {
        DHMortarVehicle(VehicleBase).ServerDestroyMortar();
    }
    // Otherwise we exit state
    else
    {
        GotoState('');
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************************* FIRING & AMMO  ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// New replicated client-to-server function to fire the mortar, after the firing animation has played (there's a delay firing a mortar, as the round is dropped down the tube)
function ServerFire()
{
    if (Gun != none)
    {
        Gun.Fire(Controller);
    }
}

// New keybound function to toggle the selected ammo type
exec function SwitchFireMode()
{
    if (Mortar != none && Mortar.bMultipleRoundTypes)
    {
        Mortar.ToggleRoundType();
    }
}

// Modified to flag that the mortar no longer needs resupply
function bool ResupplyAmmo()
{
    if (super(VehicleWeaponPawn).ResupplyAmmo()) // TODO: mortar resupply still uses RO's full resupply system instead of DH's incremental resupply - do ppl want to keep that?
    {
        if (DHMortarVehicle(VehicleBase) != none)
        {
            DHMortarVehicle(VehicleBase).bCanBeResupplied = false;
        }

        return true;
    }

    return false;
}

// New function to handle transfer of player's mortar ammo to the mortar when player enters
function DriverEnterTransferAmmunition(Pawn P)
{
    local DHPawn DHP;

    DHP = DHPawn(P);

    if (DHP != none && Mortar != none)
    {
        Mortar.MainAmmoCharge[0] = Clamp(Mortar.MainAmmoCharge[0] + DHP.MortarHEAmmo, 0, GunClass.default.InitialPrimaryAmmo);
        Mortar.MainAmmoCharge[1] = Clamp(Mortar.MainAmmoCharge[1] + DHP.MortarSmokeAmmo, 0, GunClass.default.InitialSecondaryAmmo);

        DHP.MortarHEAmmo = 0;
        DHP.MortarSmokeAmmo = 0;
    }

    CheckCanBeResupplied();
}

// New function to handle transfer of mortar's ammo to the player when he exits
function DriverLeaveAmmunitionTransfer(Pawn P)
{
    local DHPawn DHP;

    DHP = DHPawn(P);

    if (DHP != none && Mortar != none)
    {
        DHP.MortarHEAmmo = Mortar.MainAmmoCharge[0];
        DHP.MortarSmokeAmmo = Mortar.MainAmmoCharge[1];
        Mortar.MainAmmoCharge[0] = 0;
        Mortar.MainAmmoCharge[1] = 0;

        if (DHMortarVehicle(VehicleBase) != none)
        {
            DHMortarVehicle(VehicleBase).bCanBeResupplied = true;
        }
    }
}

// New function to flag whether or not mortar has less than full ammo & so can be resupplied
function CheckCanBeResupplied()
{
    if (DHMortarVehicle(VehicleBase) != none)
    {
        DHMortarVehicle(VehicleBase).bCanBeResupplied =
            Gun != none && (Gun.MainAmmoCharge[0] < GunClass.default.InitialPrimaryAmmo || Gun.MainAmmoCharge[1] < GunClass.default.InitialSecondaryAmmo);
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************************* ACTIVITY STATES *******************************  //
///////////////////////////////////////////////////////////////////////////////////////

// New state where mortar is not busy doing something, so can be fired, exited, undeployed, etc
simulated state Idle
{
    simulated function BeginState()
    {
        PlayFirstPersonAnimation(OverlayIdleAnim, true);
    }

    simulated function Fire(optional float F)
    {
        if (Mortar != none && Mortar.HasAmmo(Mortar.GetFireMode()))
        {
            GotoState('Firing');
        }
    }

    simulated exec function Deploy()
    {
        GotoState('Undeploying');
    }

    function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange)
    {
        if (YawChange == 0.0 && PitchChange == 0.0)
        {
            global.HandleTurretRotation(DeltaTime, 0.0, 0.0);

            return;
        }
        else if (PitchChange != 0.0 && (Level.TimeSeconds - LastElevationTime) > ElevationAdjustmentDelay && Mortar != none)
        {
            LastElevationTime = Level.TimeSeconds;

            if (PitchChange < 0.0)
            {
                Mortar.Elevate();
            }
            else
            {
                Mortar.Depress();
            }
        }
        else if (YawChange != 0.0)
        {
            GotoState('KnobRaising');
        }
    }
}

// New base state for various new states where mortar is busy doing something, so several operations are disabled (functions emptied out)
simulated state Busy
{
    function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange) { }
    function IncrementRange() { }
    function DecrementRange() { }
    function Fire(optional float F) { }
    function AltFire(optional float F) { }
    simulated exec function SwitchFireMode() { }
    exec function Deploy() { }
    function bool KDriverLeave(bool bForceLeave) {return false;}
}

// New state where player's hand is raising to traverse adjustment knob
simulated state KnobRaising extends Busy
{
Begin:
    PlayFirstPersonAnimation(OverlayKnobRaisingAnim, false, OverlayKnobRaisingAnimRate);
    Sleep(HUDOverlay.GetAnimDuration(OverlayKnobRaisingAnim, OverlayKnobRaisingAnimRate));
    GotoState('KnobRaised');
}

// New state where player's hand is raised on traverse adjustment knob
simulated state KnobRaised
{
    simulated function BeginState()
    {
        PlayFirstPersonAnimation(OverlayKnobIdleAnim, true);
    }

    simulated function Fire(optional float F)
    {
        if (Mortar != none && Mortar.HasAmmo(Mortar.GetFireMode()))
        {
            GotoState('KnobRaisedToFire');
        }
    }

    simulated exec function Deploy()
    {
        if (!bTraversing)
        {
            GotoState('KnobRaisedToUndeploy');
        }
    }

    function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange)
    {
        local int CurrentYaw;

        // Adjusting pitch, so we need to move the player's hand down from traverse knob, meaning we exit this state
        if (PitchChange != 0.0)
        {
            GotoState('KnobRaisedToIdle');

            return;
        }

        // If adjusting traverse, make sure we haven't gone beyond the traverse limits (zero YawChange if we have)
        if (YawChange != 0.0 && Gun != none)
        {
            CurrentYaw = Gun.CurrentAim.Yaw;

            if (CurrentYaw > 32768) // convert to negative yaw format
            {
                CurrentYaw -= 65536;
            }

            CurrentYaw = -CurrentYaw; // Matt: I'm sure this is because the vehicle base skeletal mesh is upside down !

            // Block traverse if within 10 rotational units of yaw limit - a fudge factor, as sometimes Gun stops slightly short of limit
            if (YawChange > 0.0)
            {
                if (CurrentYaw >= (Gun.MaxPositiveYaw - 10))
                {
                    YawChange = 0.0;
                }
            }
            else if (CurrentYaw <= (Gun.MaxNegativeYaw + 10))
            {
                YawChange = 0.0;
            }
        }

        // Adjusting traverse
        if (YawChange != 0.0)
        {
            bTraversing = true;

            if (YawChange > 0.0)
            {
                PlayFirstPersonAnimation(OverlayKnobTurnRightAnim, true, OverlayKnobTurnAnimRate, 0.125);
            }
            else
            {
                PlayFirstPersonAnimation(OverlayKnobTurnLeftAnim, true, OverlayKnobTurnAnimRate, 0.125);
            }

            global.HandleTurretRotation(DeltaTime, -YawChange, 0);

        }
        // We've stopped adjusting traverse
        else if (bTraversing)
        {
            bTraversing = false;
            HUDOverlay.StopAnimating(true);

            return;
        }
    }
}

// New state after firing, before returning to Idle state
simulated state FireToIdle extends Busy
{
    simulated function Fire(optional float F)
    {
        bPendingFire = true; // allows us to queue up a shot in this stage so we don't have an arbitrary 'waiting time' before we accept input after firing
    }

    simulated function EndState()
    {
        bPendingFire = false;
    }

Begin:
    SetCurrentAnimationIndex(UnflinchAnimIndex);

    if (Driver != none && Driver.HasAnim(DriverUnflinchAnim))
    {
        Sleep(Driver.GetAnimDuration(DriverUnflinchAnim));
    }
    else
    {
        ClientMessage("Missing animation: DriverUnflinchAnim" @ DriverUnflinchAnim);
    }

    if (bPendingFire && Mortar != none && Mortar.HasAmmo(Mortar.GetFireMode()))
    {
        GotoState('Firing');
    }
    else
    {
        GotoState('Idle');
    }
}

// New state where mortar is being fired
simulated state Firing extends Busy
{
Begin:
    PlayFirstPersonAnimation(OverlayFiringAnim);
    SetCurrentAnimationIndex(FiringAnimIndex);

    if (HUDOverlay != none && HUDOverlay.HasAnim(OverlayFiringAnim))
    {
        Sleep(HUDOverlay.GetAnimDuration(OverlayFiringAnim));
    }

    if (Role < ROLE_Authority && Mortar != none)
    {
        Mortar.CheckUpdateFiringSettings();
    }

    ServerFire();

    if (Gun != none)
    {
        Gun.ShakeView(false);
    }

    GotoState('FireToIdle');
}

// New state where player's hand is moving from traverse adjustment knob to fire the mortar
simulated state KnobRaisedToFire extends Busy
{
Begin:
    if (HUDOverlay != none)
    {
        PlayFirstPersonAnimation(OverlayKnobLoweringAnim, false, OverlayKnobLoweringAnimRate);
        Sleep(HUDOverlay.GetAnimDuration(OverlayKnobLoweringAnim, OverlayKnobLoweringAnimRate));
    }

    GotoState('Firing');
}

// New state where player's hand is moving from traverse adjustment knob to undeploy the mortar
simulated state KnobRaisedToUndeploy extends Busy
{
Begin:
    if (HUDOverlay != none)
    {
        PlayFirstPersonAnimation(OverlayKnobLoweringAnim);
        Sleep(HUDOverlay.GetAnimDuration(OverlayKnobLoweringAnim));
    }

    GotoState('Undeploying');
}

// New state where player's hand is moving from traverse adjustment knob to an idle position
simulated state KnobRaisedToIdle extends Busy
{
Begin:
    if (HUDOverlay != none)
    {
        PlayFirstPersonAnimation(OverlayKnobLoweringAnim);
        Sleep(HUDOverlay.GetAnimDuration(OverlayKnobLoweringAnim));
    }

    GotoState('Idle');
}

// New state when player is undeploying the mortar
simulated state Undeploying extends Busy
{
Begin:
    if (IsLocallyControlled()) // single player, or owning net client or listen server
    {
        PlayFirstPersonAnimation(OverlayUndeployingAnim);
        ServerUndeploying();
    }

    if (Role == ROLE_Authority)
    {
        Sleep(UndeployingDuration);
        Undeploy();
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  *************************  SETUP, UPDATE, CLEAN UP  ***************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to call Initialize-X functions to do set up in the related vehicle classes that requires actor references to different vehicle actors
// This is where we do it servers or single player (note we can't do it in PostNetBeginPlay because VehicleBase isn't set until this function is called)
function AttachToVehicle(ROVehicle VehiclePawn, name WeaponBone)
{
    super.AttachToVehicle(VehiclePawn, WeaponBone);

    if (Role == ROLE_Authority)
    {
        InitializeVehicleWeapon();
        InitializeVehicleBase();
    }
}

// Matt: new function to do set up that requires the 'Gun' reference to the VehicleWeapon actor
// Using it to set a convenient Mortar reference
simulated function InitializeVehicleWeapon()
{
    Mortar = DHMortarVehicleWeapon(Gun);

    if (Mortar != none)
    {
        Mortar.InitializeWeaponPawn(self);
    }
    else
    {
        Warn("ERROR:" @ Tag @ "somehow spawned without an owned DHMortarVehicleWeapon, so lots of things are not going to work!");
    }

    // If we also have the Vehicle actor, initialize anything we need to do where we need both actors
    if (VehicleBase != none && !bInitializedVehicleAndGun)
    {
        InitializeVehicleAndWeapon();
    }
}

// Matt: new function to do set up that requires the 'VehicleBase' reference to the Vehicle actor
// Using it to set StoredVehicleRotation on net client if replication timing issues stopped that happening in ClientKDriverEnter()
// And to give the VehicleBase a reference to this actor in its WeaponPawns array, each time we spawn on a net client (previously in PostNetReceive)
simulated function InitializeVehicleBase()
{
    local bool bAddSelfToWeaponPawns;
    local int  i;

    if (Role < ROLE_Authority)
    {
        // We need to set StoredVehicleRotation as were unable to do it from ClientKDriverEnter() because we hadn't then received our VehicleBase reference
        if (bNeedToStoreVehicleRotation)
        {
            StoredVehicleRotation = VehicleBase.Rotation;
        }

        // On client, this actor is destroyed if becomes net irrelevant - when it respawns, empty WeaponPawns array needs filling again or will cause lots of errors
        // First check if our WeaponPawns slot doesn't exist, is empty or has an invalid member
        if (PositionInArray >= VehicleBase.WeaponPawns.Length || VehicleBase.WeaponPawns[PositionInArray] == none || VehicleBase.WeaponPawns[PositionInArray].default.Class == none)
        {
            bAddSelfToWeaponPawns = true;

            // Then make sure that somehow another WeaponPawns slot isn't already occupied by this actor or an actor of the same class
            for (i = 0; i < VehicleBase.WeaponPawns.Length; ++i)
            {
                if (VehicleBase.WeaponPawns[i] != none && (VehicleBase.WeaponPawns[i] == self || VehicleBase.WeaponPawns[i].Class == class))
                {
                    bAddSelfToWeaponPawns = false;
                    break;
                }
            }
        }

        if (bAddSelfToWeaponPawns)
        {
            VehicleBase.WeaponPawns[PositionInArray] = self;
        }
    }

    // If we also have the VehicleWeapon actor, initialize anything we need to do where we need both actors
    if (Gun != none && !bInitializedVehicleAndGun)
    {
        InitializeVehicleAndWeapon();
    }
}

// Matt: new function to do set up that requires both the 'VehicleBase' & 'Gun' references to the Vehicle & VehicleWeapon actors
// Currently unused but putting it in for consistency & for future usage, including option to easily subclass for any mortar-specific set up
simulated function InitializeVehicleAndWeapon()
{
    bInitializedVehicleAndGun = true;
}

// From ROTankCannonPawn
function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange)
{
    if (Gun == none || !Gun.bUseTankTurretRotation)
    {
        return;
    }

    UpdateTurretRotation(DeltaTime, YawChange, PitchChange);

    if (ROPlayer(Controller) != none)
    {
        ROPlayer(Controller).WeaponBufferRotation.Yaw = CustomAim.Yaw;
        ROPlayer(Controller).WeaponBufferRotation.Pitch = CustomAim.Pitch;
    }
}

// New function to set a new CurrentAnimationIndex & play the relevant animations, & for a net client to replicate the CurrentAnimationIndex to the server
simulated function SetCurrentAnimationIndex(byte AnimIndex)
{
    CurrentAnimationIndex = AnimIndex;
    PlayThirdPersonAnimations();

    if (Role < ROLE_Authority)
    {
        ServerSetCurrentAnimationIndex(CurrentAnimationIndex);
    }
}

// New replicated client-to-server function to set CurrentAnimationIndex on server, to be replicated to other net clients, making them play the animations
simulated function ServerSetCurrentAnimationIndex(byte AnimIndex)
{
    CurrentAnimationIndex = AnimIndex;
}

// New function to play current 1st person animations for the mortar & the operator ('Driver')
simulated function PlayThirdPersonAnimations()
{
    switch (CurrentAnimationIndex)
    {
        case IdleAnimIndex:
            if (Gun != none)
            {
                Gun.LoopAnim(Gun.BeginningIdleAnim);
            }

            if (Driver != none)
            {
                Driver.LoopAnim(DriveAnim);
            }

            break;

        case FiringAnimIndex:
            if (Mortar != none)
            {
                Mortar.PlayAnim(Mortar.GunFiringAnim);
            }

            if (Driver != none)
            {
                Driver.PlayAnim(DriverFiringAnim);
            }

            break;

        case UnflinchAnimIndex:
            if (Gun != none)
            {
                Gun.LoopAnim(Gun.BeginningIdleAnim);
            }

            if (Driver != none)
            {
                Driver.PlayAnim(DriverUnflinchAnim);
            }
    }
}

// New function to play a 1st person animation on the HUDOverlay
simulated function PlayFirstPersonAnimation(name Anim, optional bool bLoop, optional float Rate, optional float TweenTime)
{
    if (HUDOverlay != none && HUDOverlay.HasAnim(Anim))
    {
        if (Rate == 0.0) // default to 1.0 if no rate was passed
        {
            Rate = 1.0;
        }

        if (bLoop)
        {
            HUDOverlay.LoopAnim(Anim, Rate, TweenTime);
        }
        else
        {
            HUDOverlay.PlayAnim(Anim, Rate, TweenTime);
        }
    }
}

defaultproperties
{
    // Mortar operator, aiming & undeploying
    bKeepDriverAuxCollision=true
    bSinglePositionExposed=true
    bCustomAiming=true
    ElevationAdjustmentDelay=0.125
    UndeployingDuration=2.0 // just a fallback, in case we forget to set one for the specific mortar

    // View & display
    bDrawMeshInFP=false
    CameraBone="Camera"
    WeaponFOV=90.0
    HUDOverlayFOV=90.0
    HUDArrowTexture=TexRotator'DH_Mortars_tex.HUD.ArrowRotator'
    Digits=(DigitTexture=texture'InterfaceArt_tex.HUD.numbers',TextureCoords[0]=(X1=15,X2=47,Y2=63),TextureCoords[1]=(X1=79,X2=111,Y2=63),TextureCoords[2]=(X1=143,X2=175,Y2=63),TextureCoords[3]=(X1=207,X2=239,Y2=63),TextureCoords[4]=(X1=15,Y1=64,X2=47,Y2=127),TextureCoords[5]=(X1=79,Y1=64,X2=111,Y2=127),TextureCoords[6]=(X1=143,Y1=64,X2=175,Y2=127),TextureCoords[7]=(X1=207,Y1=64,X2=239,Y2=127),TextureCoords[8]=(X1=15,Y1=128,X2=47,Y2=191),TextureCoords[9]=(X1=79,Y1=128,X2=111,Y2=191),TextureCoords[10]=(X1=143,Y1=128,X2=175,Y2=191))
    bPCRelativeFPRotation=true
    bAllowViewChange=false
    TPCamDistance=128.0
    TPCamLookat=(Z=16.0)
    TPCamDistRange=(Min=128.0,Max=128.0)

    // Animations
    OverlayIdleAnim="deploy_idle"
    OverlayKnobRaisingAnim="knob_raise"
    OverlayKnobLoweringAnim="knob_lower"
    OverlayKnobTurnLeftAnim="traverse_left"
    OverlayKnobTurnRightAnim="traverse_right"
    OverlayFiringAnim="Fire"
    OverlayUndeployingAnim="undeploy"
    OverlayKnobLoweringAnimRate=1.25
    OverlayKnobRaisingAnimRate=1.25
    OverlayKnobTurnAnimRate=1.25

    // Exit positions
    ExitPositions(0)=(X=-48.0)
    ExitPositions(1)=(X=-48.0,Y=-48.0)
    ExitPositions(2)=(X=-48.0,Y=48.0)
    ExitPositions(3)=(Y=-48.0)
    ExitPositions(4)=(Y=48.0)
    ExitPositions(5)=(Z=64.0)
}
