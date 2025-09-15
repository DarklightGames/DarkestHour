//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// [ ] passenger positions
// [ ] attach MG
// [ ] driver animations (closed hatch etc.)
// [ ] set up armor values
// [ ] hit points
// [ ] camo variants
// [ ] side skirts, maybe randomize them?
// [ ] destroyed mesh
//==============================================================================

class DH_PantherATank extends DHArmoredVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Panzer V 'Panther' Ausf.A"
    VehicleMass=14.0
    ReinforcementCost=5

    PlayerCameraBone="DRIVER_CAMERA"

    // Hull mesh
    Mesh=SkeletalMesh'DH_Panther_anm.PANTHER_A_BODY_EXT'
    Skins(0)=Texture'DH_Panther_tex.PANTHER_A_EXT'
    Skins(1)=Texture'DH_Panther_tex.PANTHER_TRACK'
    Skins(2)=Texture'DH_Panther_tex.PANTHER_TRACK'

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_PantherACannonPawn',WeaponBone="TURRET_PLACEMENT")
    PassengerWeapons(1)=(WeaponPawnClass=Class'DH_PantherAMountedMGPawn',WeaponBone="MG_PLACEMENT")
    // PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-96.0,Y=-76.5,Z=55.5),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider6_idle")
    // PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-180.0,Y=-76.5,Z=55.5),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider5_idle")
    // PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-150.0,Y=76.5,Z=55.5),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider3_idle")
    // PassengerPawns(3)=(AttachBone="body",DrivePos=(X=-96.0,Y=76.5,Z=55.5),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider1_idle")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Panther_anm.PANTHER_A_BODY_EXT',TransitionUpAnim="driver_hatch_open",DriverTransitionAnim="VPanther_driver_close",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Panther_anm.PANTHER_A_BODY_EXT',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VPanther_driver_open",ViewPitchUpLimit=8000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true)
    InitialPositionIndex=0
    UnbuttonedPositionIndex=1
    DriveAnim="VPanther_driver_idle_close"
    PeriscopeOverlay=Texture'DH_VehicleOptics_tex.PERISCOPE_overlay_German'

    LeftTreadPanDirection=(Pitch=0,Yaw=16384,Roll=0)
    RightTreadPanDirection=(Pitch=0,Yaw=16384,Roll=0)

    // Hull armor
    FrontArmor(0)=(Thickness=6.5,Slope=-55.0,MaxRelativeHeight=57.78291,LocationName="lower")
    FrontArmor(1)=(Thickness=8.5,Slope=55.0,LocationName="upper")
    RightArmor(0)=(Thickness=4.5,MaxRelativeHeight=83.6763,LocationName="lower")
    RightArmor(1)=(Thickness=4.0,Slope=30.0,LocationName="upper")
    LeftArmor(0)=(Thickness=4.5,MaxRelativeHeight=83.6763,LocationName="lower")
    LeftArmor(1)=(Thickness=4.0,Slope=30.0,LocationName="upper")
    RearArmor(0)=(Thickness=4.0,Slope=-30.0)

    FrontLeftAngle=333.5
    FrontRightAngle=26.5
    RearRightAngle=153.0
    RearLeftAngle=207.0

    // Movement
    bTurnInPlace=true // don't think this affects panther's ability to turn, i.e. to neutral turn; think it's just a bot property
    GearRatios(4)=0.8
    TransRatio=0.11
    ChangeUpPoint=1990.0
    ChangeDownPoint=1000.0

    // Damage
    // pros: 5 men crew;
    // cons: petrol fuel; general unreliability of the panthers; this variant in particular is an early one which was even more unreliable
    Health=560
    HealthMax=560.0
    EngineHealth=200 //engine health is lowered for above reason
    EngineRestartFailChance=0.4 //unreliability

    EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
    DisintegrationHealth=-800.0 //petrol

    VehHitpoints(0)=(PointRadius=32.0,PointHeight=35.0,PointOffset=(X=-90.0,Z=6.0)) // engine
    VehHitpoints(1)=(PointRadius=15.0,PointHeight=30.0,PointBone="body",PointOffset=(X=20.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=15.0,PointHeight=10.0,PointBone="body",PointOffset=(X=-20.0,Y=-40.0,Z=40.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=15.0,PointHeight=10.0,PointBone="body",PointOffset=(X=-20.0,Y=40.0,Z=40.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)

    TreadHitMaxHeight=0.0
    TreadDamageThreshold=0.85
    DamagedEffectOffset=(X=-100.0,Y=20.0,Z=26.0)
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.PantherG_Destroyed0'

    // Exit
    ExitPositions(0)=(X=123.0,Y=-28.0,Z=105.0) // driver
    ExitPositions(1)=(X=-91.0,Y=20.0,Z=110.0)  // commander
    ExitPositions(2)=(X=128.0,Y=39.0,Z=105.0)  // hull MG
    ExitPositions(3)=(X=-95.0,Y=-160.0,Z=5.0)  // riders
    ExitPositions(4)=(X=-176.0,Y=-162.0,Z=5.0)
    ExitPositions(5)=(X=-176.0,Y=162.0,Z=5.0)
    ExitPositions(6)=(X=-95.0,Y=160.0,Z=5.0)

    // Sounds
    SoundPitch=32
    MaxPitchSpeed=100.0
    IdleSound=SoundGroup'Vehicle_Engines.Tiger_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.tiger_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.tiger_engine_stop'
    LeftTreadSound=Sound'Vehicle_Engines.track_squeak_L05'
    RightTreadSound=Sound'Vehicle_Engines.track_squeak_R05'
    RumbleSound=Sound'Vehicle_Engines.tank_inside_rumble02'
    RumbleSoundBone="driver_attachment"

    // Visual effects
    TreadVelocityScale=225.0
    WheelRotationScale=81250.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-209.073,Y=-21.3373,Z=116.284),ExhaustRotation=(Pitch=28672))
    ExhaustPipes(1)=(ExhaustPosition=(X=-209.073,Y=21.3373,Z=116.284),ExhaustRotation=(Pitch=28672))
    
    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.panther_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.panther_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.panther_turret_look'
    VehicleHudTreadsPosX(0)=0.38
    VehicleHudTreadsPosX(1)=0.63
    VehicleHudTreadsPosY=0.49
    VehicleHudTreadsScale=0.61
    VehicleHudOccupantsX(0)=0.45
    VehicleHudOccupantsY(0)=0.38
    VehicleHudOccupantsX(2)=0.55
    VehicleHudOccupantsY(2)=0.38
    VehicleHudOccupantsX(3)=0.4
    VehicleHudOccupantsY(3)=0.69
    VehicleHudOccupantsX(4)=0.4
    VehicleHudOccupantsY(4)=0.79
    VehicleHudOccupantsX(5)=0.605
    VehicleHudOccupantsY(5)=0.79
    VehicleHudOccupantsX(6)=0.605
    VehicleHudOccupantsY(6)=0.69
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.panther'

    ShadowZOffset=40.0
    
    VehicleAttachments(0)=(bAttachToWeapon=true,WeaponAttachIndex=0,AttachClass=Class'DH_PantherIdentifierAttachment',AttachBone="GUN_YAW",SkinIndexMap=((VehicleSkinIndex=0,AttachmentSkinIndex=0),(VehicleSkinIndex=0,AttachmentSkinIndex=1),(VehicleSkinIndex=0,AttachmentSkinIndex=2),(VehicleSkinIndex=0,AttachmentSkinIndex=3)))

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
    LeftWheelBones(9)="WHEEL_10_L"
    LeftWheelBones(10)="WHEEL_11_L"
    RightWheelBones(0)="WHEEL_01_R"
    RightWheelBones(1)="WHEEL_02_R"
    RightWheelBones(2)="WHEEL_03_R"
    RightWheelBones(3)="WHEEL_04_R"
    RightWheelBones(4)="WHEEL_05_R"
    RightWheelBones(5)="WHEEL_06_R"
    RightWheelBones(6)="WHEEL_07_R"
    RightWheelBones(7)="WHEEL_08_R"
    RightWheelBones(8)="WHEEL_09_R"
    RightWheelBones(9)="WHEEL_10_R"
    RightWheelBones(10)="WHEEL_11_R"

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="STEER_WHEEL_F_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=32.0,Y=-15.0,Z=-1.0)
        WheelRadius=33.0
        bLeftTrack=true
    End Object
    Wheels(0)=LF_Steering
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="STEER_WHEEL_F_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=32.0,Y=15.0,Z=-1.0)
        WheelRadius=33.0
    End Object
    Wheels(1)=RF_Steering
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="STEER_WHEEL_B_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-14.0,Y=-15.0,Z=-1.0)
        WheelRadius=33.0
        bLeftTrack=true
    End Object
    Wheels(2)=LR_Steering
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="STEER_WHEEL_B_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-14.0,Y=15.0,Z=-1.0)
        WheelRadius=33.0
    End Object
    Wheels(3)=RR_Steering
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="DRIVE_WHEEL_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-15.0,Z=-1.0)
        WheelRadius=33.0
        bLeftTrack=true
    End Object
    Wheels(4)=Left_Drive_Wheel
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="DRIVE_WHEEL_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=15.0,Z=-1.0)
        WheelRadius=33.0
    End Object
    Wheels(5)=Right_Drive_Wheel

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=0,Y=0,Z=0.5)
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=1.0
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KParams0
}
