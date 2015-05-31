//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_GMCTruck extends DHWheeledVehicle
    abstract;

#exec OBJ LOAD FILE=..\Animations\DH_GMCTruck_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_Allied_MilitarySM.utx

defaultproperties
{
    WheelSoftness=0.025
    WheelPenScale=1.2
    WheelPenOffset=0.01
    WheelRestitution=0.1
    WheelInertia=0.1
    WheelLongFrictionFunc=(Points=(,(InVal=100.0,OutVal=1.0),(InVal=200.0,OutVal=0.9),(InVal=10000000000.0,OutVal=0.9)))
    WheelLongSlip=0.001
    WheelLatSlipFunc=(Points=(,(InVal=30.0,OutVal=0.009),(InVal=45.0),(InVal=10000000000.0)))
    WheelLongFrictionScale=1.1
    WheelLatFrictionScale=1.35
    WheelHandbrakeSlip=1.1
    WheelHandbrakeFriction=0.1
    WheelSuspensionTravel=15.0
    WheelSuspensionMaxRenderTravel=15.0
    FTScale=0.03
    ChassisTorqueScale=0.4
    MinBrakeFriction=4.0
    MaxSteerAngleCurve=(Points=((OutVal=35.0),(InVal=1500.0,OutVal=20.0),(InVal=1000000000.0,OutVal=15.0)))
    TorqueCurve=(Points=((OutVal=1.0),(InVal=200.0,OutVal=0.75),(InVal=1500.0,OutVal=2.0),(InVal=2200.0)))
    GearRatios(0)=-0.2
    GearRatios(1)=0.2
    GearRatios(2)=0.35
    GearRatios(3)=0.65
    GearRatios(4)=0.85
    TransRatio=0.12
    ChangeUpPoint=1990.0
    ChangeDownPoint=1000.0
    LSDFactor=1.0
    EngineBrakeFactor=0.0001
    EngineBrakeRPMScale=0.1
    MaxBrakeTorque=20.0
    SteerSpeed=100.0
    TurnDamping=35.0
    StopThreshold=100.0
    HandbrakeThresh=200.0
    EngineInertia=0.1
    IdleRPM=500.0
    EngineRPMSoundRange=5000.0
    SteerBoneName="WheelDrive"
    RevMeterScale=4000.0
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-150.0,Y=-35.0,Z=-12.0),ExhaustRotation=(Pitch=36000,Yaw=5000))
    ExhaustPipes(1)=(ExhaustPosition=(X=-150.0,Y=35.0,Z=-12.0),ExhaustRotation=(Pitch=36000,Yaw=5000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_GMCTruckPassengerOne',WeaponBone="passenger1")
    IdleSound=SoundGroup'Vehicle_Engines.sdkfz251.sdkfz251_engine_loop'
    StartUpSound=sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_start'
    ShutDownSound=sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Trucks.GMC_destroyed'
    DisintegrationEffectClass=class'ROEffects.ROVehicleObliteratedEmitter'
    DisintegrationEffectLowClass=class'ROEffects.ROVehicleObliteratedEmitter_simple'
    DisintegrationHealth=-10000.0
    DestructionLinearMomentum=(Min=100.0,Max=350.0)
    DestructionAngularMomentum=(Max=150.0)
    DamagedEffectScale=0.8
    DamagedEffectOffset=(X=135.0,Z=65.0)
    ImpactDamageThreshold=5000.0
    ImpactDamageMult=0.001
    VehicleTeam=1
    SteeringScaleFactor=4.0
    BeginningIdleAnim=
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_GMCTruck_anm.GMCTruck_body',ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true,ViewFOV=90.0)
    InitialPositionIndex=0
    VehicleHudEngineY=0.25
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.GMC_body'
    VehicleHudOccupantsX(0)=0.45
    VehicleHudOccupantsY(0)=0.4
    VehicleHudOccupantsX(1)=0.55
    VehicleHudOccupantsY(1)=0.4
    VehHitpoints(0)=(PointBone="body",PointOffset=(X=55.0,Y=-23.0,Z=78.0),bPenetrationPoint=false)
    VehHitpoints(1)=(PointBone="Engine",DamageMultiplier=1.0)
    VehHitpoints(2)=(PointRadius=18.0,PointScale=1.0,PointBone="wheel_FL",DamageMultiplier=1.0,HitPointType=HP_Engine)
    VehHitpoints(3)=(PointRadius=18.0,PointScale=1.0,PointBone="wheel_FR",DamageMultiplier=1.0,HitPointType=HP_Engine)
    EngineHealth=35
    bMultiPosition=false
    DriverAttachmentBone="driver_player"
    Begin Object Class=SVehicleWheel Name=RFWheel
        SteerType=VST_Steered
        BoneName="wheel_FR"
        BoneRollAxis=AXIS_Y
        WheelRadius=26.0
        SupportBoneName="Axle_F_R"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_GMCTruck.RFWheel'
    Begin Object Class=SVehicleWheel Name=LFWheel
        SteerType=VST_Steered
        BoneName="wheel_FL"
        BoneRollAxis=AXIS_Y
        WheelRadius=26.0
        SupportBoneName="Axle_F_L"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_GMCTruck.LFWheel'
    Begin Object Class=SVehicleWheel Name=MRWheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="wheel_MR"
        BoneRollAxis=AXIS_Y
        WheelRadius=26.0
        SupportBoneName="Axle_M_R"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_GMCTruck.MRWheel'
    Begin Object Class=SVehicleWheel Name=MLWheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="wheel_ML"
        BoneRollAxis=AXIS_Y
        WheelRadius=26.0
        SupportBoneName="Axle_M_L"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_GMCTruck.MLWheel'
    Begin Object Class=SVehicleWheel Name=RRWheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="wheel_RR"
        BoneRollAxis=AXIS_Y
        WheelRadius=26.0
        SupportBoneName="Axle_R_R"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_GMCTruck.RRWheel'
    Begin Object Class=SVehicleWheel Name=LRWheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="wheel_LR"
        BoneRollAxis=AXIS_Y
        WheelRadius=26.0
        SupportBoneName="Axle_R_L"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_GMCTruck.LRWheel'
    VehicleMass=3.5
    bHasHandbrake=true
    bFPNoZFromCameraPitch=true
    DrivePos=(X=6.0,Z=2.0)
    DriveAnim="VUC_driver_idle_open"
    ExitPositions(0)=(X=57.0,Y=-132.0,Z=25.0)  // driver
    ExitPositions(1)=(X=65.0,Y=137.0,Z=25.0)   // front passenger
    EntryRadius=375.0
    CenterSpringForce="SpringONSSRV"
    DriverDamageMult=1.0
    VehicleNameString="GMC 2.5 Ton Truck"
    MaxDesireability=0.12
    FlagBone="Mg_placement"
    FlagRotation=(Yaw=32768)
    GroundSpeed=325.0
    PitchUpLimit=5000
    PitchDownLimit=49000
    HealthMax=150.0
    Health=150
    Mesh=SkeletalMesh'DH_GMCTruck_anm.GMCTruck_body'
    Skins(0)=texture'DH_Allied_MilitarySM.American.GMC'
    SoundRadius=800.0
    TransientSoundRadius=1500.0
    CollisionRadius=175.0
    CollisionHeight=40.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_GMCTruck.KParams0'
}
