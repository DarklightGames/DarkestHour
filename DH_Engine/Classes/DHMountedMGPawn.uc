//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// [ ] bullet snapping & whizzing should still work on exposed vehicle occupants!
// [ ] There's no message when the gun barrel is blocked and the player tries to fire.
// [ ] Switch off of the gunsight position when reloading.
//=============================================================================

class DHMountedMGPawn extends DHVehicleMGPawn
    abstract;

// Debugging
var Actor TargetActor;
var StaticMesh TargetStaticMesh;

// Zooming
var bool bIsZoomed;
var() float ZoomFOV;

// Reload
var() name  ReloadCameraBone;

// First Person Hands
var DHFirstPersonHands  HandsActor;
var Mesh                HandsMesh;
var() name              HandsReloadSequence;
var() name              HandsIdleSequence;
var name                HandsAttachBone;
var() Vector            HandsRelativeLocation;

// Belt
var Class<DHFirstPersonBelt>    BeltClass;
var name                        BeltAttachBone;
var DHFirstPersonBelt           BeltActor;

var int GunsightPositionIndex;

// Camera Transition
var name CameraBone;
var name TargetCameraBone;
var float CameraTransitionStartTimeSeconds;
var float CameraTransitionDurationSeconds;

simulated function SetCameraBoneTarget(name NewTargetCameraBone, optional float TransitionDurationSeconds)
{
    TargetCameraBone = NewTargetCameraBone;
    CameraTransitionStartTimeSeconds = Level.TimeSeconds;
    CameraTransitionDurationSeconds = TransitionDurationSeconds;
}

simulated function TickCamera()
{
    local Vector CameraLocation, TargetCameraLocation;
    local Rotator CameraRotation, TargetCameraRotation;
    local float T;

    if (Gun == none || CameraBone == TargetCameraBone)
    {
        // Nothing to do.
        return;
    }

    T = (Level.TimeSeconds - CameraTransitionStartTimeSeconds) / CameraTransitionDurationSeconds;

    if (T >= 1.0)
    {
        // Transition complete.
        CameraBone = TargetCameraBone;
        return;
    }
}

simulated function GetCameraLocationAndRotation(out Vector CameraLocation, out Rotator CameraRotation)
{
    local float T;
    local Vector TargetCameraLocation;
    local Rotator TargetCameraRotation;

    // Get current and target camera coords.
    CameraLocation = Gun.GetBoneCoords(CameraBone).Origin;
    CameraRotation = Gun.GetBoneRotation(CameraBone);
    TargetCameraLocation = Gun.GetBoneCoords(TargetCameraBone).Origin;
    TargetCameraRotation = Gun.GetBoneRotation(TargetCameraBone);

    T = Clamp((Level.TimeSeconds - CameraTransitionStartTimeSeconds) / CameraTransitionDurationSeconds, 0.0, 1.0);

    if (T >= 1.0)
    {
        // Transition complete.
        CameraLocation = TargetCameraLocation;
        CameraRotation = TargetCameraRotation;
        return;
    }
    else if (T <= 0.0)
    {
        // Transition not started yet.
        return;
    }
    else
    {
        // Smooth step.
        T = Class'UInterp'.static.SmoothStep(T, 0.0, 1.0);
        CameraLocation = Class'UVector'.static.VLerp(T, CameraLocation, TargetCameraLocation);
        CameraRotation = QuatToRotator(QuatSlerp(QuatFromRotator(CameraRotation), QuatFromRotator(TargetCameraRotation), T));
    }
}

// We only have two positions and we want to snap the field of view when switching
// between them.
simulated function bool ShouldViewSnapInPosition(byte PositionIndex)
{
    return true;
}

// Overridden to un-zoom when changing view positions.
simulated state ViewTransition
{
    simulated function BeginState()
    {
        // TODO: i think this is what's immediately forcing the FOV?

        super.BeginState();

        // Un-zoom when changing view positions.
        if (bIsZoomed)
        {
            SetIsZoomed(false);
        }

        // Which camera are we switching to?
        if (DriverPositionIndex == GunsightPositionIndex)
        {
        }
    }
    
    // TODO: transfer the camera.
}

