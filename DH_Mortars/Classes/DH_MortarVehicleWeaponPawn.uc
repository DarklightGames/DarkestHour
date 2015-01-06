//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_MortarVehicleWeaponPawn extends ROTankCannonPawn
    abstract;

const DEG2RAD = 0.0174532925;
const RAD2DEG = 57.2957795;
const DEG2UU = 182.04444;

//Animations
var name DriverIdleAnim;
var name DriverFiringAnim;
var name DriverUnflinchAnim;

const IdleAnimIndex = 0;
const FiringAnimIndex = 1;
const UnflinchAnimIndex = 2;

var name OverlayIdleAnim;
var name OverlayFiringAnim;
var name OverlayUndeployingAnim;
var name OverlayKnobRaisingAnim;
var name OverlayKnobLoweringAnim;
var name OverlayKnobIdleAnim;
var name OverlayKnobTurnLeftAnim;
var name OverlayKnobTurnRightAnim;

//Animation rates, new in 5.0 hotfix because old animations were too slow.
var float OverlayKnobLoweringAnimRate;
var float OverlayKnobRaisingAnimRate;
var float OverlayKnobTurnAnimRate;

var name GunIdleAnim;
var name GunFiringAnim;

var class<DH_MortarWeapon> WeaponClass;

var bool bTraversing;

//Elevation timing
var float LastElevationTime;
var float ElevationAdjustmentDelay;

var texture HUDMortarTexture;
var texture HUDHighExplosiveTexture;
var texture HUDSmokeTexture;
var texture HUDArcTexture;
var TexRotator HUDArrowTexture;

var byte CurrentDriverAnimation;
var byte OldDriverAnimation;

var bool    bCanUndeploy;
var bool    bPendingFire;

// View shake vars
var         float       ShakeScale;       // how much larger than the explosion radius should the view shake
var         float       BlurTime;         // how long blur effect should last for this projectile
// camera shakes //
var()       vector      ShakeRotMag;      // how far to rot view
var()       vector      ShakeRotRate;     // how fast to rot view
var()       float       ShakeRotTime;     // how much time to rot the instigator's view
var()       vector      ShakeOffsetMag;   // max view offset vertically
var()       vector      ShakeOffsetRate;  // how fast to offset view vertically
var()       float       ShakeOffsetTime;  // how much time to offset view
var()       float       BlurEffectScalar; 

struct DigitSet
{
    var Material DigitTexture;
    var IntBox   TextureCoords[11];
};
var DigitSet Digits;

replication
{
    reliable if (Role < ROLE_Authority) // client to server
        ServerUndeploy, ServerFire, SetCurrentAnimation;

    reliable if (Role == ROLE_Authority) // server to client
        CurrentDriverAnimation, bCanUndeploy, ClientShakeView;
}

simulated function IncrementRange() { }
simulated function DecrementRange() { }

