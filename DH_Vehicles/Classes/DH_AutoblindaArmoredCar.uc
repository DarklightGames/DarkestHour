//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// [ ] Ammo hitpoint areas
// [ ] Armor values (wolfkraut)
// [ ] Fix collision area for the driver's hatch on the body
// [ ] Set up projectiles for AB41 & 43
// [ ] Calibrate range for shells
// [ ] Fix offset of rear MG muzzle flag
// [ ] Damaged effect offsets
// ART
// [ ] AB41-specific turret mesh/textures
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
    Skins(0)=Texture'DH_Autoblinda_tex.ab41_body_ext'

    FireEffectOffset=(X=25.0,Y=0.0,Z=-10.0)

    // Vehicle weapons & passengers
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_AutoblindaMGPawn',WeaponBone="mg_attachment")
    PassengerPawns(0)=(AttachBone="PASSENGER_L",DrivePos=(Z=58),DriveAnim="autoblinda_passenger_l")
    PassengerPawns(1)=(AttachBone="PASSENGER_R",DrivePos=(Z=58),DriveAnim="autoblinda_passenger_r")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Autoblinda_anm.autoblinda_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=1,ViewNegativeYawLimit=-1,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Autoblinda_anm.autoblinda_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="VBA64_driver_close",ViewPitchUpLimit=4096,ViewPitchDownLimit=61439,ViewPositiveYawLimit=8192,ViewNegativeYawLimit=-8192)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Autoblinda_anm.autoblinda_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VBA64_driver_open",ViewPitchUpLimit=4096,ViewPitchDownLimit=61439,ViewPositiveYawLimit=8192,ViewNegativeYawLimit=-8192,bExposed=true)
    UnbuttonedPositionIndex=0
    DrivePos=(X=20,Y=0,Z=-5)
    DriveRot=(Pitch=0,Yaw=0,Roll=0)
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
    WheelSuspensionOffset=-4.0
    WheelSuspensionTravel=10.0
    WheelSuspensionMaxRenderTravel=5.0
    ChassisTorqueScale=0.095
    MaxSteerAngleCurve=(Points=((OutVal=32.0),(InVal=500.0,OutVal=16.0),(InVal=600.0,OutVal=8.0),(InVal=1000000000.0,OutVal=4.0)))
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
    ExitPositions(0)=(X=-34,Y=-104,Z=57)        // Driver
    ExitPositions(1)=(X=24,Y=0,Z=200)           // Gunner
    ExitPositions(2)=(X=-34,Y=104,Z=57)         // MG Gunner
    ExitPositions(3)=(X=-103,Y=-110,Z=57)       // Left Passenger
    ExitPositions(4)=(X=-103,Y=110,Z=57)        // Right Passenger
    ExitPositions(5)=(X=-206,Y=0,Z=57)          // Fallback exit (rear)

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
    VehicleHudEngineX=0.50
    VehicleHudEngineY=0.75
    VehicleHudOccupantsX(0)=0.5
    VehicleHudOccupantsY(0)=0.3
    VehicleHudOccupantsX(1)=0.5
    VehicleHudOccupantsY(1)=0.4
    VehicleHudOccupantsX(2)=0.55
    VehicleHudOccupantsY(2)=0.55
    VehicleHudOccupantsX(3)=0.4
    VehicleHudOccupantsY(3)=0.65
    VehicleHudOccupantsX(4)=0.6
    VehicleHudOccupantsY(4)=0.65

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=FRWheel
        SteerType=VST_Steered
        BoneName="WHEEL_F_R"
        BoneRollAxis=AXIS_Y
        //BoneOffset=(Y=11.0)
        WheelRadius=32.0
        SupportBoneName="SUSPENSION_F_R"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(0)=FRWheel
    Begin Object Class=SVehicleWheel Name=FLWheel
        SteerType=VST_Steered
        BoneName="WHEEL_F_L"
        BoneRollAxis=AXIS_Y
        // BoneOffset=(Y=-11.0)
        WheelRadius=32.0
        SupportBoneName="SUSPENSION_F_L"
        SupportBoneAxis=AXIS_X
        bLeftTrack=true
    End Object
    Wheels(1)=FLWheel
    Begin Object Class=SVehicleWheel Name=BRWheel
        SteerType=VST_Inverted
        BoneName="WHEEL_B_R"
        BoneRollAxis=AXIS_Y
        // BoneOffset=(Y=11.0)
        WheelRadius=32.0
        SupportBoneName="SUSPENSION_B_R"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(2)=BRWheel
    Begin Object Class=SVehicleWheel Name=BLWheel
        SteerType=VST_Inverted
        BoneName="WHEEL_B_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=32.0
        SupportBoneName="SUSPENSION_B_L"
        SupportBoneAxis=AXIS_X
        bLeftTrack=true
    End Object
    Wheels(3)=BLWheel

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
    KParams=KParams0
}