simulated function Destroyed()
{
    if (TargetActor != none)
    {
        TargetActor.Destroy();
    }

    if (HandsActor != none)
    {
        HandsActor.Destroy();
    }

    if (BeltActor != none)
    {
        BeltActor.Destroy();
    }

    super.Destroyed();
}

simulated function InitializeBelt()
{
    if (BeltActor != none)
    {
        BeltActor.Destroy();
    }

    if (BeltClass == none)
    {
        return;
    }

    BeltActor = Spawn(BeltClass, self);

    if (BeltActor == none)
    {
        return;
    }

    Gun.AttachToBone(BeltActor, BeltAttachBone);
    BeltActor.SetRelativeLocation(vect(0, 0, 0));
    BeltActor.SetRelativeRotation(rot(0, 0, 0));
}

simulated function InitializeHands()
{
    if (HandsActor != none)
    {
        HandsActor.Destroy();
    }

    if (HandsMesh == none)
    {
        return;
    }

    HandsActor = Spawn(Class'DHFirstPersonHands', self);
    HandsActor.LinkMesh(HandsMesh);

    if (HandsActor.HasAnim(HandsIdleSequence))
    {
        HandsActor.PlayAnim(HandsIdleSequence);
    }

    HandsActor.SetSkins(DHPlayer(Controller));

    if (Gun != none)
    {
        Gun.AttachToBone(HandsActor, HandsAttachBone);
    }

    HandsActor.SetRelativeLocation(HandsRelativeLocation);
    HandsActor.SetRelativeRotation(rot(0, 0, 0));
}

simulated function ClientKDriverEnter(PlayerController PC)
{
    local DHMountedMG MG;

    super.ClientKDriverEnter(PC);

    if (!IsLocallyControlled())
    {
        return;
    }

    InitializeHands();
    InitializeBelt();

    MG = DHMountedMG(Gun);

    if (MG != none)
    {
        MG.UpdateClip();
        MG.UpdateRangeDriverFrameTarget();

        // Put the belt in the right state based on current ammo count.
        if (BeltActor != none)
        {
            BeltActor.FreezeAnimAtAmmoCount(MG.MainAmmoCharge[0]);
        }
    }
}

simulated function ClientKDriverLeave(PlayerController PC)
{
    super.ClientKDriverLeave(PC);

    if (HandsActor != none)
    {
        HandsActor.Destroy();
        HandsActor = none;
    }
}

simulated function SetIsZoomed(bool bNewIsZoomed)
{
    local DHPlayer PC;

    PC = DHPlayer(Controller);

    // Only the local player can change the zoom state.
    if (!IsLocallyControlled() || bIsZoomed == bNewIsZoomed || PC == none)
    {
        return;
    }

    if (bNewIsZoomed)
    {
        PC.DesiredFOV = ZoomFOV;
    }
    else
    {
        PC.DesiredFOV = PC.DefaultFOV;
    }

    bIsZoomed = bNewIsZoomed;
}

simulated function ToggleZoom()
{
    if (IsReloading() || IsOnGunsight() || IsInState('ViewTransition'))
    {
        return;
    }

    SetIsZoomed(!bIsZoomed);
}

simulated function ROIronSights()
{
    ToggleZoom();
}

simulated function PlayHandsReloadAnim()
{
    if (HandsActor == none)
    {
        return;
    }

    HandsActor.PlayAnim(HandsReloadSequence);
}

simulated function bool IsReloading()
{
    local DHMountedMG MG;

    MG = DHMountedMG(Gun);

    return MG != none && MG.IsReloading();
}

simulated function bool IsOnGunsight()
{
    return DriverPositionIndex == GunsightPositionIndex && !IsInState('ViewTransition');
}

simulated function float GetOverlayCorrectionX()
{
    local DHMountedMG MG;

    MG = DHMountedMG(Gun);

    if (MG == none)
    {
        return super.GetOverlayCorrectionX();
    }

    return MG.RangeParams.GetGunsightCorrectXOffset();
}