simulated function PostNetReceive()
{
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

simulated function SetCurrentAnimation(byte Index)
{
    CurrentDriverAnimation = Index;
}

simulated function ServerFire()
{
    Gun.Fire(Controller);
}

// Matt: modified to avoid an "accessed none" error (need to remove a reference to VehicleBase in the Super in ROVehicleWeaponPawn)
simulated function ClientKDriverEnter(PlayerController PC)
{
    local DHPlayer DHP;

    if (bMultiPosition)
    {
        GotoState('EnteringVehicle');
    }

    PendingPositionIndex = 0;
//  StoredVehicleRotation = VehicleBase.Rotation; // this is called a split second before we receive VehicleBase, so we just get "accessed none" & StoredVehicleRotation isn't used anyway

    super(VehicleWeaponPawn).ClientKDriverEnter(PC);

    PC.SetFOV( WeaponFOV );

    // From here on is mortar specific - above is just re-stating the Supers, with 1 line removed
    GotoState('Idle');

    DHP = DHPlayer(PC);
    DHP.QueueHint(7, false);
    DHP.QueueHint(8, false);
    DHP.QueueHint(9, false);
    DHP.QueueHint(10, false);
}

simulated function ClientKDriverLeave(PlayerController PC)
{
    local rotator PCRot;

    super.ClientKDriverLeave(PC);

    DH_MortarVehicleWeapon(Gun).ClientReplicateElevation(DH_MortarVehicleWeapon(Gun).Elevation);

    PCRot = Gun.GetBoneRotation(DH_MortarVehicleWeapon(Gun).MuzzleBoneName);
    PCRot.Pitch = 0;
    PCRot.Roll = 0;
    PC.Pawn.SetRotation(PCRot);

    GotoState('Idle');

    PC.FixFOV();
}

simulated state Busy
{
    function HandleTurretRotation(float DeltaTime, float YawChange, float PitchChange) { }
    function IncrementRange() { }
    function DecrementRange() { }
    function Fire(optional float F) { }
    function AltFire(optional float F) { }
    simulated exec function SwitchFireMode() { }
    exec function Deploy() { }

    function bool KDriverLeave(bool bForceLeave)
    {
        local bool bDriverLeft;
        local Pawn P;

        P = Driver;

        bDriverLeft = false;

        if (IsInState('Undeploying'))
        {
            bDriverLeft = super.KDriverLeave(bForceLeave);

            if (bDriverLeft)
            {
                DriverLeaveAmmunitionTransfer(P);

                GotoState('Idle'); // reset state for the next person who comes on.

                if (DHPlayer(P.Controller) != none)
                {
                    DHPlayer(P.Controller).ClientToggleDuck();
                }

                if (DH_Pawn(P) != none)
                {
                    DH_Pawn(P).CheckIfMortarCanBeResupplied();
                }
            }
        }

        return bDriverLeft;
    }
}

simulated state Idle
{
    simulated function BeginState()
    {
        PlayOverlayAnimation(OverlayIdleAnim, true, 1.0);
    }

    simulated function Fire(optional float F)
    {
        if (DH_MortarVehicleWeapon(Gun) != none && DH_MortarVehicleWeapon(Gun).HasPendingAmmo())
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
        else if (PitchChange != 0.0 && (Level.TimeSeconds - LastElevationTime) > ElevationAdjustmentDelay)
        {
            LastElevationTime = Level.TimeSeconds;

            if (PitchChange < 0.0)
            {
                DH_MortarVehicleWeapon(Gun).Elevate();
            }
            else
            {
                DH_MortarVehicleWeapon(Gun).Depress();
            }
        }
        else if (YawChange != 0.0)
        {
            GotoState('KnobRaising');
        }
    }
}

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
        ClientMessage("Missing animation: " @ DriverUnflinchAnim);
    }

    if (bPendingFire && DH_MortarVehicleWeapon(Gun) != none && DH_MortarVehicleWeapon(Gun).HasPendingAmmo())
    {
        GotoState('Firing');
    }
    else
    {
        GotoState('Idle');
    }
}

simulated function ClientShakeView()
{
    if (Controller != none && DHPlayer(Controller) != none)
    {
        DHPlayer(Controller).AddBlur(BlurTime, BlurEffectScalar);
        DHPlayer(Controller).ShakeView(ShakeRotMag, ShakeRotRate, ShakeRotTime, ShakeOffsetMag, ShakeOffsetRate, ShakeOffsetTime);
    }
}

simulated state KnobRaising extends Busy
{
Begin:
    PlayOverlayAnimation(OverlayKnobRaisingAnim, false, OverlayKnobRaisingAnimRate);
    Sleep(HUDOverlay.GetAnimDuration(OverlayKnobRaisingAnim, OverlayKnobRaisingAnimRate));
    GotoState('KnobRaised');
}

