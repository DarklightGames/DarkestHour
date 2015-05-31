//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WillysJeep extends DHWheeledVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_WillysJeep_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex2.utx
#exec OBJ LOAD FILE=..\Sounds\DH_AlliedVehicleSounds.uax
#exec OBJ LOAD FILE=..\Sounds\DH_GerVehicleSounds2.uax

defaultproperties
{
    MaxPitchSpeed=250.0
    RumbleSound=sound'DH_GerVehicleSounds2.Kubelwagen.kubelwagen_engine_interior'
    RumbleSoundBone="body"
    WheelSoftness=0.025
    WheelPenScale=1.2
    WheelPenOffset=0.01
    WheelRestitution=0.1
    WheelInertia=0.1
    WheelLongFrictionFunc=(Points=(,(InVal=100.0,OutVal=1.0),(InVal=200.0,OutVal=0.9),(InVal=10000000000.0,OutVal=0.9)))
    WheelLongSlip=0.001
    WheelLatSlipFunc=(Points=(,(InVal=30.0,OutVal=0.009),(InVal=45.0),(InVal=10000000000.0)))
    WheelLongFrictionScale=1.1
    WheelLatFrictionScale=1.55
    WheelHandbrakeSlip=0.01
    WheelHandbrakeFriction=0.1
    WheelSuspensionTravel=10.0
    WheelSuspensionMaxRenderTravel=5.0
    FTScale=0.03
    ChassisTorqueScale=0.095
    MinBrakeFriction=4.0
    MaxSteerAngleCurve=(Points=((OutVal=45.0),(InVal=300.0,OutVal=30.0),(InVal=500.0,OutVal=20.0),(InVal=600.0,OutVal=15.0),(InVal=1000000000.0,OutVal=10.0)))
    TorqueCurve=(Points=((OutVal=10.0),(InVal=200.0,OutVal=0.75),(InVal=1500.0,OutVal=2.0),(InVal=2200.0)))
    GearRatios(0)=-0.2
    GearRatios(1)=0.2
    GearRatios(2)=0.35
    GearRatios(3)=0.55
    GearRatios(4)=0.8
    TransRatio=0.17
    ChangeUpPoint=2000.0
    ChangeDownPoint=1000.0
    LSDFactor=1.0
    EngineBrakeFactor=0.0001
    EngineBrakeRPMScale=0.1
    MaxBrakeTorque=20.0
    SteerSpeed=160.0
    TurnDamping=35.0
    StopThreshold=100.0
    HandbrakeThresh=200.0
    EngineInertia=0.1
    IdleRPM=500.0
    EngineRPMSoundRange=6000.0
    SteerBoneName="Steer_Wheel"
    RevMeterScale=4000.0
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-120.0,Y=30.0,Z=-5.0),ExhaustRotation=(Pitch=34000,Roll=-5000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_WillysJeepPassengerOne',WeaponBone="passenger2")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_WillysJeepPassengerTwo',WeaponBone="Passenger3")
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_WillysJeepPassengerThree',WeaponBone="Passenger4")
    IdleSound=SoundGroup'DH_AlliedVehicleSounds.Jeep.jeep_engine_loop03'
    StartUpSound=sound'DH_AlliedVehicleSounds.Jeep.jeep_engine_start'
    ShutDownSound=sound'DH_AlliedVehicleSounds.Jeep.jeep_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Jeep.WillysJeep_dest1'
    DisintegrationHealth=-10000.0
    DestructionLinearMomentum=(Min=50.0,Max=175.0)
    DestructionAngularMomentum=(Min=5.0,Max=15.0)
    DamagedEffectScale=0.8
    DamagedEffectOffset=(X=75.0,Y=5.0,Z=45.0)
    VehicleTeam=1
    SteeringScaleFactor=4.0
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_WillysJeep_anm.jeep_body_ext',ViewPitchUpLimit=8000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=26000,ViewNegativeYawLimit=-24000,bExposed=true,ViewFOV=90.0)
    InitialPositionIndex=0
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.Willys_body'
    VehicleHudOccupantsX(0)=0.44
    VehicleHudOccupantsX(1)=0.57
    VehicleHudOccupantsX(2)=0.41
    VehicleHudOccupantsX(3)=0.6
    VehicleHudOccupantsY(0)=0.53
    VehicleHudOccupantsY(1)=0.53
    VehicleHudOccupantsY(2)=0.66
    VehicleHudOccupantsY(3)=0.66
    VehicleHudEngineY=0.28
    VehHitpoints(0)=(PointBone="body",PointOffset=(X=-10.0,Y=-25.0,Z=55.0),bPenetrationPoint=false)
    VehHitpoints(1)=(PointRadius=20.0,PointOffset=(X=65.0,Z=15.0),DamageMultiplier=1.0)
    VehHitpoints(2)=(PointRadius=18.0,PointScale=1.0,PointBone="LeftFrontWheel",DamageMultiplier=1.0,HitPointType=HP_Engine)
    VehHitpoints(3)=(PointRadius=18.0,PointScale=1.0,PointBone="RightFrontWheel",DamageMultiplier=1.0,HitPointType=HP_Engine)
    VehHitpoints(4)=(PointRadius=18.0,PointScale=1.0,PointBone="LeftRearWheel",DamageMultiplier=1.0,HitPointType=HP_Engine)
    VehHitpoints(5)=(PointRadius=18.0,PointScale=1.0,PointBone="RightRearWheel",DamageMultiplier=1.0,HitPointType=HP_Engine)
    EngineHealth=25
    bMultiPosition=false
    DriverAttachmentBone="driver_attachment"
    Begin Object Class=SVehicleWheel Name=LFWheel
        SteerType=VST_Steered
        BoneName="LeftFrontWheel"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=9.0,Z=1.0)
        WheelRadius=25.0
        SupportBoneName="RightFrontSusp00"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_WillysJeep.LFWheel'
    Begin Object Class=SVehicleWheel Name=RFWheel
        SteerType=VST_Steered
        BoneName="RightFrontWheel"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-9.0,Z=1.0)
        WheelRadius=25.0
        SupportBoneName="LeftFrontSusp00"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_WillysJeep.RFWheel'
    Begin Object Class=SVehicleWheel Name=LRWheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="LeftRearWheel"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=9.0,Z=1.0)
        WheelRadius=25.0
        SupportBoneName="LeftRearAxle"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_WillysJeep.LRWheel'
    Begin Object Class=SVehicleWheel Name=RRWheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="RightRearWheel"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-9.0,Z=1.0)
        WheelRadius=25.0
        SupportBoneName="RightRearAxle"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_WillysJeep.RRWheel'
    VehicleMass=3.0
    bHasHandbrake=true
    bFPNoZFromCameraPitch=true
    DrivePos=(X=5.0,Z=8.0)
    DriveAnim="Vhalftrack_driver_idle"
    ExitPositions(0)=(X=-4.0,Y=-111.0,Z=30.0)
    ExitPositions(1)=(X=-3.0,Y=107.0,Z=30.0)
    ExitPositions(2)=(X=-64.0,Y=-109.0,Z=30.0)
    ExitPositions(3)=(X=-71.0,Y=109.0,Z=30.0)
    EntryRadius=225.0
    FPCamViewOffset=(Z=-5.0)
    CenterSpringForce="SpringONSSRV"
    DriverDamageMult=1.0
    VehicleNameString="Willys Jeep MB"
    GroundSpeed=325.0
    PitchUpLimit=500
    PitchDownLimit=58000
    HealthMax=125.0
    Health=125
    Mesh=SkeletalMesh'DH_WillysJeep_anm.jeep_body_ext'
    Skins(0)=texture'DH_VehiclesUS_tex2.ext_vehicles.WillysJeep'
    CollisionRadius=175.0
    CollisionHeight=40.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.3
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-0.2)
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_WillysJeep.KParams0'
    HighDetailOverlay=texture'DH_VehiclesUS_tex2.ext_vehicles.WillysJeep'
}
