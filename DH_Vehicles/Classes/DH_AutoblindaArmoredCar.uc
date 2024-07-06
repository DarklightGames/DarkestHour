//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// [ ] Hitpoints
// [ ] Exit positions
// [ ] Destroyed mesh
// [ ] Armor values (wolfkraut)
// [ ] Fix wheel suspension in the rig
// [ ] Fix collision area for the driver's hatch on the body
// [ ] Driver animations
// [x] UI elements
// [ ] Set up projectiles for AB41 & 43
// [ ] Calibrate range for shells
//==============================================================================

class DH_AutoblindaArmoredCar extends DHArmoredVehicle
    abstract;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Autoblinda 41"
    bIsApc=true
    bHasTreads=false
    bSpecialTankTurning=false
    VehicleMass=4.0
    ReinforcementCost=3

    // Hull mesh
    Mesh=SkeletalMesh'DH_Autoblinda_anm.autoblinda_body_ext'
    // Skins(0)=Texture'DH_VehiclesGE_tex6.ext_vehicles.Autoblinda_body_dunk'
    // Skins(1)=Texture'DH_VehiclesGE_tex6.ext_vehicles.Autoblinda_wheels_dunk'
    // Skins(2)=Texture'DH_VehiclesGE_tex6.ext_vehicles.Autoblinda_extras_dunk'
    // Skins(3)=Texture'DH_VehiclesGE_tex6.ext_vehicles.Autoblinda_accessories'
    // Skins(4)=Texture'DH_VehiclesGE_tex6.int_vehicles.Autoblinda_body_int'
    FireEffectOffset=(X=25.0,Y=0.0,Z=-10.0)

    // Vehicle weapons & passengers
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_AutoblindaMGPawn',WeaponBone="mg_attachment")
    PassengerPawns(0)=(AttachBone="PASSENGER_L",DrivePos=(Z=58),DriveAnim="autoblinda_passenger_l")
    PassengerPawns(1)=(AttachBone="PASSENGER_R",DrivePos=(Z=58),DriveAnim="autoblinda_passenger_r")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Autoblinda_anm.autoblinda_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=1,ViewNegativeYawLimit=-1,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Autoblinda_anm.autoblinda_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="VBA64_driver_close",ViewPitchUpLimit=4096,ViewPitchDownLimit=61439,ViewPositiveYawLimit=8192,ViewNegativeYawLimit=-8192)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Autoblinda_anm.autoblinda_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VBA64_driver_open",ViewPitchUpLimit=4096,ViewPitchDownLimit=61439,ViewPositiveYawLimit=8192,ViewNegativeYawLimit=-8192,bExposed=true)
    UnbuttonedPositionIndex=3 // can't unbutton, no exit hatch for driver (maybe the side doors???)
    DrivePos=(Z=58.0)
    DriveRot=(Yaw=16384)
    DriveAnim="VBA64_driver_idle_close" // default driver anim

    // Hull armor   // TODO: get all this
    FrontArmor(0)=(Thickness=3.0,Slope=-41.0,MaxRelativeHeight=40.0,LocationName="lower nose") // assumed 30mm to all front & 8mm elsewhere; measured all the slopes in the hull mesh
    FrontArmor(1)=(Thickness=3.0,Slope=42.0,MaxRelativeHeight=61.0,LocationName="upper nose")
    FrontArmor(2)=(Thickness=3.0,Slope=73.0,MaxRelativeHeight=77.0,LocationName="upper")
    FrontArmor(3)=(Thickness=3.0,Slope=37.0,LocationName="driver plate")
    RightArmor(0)=(Thickness=0.8,Slope=-22.5,MaxRelativeHeight=51.0,LocationName="lower") // composite slope & height for sides, as varies along length of hull
    RightArmor(1)=(Thickness=0.8,Slope=30.0,LocationName="upper")
    LeftArmor(0)=(Thickness=0.8,Slope=-22.5,MaxRelativeHeight=51.0,LocationName="lower")
    LeftArmor(1)=(Thickness=0.8,Slope=30.0,LocationName="upper")
    RearArmor(0)=(Thickness=0.8,Slope=-27.5,MaxRelativeHeight=46.0,LocationName="lower")
    RearArmor(1)=(Thickness=0.8,Slope=24.0,MaxRelativeHeight=75.5,LocationName="upper")
    RearArmor(2)=(Thickness=0.8,Slope=38.0,LocationName="turret upstand")

    FrontLeftAngle=338.0
    FrontRightAngle=22.0
    RearRightAngle=158.0
    RearLeftAngle=202.0

    // Movement
    GearRatios(0)=-0.35
    GearRatios(3)=0.6
    GearRatios(4)=0.75
    TransRatio=0.13
    WheelPenScale=1.2
    WheelLatSlipFunc=(Points=(,(InVal=30.0,OutVal=0.009),(InVal=45.0),(InVal=10000000000.0)))
    WheelLongFrictionScale=1.1
    WheelLatFrictionScale=1.55
    WheelSuspensionTravel=10.0
    WheelSuspensionMaxRenderTravel=5.0
    ChassisTorqueScale=0.095
    MaxSteerAngleCurve=(Points=((OutVal=45.0),(InVal=300.0,OutVal=20.0),(InVal=500.0,OutVal=15.0),(InVal=600.0,OutVal=10.0),(InVal=1000000000.0,OutVal=8.0)))
    ChangeUpPoint=1990.0
    ChangeDownPoint=1000.0
    SteerSpeed=75.0
    TurnDamping=100.0

    PeriscopeCameraBone="PERISCOPE_CAMERA"
    PeriscopePositionIndex=0

    // TODO: revisit all of hte damage stuff
    // Damage
	// pros: diesel fuel; 20mm ammo is very unlikely to detonate;
	// 4 men crew
    Health=525
    HealthMax=525.0
	EngineHealth=300
	AmmoIgnitionProbability=0.2  // 0.75 default
    TurretDetonationThreshold=5000.0 // increased from 1750

	PlayerFireDamagePer2Secs=12.0 // reduced from 15 for all diesels
    FireDetonationChance=0.045  //reduced from 0.07 for all diesels
    DisintegrationHealth=-1200.0 //diesel
    VehHitpoints(0)=(PointRadius=32.0,PointBone="engine",DamageMultiplier=1.0,HitPointType=HP_Engine)
    // TODO: add ammo store hitpoint
    DamagedEffectScale=0.8
    DamagedEffectOffset=(X=-150.0,Y=0.0,Z=65.0)
    DriverKillChance=900.0
    CommanderKillChance=600.0
    GunDamageChance=1000.0
    TraverseDamageChance=1250.0
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc3.234.234_dest'   // TODO: replace

    // Exit
    ExitPositions(0)=(X=-92.0,Y=4.0,Z=150.0)
    ExitPositions(1)=(X=-92.0,Y=4.0,Z=150.0)
    ExitPositions(2)=(X=-160.0,Y=-120.0,Z=35.0)
    ExitPositions(3)=(X=-300.0,Y=0.0,Z=35.0)
    ExitPositions(4)=(X=-160.0,Y=120.0,Z=35.0)
    ExitPositions(5)=(X=-300.0,Y=0.0,Z=35.0)

    // Sounds
    IdleSound=SoundGroup'Vehicle_Engines.sdkfz251.sdkfz251_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_stop'

    // Visual effects
    ExhaustPipes(0)=(ExhaustPosition=(X=-140.85,Y=50.59,Z=33.88),ExhaustRotation=(Roll=0,Pitch=4354,Yaw=23546))
    ShadowZOffset=40.0
    SteerBoneName="steering_wheel"
    SteeringScaleFactor=2.0

    // Collision Attachments
    //CollisionAttachments(0)=(StaticMesh=StaticMesh'DH_Autoblinda_stc.autoblinda_vision_port_collision',AttachBone=VISION_PORT)

    // HUD
    VehicleHudImage=Texture'DH_Autoblinda_tex.interface.ab41_body'
    VehicleHudEngineX=0.51
    VehicleHudOccupantsX(0)=0.48
    VehicleHudOccupantsY(0)=0.32
    VehicleHudOccupantsX(1)=0.5
    VehicleHudOccupantsY(1)=0.43
    VehicleHudOccupantsX(2)=0.4
    VehicleHudOccupantsY(2)=0.75
    VehicleHudOccupantsX(3)=0.5
    VehicleHudOccupantsY(3)=0.6
    VehicleHudOccupantsX(4)=0.6
    VehicleHudOccupantsY(4)=0.75
    VehicleHudOccupantsX(5)=0.5
    VehicleHudOccupantsY(5)=0.8

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=FRWheel
        SteerType=VST_Steered
        BoneName="WHEEL_F_R"
        BoneRollAxis=AXIS_Y
        //BoneOffset=(Y=11.0)
        WheelRadius=32.0
        //SupportBoneName="Axel_RF"
        //SupportBoneAxis=AXIS_X
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_AutoblindaArmoredCar.FRWheel'
    Begin Object Class=SVehicleWheel Name=FLWheel
        SteerType=VST_Steered
        BoneName="WHEEL_F_L"
        BoneRollAxis=AXIS_Y
        // BoneOffset=(Y=-11.0)
        WheelRadius=32.0
        //SupportBoneName="Axel_LF"
        //SupportBoneAxis=AXIS_X
        bLeftTrack=true
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_AutoblindaArmoredCar.FLWheel'
    Begin Object Class=SVehicleWheel Name=BRWheel
        SteerType=VST_Inverted
        BoneName="WHEEL_B_R"
        BoneRollAxis=AXIS_Y
        // BoneOffset=(Y=11.0)
        WheelRadius=32.0
        //SupportBoneName="Axel_RF"
        //SupportBoneAxis=AXIS_X
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_AutoblindaArmoredCar.BRWheel'
    Begin Object Class=SVehicleWheel Name=BLWheel
        SteerType=VST_Inverted
        BoneName="WHEEL_B_L"
        BoneRollAxis=AXIS_Y
        //BoneOffset=(Y=-11.0)
        WheelRadius=32.0
        //SupportBoneName="Axel_LF"
        //SupportBoneAxis=AXIS_X
        bLeftTrack=true
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_AutoblindaArmoredCar.BLWheel'

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.3 // default is 1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=0.0,Z=0.65)
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
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_AutoblindaArmoredCar.KParams0'
}
