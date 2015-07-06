//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMortarVehicleWeaponPawn extends ROVehicleWeaponPawn
    abstract;

struct DigitSet
{
    var Material    DigitTexture;
    var IntBox      TextureCoords[11];
};

// General
var     class<DHMortarWeapon> WeaponClass;
var     DHMortarVehicleWeapon Mortar;        // just a reference to the mortar VW actor, for convenience & to avoid lots of casts
var     bool        bNeedToInitializeDriver; // clientside flag that we need to do some player set up, once we receive the Driver actor

// Deploying, aim & firing
var     bool        bPendingFire;
var     bool        bTraversing;
var     bool        bCanUndeploy;
var     float       UndeployingDuration;     // needs literal as server doesn't have HUDOverlay actor & so can't use GetAnimDuration on it
var     float       LastElevationTime;
var     float       ElevationAdjustmentDelay;

// Animations
const   IdleAnimIndex = 0;
const   FiringAnimIndex = 1;
const   UnflinchAnimIndex = 2;

var     name        DriverFiringAnim;
var     name        DriverUnflinchAnim;
var     byte        CurrentDriverAnimation;
var     byte        OldDriverAnimation;

// Overlay animations
var     name        OverlayIdleAnim;
var     name        OverlayFiringAnim;
var     name        OverlayUndeployingAnim;
var     name        OverlayKnobRaisingAnim;
var     name        OverlayKnobLoweringAnim;
var     name        OverlayKnobIdleAnim;
var     name        OverlayKnobTurnLeftAnim;
var     name        OverlayKnobTurnRightAnim;

// Animation rates - new in 5.0 hotfix because old animations were too slow
var     float       OverlayKnobLoweringAnimRate;
var     float       OverlayKnobRaisingAnimRate;
var     float       OverlayKnobTurnAnimRate;

// HUD
var     texture     HUDHighExplosiveTexture;
var     texture     HUDSmokeTexture;
var     texture     HUDArcTexture;
var     TexRotator  HUDArrowTexture;
var     DigitSet    Digits;

// View shake
var     float       ShakeScale;       // how much larger than the explosion radius should the view shake
var     float       BlurTime;         // how long blur effect should last for this projectile
var     vector      ShakeRotMag;      // how far to rot view
var     vector      ShakeRotRate;     // how fast to rot view
var     float       ShakeRotTime;     // how much time to rot the instigator's view
var     vector      ShakeOffsetMag;   // max view offset vertically
var     vector      ShakeOffsetRate;  // how fast to offset view vertically
var     float       ShakeOffsetTime;  // how much time to offset view
var     float       BlurEffectScalar;

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerUndeploying, ServerFire, SetCurrentAnimation, ServerToggleRoundType;

    // Functions the server can call on the client that owns this actor
    reliable if (Role == ROLE_Authority)
        CurrentDriverAnimation, bCanUndeploy, ClientShakeView;
}

simulated function IncrementRange() { }
simulated function DecrementRange() { }

// Matt: new function to do any extra set up in the mortar classes (called from PostNetReceive on net client or from AttachToVehicle on standalone or server)
// Crucially, we know that we have VehicleBase & Gun when this function gets called, so we can reliably do stuff that needs those actors
simulated function InitializeMortar()
{
    Mortar = DHMortarVehicleWeapon(Gun);

    if (Mortar != none)
    {
        Mortar.InitializeMortar(self);
    }
    else
    {
        Warn("ERROR:" @ Tag @ "somehow spawned without an owned DHMortarVehicleWeapon, so lots of things are not going to work!");
    }
}

