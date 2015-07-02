//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHMortarVehicleWeaponPawn extends ROTankCannonPawn
    abstract;

struct DigitSet
{
    var Material    DigitTexture;
    var IntBox      TextureCoords[11];
};

var     class<DHMortarWeapon> WeaponClass;

// Deploying, aim & firing
var     bool        bPendingFire;
var     bool        bTraversing;
var     bool        bCanUndeploy;
var     float       UndeployingDuration;
var     float       LastElevationTime;
var     float       ElevationAdjustmentDelay;

// Animations
const   IdleAnimIndex = 0;
const   FiringAnimIndex = 1;
const   UnflinchAnimIndex = 2;

var     name        GunIdleAnim;
var     name        GunFiringAnim;
var     name        DriverIdleAnim;
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
        ServerUndeploy, ServerFire, SetCurrentAnimation;

    // Functions the server can call on the client that owns this actor
    reliable if (Role == ROLE_Authority)
        CurrentDriverAnimation, bCanUndeploy, ClientShakeView;
}

simulated function IncrementRange() { }
simulated function DecrementRange() { }

// Modified to ensure player pawn is attached, as on replication, AttachDriver() only works if client has received VehicleWeapon actor, which it may not have yet
// Also to remove stuff not relevant to a mortar, as is not multi-position
simulated function PostNetReceive()
{
    // When a manned mortar gets replicated to a net client, AttachDriver() gets called but does nothing as client doesn't yet have a Gun reference
    // Client then receives Driver attachment and RelativeLocation through replication, but this is unreliable & sometimes gives incorrect positioning
    // As a fix, call AttachDriver() here to make sure client has correct positioning (Driver may or may not be attached at this point, possibly incorrectly, so detach first)
    if (!bInitializedVehicleGun && Gun != none)
    {
        bInitializedVehicleGun = true;

        if (Driver != none)
        {
            DetachDriver(Driver);
            AttachDriver(Driver);
        }
    }

    if (CurrentDriverAnimation != OldDriverAnimation)
    {
        switch (CurrentDriverAnimation)
        {
            case IdleAnimIndex:
                Gun.LoopAnim(GunIdleAnim);
                Driver.LoopAnim(DriverIdleAnim);
                break;
            case FiringAnimIndex:
                Gun.PlayAnim(GunFiringAnim);
                Driver.PlayAnim(DriverFiringAnim);
                break;
            case UnflinchAnimIndex:
                Gun.LoopAnim(GunIdleAnim);
                Driver.PlayAnim(DriverUnflinchAnim);
            default:
                break;
        }

        OldDriverAnimation = CurrentDriverAnimation;
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
            super.HandleTurretRotation(DeltaTime, YawChange, PitchChange);

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
        Gun.LoopAnim(GunIdleAnim);
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
                PlayOverlayAnimation(OverlayKnobTurnRightAnim, true, 0.125);
            }
            else
            {
                PlayOverlayAnimation(OverlayKnobTurnLeftAnim, true, 0.125);
            }

            super.HandleTurretRotation(DeltaTime, -YawChange, 0); // Matt: I'm sure the minus YawChange is because the vehicle base skeletal mesh is upside down !

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

// New state where mortar is being fired
simulated state Firing extends Busy
{
Begin:
    DHMortarVehicleWeapon(Gun).ClientReplicateElevation(DHMortarVehicleWeapon(Gun).Elevation);
    PlayOverlayAnimation(OverlayFiringAnim);

    if (Level.NetMode == NM_Standalone) //TODO: Remove, single-player testing?
    {
        Gun.PlayAnim(GunFiringAnim);
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
        ServerUndeploy(HUDOverlay.GetAnimDuration(OverlayUndeployingAnim));
    }

    if (Role == ROLE_Authority)
    {
        Sleep(UndeployingDuration);
        Undeploy();
    }
}

// New client-to-server function called when player undeploys mortar, to send server to state Undeploying
function ServerUndeploy(float AnimDuration)
{
    UndeployingDuration = AnimDuration; // server doesn't have HUDOverlay, so client passes animation duration so server can time destruction of mortar actors

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

// New function to play an animation on the HUDOverlay
simulated function PlayOverlayAnimation(name OverlayAnimation, optional bool bLoop, optional float Rate)
{
    if (HUDOverlay != none && HUDOverlay.HasAnim(OverlayAnimation))
    {
        if (Rate == 0.0) // default to 1.0 if no rate was passed
        {
            Rate = 1.0;
        }

        if (bLoop)
        {
            HUDOverlay.LoopAnim(OverlayAnimation, Rate);
        }
        else
        {
            HUDOverlay.PlayAnim(OverlayAnimation, Rate);
        }
    }
}

simulated function DrawHUD(Canvas C)
{
    local PlayerController PC;
    local vector  CameraLocation, Loc;
    local rotator CameraRotation;
    local Actor   ViewActor;
    local float   HUDScale, Elevation, Traverse;
    local byte    Quotient, Remainder;
    local int     SizeX, SizeY, PendingRoundIndex;
    local string  TraverseString;

    PC = PlayerController(Controller);

    if (PC == none)
    {
        super.RenderOverlays(C);

        return;
    }
    else
    {
        SpecialCalcBehindView(PC, ViewActor, CameraLocation, CameraRotation);
    }

    if (PC != none && !PC.bBehindView && HUDOverlay != none)
    {
        SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);

        if (!Level.IsSoftwareRendering())
        {
            if (DHMortarVehicleWeapon(Gun) != none)
            {
                Elevation = DHMortarVehicleWeapon(Gun).Elevation;
            }

            Traverse = Gun.CurrentAim.Yaw;

            if (Traverse > 32768.0)
            {
                Traverse -= 65536.0;
            }

            // Convert to degrees and use make clockwise rotations positive
            Traverse /= -182.0444;

            TraverseString = "T: ";

            // Add a + at the beginning to explicitly state a positive rotation
            if (Traverse > 0.0)
            {
                TraverseString $= "+";
            }

            TraverseString $= String(Traverse);

            CameraRotation = PC.Rotation;
            SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);

            //CameraRotation.Pitch += (Elevation - 60) * 182.0444444444444;

            HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));

            HUDOverlay.SetRotation(CameraRotation);

            C.DrawActor(HUDOverlay, false, true, HUDOverlayFOV);

            if (PC.myHUD != none && PC.myHUD.bHideHUD)
            {
                return;
            }

            C.Font = class'DHHud'.static.GetSmallerMenuFont(C);

            HUDScale = C.SizeY / 1280.0;

            C.SetPos(0.0, C.SizeY - (256.0 * HUDScale));
            C.SetDrawColor(255, 255, 255, 255);
            C.DrawTile(HUDArcTexture, 256.0 * HUDScale, 256.0 * HUDScale, 0.0, 0.0, 512.0, 512.0);

            // Draw rounds
            C.SetPos(256.0 * HUDScale, C.SizeY - (256.0 * HUDScale));

            PendingRoundIndex = DHMortarVehicleWeapon(Gun).GetPendingRoundIndex();

            C.SetDrawColor(0, 0, 0, 255);
            C.SetPos(HUDScale * 10.0, C.SizeY - (HUDScale * 94.0));
            C.DrawText(DHMortarVehicleWeapon(Gun).PendingProjectileClass.default.Tag);

            if (Gun.HasAmmo(PendingRoundIndex))
            {
                C.SetDrawColor(255, 255, 255, 255);
            }
            else
            {
                C.SetDrawColor(128, 128, 128, 255);
            }

            C.SetPos(HUDScale * 256.0, C.SizeY - HUDScale * 256.0);

            if (PendingRoundIndex == 0)
            {
                C.DrawTile(HUDHighExplosiveTexture, 128.0 * HUDScale, 256.0 * HUDScale, 0.0, 0.0, 128.0, 256.0);
            }
            else
            {
                C.DrawTile(HUDSmokeTexture, 128.0 * HUDScale, 256.0 * HUDScale, 0.0, 0.0, 128.0, 256.0);
            }

            // Drawing
            if (Gun.MainAmmoCharge[PendingRoundIndex] < 10)
            {
                C.SetPos(384.0 * HUDScale, C.SizeY - (160.0 * HUDScale));
                Quotient = Gun.MainAmmoCharge[PendingRoundIndex];

                SizeX = Digits.TextureCoords[Quotient].X2 - Digits.TextureCoords[Quotient].X1;
                SizeY = Digits.TextureCoords[Quotient].Y2 - Digits.TextureCoords[Quotient].Y1;

                C.DrawTile(Digits.DigitTexture, 40.0 * HUDScale, 64.0 * HUDScale, Digits.TextureCoords[Gun.MainAmmoCharge[PendingRoundIndex]].X1,
                    Digits.TextureCoords[Gun.MainAmmoCharge[PendingRoundIndex]].Y1, SizeX, SizeY);
            }
            else
            {
                C.SetPos(384.0 * HUDScale, C.SizeY - (160.0 * HUDScale));
                Quotient = Gun.MainAmmoCharge[PendingRoundIndex] / 10;
                Remainder = Gun.MainAmmoCharge[PendingRoundIndex] % 10;

                SizeX = Digits.TextureCoords[Quotient].X2 - Digits.TextureCoords[Quotient].X1;
                SizeY = Digits.TextureCoords[Quotient].Y2 - Digits.TextureCoords[Quotient].Y1;

                C.DrawTile(Digits.DigitTexture, 40.0 * HUDScale, 64.0 * HUDScale, Digits.TextureCoords[Quotient].X1, Digits.TextureCoords[Quotient].Y1, SizeX, SizeY);

                SizeX = Digits.TextureCoords[Remainder].X2 - Digits.TextureCoords[Remainder].X1;
                SizeY = Digits.TextureCoords[Remainder].Y2 - Digits.TextureCoords[Remainder].Y1;

                C.DrawTile(Digits.DigitTexture, 40.0 * HUDScale, 64.0 * HUDScale, Digits.TextureCoords[Remainder].X1, Digits.TextureCoords[Remainder].Y1, SizeX, SizeY);
            }

            C.SetDrawColor(255, 255, 255, 255);
            C.SetPos(HUDScale * 8.0, C.SizeY - (HUDScale * 96.0));
            C.DrawText(DHMortarVehicleWeapon(Gun).PendingProjectileClass.default.Tag);

            HUDArrowTexture.Rotation.Yaw = class'DHLib'.static.DegreesToUnreal(Elevation + 180.0);
            Loc.X = Cos(class'DHLib'.static.DegreesToRadians(Elevation)) * 256.0;
            Loc.Y = Sin(class'DHLib'.static.DegreesToRadians(Elevation)) * 256.0;

            C.SetDrawColor(255, 255, 255, 255);
            C.SetPos(HUDScale * (Loc.X - 32.0), C.SizeY - (HUDScale * (Loc.Y + 32.0)));
            C.DrawTile(HUDArrowTexture, 64.0 * HUDScale, 64.0 * HUDScale, 0.0, 0.0, 128.0, 128.0);

            C.SetDrawColor(0, 0, 0, 255);
            C.SetPos(HUDScale * 10.0, C.SizeY - (HUDScale * 30.0));
            C.DrawText("E:" @ String(Elevation));

            C.SetDrawColor(255, 255, 255, 255);
            C.SetPos(HUDScale * 8.0, C.SizeY - (HUDScale * 32.0));
            C.DrawText("E:" @ String(Elevation));

            C.SetDrawColor(0, 0, 0, 255);
            C.SetPos(HUDScale * 10.0, C.SizeY - (HUDScale * 62.0));
            C.DrawText(TraverseString);

            C.SetDrawColor(255, 255, 255, 255);
            C.SetPos(HUDScale * 8.0, C.SizeY - (HUDScale * 64.0));
            C.DrawText(TraverseString);
        }
    }
    else
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
    local vector  x, y, z;
    local vector  VehicleZ, CamViewOffsetWorld;
    local float   CamViewOffsetZAmount;
    local coords  CamBoneCoords;
    local rotator WeaponAimRot;
    local quat    AQuat, BQuat, CQuat;

    GetAxes(CameraRotation, x, y, z);
    ViewActor = self;

    WeaponAimRot = rotator(vector(Gun.CurrentAim) >> Gun.Rotation);
    WeaponAimRot.Roll = VehicleBase.Rotation.Roll;

    if (ROPlayer(Controller) != none)
    {
        ROPlayer(Controller).WeaponBufferRotation.Yaw = WeaponAimRot.Yaw;
        ROPlayer(Controller).WeaponBufferRotation.Pitch = WeaponAimRot.Pitch;
    }

    // This makes the camera stick to the cannon, but you have no control
    if (DriverPositionIndex == 0)
    {
        CameraRotation = rotator(Gun.GetBoneCoords(CameraBone).XAxis);
        CameraRotation.Roll = 0; // make the cannon view have no roll
    }
    else if (bPCRelativeFPRotation)
    {
        // First, rotate the headbob by the player controllers rotation (looking around)
        AQuat = QuatFromRotator(PC.Rotation);
        BQuat = QuatFromRotator(HeadRotationOffset - ShiftHalf);
        CQuat = QuatProduct(AQuat,BQuat);

        // Then, rotate that by the vehicles rotation to get the final rotation
        AQuat = QuatFromRotator(VehicleBase.Rotation);
        BQuat = QuatProduct(CQuat,AQuat);

        // Make it back into a rotator!
        CameraRotation = QuatToRotator(BQuat);
    }
    else
    {
        CameraRotation = PC.Rotation;
    }

    if (IsInState('ViewTransition') && bLockCameraDuringTransition)
    {
        CameraRotation = Gun.GetBoneRotation('Camera_com');
    }

    CamViewOffsetWorld = FPCamViewOffset >> CameraRotation;

    if (CameraBone != '' && Gun != none)
    {
        CamBoneCoords = Gun.GetBoneCoords(CameraBone);

        if (DriverPositionIndex == 0 && !IsInState('ViewTransition'))
        {
            CameraLocation = CamBoneCoords.Origin + (FPCamPos >> WeaponAimRot) + CamViewOffsetWorld;
        }
        else
        {
            CameraLocation = Gun.GetBoneCoords('Camera_com').Origin;
        }

        if (bFPNoZFromCameraPitch)
        {
            VehicleZ = vect(0.0, 0.0, 1.0) >> WeaponAimRot;

            CamViewOffsetZAmount = CamViewOffsetWorld dot VehicleZ;
            CameraLocation -= CamViewOffsetZAmount * VehicleZ;
        }
    }
    else
    {
        CameraLocation = GetCameraLocationStart() + (FPCamPos >> Rotation) + CamViewOffsetWorld;

        if (bFPNoZFromCameraPitch)
        {
            VehicleZ = vect(0.0, 0.0, 1.0) >> Rotation;
            CamViewOffsetZAmount = CamViewOffsetWorld dot VehicleZ;
            CameraLocation -= CamViewOffsetZAmount * VehicleZ;
        }
    }

    CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
    CameraLocation = CameraLocation + PC.ShakeOffset.X * x + PC.ShakeOffset.Y * y + PC.ShakeOffset.Z * z;
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
    // Big giant hack to allow us to access the PRI of the gunner
    VehicleBase.PlayerReplicationInfo = P.PlayerReplicationInfo;
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

        VehicleBase.PlayerReplicationInfo = none; // reset back to none
    }
}

