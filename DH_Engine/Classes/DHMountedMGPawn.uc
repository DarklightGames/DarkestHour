//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// TODO
//==============================================================================
// [ ] Bullet snapping & whizzing should still work on exposed vehicle occupants.
// [ ] There's no message when the gun barrel is blocked and the player tries to fire.
// [ ] Switch off of the gunsight position when reloading.
// [ ] muzzle flash not visible unless on gunsight?
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

// Camera Transition
var DHCameraTransitionController CameraTransitionController;

var int IronSightsPositionIndex;
var int GunsightPositionIndex;

// Extra info for driver positions.
struct PositionInfoExtra
{
    var name CameraBone;
};
var array<PositionInfoExtra> DriverPositionsExtra;

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
        super.BeginState();

        // Un-zoom when changing view positions.
        if (bIsZoomed)
        {
            SetIsZoomed(false);
        }

        // TODO: have this camera transition info be defined in the Extras struct.

        // TODO: this is UGLY.
        if (LastPositionIndex == IronsightsPositionIndex)
        {
            // Transition off of the ironsights position to the normal position.
            CameraTransitionController.QueueCameraTransition(CameraBone, Level.TimeSeconds, 0.125, INTERP_SmoothStep);
        }
        else if (DriverPositionIndex == IronsightsPositionIndex)
        {
            // Transition to the transition camera.
            CameraTransitionController.QueueCameraTransition(CameraBone, Level.TimeSeconds, 0.125, INTERP_SmoothStep);
            // Then transition to the ironsights camera at the end of the animation.
            CameraTransitionController.QueueCameraTransition(
                GetCameraBoneForPosition(IronsightsPositionIndex),
                Level.TimeSeconds + ViewTransitionDuration - 0.25, 0.25, INTERP_SmoothStep);
        }
    }

    simulated function EndState()
    {
        super.EndState();

        CameraTransitionController.SetCurrentCameraBone(GetCameraBoneForPosition(DriverPositionIndex));
    }
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

simulated function bool CanReload()
{
    if (DriverPositionIndex == GunsightPositionIndex)
    {
        return false;
    }

    return super.CanReload();
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

simulated function PlayReloadAnim(float AnimationDurationSeconds)
{
    if (HandsActor != none)
    {
        HandsActor.PlayAnim(HandsReloadSequence);
    }

    // Add a transition to and from the reload camera.
    CameraTransitionController.QueueCameraTransition(
        ReloadCameraBone, Level.TimeSeconds, 0.25, INTERP_SmoothStep);
    CameraTransitionController.QueueCameraTransition(
        GetCameraBoneForPosition(DriverPositionIndex), Level.TimeSeconds + AnimationDurationSeconds - 0.25, 0.25, INTERP_SmoothStep);
}

simulated function PlayerBarrelChangeAnim(float AnimationDurationSeconds)
{
    // Add a transition to and from the reload camera.
    CameraTransitionController.QueueCameraTransition(
        ReloadCameraBone, Level.TimeSeconds, 0.25, INTERP_SmoothStep);
    CameraTransitionController.QueueCameraTransition(
        GetCameraBoneForPosition(DriverPositionIndex), Level.TimeSeconds + AnimationDurationSeconds, 0.25, INTERP_SmoothStep);
}

simulated function bool IsReloading()
{
    local DHMountedMG MG;

    MG = DHMountedMG(Gun);

    return MG != none && MG.IsReloading();
}

simulated function bool IsChangingBarrels()
{
    local DHMountedMG MG;

    MG = DHMountedMG(Gun);

    return MG != none && MG.IsChangingBarrels();
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

simulated function name GetCameraBoneForPosition(int PositionIndex)
{
    if (PositionIndex < DriverPositionsExtra.Length && DriverPositionsExtra[PositionIndex].CameraBone != '')
    {
        return DriverPositionsExtra[PositionIndex].CameraBone;
    }

    return CameraBone;
}

simulated function SpecialCalcFirstPersonView(PlayerController PC, out Actor ViewActor, out Vector CameraLocation, out Rotator CameraRotation)
{
    local DHMountedMG MG;
    local name CurrentCameraBone;
    local Rotator GunsightCameraRotation;

    MG = DHMountedMG(Gun);

    if (MG == none)
    {
        return;
    }

    CameraTransitionController.Tick(MG, Level.TimeSeconds);

    if (IsOnGunsight())
    {
        // Gunsight is a special case.

        // Adjust the pitch of the gunsight bone based on the current range setting.
        CameraLocation = Gun.GetBoneCoords(GunsightCameraBone).Origin;
        GunsightCameraRotation.Pitch = MG.RangeParams.GetGunsightPitchOffset();
        // TODO: double check that this is the right order of multiplication; this could be the cause of aiming issues.
        CameraRotation = QuatToRotator(QuatProduct(
            QuatFromRotator(GunsightCameraRotation),
            QuatFromRotator(Gun.GetBoneRotation(GunsightCameraBone))
            ));
    }
    else
    {
        CameraTransitionController.GetCameraLocationAndRotation(CameraLocation, CameraRotation);
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
    local DHMountedMG MG;

    MG = DHMountedMG(Gun);

    if (MG != none && MG.TryChangeBarrels())
    {
        // We're changing barrels, so un-zoom.
        SetIsZoomed(false);
    }
}

//==============================================================================
// DEBUG FUNCTIONS
//==============================================================================

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
    Begin Object Class=DHCameraTransitionController Name=CameraTransitionController0
        CurrentCameraBone="GUNNER_CAMERA"
    End Object
    CameraTransitionController=CameraTransitionController0
}