// Modified to play animations on the mortar & the player, when a new value is received by a net client
// Also to call InitializeMortar when we've received both the replicated Gun & VehicleBase actors (just after vehicle spawns via replication), same as DH cannon pawn
// Also to ensure player pawn is attached, as on replication, AttachDriver() only works if client has received VehicleWeapon actor, which it may not have yet
// And to remove stuff not relevant to a mortar, as is not multi-position
simulated function PostNetReceive()
{
    local int i;

    // Play animations
    if (CurrentDriverAnimation != OldDriverAnimation)
    {
        switch (CurrentDriverAnimation)
        {
            case IdleAnimIndex:
                Gun.LoopAnim(Gun.BeginningIdleAnim);
                Driver.LoopAnim(DriveAnim);
                break;
            case FiringAnimIndex:
                Mortar.PlayAnim(Mortar.GunFiringAnim);
                Driver.PlayAnim(DriverFiringAnim);
                break;
            case UnflinchAnimIndex:
                Gun.LoopAnim(Gun.BeginningIdleAnim);
                Driver.PlayAnim(DriverUnflinchAnim);
            default:
                break;
        }

        OldDriverAnimation = CurrentDriverAnimation;
    }

    // Initialize the mortar
    if (!bInitializedVehicleGun && Gun != none && VehicleBase != none)
    {
        bInitializedVehicleGun = true;
        InitializeMortar();
    }

    // Initialize the vehicle base
    if (!bInitializedVehicleBase && VehicleBase != none)
    {
        bInitializedVehicleBase = true;

        // On client, this actor is destroyed if becomes net irrelevant - when it respawns, empty WeaponPawns array needs filling again or will cause lots of errors
        if (VehicleBase.WeaponPawns.Length > 0 && VehicleBase.WeaponPawns.Length > PositionInArray &&
            (VehicleBase.WeaponPawns[PositionInArray] == none || VehicleBase.WeaponPawns[PositionInArray].default.Class == none))
        {
            VehicleBase.WeaponPawns[PositionInArray] = self;

            return;
        }

        for (i = 0; i < VehicleBase.WeaponPawns.Length; ++i)
        {
            if (VehicleBase.WeaponPawns[i] != none && (VehicleBase.WeaponPawns[i] == self || VehicleBase.WeaponPawns[i].Class == class))
            {
                return;
            }
        }

        VehicleBase.WeaponPawns[PositionInArray] = self;
    }

    // Fix 'driver' attachment position - on replication, AttachDriver() only works if client has received MortarVehicleWeapon actor, which it may not have yet
    // Client then receives Driver attachment and RelativeLocation through replication, but this is unreliable & sometimes gives incorrect positioning
    // As a fix, if player pawn has flagged bNeedToAttachDriver (meaning attach failed), we call AttachDriver() here
    if (bNeedToInitializeDriver && Driver != none && VehicleBase != none)
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

// Modified to call InitializeMortar to do any extra set up in the mortar classes
// This is where we do it for standalones or servers (note we can't do it in PostNetBeginPlay because VehicleBase isn't set until this function is called)
function AttachToVehicle(ROVehicle VehiclePawn, name WeaponBone)
{
    super.AttachToVehicle(VehiclePawn, WeaponBone);

    if (Role == ROLE_Authority)
    {
        InitializeMortar();
    }
}

// New client-to-server function to set CurrentDriverAnimation on server, to be replicated to other net clients
simulated function SetCurrentAnimation(byte Index)
{
    CurrentDriverAnimation = Index;
}

// New client-to-server function to fire the mortar, after the firing animation has played (there's a delay firing a mortar, as the round is dropped down the tube)
simulated function ServerFire()
{
    if (Gun != none)
    {
        Gun.Fire(Controller);
    }
}

// Modified to add mortar hints & also to avoid an "accessed none" error (need to remove a reference to VehicleBase in the Super in ROVehicleWeaponPawn)
// Also removes some multi-position stuff that isn't relevant to mortar
simulated function ClientKDriverEnter(PlayerController PC)
{
    local DHPlayer DHP;

    super(VehicleWeaponPawn).ClientKDriverEnter(PC);

    GotoState('Idle');

    if (PC != none)
    {
        PC.SetFOV(WeaponFOV);

        DHP = DHPlayer(PC);

        if (DHP != none)
        {
            DHP.QueueHint(7, false);
            DHP.QueueHint(8, false);
            DHP.QueueHint(9, false);
            DHP.QueueHint(10, false);
        }
    }
}

// Modified to match player's rotation to where mortar is aimed, to destroy mortar if player just undeployed, or to record elevation on server if player just exited
simulated function ClientKDriverLeave(PlayerController PC)
{
    local DHMortarVehicleWeapon MVW;
    local rotator               NewRotation;

    super.ClientKDriverLeave(PC);

    MVW = DHMortarVehicleWeapon(Gun);

    if (PC != none)
    {
        if (MVW != none && MVW.MuzzleBoneName != '' && PC.Pawn != none)
        {
            NewRotation = Gun.GetBoneRotation(MVW.MuzzleBoneName);
            NewRotation.Pitch = 0;
            NewRotation.Roll = 0;
            PC.Pawn.SetRotation(NewRotation);
        }

        PC.FixFOV();
    }

    if (Role < ROLE_Authority)
    {
        // If undeploying, owning net client now tells server to destroy mortar vehicle (& so all associated actors), as we've completed vehicle exit/unpossess process
        if (IsInState('Undeploying'))
        {
            if (DHMortarVehicle(VehicleBase) != none)
            {
                DHMortarVehicle(VehicleBase).ServerDestroyMortar();

                return;
            }
        }
        // Or if player has exited mortar, leaving it deployed on the ground, client send current elevation setting to be recorded on server
        else if (MVW != none)
        {
            MVW.ClientReplicateElevation(MVW.Elevation);
        }
    }

    GotoState('');
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

// New state where mortar is not busy doing something, so can be fired, exited, undeployed, etc
simulated state Idle
{
    simulated function BeginState()
    {
        PlayOverlayAnimation(OverlayIdleAnim, true);
    }

    simulated function Fire(optional float F)
    {
        if (DHMortarVehicleWeapon(Gun) != none && DHMortarVehicleWeapon(Gun).HasPendingAmmo())
        {
            GotoState('Firing');
        }
    }

    simulated exec function Deploy()
    {
        if (bCanUndeploy)
        {
            GotoState('Undeploying');
        }
    }

    function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange)
    {
        if (YawChange == 0.0 && PitchChange == 0.0)
        {
            global.HandleTurretRotation(DeltaTime, 0.0, 0.0);

            return;
        }
        else if (PitchChange != 0.0 && (Level.TimeSeconds - LastElevationTime) > ElevationAdjustmentDelay && DHMortarVehicleWeapon(Gun) != none)
        {
            LastElevationTime = Level.TimeSeconds;

            if (PitchChange < 0.0)
            {
                DHMortarVehicleWeapon(Gun).Elevate();
            }
            else
            {
                DHMortarVehicleWeapon(Gun).Depress();
            }
        }
        else if (YawChange != 0.0)
        {
            GotoState('KnobRaising');
        }
    }
}

// New state after firing, before returning to Idle state
simulated state FireToIdle extends Busy
{
    simulated function Fire(optional float F)
    {
        // Allows us to queue up a shot in this stage so we don't have an arbitrary 'waiting time' before we accept input after firing
        bPendingFire = true;
    }

    simulated function EndState()
    {
        bPendingFire = false;
    }

Begin:
    if (Level.NetMode == NM_Standalone) // single-player
    {
        Gun.LoopAnim(Gun.BeginningIdleAnim);
        Driver.PlayAnim(DriverUnflinchAnim);
    }
    else // multi-player
    {
        SetCurrentAnimation(UnflinchAnimIndex);
    }

    if (Driver.HasAnim(DriverUnflinchAnim))
    {
        Sleep(Driver.GetAnimDuration(DriverUnflinchAnim));
    }
    else
    {
        ClientMessage("Missing animation: DriverUnflinchAnim" @ DriverUnflinchAnim);
    }

    if (bPendingFire && DHMortarVehicleWeapon(Gun) != none && DHMortarVehicleWeapon(Gun).HasPendingAmmo())
    {
        GotoState('Firing');
    }
    else
    {
        GotoState('Idle');
    }
}

// New function to shake player's view when firing
simulated function ClientShakeView()
{
    if (Controller != none && DHPlayer(Controller) != none)
    {
        DHPlayer(Controller).AddBlur(BlurTime, BlurEffectScalar);
        DHPlayer(Controller).ShakeView(ShakeRotMag, ShakeRotRate, ShakeRotTime, ShakeOffsetMag, ShakeOffsetRate, ShakeOffsetTime);
    }
}

// New state where player's hand is raising to traverse adjustment knob
simulated state KnobRaising extends Busy
{
Begin:
    PlayOverlayAnimation(OverlayKnobRaisingAnim, false, OverlayKnobRaisingAnimRate);
    Sleep(HUDOverlay.GetAnimDuration(OverlayKnobRaisingAnim, OverlayKnobRaisingAnimRate));
    GotoState('KnobRaised');
}

// New state where player's hand is raised on traverse adjustment knob
simulated state KnobRaised
{
    simulated function BeginState()
    {
        PlayOverlayAnimation(OverlayKnobIdleAnim, true);
    }

    simulated function Fire(optional float F)
    {
        if (DHMortarVehicleWeapon(Gun) != none && DHMortarVehicleWeapon(Gun).HasPendingAmmo())
        {
            GotoState('KnobRaisedToFire');
        }
    }

    simulated exec function Deploy()
    {
        if (bCanUndeploy && !bTraversing)
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
                PlayOverlayAnimation(OverlayKnobTurnRightAnim, true, OverlayKnobTurnAnimRate, 0.125);
            }
            else
            {
                PlayOverlayAnimation(OverlayKnobTurnLeftAnim, true, OverlayKnobTurnAnimRate, 0.125);
            }

            global.HandleTurretRotation(DeltaTime, -YawChange, 0); // Matt: I'm sure the minus YawChange is because the vehicle base skeletal mesh is upside down !

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

// New state where mortar is being fired
simulated state Firing extends Busy
{
Begin:
    DHMortarVehicleWeapon(Gun).ClientReplicateElevation(DHMortarVehicleWeapon(Gun).Elevation);
    PlayOverlayAnimation(OverlayFiringAnim);

    if (Level.NetMode == NM_Standalone) //TODO: Remove, single-player testing?
    {
        Mortar.PlayAnim(Mortar.GunFiringAnim);
        Driver.PlayAnim(DriverFiringAnim);
    }
    else
    {
        SetCurrentAnimation(FiringAnimIndex);
    }

    if (HUDOverlay != none && HUDOverlay.HasAnim(OverlayFiringAnim))
    {
        Sleep(HUDOverlay.GetAnimDuration(OverlayFiringAnim));
    }

    ServerFire();
    GotoState('FireToIdle');
}

// New state when player is undeploying the mortar
simulated state Undeploying extends Busy
{
Begin:
    if (IsLocallyControlled()) // single player, or owning net client or listen server
    {
        PlayOverlayAnimation(OverlayUndeployingAnim);
        ServerUndeploying();
    }

    if (Role == ROLE_Authority)
    {
        Sleep(UndeployingDuration);
        Undeploy();
    }
}

// New client-to-server function called when player undeploys mortar, to send server to state Undeploying
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
        if (IsLocallyControlled())
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

// Modified so mortar is destroyed a few seconds after player dies
function DriverDied()
{
    super.DriverDied();
    
    if (DHMortarVehicle(VehicleBase) != none)
    {
        DHMortarVehicle(VehicleBase).GotoState('PendingDestroy');
    }
}

// New function to play an animation on the HUDOverlay
simulated function PlayOverlayAnimation(name OverlayAnimation, optional bool bLoop, optional float Rate, optional float TweenTime)
{
    if (HUDOverlay != none && HUDOverlay.HasAnim(OverlayAnimation))
    {
        if (Rate == 0.0) // default to 1.0 if no rate was passed
        {
            Rate = 1.0;
        }

        if (bLoop)
        {
            HUDOverlay.LoopAnim(OverlayAnimation, Rate, TweenTime);
        }
        else
        {
            HUDOverlay.PlayAnim(OverlayAnimation, Rate, TweenTime);
        }
    }
}

simulated function DrawHUD(Canvas C)
{
    local PlayerController PC;
    local Actor            ViewActor;
    local vector           CameraLocation, Loc;
    local rotator          CameraRotation;
    local float            HUDScale, Elevation, Traverse;
    local int              SizeX, SizeY, RoundIndex;
    local byte             Quotient, Remainder;
    local string           TraverseString;

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView)
    {
        if (HUDOverlay != none && !Level.IsSoftwareRendering() && Mortar != none)
        {
            // Get camera rotation & location
            CameraRotation = PC.Rotation;
            SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);

            // Draw HUDOverlay
            HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));
            HUDOverlay.SetRotation(CameraRotation);
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
            Traverse = class'DHLib'.static.UnrealToDegrees(Mortar.CurrentAim.Yaw);

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
            RoundIndex = Mortar.GetPendingRoundIndex();

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
            C.DrawText(Mortar.PendingProjectileClass.default.Tag);

            // Draw the elevation indicator icon
            C.SetPos(0.0, C.SizeY - (256.0 * HUDScale));
            C.DrawTile(HUDArcTexture, 256.0 * HUDScale, 256.0 * HUDScale, 0.0, 0.0, 512.0, 512.0);

            HUDArrowTexture.Rotation.Yaw = class'DHLib'.static.DegreesToUnreal(Elevation + 180.0);
            Loc.X = Cos(class'DHLib'.static.DegreesToRadians(Elevation)) * 256.0;
            Loc.Y = Sin(class'DHLib'.static.DegreesToRadians(Elevation)) * 256.0;
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
    else if (HUDOverlay != none)
    {
        ActivateOverlay(false);
    }
}

