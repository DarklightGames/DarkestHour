//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Stug3GCannonPawn extends DH_AssaultGunCannonPawn;

// modification allowing dual-magnification optics is here (look for "GunsightPositions")
simulated function SpecialCalcFirstPersonView(PlayerController PC, out actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local vector x, y, z;
    local vector VehicleZ, CamViewOffsetWorld;
    local float CamViewOffsetZAmount;
    local coords CamBoneCoords;
    local rotator WeaponAimRot;
    local quat AQuat, BQuat, CQuat;

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
     if (DriverPositionIndex < GunsightPositions)
     {
        CameraRotation =  WeaponAimRot;
        // Make the cannon view have no roll
        CameraRotation.Roll = 0;
    }
    else if (bPCRelativeFPRotation)
    {
        //__________________________________________
        // First, Rotate the headbob by the player
        // controllers rotation (looking around) ---
        AQuat = QuatFromRotator(PC.Rotation);
        BQuat = QuatFromRotator(HeadRotationOffset - ShiftHalf);
        CQuat = QuatProduct(AQuat,BQuat);
        //__________________________________________
        // Then, rotate that by the vehicles rotation
        // to get the final rotation ---------------
        AQuat = QuatFromRotator(GetVehicleBase().Rotation);
        BQuat = QuatProduct(CQuat,AQuat);
        //__________________________________________
        // Make it back into a rotator!
        CameraRotation = QuatToRotator(BQuat);
        }
        else
            CameraRotation = PC.Rotation;

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
                CameraLocation = Gun.GetBoneCoords('Camera_com').Origin + (FPCamPos >> WeaponAimRot) + CamViewOffsetWorld;
                //CameraLocation = Gun.GetBoneCoords('Camera_com').Origin;
            }

            if (bFPNoZFromCameraPitch)
            {
                VehicleZ = vect(0,0,1) >> WeaponAimRot;
                CamViewOffsetZAmount = CamViewOffsetWorld dot VehicleZ;
                CameraLocation -= CamViewOffsetZAmount * VehicleZ;
            }
        }
        else
        {
            CameraLocation = GetCameraLocationStart() + (FPCamPos >> Rotation) + CamViewOffsetWorld;

            if (bFPNoZFromCameraPitch)
            {
                VehicleZ = vect(0,0,1) >> Rotation;
                CamViewOffsetZAmount = CamViewOffsetWorld Dot VehicleZ;
                CameraLocation -= CamViewOffsetZAmount * VehicleZ;
            }
        }

    CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
    CameraLocation = CameraLocation + PC.ShakeOffset.X * x + PC.ShakeOffset.Y * y + PC.ShakeOffset.Z * z;
}

defaultproperties
{
     OverlayCenterSize=0.555000
     PeriscopePositionIndex=1
     UnbuttonedPositionIndex=3
     DestroyedScopeOverlay=Texture'DH_VehicleOpticsDestroyed_tex.German.stug3_SflZF1a_destroyed'
     bManualTraverseOnly=true
     PoweredRotateSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
     PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
     PoweredRotateAndPitchSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
     CannonScopeOverlay=Texture'DH_VehicleOptics_tex.German.stug3_SflZF1a_sight'
     BinocPositionIndex=4
     WeaponFov=14.400000
     AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell'
     AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.panzer4F2shell_reload'
     DriverPositions(0)=(ViewLocation=(Y=-32.000000,Z=30.000000),ViewFOV=14.400000,PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug3g_turret_int',ViewPitchUpLimit=3641,ViewPitchDownLimit=64444,ViewPositiveYawLimit=2000,ViewNegativeYawLimit=-2000,bDrawOverlays=true)
     DriverPositions(1)=(ViewLocation=(Z=10.000000),ViewFOV=7.200000,PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug3g_turret_int',ViewPitchUpLimit=1200,ViewPitchDownLimit=64500,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bDrawOverlays=true)
     DriverPositions(2)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug3g_turret_int',TransitionUpAnim="com_open",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536)
     DriverPositions(3)=(ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug3g_turret_int',TransitionDownAnim="com_close",DriverTransitionAnim="VStug3_com_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bExposed=true)
     DriverPositions(4)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug3g_turret_int',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true,bExposed=true)
     GunClass=class'DH_Vehicles.DH_Stug3GCannon'
     CameraBone="Turret"
     MinRotateThreshold=0.500000
     MaxRotateThreshold=2.500000
     bPCRelativeFPRotation=true
     bFPNoZFromCameraPitch=true
     DrivePos=(Z=-6.000000)
     DriveAnim="stand_idlehip_binoc"
     EntryRadius=130.000000
     FPCamPos=(Z=5.000000)
     TPCamDistance=300.000000
     TPCamLookat=(X=-25.000000,Z=0.000000)
     TPCamWorldOffset=(Z=120.000000)
     VehiclePositionString="in a StuG III Ausf.G cannon"
     VehicleNameString="StuG III Ausf.G cannon"
     PitchUpLimit=6000
     PitchDownLimit=64000
     SoundVolume=130
}