simulated state KnobRaised
{
    simulated function BeginState()
    {
        PlayOverlayAnimation(OverlayKnobIdleAnim, true, 1.0);
    }

    simulated function Fire(optional float F)
    {
        if (DH_MortarVehicleWeapon(Gun) != none && DH_MortarVehicleWeapon(Gun).HasPendingAmmo())
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
        if (PitchChange != 0.0)
        {
            GotoState('KnobRaisedToIdle');

            return;
        }

        if (bTraversing && YawChange == 0.0)
        {
            bTraversing = false;
            HUDOverlay.StopAnimating(true);

            return;
        }

        if (YawChange != 0.0)
        {
            bTraversing = true;

            if (YawChange > 0.0)
            {
                HUDOverlay.LoopAnim(OverlayKnobTurnRightAnim, OverlayKnobTurnAnimRate, 0.125);
            }
            else
            {
                HUDOverlay.LoopAnim(OverlayKnobTurnLeftAnim, OverlayKnobTurnAnimRate, 0.125);
            }

            super.HandleTurretRotation(DeltaTime, -YawChange, 0);
        }
    }
}

simulated state KnobLowering extends Busy
{
Begin:
    PlayOverlayAnimation(OverlayKnobLoweringAnim, false, OverlayKnobLoweringAnimRate);
    Sleep(HUDOverlay.GetAnimDuration(OverlayKnobLoweringAnim, OverlayKnobLoweringAnimRate));
    GotoState('Idle');
}