// New state where player's hand is moving from traverse adjustment knob to fire the mortar
simulated state KnobRaisedToFire extends Busy
{
Begin:
    PlayOverlayAnimation(OverlayKnobLoweringAnim);
    Sleep(HUDOverlay.GetAnimDuration(OverlayKnobLoweringAnim));
    GotoState('Firing');
}

// New state where player's hand is moving from traverse adjustment knob to undeploy the mortar
simulated state KnobRaisedToUndeploy extends Busy
{
Begin:
    PlayOverlayAnimation(OverlayKnobLoweringAnim);
    Sleep(HUDOverlay.GetAnimDuration(OverlayKnobLoweringAnim));
    GotoState('Undeploying');
}

// New state where player's hand is moving from traverse adjustment knob to an idle position
simulated state KnobRaisedToIdle extends Busy
{
Begin:
    PlayOverlayAnimation(OverlayKnobLoweringAnim);
    Sleep(HUDOverlay.GetAnimDuration(OverlayKnobLoweringAnim));
    GotoState('Idle');
}

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

// Modified to flag that the mortar no longer needs resupply
function bool ResupplyAmmo()
{
    if (super.ResupplyAmmo())
    {
        DHMortarVehicle(VehicleBase).bCanBeResupplied = false;

        return true;
    }

    return false;
}

