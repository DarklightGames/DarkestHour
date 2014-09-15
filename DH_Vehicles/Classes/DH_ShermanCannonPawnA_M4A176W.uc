//==============================================================================
// DH_ShermanCannonPawnA_M4A176W
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// American M4A1(76)W (Sherman) tank cannon pawn
//==============================================================================
class DH_ShermanCannonPawnA_M4A176W extends DH_AmericanTankCannonPawn;


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

        if (DriverPositions[DriverPositionIndex].bDrawOverlays && DriverPositionIndex < GunsightPositions && !IsInState('ViewTransition'))
        {
            CameraLocation = CamBoneCoords.Origin + (FPCamPos >> WeaponAimRot) + CamViewOffsetWorld;
        }
        else
        {
            CameraLocation = Gun.GetBoneCoords('Camera_com').Origin + (FPCamPos >> WeaponAimRot) + CamViewOffsetWorld;
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
     OverlayCenterSize=0.972000
     DestroyedScopeOverlay=Texture'DH_VehicleOpticsDestroyed_tex.Allied.Wolverine_sight_destroyed'
     PoweredRotateSound=Sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
     PoweredPitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
     PoweredRotateAndPitchSound=Sound'DH_AlliedVehicleSounds.Sherman.ShermanTurretTraverse'
     CannonScopeOverlay=Texture'DH_VehicleOptics_tex.Allied.Sherman76mm_sight_background'
     WeaponFov=14.400000
     AmmoShellTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.WolverineShell'
     AmmoShellReloadTexture=Texture'DH_InterfaceArt_tex.Tank_Hud.WolverineShell_reload'
     DriverPositions(0)=(ViewLocation=(X=18.000000,Y=20.000000,Z=7.000000),ViewFOV=14.400000,PositionMesh=SkeletalMesh'DH_ShermanM4A176W_anm.shermanM4A1w_turret_extA',ViewPitchUpLimit=5461,ViewPitchDownLimit=63715,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bDrawOverlays=true)
     DriverPositions(1)=(ViewLocation=(Z=10.000000),ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_ShermanM4A176W_anm.shermanM4A1w_turret_extA',TransitionUpAnim="com_open",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=65536,ViewNegativeYawLimit=-65536,bDrawOverlays=true)
     DriverPositions(2)=(ViewLocation=(Z=4.000000),ViewFOV=90.000000,PositionMesh=SkeletalMesh'DH_ShermanM4A176W_anm.shermanM4A1w_turret_extA',TransitionDownAnim="com_close",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
     DriverPositions(3)=(ViewLocation=(Z=4.000000),ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_ShermanM4A176W_anm.shermanM4A1w_turret_extA',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bDrawOverlays=true,bExposed=true)
     FireImpulse=(X=-95000.000000)
     GunClass=Class'DH_Vehicles.DH_ShermanCannonA_M4A176W'
     CameraBone="Gun"
     bPCRelativeFPRotation=true
     bFPNoZFromCameraPitch=true
     DrivePos=(X=3.000000,Z=-8.000000)
     DriveAnim="stand_idlehip_binoc"
     ExitPositions(0)=(Y=-100.000000,Z=186.000000)
     ExitPositions(1)=(Y=100.000000,Z=186.000000)
     EntryRadius=130.000000
     TPCamDistance=300.000000
     TPCamLookat=(X=-25.000000,Z=0.000000)
     TPCamWorldOffset=(Z=120.000000)
     VehiclePositionString="in a Sherman M4A1(76)W cannon"
     VehicleNameString="Sherman M4A1(76)W cannon"
     PitchUpLimit=6000
     PitchDownLimit=64000
     SoundVolume=130
     PeriscopePositionIndex=1
}