simulated state Firing extends Busy
{
Begin:
    DH_MortarVehicleWeapon(Gun).ClientReplicateElevation(DH_MortarVehicleWeapon(Gun).Elevation);
    PlayOverlayAnimation(OverlayFiringAnim, false, 1.0);

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

simulated state Undeploying extends Busy
{
Begin:
    PlayOverlayAnimation(OverlayUndeployingAnim, false, 1.0);
    Sleep(HUDOverlay.GetAnimDuration(OverlayUndeployingAnim));
    ServerUndeploy();
}

function bool KDriverLeave(bool bForceLeave)
{
    local Pawn P;
    local bool bDriverLeft;

    P = Driver;

    bDriverLeft = super.KDriverLeave(bForceLeave);

    if (bDriverLeft)
    {
        DriverLeaveAmmunitionTransfer(P);

        GotoState('Idle'); // reset state for the next person who comes on

        if (DHPlayer(P.Controller) != none)
        {
            DHPlayer(P.Controller).ClientToggleDuck();
        }

        if (DH_Pawn(P) != none)
        {
            DH_Pawn(P).CheckIfMortarCanBeResupplied();
        }
    }

    return bDriverLeft;
}

simulated function PlayOverlayAnimation(name OverlayAnimation, bool bLoop, float Rate)
{
    if (HUDOverlay != none && HUDOverlay.HasAnim(OverlayAnimation))
    {
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

simulated function ServerUndeploy()
{
    local DH_MortarWeapon  W;
    local PlayerController PC;

    PC = PlayerController(Controller);
    W = Spawn(WeaponClass, PC.Pawn);

    KDriverLeave(true);
    W.GiveTo(PC.Pawn);
    VehicleBase.Destroy();
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
            if (DH_MortarVehicleWeapon(Gun) != none)
            {
                Elevation = DH_MortarVehicleWeapon(Gun).Elevation;
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

            PendingRoundIndex = DH_MortarVehicleWeapon(Gun).GetPendingRoundIndex();

            C.SetDrawColor(0, 0, 0, 255);
            C.SetPos(HUDScale * 10.0, C.SizeY - (HUDScale * 94.0));
            C.DrawText(DH_MortarVehicleWeapon(Gun).PendingProjectileClass.default.Tag);

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
            C.DrawText(DH_MortarVehicleWeapon(Gun).PendingProjectileClass.default.Tag);

            HUDArrowTexture.Rotation.Yaw = (Elevation + 180.0) * DEG2UU;
            Loc.X = Cos(Elevation * DEG2RAD) * 256.0;
            Loc.Y = Sin(Elevation * DEG2RAD) * 256.0;

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

simulated state KnobRaisedToFire extends Busy
{
Begin:
    HUDOverlay.PlayAnim(OverlayKnobLoweringAnim);
    Sleep(HUDOverlay.GetAnimDuration(OverlayKnobLoweringAnim));
    GotoState('Firing');
}

simulated state KnobRaisedToUndeploy extends Busy
{
Begin:
    HUDOverlay.PlayAnim(OverlayKnobLoweringAnim);
    Sleep(HUDOverlay.GetAnimDuration(OverlayKnobLoweringAnim));
    GotoState('Undeploying');
}

simulated state KnobRaisedToIdle extends Busy
{
Begin:
    HUDOverlay.PlayAnim(OverlayKnobLoweringAnim);
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
    WeaponAimRot.Roll =  GetVehicleBase().Rotation.Roll;

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
        AQuat = QuatFromRotator(GetVehicleBase().Rotation);
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

        if (DriverPositions[DriverPositionIndex].bDrawOverlays && DriverPositionIndex == 0 && !IsInState('ViewTransition'))
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

function bool ResupplyAmmo()
{
    local bool bResupplySuccessful;

    bResupplySuccessful = super.ResupplyAmmo();

    if (bResupplySuccessful)
    {
        DH_MortarVehicle(VehicleBase).bCanBeResupplied = false;
    }

    return bResupplySuccessful;
}

function KDriverEnter(Pawn P)
{
    // Big giant hack to allow us to access the PRI of the gunner
    VehicleBase.PlayerReplicationInfo = P.PlayerReplicationInfo;
    DriverEnterTransferAmmunition(P);

    super.KDriverEnter(P);

    GotoState('Idle');
}

// This transfers the ammunition to the weapon upon entering the mortar
function DriverEnterTransferAmmunition(Pawn P)
{
    local DH_Pawn DHP;
    local DH_MortarVehicleWeapon DHMVW;

    DHP = DH_Pawn(P);
    DHMVW = DH_MortarVehicleWeapon(Gun);

    if (DHP != none && DHMVW != none)
    {
        DHMVW.MainAmmoCharge[0] = Clamp(DHMVW.MainAmmoCharge[0] + DHP.MortarHEAmmo, 0, GunClass.default.InitialPrimaryAmmo);
        DHMVW.MainAmmoCharge[1] = Clamp(DHMVW.MainAmmoCharge[1] + DHP.MortarSmokeAmmo, 0, GunClass.default.InitialSecondaryAmmo);

        DHP.MortarHEAmmo = 0;
        DHP.MortarSmokeAmmo = 0;
    }

    CheckCanBeResupplied();
}

function CheckCanBeResupplied()
{
    if (Gun.MainAmmoCharge[0] < GunClass.default.InitialPrimaryAmmo || Gun.MainAmmoCharge[1] < GunClass.default.InitialSecondaryAmmo)
    {
        DH_MortarVehicle(VehicleBase).bCanBeResupplied = true;
    }
    else
    {
        DH_MortarVehicle(VehicleBase).bCanBeResupplied = false;
    }
}

// This transfers the ammunition to the player upon exiting the mortar
function DriverLeaveAmmunitionTransfer(Pawn P)
{
    local DH_Pawn DHP;
    local DH_MortarVehicleWeapon G;

    DHP = DH_Pawn(P);
    G = DH_MortarVehicleWeapon(Gun);

    if (DHP != none && G != none)
    {
        DHP.MortarHEAmmo = G.MainAmmoCharge[0];
        DHP.MortarSmokeAmmo = G.MainAmmoCharge[1];
        G.MainAmmoCharge[0] = 0;
        G.MainAmmoCharge[1] = 0;

        if (DH_MortarVehicle(VehicleBase) != none)
        {
            DH_MortarVehicle(VehicleBase).bCanBeResupplied = true;
        }

        VehicleBase.PlayerReplicationInfo = none; // reset back to none
    }
}

defaultproperties
{
    OverlayKnobLoweringAnimRate=1.25
    OverlayKnobRaisingAnimRate=1.25
    OverlayKnobTurnAnimRate=1.25
    ElevationAdjustmentDelay=0.125
    HUDMortarTexture=texture'DH_Mortars_tex.60mmMortarM2.60mmMortarM2'
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
