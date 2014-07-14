//==============================================================================
// DH_Flak88CannonPawn
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
// AHZ AT Gun Source -(c) William "Teufelhund" Miller
//
// German Flak 36 88mm AT Gun cannon pawn
//==============================================================================
class DH_Flak88CannonPawn extends DH_ATGunTwoCannonPawn;

simulated function SpecialCalcFirstPersonView(PlayerController PC, out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
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

        if( ROPlayer(Controller) != none )
        {
                 ROPlayer(Controller).WeaponBufferRotation.Yaw = WeaponAimRot.Yaw;
                 ROPlayer(Controller).WeaponBufferRotation.Pitch = WeaponAimRot.Pitch;
        }

        // This makes the camera stick to the cannon, but you have no control
        if (DriverPositionIndex < 1)
        {
                CameraRotation =  WeaponAimRot;
                // Make the cannon view have no roll
                CameraRotation.Roll = 0;
        }
        else        if (bPCRelativeFPRotation)
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

        if( IsInState('ViewTransition') && bLockCameraDuringTransition )
        {
                CameraRotation = Gun.GetBoneRotation( 'com_player' );
        }

        CamViewOffsetWorld = FPCamViewOffset >> CameraRotation;
        if(CameraBone != '' && Gun != None)
        {
                CamBoneCoords = Gun.GetBoneCoords(CameraBone);

                if( DriverPositions[DriverPositionIndex].bDrawOverlays && DriverPositionIndex < 1 && !IsInState('ViewTransition'))
                {
                        CameraLocation = CamBoneCoords.Origin + (FPCamPos >> WeaponAimRot) + CamViewOffsetWorld;
                }
                else
                {
                        CameraLocation = Gun.GetBoneCoords('com_player').Origin;
                }

                if(bFPNoZFromCameraPitch)
                {
                        VehicleZ = vect(0,0,1) >> WeaponAimRot;

                        CamViewOffsetZAmount = CamViewOffsetWorld dot VehicleZ;
                        CameraLocation -= CamViewOffsetZAmount * VehicleZ;
                }
        }
        else
        {
                CameraLocation = GetCameraLocationStart() + (FPCamPos >> Rotation) + CamViewOffsetWorld;

                if(bFPNoZFromCameraPitch)
                {
                        VehicleZ = vect(0,0,1) >> Rotation;
                        CamViewOffsetZAmount = CamViewOffsetWorld Dot VehicleZ;
                        CameraLocation -= CamViewOffsetZAmount * VehicleZ;
                }
        }

    CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
    CameraLocation = CameraLocation + PC.ShakeOffset.X * x + PC.ShakeOffset.Y * y + PC.ShakeOffset.Z * z;
}

//==============================================================================
// defaultproperties
//==============================================================================

defaultproperties
{
     OverlayCenterSize=0.961000
     OverlayCorrectionX=-3
     CannonScopeOverlay=Texture'DH_VehicleOptics_tex.Artillery.Flak36_sight_background'
     BinocPositionIndex=2
     WeaponFov=18.000000
     AmmoShellTexture=Texture'InterfaceArt_tex.Tank_Hud.Tigershell'
     AmmoShellReloadTexture=Texture'InterfaceArt_tex.Tank_Hud.Tigershell_reload'
     DriverPositions(0)=(ViewLocation=(X=70.000000,Y=20.000000,Z=5.000000),ViewFOV=18.000000,PositionMesh=SkeletalMesh'DH_Flak88_anm.flak88_turret',DriverTransitionAnim="Vt3485_driver_idle_close",ViewPitchUpLimit=15474,ViewPitchDownLimit=64990,ViewPositiveYawLimit=3000,ViewNegativeYawLimit=-3000,bDrawOverlays=True,bExposed=True)
     DriverPositions(1)=(ViewFOV=85.000000,PositionMesh=SkeletalMesh'DH_Flak88_anm.flak88_turret',DriverTransitionAnim="Vt3485_driver_idle_close",ViewPitchUpLimit=8000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,bExposed=True)
     DriverPositions(2)=(ViewFOV=12.000000,PositionMesh=SkeletalMesh'DH_Flak88_anm.flak88_turret',DriverTransitionAnim="Vt3485_driver_idle_close",ViewPitchUpLimit=8000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,bDrawOverlays=True,bExposed=True)
     GunClass=Class'DH_Guns.DH_Flak88Cannon'
     CameraBone="Gun"
     RotateSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
     PitchSound=Sound'Vehicle_Weapons.Turret.manual_turret_elevate'
     RotateAndPitchSound=Sound'Vehicle_Weapons.Turret.manual_gun_traverse'
     bFPNoZFromCameraPitch=True
     DrivePos=(X=-15.000000,Z=-5.000000)
     DriveAnim="Vt3485_driver_idle_close"
     ExitPositions(0)=(X=-150.000000,Y=0.000000,Z=0.000000)
     ExitPositions(1)=(X=-100.000000,Y=0.000000,Z=0.000000)
     ExitPositions(2)=(X=-100.000000,Y=20.000000,Z=0.000000)
     ExitPositions(3)=(X=-100.000000,Y=-20.000000,Z=0.000000)
     ExitPositions(4)=(Y=50.000000,Z=0.000000)
     ExitPositions(5)=(Y=-50.000000,Z=0.000000)
     ExitPositions(6)=(X=-50.000000,Y=-50.000000,Z=0.000000)
     ExitPositions(7)=(X=-50.000000,Y=50.000000,Z=0.000000)
     ExitPositions(8)=(X=-75.000000,Y=75.000000,Z=0.000000)
     ExitPositions(9)=(X=-75.000000,Y=-75.000000,Z=0.000000)
     ExitPositions(10)=(X=-40.000000,Y=0.000000,Z=5.000000)
     ExitPositions(11)=(X=-60.000000,Y=0.000000,Z=5.000000)
     ExitPositions(12)=(X=-60.000000,Z=10.000000)
     ExitPositions(13)=(X=-60.000000,Z=15.000000)
     ExitPositions(14)=(X=-60.000000,Z=20.000000)
     ExitPositions(15)=(Z=5.000000)
     EntryRadius=325.000000
     VehiclePositionString="Using a FlaK 36 Gun"
     VehicleNameString="FlaK 36 Gun"
     bKeepDriverAuxCollision=True
     SoundVolume=100
}