// Modified to transfer player's mortar ammo to the mortar when player enters
function KDriverEnter(Pawn P)
{
    DriverEnterTransferAmmunition(P);

    super.KDriverEnter(P);

    GotoState('Idle');
}

// New function to handle transfer of player's mortar ammo to the mortar when player enters
function DriverEnterTransferAmmunition(Pawn P)
{
    local DHPawn DHP;
    local DHMortarVehicleWeapon DHMVW;

    DHP = DHPawn(P);
    DHMVW = DHMortarVehicleWeapon(Gun);

    if (DHP != none && DHMVW != none)
    {
        DHMVW.MainAmmoCharge[0] = Clamp(DHMVW.MainAmmoCharge[0] + DHP.MortarHEAmmo, 0, GunClass.default.InitialPrimaryAmmo);
        DHMVW.MainAmmoCharge[1] = Clamp(DHMVW.MainAmmoCharge[1] + DHP.MortarSmokeAmmo, 0, GunClass.default.InitialSecondaryAmmo);

        DHP.MortarHEAmmo = 0;
        DHP.MortarSmokeAmmo = 0;
    }

    CheckCanBeResupplied();
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

// New function to handle transfer of mortar's ammo to the player when he exits
function DriverLeaveAmmunitionTransfer(Pawn P)
{
    local DHPawn DHP;
    local DHMortarVehicleWeapon G;

    DHP = DHPawn(P);
    G = DHMortarVehicleWeapon(Gun);

    if (DHP != none && G != none)
    {
        DHP.MortarHEAmmo = G.MainAmmoCharge[0];
        DHP.MortarSmokeAmmo = G.MainAmmoCharge[1];
        G.MainAmmoCharge[0] = 0;
        G.MainAmmoCharge[1] = 0;

        if (DHMortarVehicle(VehicleBase) != none)
        {
            DHMortarVehicle(VehicleBase).bCanBeResupplied = true;
        }
    }
}

// From ROTankCannonPawn
exec function SwitchFireMode()
{
    if (Gun != none && Gun.bMultipleRoundTypes)
    {
        if (PlayerController(Controller) != none)
        {
            PlayerController(Controller).ClientPlaySound(sound'ROMenuSounds.msfxMouseClick', false,, SLOT_Interface);
        }

        ServerToggleRoundType();
    }
}

// From ROTankCannonPawn
function ServerToggleRoundType()
{
    if (DHMortarVehicleWeapon(Gun) != none)
    {
        DHMortarVehicleWeapon(Gun).ToggleRoundType();
    }
}

// From ROTankCannonPawn
simulated function bool PointOfView()
{
    return false;
}

defaultproperties
{
    // From ROTankCannonPawn:
	bCustomAiming=true
    bAllowViewChange=false
    PositionInArray=0    
    
    bMultiPosition=false
    bSinglePositionExposed=true
    bKeepDriverAuxCollision=true
    bDrawMeshInFP=false
    bPCRelativeFPRotation=true
    CameraBone="Camera"
    WeaponFOV=90.0
    HUDOverlayFOV=90.0
    HUDArrowTexture=TexRotator'DH_Mortars_tex.HUD.ArrowRotator'
    Digits=(DigitTexture=texture'InterfaceArt_tex.HUD.numbers',TextureCoords[0]=(X1=15,X2=47,Y2=63),TextureCoords[1]=(X1=79,X2=111,Y2=63),TextureCoords[2]=(X1=143,X2=175,Y2=63),TextureCoords[3]=(X1=207,X2=239,Y2=63),TextureCoords[4]=(X1=15,Y1=64,X2=47,Y2=127),TextureCoords[5]=(X1=79,Y1=64,X2=111,Y2=127),TextureCoords[6]=(X1=143,Y1=64,X2=175,Y2=127),TextureCoords[7]=(X1=207,Y1=64,X2=239,Y2=127),TextureCoords[8]=(X1=15,Y1=128,X2=47,Y2=191),TextureCoords[9]=(X1=79,Y1=128,X2=111,Y2=191),TextureCoords[10]=(X1=143,Y1=128,X2=175,Y2=191))
    OverlayIdleAnim="deploy_idle"
    OverlayFiringAnim="Fire"
    OverlayKnobRaisingAnim="knob_raise"
    OverlayKnobLoweringAnim="knob_lower"
    OverlayKnobTurnLeftAnim="traverse_left"
    OverlayKnobTurnRightAnim="traverse_right"
    OverlayUndeployingAnim="undeploy"
    UndeployingDuration=2.0 // just a fallback, in case we forget to set one for the specific mortar
    OverlayKnobLoweringAnimRate=1.25
    OverlayKnobRaisingAnimRate=1.25
    OverlayKnobTurnAnimRate=1.25
    ElevationAdjustmentDelay=0.125
    bCanUndeploy=true
    ShakeScale=2.25
    BlurTime=0.5
    BlurEffectScalar=1.35
    ExitPositions(0)=(X=-48.0)
    ExitPositions(1)=(X=-48.0,Y=-48.0)
    ExitPositions(2)=(X=-48.0,Y=48.0)
    ExitPositions(3)=(Y=-48.0)
    ExitPositions(4)=(Y=48.0)
    ExitPositions(5)=(Z=64.0)
    TPCamDistance=128.0
    TPCamLookat=(Z=16.0)
    TPCamDistRange=(Min=128.0,Max=128.0)
}
