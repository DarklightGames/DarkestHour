//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_OpelBlitz extends DHVehicle
    abstract;

#exec OBJ LOAD FILE=..\Animations\DH_OpelBlitz_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex2.utx

defaultproperties
{
    ReinforcementCost=5
    bCanCrash=true
    WheelSoftness=0.025
    WheelPenScale=1.2
    WheelPenOffset=0.01
    WheelRestitution=0.1
    WheelInertia=0.1
    WheelLongFrictionFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=100.0,OutVal=1.0),(InVal=200.0,OutVal=0.2),(InVal=400.0,OutVal=0.001),(InVal=10000000000.0,OutVal=0.0)))
    WheelLongSlip=0.001
    WheelLongFrictionScale=1.1
    WheelLatSlipFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=30.0,OutVal=0.009),(InVal=45.0,OutVal=0.09),(InVal=10000000000.0,OutVal=0.9)))
    WheelLatFrictionScale=1.35
    WheelHandbrakeSlip=1.5
    WheelHandbrakeFriction=0.1
    WheelSuspensionTravel=15.0
    WheelSuspensionMaxRenderTravel=15.0
    FTScale=0.03
    ChassisTorqueScale=0.4
    MinBrakeFriction=3.0
    MaxSteerAngleCurve=(Points=((InVal=0.0,OutVal=45.0),(InVal=200.0,OutVal=35.0),(InVal=800.0,OutVal=6.0),(InVal=1000000000.0,OutVal=0.0)))
    TorqueCurve=(Points=((InVal=0.0,OutVal=15.0),(InVal=200.0,OutVal=10.0),(InVal=600.0,OutVal=8.0),(InVal=1200.0,OutVal=3.0),(InVal=2000.0,OutVal=0.5)))
    GearRatios(0)=-0.3
    GearRatios(1)=0.2
    GearRatios(2)=0.35
    GearRatios(3)=0.55
    GearRatios(4)=0.98
    TransRatio=0.18
    ChangeUpPoint=1990.0
    ChangeDownPoint=1000.0
    LSDFactor=1.0
    EngineBrakeFactor=0.0001
    EngineBrakeRPMScale=0.1
    MaxBrakeTorque=10.0
    SteerSpeed=70.0
    TurnDamping=25.0
    StopThreshold=100.0
    HandbrakeThresh=100.0
    EngineInertia=0.1
    IdleRPM=500.0
    EngineRPMSoundRange=5000.0
    SteerBoneName="WheelDrive"
    RevMeterScale=4000.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-30.0,Y=180.0,Z=-50.0),ExhaustRotation=(Pitch=36000,Yaw=5000))
    PassengerPawns(0)=(AttachBone="passenger1",DrivePos=(X=2.0,Y=0.0,Z=-6.0),DriveAnim="VHalftrack_Rider1_idle")
    IdleSound=SoundGroup'Vehicle_Engines.BA64.ba64_engine_loop'
    StartUpSound=sound'Vehicle_Engines.BA64.BA64_engine_start'
    ShutDownSound=sound'Vehicle_Engines.BA64.BA64_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Trucks.OpelBlitz_dest'
    DisintegrationEffectClass=class'ROEffects.ROVehicleObliteratedEmitter'
    DisintegrationEffectLowClass=class'ROEffects.ROVehicleObliteratedEmitter_simple'
    DisintegrationHealth=-1000.0
    DestructionLinearMomentum=(Min=100.0,Max=350.0)
    DestructionAngularMomentum=(Max=150.0)
    DamagedEffectScale=0.8
    DamagedEffectOffset=(X=115.0,Z=70.0)
    BeginningIdleAnim="Overlay_Idle"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_OpelBlitz_anm.OpelBlitz_body_int',TransitionUpAnim="Overlay_In",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_OpelBlitz_anm.OpelBlitz_body_int',TransitionDownAnim="Overlay_Out",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    InitialPositionIndex=0
    VehicleHudEngineY=0.25
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.opelblitz_body'
    VehicleHudOccupantsX(0)=0.45
    VehicleHudOccupantsY(0)=0.35
    VehicleHudOccupantsX(1)=0.55
    VehicleHudOccupantsY(1)=0.35
    VehHitpoints(0)=(PointOffset=(X=16.0)) // engine
    DriverAttachmentBone="driver_player"
    Begin Object Class=SVehicleWheel Name=RFWheel
        SteerType=VST_Steered
        BoneName="wheel_FR"
        BoneRollAxis=AXIS_Y
        WheelRadius=25.0
        SupportBoneName="Axle_F_R"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_OpelBlitz.RFWheel'
    Begin Object Class=SVehicleWheel Name=LFWheel
        SteerType=VST_Steered
        BoneName="wheel_FL"
        BoneRollAxis=AXIS_Y
        WheelRadius=25.0
        SupportBoneName="Axle_F_L"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_OpelBlitz.LFWheel'
    Begin Object Class=SVehicleWheel Name=RRWheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="wheel_RR"
        BoneRollAxis=AXIS_Y
        WheelRadius=26.0
        SupportBoneName="Axle_R_R"
        SupportBoneAxis=AXIS_Z
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_OpelBlitz.RRWheel'
    Begin Object Class=SVehicleWheel Name=LRWheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="wheel_LR"
        BoneRollAxis=AXIS_Y
        WheelRadius=26.0
        SupportBoneName="Axle_R_L"
        SupportBoneAxis=AXIS_Z
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_OpelBlitz.LRWheel'
    VehicleMass=3.0
    bFPNoZFromCameraPitch=true
    DrivePos=(X=13.0,Y=-1.0,Z=-5.0)
    DriveAnim="VUC_driver_idle_close"
    ExitPositions(0)=(X=70.0,Y=-130.0,Z=60.0)
    ExitPositions(1)=(X=70.0,Y=130.0,Z=60.0)
    CenterSpringForce="SpringONSSRV"
    VehicleNameString="Opel Blitz"
    MaxDesireability=0.12
    FlagBone="Mg_placement"
    FlagRotation=(Yaw=32768)
    GroundSpeed=325.0
    PitchUpLimit=5000
    PitchDownLimit=49000
    ImpactDamageThreshold=20.0
    ImpactDamageMult=0.001
    ImpactWorldDamageMult=1.0
    HeavyEngineDamageThreshold=0.33
    EngineHealth=35
    HealthMax=150.0
    Health=150
    Mesh=SkeletalMesh'DH_OpelBlitz_anm.OpelBlitz_body_ext'
    Skins(0)=texture'DH_VehiclesGE_tex2.ext_vehicles.OpelBlitz_body_ext'
    Skins(1)=texture'DH_VehiclesGE_tex2.ext_vehicles.OpelBlitz_body_ext'
    Skins(2)=texture'DH_VehiclesGE_tex2.int_vehicles.OpelBlitz_body_int'
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_OpelBlitz.KParams0'
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.opelblitz'
}
