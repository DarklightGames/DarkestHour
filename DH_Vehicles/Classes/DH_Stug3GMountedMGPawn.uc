//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Stug3GMountedMGPawn extends DH_ROMountedTankMGPawn;

// Can't fire unless unbuttoned & controlling the external MG
function bool CanFire()
{
    return (DriverPositionIndex == UnbuttonedPositionIndex && !IsInState('ViewTransition')) || DriverPositionIndex > UnbuttonedPositionIndex;
}

// Modified to do null UpdateSpecialCustomAim(), otherwise MG faces wrong direction when player enters in buttoned up position, not controlling external MG
simulated state EnteringVehicle // Matt: this is a TEST as an alternative to doing this in UpdateRocketAcceleration
{
    simulated function HandleEnter()
    {
        super.HandleEnter();

        UpdateSpecialCustomAim(0.01, 0.0, 0.0);
    }
}

// Modified so that unbuttoned player can look around, similar to a cannon pawn
simulated function SpecialCalcFirstPersonView(PlayerController PC, out Actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local vector  x, y, z;
    local vector  VehicleZ, CamViewOffsetWorld;
    local float   CamViewOffsetZAmount;
    local rotator WeaponAimRot;
    local quat    AQuat, BQuat, CQuat;

    GetAxes(CameraRotation, x, y, z);
    ViewActor = self;

    WeaponAimRot = Gun.GetBoneRotation(CameraBone);

    if (ROPlayer(Controller) != none)
    {
        ROPlayer(Controller).WeaponBufferRotation.Yaw = WeaponAimRot.Yaw;
        ROPlayer(Controller).WeaponBufferRotation.Pitch = WeaponAimRot.Pitch;
    }

    // Use loader's camera bone rotation if unbuttoned & controlling the external MG
    if (CanFire())
    {
        CameraRotation =  WeaponAimRot;
    }
    // Or if unbuttoned we'll use this 'free look around' code instead
    else if (bPCRelativeFPRotation)
    {
        // First, rotate the headbob by the PlayerController's rotation (looking around)
        AQuat = QuatFromRotator(PC.Rotation);
        BQuat = QuatFromRotator(HeadRotationOffset - ShiftHalf);
        CQuat = QuatProduct(AQuat, BQuat);

        // Then, rotate that by the vehicle's rotation to get the final rotation
        AQuat = QuatFromRotator(VehicleBase.Rotation);
        BQuat = QuatProduct(CQuat, AQuat);

        // Finally make it back into a rotator
        CameraRotation = QuatToRotator(BQuat);
    }
    else
    {
        CameraRotation = PC.Rotation;
    }

    CamViewOffsetWorld = FPCamViewOffset >> CameraRotation;

    if (CameraBone != '' && Gun != none)
    {
        CameraLocation = Gun.GetBoneCoords('loader_cam').Origin;

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
    bPlayerCollisionBoxMoves=true
    FirstPersonGunShakeScale=2.0
    WeaponFOV=72.0
    DriverPositions(0)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug_mg34_ext',TransitionUpAnim="loader_unbutton",DriverTransitionAnim="Vhalftrack_com_close",ViewPitchUpLimit=7500,ViewPitchDownLimit=65535,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug_mg34_int',TransitionUpAnim="loader_open",TransitionDownAnim="loader_button",DriverTransitionAnim="Vhalftrack_com_open",ViewPitchUpLimit=2400,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bDrawOverlays=true,bExposed=true)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug_mg34_int',TransitionDownAnim="loader_close",ViewPitchUpLimit=2400,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bDrawOverlays=true,bExposed=true)
    bMultiPosition=true
    GunClass=class'DH_Vehicles.DH_Stug3GMountedMG'
    bCustomAiming=true
    bHasAltFire=false
    CameraBone="loader_cam"
    FirstPersonGunRefBone="firstperson_wep"
    FirstPersonOffsetZScale=3.0
    bPCRelativeFPRotation=true
    bDesiredBehindView=false
    DrivePos=(X=16.0,Z=20.0)
    DriveRot=(Yaw=16384)
    DriveAnim="VHalftrack_com_idle"
    EntryRadius=130.0
    TPCamDistance=300.0
    TPCamLookat=(X=-50.0,Y=25.0,Z=0.0)
    TPCamWorldOffset=(Z=120.0)
    HUDOverlayClass=class'DH_Vehicles.DH_Stug3GOverlayMG'
    HUDOverlayFOV=45.0
    PitchUpLimit=6000
    PitchDownLimit=63500
}