exec function SetOverlayCorrectionX(float NewCorrectionX)
{
    local DHMountedMG MG;

    MG = DHMountedMG(Gun);

    if (MG != none)
    {
        MG.RangeParams.RangeTable[MG.RangeIndex].GunsightCorrectX = NewCorrectionX;
    }
}

exec function SetGunsightPitchOffset(float NewPitchOffset)
{
    local DHMountedMG MG;

    MG = DHMountedMG(Gun);

    if (MG != none)
    {
        MG.RangeParams.RangeTable[MG.RangeIndex].GunsightPitch = NewPitchOffset;
    }
}

simulated function SpecialCalcFirstPersonView(PlayerController PC, out Actor ViewActor, out Vector CameraLocation, out Rotator CameraRotation)
{
    local float T;
    local DHMountedMG MG;
    local Coords ReloadCameraCoords;
    local Vector ReloadCameraLocation, GunsightCameraLocation;
    local Rotator GunsightCameraRotation, ReloadCameraRotation;

    MG = DHMountedMG(Gun);

    if (MG == none)
    {
        return;
    }

    if (IsOnGunsight())
    {
        // Adjust the pitch of the gunsight bone based on the current range setting.
        CameraLocation = Gun.GetBoneCoords(GunsightCameraBone).Origin;
        GunsightCameraRotation.Pitch = MG.RangeParams.GetGunsightPitchOffset();
        CameraRotation = QuatToRotator(QuatProduct(
            QuatFromRotator(GunsightCameraRotation),
            QuatFromRotator(Gun.GetBoneRotation(GunsightCameraBone))
            ));

        Log("CameraRotation" @ CameraRotation);
    }
    else if (IsReloading())
    {
        ReloadCameraCoords = MG.GetBoneCoords(ReloadCameraBone);
        ReloadCameraLocation = ReloadCameraCoords.Origin;
        ReloadCameraRotation = QuatToRotator(
            Class'UQuaternion'.static.FromAxes(ReloadCameraCoords.XAxis, ReloadCameraCoords.YAxis, ReloadCameraCoords.ZAxis)
        );

        T = Class'UInterp'.static.LerpBilateral(Level.TimeSeconds, MG.ReloadStartTimeSeconds, MG.ReloadEndTimeSeconds, MG.ReloadCameraTweenTime, MG.ReloadCameraTweenTime);
        T = Class'UInterp'.static.SmoothStep(T, 0.0, 1.0);

        CameraLocation = Class'UVector'.static.VLerp(T, CameraLocation, ReloadCameraLocation);
        CameraRotation = QuatToRotator(QuatSlerp(QuatFromRotator(CameraRotation), QuatFromRotator(ReloadCameraRotation), T));
    }
    else
    {
        GetCameraLocationAndRotation(CameraLocation, CameraRotation);
    }

    // Finalise the camera with any shake
    CameraLocation += PC.ShakeOffset >> PC.Rotation;
    CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
}

// Despite the name, this function is used to update the gun's rotation.
public function UpdateRocketAcceleration(Float DeltaTime, Float YawChange, Float PitchChange)
{
    PitchChange *= 0.5;

    // If we are reloading, don't allow the player to rotate the gun.
    if (IsReloading())
    {
        PitchChange = 0;
        YawChange = 0;
    }

    if (bIsZoomed)
    {
        YawChange *= 0.5;
        PitchChange *= 0.5;
    }

    super.UpdateRocketAcceleration(DeltaTime, YawChange, PitchChange);
}

// Pitch is handled with W/S keys.
function HandleTurretRotation(Float DeltaTime, Float YawChange, Float PitchChange)
{
    local DHMountedMG MG;

    super.HandleTurretRotation(DeltaTime, YawChange, PitchChange);

    // TODO: figure out delta from zero.
    UpdateTurretRotation(DeltaTime, YawChange, PitchChange);

    if (IsHumanControlled())
    {
        PlayerController(Controller).WeaponBufferRotation.Yaw = CustomAim.Yaw;
        PlayerController(Controller).WeaponBufferRotation.Pitch = CustomAim.Pitch;
    }

    MG = DHMountedMG(Gun);

    if (MG != none)
    {
        MG.UpdateAnimationDrivers();
    }
}

