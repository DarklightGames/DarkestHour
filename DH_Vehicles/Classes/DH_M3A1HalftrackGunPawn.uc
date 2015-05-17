//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_M3A1HalftrackGunPawn extends DHMountedTankMGPawn;

simulated function SpecialCalcFirstPersonView(PlayerController PC, out Actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local vector  x, y, z;
    local vector  VehicleZ, CamViewOffsetWorld;
    local float   CamViewOffsetZAmount;
    local rotator WeaponAimRot;

    GetAxes(CameraRotation, x, y, z);
    ViewActor = self;

    WeaponAimRot = Gun.GetBoneRotation(CameraBone);

    if (ROPlayer(Controller) != none)
    {
        ROPlayer(Controller).WeaponBufferRotation.Yaw = WeaponAimRot.Yaw;
        ROPlayer(Controller).WeaponBufferRotation.Pitch = WeaponAimRot.Pitch;
    }

    CameraRotation =  WeaponAimRot;

    CamViewOffsetWorld = FPCamViewOffset >> CameraRotation;

    if (CameraBone != '' && Gun != none)
    {
        CameraLocation = Gun.GetBoneCoords('Camera_com').Origin;

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

defaultproperties
{
    UnbuttonedPositionIndex=0
    FirstPersonGunShakeScale=0.75
    WeaponFOV=60.0
    DriverPositions(0)=(ViewFOV=60.0,PositionMesh=SkeletalMesh'DH_M3A1Halftrack_anm.m3halftrack_gun_int',TransitionUpAnim="com_open",DriverTransitionAnim="Vhalftrack_com_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=63000,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bDrawOverlays=true,bExposed=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_M3A1Halftrack_anm.m3halftrack_gun_int',TransitionDownAnim="com_close",DriverTransitionAnim="Vhalftrack_com_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=63000,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bDrawOverlays=true,bExposed=true)
    bMultiPosition=true
    bMustBeTankCrew=false
    GunClass=class'DH_Vehicles.DH_M3A1HalftrackGun'
    bCustomAiming=true
    PositionInArray=0
    bHasAltFire=false
    CameraBone="Camera_com"
    FirstPersonGunRefBone="1stperson_wep"
    FirstPersonOffsetZScale=1.0
    bHideMuzzleFlashAboveSights=true
    bDesiredBehindView=false
    DrivePos=(Y=-5.0,Z=14.0)
    DriveRot=(Yaw=16384)
    DriveAnim="VHalftrack_com_idle"
    EntryRadius=130.0
    HUDOverlayClass=class'DH_Vehicles.DH_M3A1HalftrackMGOverlay'
    HUDOverlayOffset=(X=-2.0)
    HUDOverlayFOV=35.0
    bKeepDriverAuxCollision=true
    PitchUpLimit=4000
    PitchDownLimit=60000
}
