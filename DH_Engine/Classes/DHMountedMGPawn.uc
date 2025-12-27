//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

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

// TODO: maybe use a state while reloading to make this easier to manage.

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

    if (IsLocallyControlled())
    {
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

    // Only the local player can change the zoom state.
    if (!IsLocallyControlled() || bIsZoomed == bNewIsZoomed)
    {
        return;
    }

    PC = DHPlayer(Controller);

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
    if (IsReloading())
    {
        // Don't allow the player to toggle the zoom while reloading.
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

simulated function SpecialCalcFirstPersonView(PlayerController PC, out Actor ViewActor, out Vector CameraLocation, out Rotator CameraRotation)
{
    local float T;
    local DHMountedMG VW;
    local Coords ReloadCameraCoords;
    local Vector ReloadCameraLocation;
    local Rotator ReloadCameraRotation;

    super.SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);

    if (IsReloading())
    {
        VW = DHMountedMG(Gun);

        ReloadCameraCoords = VW.GetBoneCoords(ReloadCameraBone);
        ReloadCameraLocation = ReloadCameraCoords.Origin;
        ReloadCameraRotation = QuatToRotator(
            Class'UQuaternion'.static.FromAxes(ReloadCameraCoords.XAxis, ReloadCameraCoords.YAxis, ReloadCameraCoords.ZAxis)
        );

        T = Class'UInterp'.static.LerpBilateral(Level.TimeSeconds, VW.ReloadStartTimeSeconds, VW.ReloadEndTimeSeconds, VW.ReloadCameraTweenTime, VW.ReloadCameraTweenTime);
        T = Class'UInterp'.static.SmoothStep(T, 0.0, 1.0);

        CameraLocation = Class'UVector'.static.VLerp(T, CameraLocation, ReloadCameraLocation);
        CameraRotation = QuatToRotator(QuatSlerp(QuatFromRotator(CameraRotation), QuatFromRotator(ReloadCameraRotation), T));
    }
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
    // TODO: figure out delta from zero.
    

    UpdateTurretRotation(DeltaTime, YawChange, PitchChange);

    if (IsHumanControlled())
    {
        PlayerController(Controller).WeaponBufferRotation.Yaw = CustomAim.Yaw;
        PlayerController(Controller).WeaponBufferRotation.Pitch = CustomAim.Pitch;
    }
}

// Debugging functions.
simulated exec function SpawnRangeTarget()
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

    TargetActor = Spawn(Class'DHRangeTargetActor', self,, TargetLocation, Rotator(-Direction));
    TargetActor.SetStaticMesh(TargetStaticMesh);
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

function bool CanFire()
{
    local DHMountedMG MG;

    MG = DHMountedMG(Gun);

    if (MG.BarrelCondition == BC_Failed)
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
}
