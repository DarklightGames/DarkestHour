//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// [ ] Fire/damaged effect locations (didn't i already do this?)
// [ ] Adjust handling & engine
// [ ] Fix default periscope rotation
//==============================================================================
// References:
// - https://comandosupremo.com/fiat-l6-40/
// - https://en.wikipedia.org/wiki/L6/40_tank
// - https://tanks-encyclopedia.com/ww2/italy/carro_armato_l6_40.php
//==============================================================================

class DH_FiatL640Tank extends DHArmoredVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Carro Armato L6/40"
    VehicleTeam=0
    VehicleMass=6.8
    ReinforcementCost=2

    // Periscope
    PeriscopePositionIndex=0
    PeriscopeCameraBone="CAMERA_PERISCOPE"

    Skins(0)=Texture'DH_FiatL640_tex.fiatl640_body_ext'
    Skins(1)=Texture'DH_FiatL640_tex.fiatl640_treads'
    Skins(2)=Texture'DH_FiatL640_tex.fiatl640_treads'

    // Hull mesh
    Mesh=SkeletalMesh'DH_FiatL640_anm.fiatl640_body_ext'

    // Vehicle weapons & passengers
    BeginningIdleAnim="closed"
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_FiatL640CannonPawn',WeaponBone="TURRET_PLACEMENT")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=0,Y=0,Z=58),DriveRot=(Yaw=16384),DriveAnim="fiatl640_passenger_02",InitialViewRotationOffset=(Yaw=-16384))
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=0,Y=0,Z=58),DriveRot=(Yaw=16384),DriveAnim="fiatl640_passenger_01",InitialViewRotationOffset=(Yaw=-16384))

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_FiatL640_anm.fiatl640_body_int',TransitionUpAnim="overlay_out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=0,ViewNegativeYawLimit=-1,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_FiatL640_anm.fiatl640_body_int',DriverTransitionAnim="fiatl640_driver_out",TransitionUpAnim="open",TransitionDownAnim="overlay_in",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_FiatL640_anm.fiatl640_body_int',DriverTransitionAnim="fiatl640_driver_in",TransitionDownAnim="close",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,bExposed=true)
    DrivePos=(X=0,Y=0,Z=58)
    DriveRot=(Yaw=16384)
    DriveAnim="fiatl640_driver_closed"
    DriverAttachmentBone="driver_attachment"
    UnbuttonedPositionIndex=3
    bLockCameraDuringTransition=false

    // Hull armor
    // https://tanks-encyclopedia.com/ww2/italy/carro_armato_l6_40.php
    // "The front plates of the superstructure were 30 mm thick, while those of the gun shield and driver�s port were 40 mm thick.
    // The front plates of the transmission cover and the side plates were 15 mm thick, as was the rear. The engine deck was 6 mm
    // thick and the floor had 10 mm armor plates."
    FrontArmor(0)=(Thickness=3.0,Slope=-65.84,MaxRelativeHeight=32.3213,LocationName="lower slope")
    FrontArmor(1)=(Thickness=3.0,Slope=-15.27,MaxRelativeHeight=51.5188,LocationName="lower")
    FrontArmor(2)=(Thickness=1.5,Slope=75.82,MaxRelativeHeight=65.4981,LocationName="transmission cover")
    FrontArmor(3)=(Thickness=3.0,Slope=13.35,LocationName="upper")
    RightArmor(0)=(Thickness=1.5,Slope=0.0,MaxRelativeHeight=59.0221,LocationName="lower")
    RightArmor(1)=(Thickness=1.5,Slope=11.3,LocationName="upper")
    LeftArmor(0)=(Thickness=1.5,Slope=0.0,MaxRelativeHeight=59.0221,LocationName="lower")
    LeftArmor(1)=(Thickness=1.5,Slope=11.3,LocationName="upper")
    RearArmor(0)=(Thickness=1.5,Slope=0)

    FrontLeftAngle=330
    FrontRightAngle=30
    RearLeftAngle=208
    RearRightAngle=153

    // Damage
    // pros: 37mm ammo is less likely to explode;
    // cons: tightly placed 4 men crew; petrol fuel;
    Health=420
    HealthMax=420.0
    EngineHealth=300
    AmmoIgnitionProbability=0.27  // 0.75 default
    TurretDetonationThreshold=4000.0 // increased from 1750
    EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
    DisintegrationHealth=-800.0 //petrol

    // Hitpoints
    VehHitpoints(0)=(PointBone="BODY",PointRadius=27.1584,PointOffset=(X=-68.1716,Z=49.7671),HitPointType=HP_Engine)
    VehHitpoints(1)=(PointBone="BODY",PointRadius=16,PointOffset=(X=-19.1348,Y=-38.7964,Z=68.5152),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)

    TreadHitMaxHeight=55.0
    TreadDamageThreshold=0.5
    DamagedEffectOffset=(X=-70,Y=0,Z=80)
    DamagedEffectScale=1.0
    FireAttachBone="body"
    DestroyedVehicleMesh=StaticMesh'DH_FiatL640_stc.fiatl640_destroyed'
    ShadowZOffset=20.0

    DamagedTrackStaticMeshLeft=StaticMesh'DH_FiatL640_stc.fiatl640_tracks_dest_L'
    DamagedTrackStaticMeshRight=StaticMesh'DH_FiatL640_stc.fiatl640_tracks_dest_R'

    FireEffectOffset=(X=40,Y=15,Z=60)

    // Exit
    ExitPositions(0)=(X=-85.00,Y=-25.00,Z=150.00)
    ExitPositions(1)=(X=-85.00,Y=25.00,Z=150.00)
    ExitPositions(2)=(X=-65.00,Y=-105.00,Z=55.00)
    ExitPositions(3)=(X=-65.00,Y=105.00,Z=55.00)
    ExitPositions(4)=(X=-165.00,Y=-35.00,Z=55.00)
    ExitPositions(5)=(X=-165.00,Y=35.00,Z=55.00)

    // Sounds
    SoundPitch=48
    IdleSound=SoundGroup'DH_AlliedVehicleSounds.stuart_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.t60_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.t60_engine_stop'
    LeftTreadSound=Sound'Vehicle_EnginesTwo.UC_tread_L'
    RightTreadSound=Sound'Vehicle_EnginesTwo.UC_tread_R'
    RumbleSoundBone="body"
    RumbleSound=Sound'DH_AlliedVehicleSounds.stuart_inside_rumble'

    // Visual effects
    LeftTreadIndex=1
    RightTreadIndex=2
    LeftTreadPanDirection=(Pitch=0,Yaw=0,Roll=0)
    RightTreadPanDirection=(Pitch=0,Yaw=0,Roll=0)
    TreadVelocityScale=100.0
    WheelRotationScale=45500.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-115.924,Y=48.0646,Z=60.461),ExhaustRotation=(Pitch=32768))
    LeftLeverBoneName="LEVER_L"
    RightLeverBoneName="LEVER_R"

    // HUD
    VehicleHudImage=Texture'DH_FiatL640_tex.fiatl640_body'
    VehicleHudTurret=TexRotator'DH_FiatL640_tex.fiatl640_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_FiatL640_tex.fiatl640_turret_look'

    VehicleHudEngineX=0.50

    VehicleHudTreadsPosX(0)=0.35
    VehicleHudTreadsPosX(1)=0.65
    VehicleHudTreadsPosY=0.50
    VehicleHudTreadsScale=0.7

    VehicleHudOccupantsX(0)=0.545
    VehicleHudOccupantsY(0)=0.4
    VehicleHudOccupantsX(1)=0.45
    VehicleHudOccupantsY(1)=0.475
    VehicleHudOccupantsX(2)=0.35
    VehicleHudOccupantsY(2)=0.65
    VehicleHudOccupantsX(3)=0.65
    VehicleHudOccupantsY(3)=0.65

    SpawnOverlay(0)=Material'DH_FiatL640_tex.fiatl640_icon'

    // Visible wheels
    LeftWheelBones(0)="WHEEL_01_L"
    LeftWheelBones(1)="WHEEL_02_L"
    LeftWheelBones(2)="WHEEL_03_L"
    LeftWheelBones(3)="WHEEL_04_L"
    LeftWheelBones(4)="WHEEL_05_L"
    LeftWheelBones(5)="WHEEL_06_L"
    LeftWheelBones(6)="WHEEL_07_L"
    LeftWheelBones(7)="WHEEL_08_L"
    LeftWheelBones(8)="WHEEL_09_L"

    RightWheelBones(0)="WHEEL_01_R"
    RightWheelBones(1)="WHEEL_02_R"
    RightWheelBones(2)="WHEEL_03_R"
    RightWheelBones(3)="WHEEL_04_R"
    RightWheelBones(4)="WHEEL_05_R"
    RightWheelBones(5)="WHEEL_06_R"
    RightWheelBones(6)="WHEEL_07_R"
    RightWheelBones(7)="WHEEL_08_R"
    RightWheelBones(8)="WHEEL_09_R"

    LeftTrackSoundBone="DRIVE_WHEEL_L"
    RightTrackSoundBone="DRIVE_WHEEL_R"

    CollisionAttachments(0)=(StaticMesh=StaticMesh'DH_FiatL640_stc.fiatl640_driver_flap_collision',AttachBone="VISION_PORT")

    // Movement
    GearRatios(3)=0.65
    GearRatios(4)=0.75
    TransRatio=0.13
    WheelLatFrictionScale=2.0
    HandbrakeThresh=1000.000000
    MaxBrakeTorque=10.0

    // Karma properties
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=0.0,Y=0.0,Z=0.4)
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
        KMaxAngularSpeed=1.0
    End Object
    KParams=KParams0

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="STEER_WHEEL_F_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
        bLeftTrack=true
    End Object
    Wheels(0)=LF_Steering
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="STEER_WHEEL_F_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
    End Object
    Wheels(1)=RF_Steering
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="STEER_WHEEL_B_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
        bLeftTrack=true
    End Object
    Wheels(2)=LR_Steering
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="STEER_WHEEL_B_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
    End Object
    Wheels(3)=RR_Steering
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="DRIVE_WHEEL_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
        bLeftTrack=true
    End Object
    Wheels(4)=Left_Drive_Wheel
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="DRIVE_WHEEL_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
    End Object
    Wheels(5)=Right_Drive_Wheel
}