defaultproperties
{
    bMultiPosition=false
    bSinglePositionExposed=true
    OverlayKnobLoweringAnimRate=1.25
    OverlayKnobRaisingAnimRate=1.25
    OverlayKnobTurnAnimRate=1.25
    ElevationAdjustmentDelay=0.125
    HUDHighExplosiveTexture=texture'DH_Mortars_tex.60mmMortarM2.M49A2-HE'
    HUDSmokeTexture=texture'DH_Mortars_tex.60mmMortarM2.M302-WP'
    HUDArrowTexture=TexRotator'DH_Mortars_tex.HUD.ArrowRotator'
    bCanUndeploy=true
    ShakeScale=2.25
    BlurTime=0.5
    BlurEffectScalar=1.35
    Digits=(DigitTexture=texture'InterfaceArt_tex.HUD.numbers',TextureCoords[0]=(X1=15,X2=47,Y2=63),TextureCoords[1]=(X1=79,X2=111,Y2=63),TextureCoords[2]=(X1=143,X2=175,Y2=63),TextureCoords[3]=(X1=207,X2=239,Y2=63),TextureCoords[4]=(X1=15,Y1=64,X2=47,Y2=127),TextureCoords[5]=(X1=79,Y1=64,X2=111,Y2=127),TextureCoords[6]=(X1=143,Y1=64,X2=175,Y2=127),TextureCoords[7]=(X1=207,Y1=64,X2=239,Y2=127),TextureCoords[8]=(X1=15,Y1=128,X2=47,Y2=191),TextureCoords[9]=(X1=79,Y1=128,X2=111,Y2=191),TextureCoords[10]=(X1=143,Y1=128,X2=175,Y2=191))
    bDrawMeshInFP=false
    bPCRelativeFPRotation=true
    ExitPositions(0)=(X=-48.0)
    ExitPositions(1)=(X=-48.0,Y=-48.0)
    ExitPositions(2)=(X=-48.0,Y=48.0)
    ExitPositions(3)=(Y=-48.0)
    ExitPositions(4)=(Y=48.0)
    ExitPositions(5)=(Z=64.0)
    bKeepDriverAuxCollision=true
    WeaponFOV=90.0
}