// Debugging functions.
simulated exec function SpawnRangeTarget(int SizeMeters)
{
    local Coords MuzzleCoords;
    local Vector Direction, TargetLocation;
    local DHMountedMG MG;

    if (Level.NetMode != NM_Standalone && !Class'DH_LevelInfo'.static.DHDebugMode())
    {
        return;
    }
    
    MG = DHMountedMG(Gun);

    if (Gun == none || MG.RangeParams == none)
    {
        return;
    }

    MuzzleCoords = Gun.GetBoneCoords(Gun.WeaponFireAttachmentBone);

    Direction = MuzzleCoords.XAxis;
    Direction.Z = 0;
    Direction = Normal(Direction);

    if (TargetActor != none)
    {
        TargetActor.Destroy();
    }

    TargetLocation = MuzzleCoords.Origin + (Direction * Class'DHUnits'.static.MetersToUnreal(MG.RangeParams.RangeTable[MG.RangeIndex].Range));

    if (SizeMeters == 0)
    {
        SizeMeters = 4.0;
    }
    
    TargetActor = Spawn(Class'DHRangeTargetActor', self,, TargetLocation, Rotator(-Direction));
    TargetActor.SetStaticMesh(TargetStaticMesh);
    // Set the target size.
    TargetActor.SetDrawScale(SizeMeters / 4.0);
}

//  Debugging function for calibrating the range table to the animations.
simulated exec function SetRangeTheta(float NewTheta)
{
    local DHMountedMG MG;
    MG = DHMountedMG(Gun);

    if (Level.NetMode != NM_Standalone && !Class'DH_LevelInfo'.static.DHDebugMode() || MG.RangeParams == none)
    {
        return;
    }

    MG.RangeParams.RangeTable[MG.RangeIndex].AnimationTime = NewTheta;
    MG.UpdateRangeDriverFrameTarget();
}

simulated exec function DumpRangeTable()
{
    local DHMountedMG MG;

    if (Level.NetMode != NM_Standalone && !Class'DH_LevelInfo'.static.DHDebugMode())
    {
        return;
    }

    MG = DHMountedMG(Gun);

    if (MG.RangeParams != none)
    {
        MG.RangeParams.DumpRangeTable();
    }
}

function bool IsWeaponBusy()
{
    local DHMountedMG MG;

    MG = DHMountedMG(Gun);

    if (MG != none)
    {
        return MG.IsBusy();
    }

    return false;
}

simulated function NextWeapon()
{
    if (!IsWeaponBusy())
    {
        super.NextWeapon();
    }
}

simulated function PrevWeapon()
{
    if (!IsWeaponBusy())
    {
        super.PrevWeapon();
    }
}

function bool CanFire()
{
    local DHMountedMG MG;

    MG = DHMountedMG(Gun);

    if (MG.BarrelCondition == BC_Failed || MG.IsBusy())
    {
        return false;
    }

    return super.CanFire();
}

function OnFire()
{
    if (BeltActor == none)
    {
        return;
    }

    BeltActor.PlayFiringAnimation(Gun.MainAmmoCharge[0]);
}

exec function ROMGOperation()
{
    // TODO: implement barrel change functionality.
    local DHMountedMG MG;

    MG = DHMountedMG(Gun);

    if (MG == none)
    {
        return;
    }

    if (MG.TryChangeBarrels())
    {
        // We're changing barrels, so un-zoom.
        SetIsZoomed(false);
    }
}

defaultproperties
{
    HandsAttachBone="HANDS_ATTACHMENT"
    PositionInArray=0
    bMustBeTankCrew=false
    bKeepDriverAuxCollision=true
    bMultiPosition=true
    UnbuttonedPositionIndex=0
    bDrawDriverInTP=true
    BinocsDriveRot=(Pitch=0,Yaw=16384,Roll=0)
    bHideMuzzleFlashAboveSights=true
    CameraBone="GUNNER_CAMERA"
    ReloadCameraBone="RELOAD_CAMERA"
    TargetStaticMesh=StaticMesh'DH_DebugTools.4MTARGET'
    ZoomFOV=50.0
    TPCamLookat=(Z=-70.0)
    GunsightPositionIndex=-1
}
