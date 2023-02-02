//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Sdkfz2341ArmoredCar extends DHArmoredVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Sd.Kfz.234/1 Armored Car"
    bIsApc=true
    bHasTreads=false
    bSpecialTankTurning=false
    VehicleMass=5.0
    ReinforcementCost=3

    // Hull mesh
    Mesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_body_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_body_dunk'
    Skins(1)=Texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_wheels_dunk'
    Skins(2)=Texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_extras_dunk'
    Skins(3)=Texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_accessories'
    Skins(4)=Texture'DH_VehiclesGE_tex6.int_vehicles.sdkfz2341_body_int'
    FireEffectOffset=(X=25.0,Y=0.0,Z=-10.0)

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Sdkfz2341CannonPawn',WeaponBone="Turret_placement")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-165.0,Y=-35.0,Z=80.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-77.5,Y=0.0,Z=91.25),DriveRot=(Yaw=32768),DriveAnim="VUC_rider1_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-165.0,Y=60.0,Z=80.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(3)=(AttachBone="body",DrivePos=(X=-210.0,Y=0.0,Z=80.0),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider2_idle")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=2730,ViewPitchDownLimit=60065,ViewPositiveYawLimit=9500,ViewNegativeYawLimit=-9500)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="VBA64_driver_close",ViewPitchUpLimit=2730,ViewPitchDownLimit=60065,ViewPositiveYawLimit=15000,ViewNegativeYawLimit=-15000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VBA64_driver_open",ViewPitchUpLimit=9500,ViewPitchDownLimit=62835,ViewPositiveYawLimit=15000,ViewNegativeYawLimit=-15000,bExposed=true)
    UnbuttonedPositionIndex=3 // can't unbutton, no exit hatch for driver
    DrivePos=(X=4.0,Y=-2.0,Z=0.0)
    DriveAnim="VBA64_driver_idle_close"

    // Hull armor
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
    MaxCriticalSpeed=1039.0 // 62 kph
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
    VehHitpoints(0)=(PointOffset=(X=-150.0,Z=52.0)) // engine
    VehHitpoints(1)=(PointRadius=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=30.0,Y=-30.0,Z=52.0),DamageMultiplier=3.0,HitPointType=HP_AmmoStore)
    DamagedEffectScale=0.8
    DamagedEffectOffset=(X=-150.0,Y=0.0,Z=65.0)
    DriverKillChance=900.0
    CommanderKillChance=600.0
    GunDamageChance=1000.0
    TraverseDamageChance=1250.0
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc3.234.234_dest'

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
    ExhaustPipes(0)=(ExhaustPosition=(X=-230.0,Y=-68.0,Z=45.0),ExhaustRotation=(Pitch=36000))
    ExhaustPipes(1)=(ExhaustPosition=(X=-230.0,Y=69.0,Z=45.0),ExhaustRotation=(Pitch=36000))
    SteerBoneName="Steer_Wheel"
    SteeringScaleFactor=2.0

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.234_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.2341_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.2341_turret_look'
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
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.sdkfz_234_1'

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=RFWheel
        SteerType=VST_Steered
        BoneName="wheel_FR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=11.0)
        WheelRadius=32.0
        SupportBoneName="Axel_RF"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_Sdkfz2341ArmoredCar.RFWheel'
    Begin Object Class=SVehicleWheel Name=LFWheel
        SteerType=VST_Steered
        BoneName="wheel_FL"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-11.0)
        WheelRadius=32.0
        SupportBoneName="Axel_LF"
        SupportBoneAxis=AXIS_X
        bLeftTrack=true
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_Sdkfz2341ArmoredCar.LFWheel'
    Begin Object Class=SVehicleWheel Name=MFRWheel
        bPoweredWheel=true
        BoneName="Wheel_R_1"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=11.0)
        WheelRadius=32.0
        SupportBoneName="Axel_R_1"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_Sdkfz2341ArmoredCar.MFRWheel'
    Begin Object Class=SVehicleWheel Name=MFLWheel
        bPoweredWheel=true
        BoneName="Wheel_L_1"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-11.0)
        WheelRadius=32.0
        SupportBoneName="Axel_L_1"
        SupportBoneAxis=AXIS_X
        bLeftTrack=true
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_Sdkfz2341ArmoredCar.MFLWheel'
    Begin Object Class=SVehicleWheel Name=MRRWheel
        bPoweredWheel=true
        BoneName="Wheel_R_2"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=11.0)
        WheelRadius=32.0
        SupportBoneName="Axel_R_2"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_Sdkfz2341ArmoredCar.MRRWheel'
    Begin Object Class=SVehicleWheel Name=MRLWheel
        bPoweredWheel=true
        BoneName="Wheel_L_2"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-11.0)
        WheelRadius=32.0
        SupportBoneName="Axel_R_2"
        SupportBoneAxis=AXIS_X
        bLeftTrack=true
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_Sdkfz2341ArmoredCar.MRLWheel'
    Begin Object Class=SVehicleWheel Name=RRWheel
        bPoweredWheel=true
        BoneName="wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=11.0)
        WheelRadius=32.0
        SupportBoneName="Axel_RR"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(6)=SVehicleWheel'DH_Vehicles.DH_Sdkfz2341ArmoredCar.RRWheel'
    Begin Object Class=SVehicleWheel Name=RLWheel
        bPoweredWheel=true
        BoneName="Wheel_RL"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-11.0)
        WheelRadius=32.0
        SupportBoneName="Axel_LR"
        SupportBoneAxis=AXIS_X
        bLeftTrack=true
    End Object
    Wheels(7)=SVehicleWheel'DH_Vehicles.DH_Sdkfz2341ArmoredCar.RLWheel'

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.3 // default is 1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=0.3,Z=-0.525) // default is X=0.0, Z=-0.5
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_Sdkfz2341ArmoredCar.KParams0'
}
