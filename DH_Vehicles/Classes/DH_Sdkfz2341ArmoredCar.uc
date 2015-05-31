//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Sdkfz2341ArmoredCar extends DHArmoredWheeledVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_Sdkfz234ArmoredCar_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex6.utx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_German_vehicles_stc3.usx

defaultproperties
{
    UnbuttonedPositionIndex=3
    MaxCriticalSpeed=1039.0
    UFrontArmorFactor=3.0
    URightArmorFactor=0.8
    ULeftArmorFactor=0.8
    URearArmorFactor=0.8
    UFrontArmorSlope=40.0
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.2341_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.2341_turret_look'
    FrontLeftAngle=338.0
    FrontRightAngle=22.0
    RearRightAngle=158.0
    RearLeftAngle=202.0
    WheelPenScale=1.2
    WheelLatSlipFunc=(Points=(,(InVal=30.0,OutVal=0.009),(InVal=45.0),(InVal=10000000000.0)))
    WheelLongFrictionScale=1.1
    WheelLatFrictionScale=1.55
    WheelSuspensionTravel=10.0
    WheelSuspensionMaxRenderTravel=5.0
    ChassisTorqueScale=0.095
    MaxSteerAngleCurve=(Points=((OutVal=45.0),(InVal=300.0,OutVal=30.0),(InVal=500.0,OutVal=20.0),(InVal=600.0,OutVal=15.0),(InVal=1000000000.0,OutVal=10.0)))
    GearRatios(0)=-0.35
    GearRatios(3)=0.6
    GearRatios(4)=0.75
    TransRatio=0.13
    ChangeUpPoint=1990.0
    ChangeDownPoint=1000.0
    SteerSpeed=75.0
    TurnDamping=100.0
    SteerBoneName="Steer_Wheel"
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-230.0,Y=-68.0,Z=45.0),ExhaustRotation=(Pitch=36000))
    ExhaustPipes(1)=(ExhaustPosition=(X=-230.0,Y=69.0,Z=45.0),ExhaustRotation=(Pitch=36000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Sdkfz2341CannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_Sdkfz234PassengerOne',WeaponBone="body")
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_Sdkfz234PassengerTwo',WeaponBone="body")
    PassengerWeapons(3)=(WeaponPawnClass=class'DH_Vehicles.DH_Sdkfz234PassengerThree',WeaponBone="body")
    PassengerWeapons(4)=(WeaponPawnClass=class'DH_Vehicles.DH_Sdkfz234PassengerFour',WeaponBone="body")
    IdleSound=SoundGroup'Vehicle_Engines.sdkfz251.sdkfz251_engine_loop'
    StartUpSound=sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_start'
    ShutDownSound=sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc3.234.234_dest'
    DisintegrationHealth=-100000.0
    DamagedEffectScale=0.8
    DamagedEffectOffset=(X=-150.0,Y=0.0,Z=65.0)
    SteeringScaleFactor=4.0
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=2730,ViewPitchDownLimit=60065,ViewPositiveYawLimit=9500,ViewNegativeYawLimit=-9500,ViewFOV=90.0)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="VBA64_driver_close",ViewPitchUpLimit=2730,ViewPitchDownLimit=60065,ViewPositiveYawLimit=15000,ViewNegativeYawLimit=-15000,ViewFOV=90.0)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VBA64_driver_open",ViewPitchUpLimit=9500,ViewPitchDownLimit=62835,ViewPositiveYawLimit=15000,ViewNegativeYawLimit=-15000,bExposed=true,ViewFOV=90.0)
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.234_body'
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
    VehicleHudEngineX=0.51
    VehHitpoints(0)=(PointOffset=(X=5.0,Z=-5.0),bPenetrationPoint=false)
    VehHitpoints(1)=(PointOffset=(X=-150.0,Z=52.0),DamageMultiplier=1.0)
    VehHitpoints(2)=(PointRadius=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=30.0,Y=-30.0,Z=52.0),DamageMultiplier=3.0,HitPointType=HP_AmmoStore)
    EngineHealth=100
    bIsApc=true
    DriverAttachmentBone="driver_attachment"
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
    End Object
    Wheels(7)=SVehicleWheel'DH_Vehicles.DH_Sdkfz2341ArmoredCar.RLWheel'
    VehicleMass=5.0
    DrivePos=(X=4.0,Y=-2.0,Z=0.0)
    DriveAnim="VBA64_driver_idle_close"
    ExitPositions(0)=(X=-92.0,Y=4.0,Z=150.0)
    ExitPositions(1)=(X=-92.0,Y=4.0,Z=150.0)
    ExitPositions(2)=(X=-160.0,Y=-120.0,Z=35.0)
    ExitPositions(3)=(X=-300.0,Y=0.0,Z=35.0)
    ExitPositions(4)=(X=-160.0,Y=120.0,Z=35.0)
    ExitPositions(5)=(X=-300.0,Y=0.0,Z=35.0)
    EntryRadius=375.0
    DriverDamageMult=1.0
    VehicleNameString="Sdkfz 234/1 Armored Car"
    MaxDesireability=0.1
    PitchUpLimit=500
    PitchDownLimit=58000
    Mesh=SkeletalMesh'DH_Sdkfz234ArmoredCar_anm.Sdkfz234_body_ext'
    Skins(0)=texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_body_dunk'
    Skins(1)=texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_wheels_dunk'
    Skins(2)=texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_extras_dunk'
    Skins(3)=texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_accessories'
    Skins(4)=texture'DH_VehiclesGE_tex6.int_vehicles.sdkfz2341_body_int'
    SoundRadius=800.0
    TransientSoundRadius=1500.0
    CollisionRadius=175.0
    CollisionHeight=60.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.3
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=0.3,Z=-0.525)
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
    HighDetailOverlayIndex=4
    bAllowRiders=true
}
