//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_GMCTruck extends DHVehicle
    abstract;

#exec OBJ LOAD FILE=..\Animations\DH_GMCTruck_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_Allied_MilitarySM.utx

defaultproperties
{
    // Vehicle properties
    VehicleNameString="GMC CCKW"
    VehicleTeam=1
    VehicleMass=2.5
    ReinforcementCost=5
    MaxDesireability=0.12

    // Hull mesh
    Mesh=SkeletalMesh'DH_GMCTruck_anm.GMCTruck_body'
    Skins(0)=Texture'DH_Allied_MilitarySM.American.GMC'
    BeginningIdleAnim="" // override unwanted inherited value, as GMC has no animations

    // Passengers
    PassengerPawns(0)=(AttachBone="passenger1",DrivePos=(X=2.0,Y=0.0,Z=5.0),DriveAnim="VHalftrack_Rider1_idle")

    // Driver
    bMultiPosition=false
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_GMCTruck_anm.GMCTruck_body',ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    InitialPositionIndex=0
    DriverAttachmentBone="driver_player"
    DrivePos=(X=6.0,Y=0.0,Z=2.0)
    DriveAnim="VUC_driver_idle_open"

    // Movement
    GearRatios(0)=-0.3
    GearRatios(4)=0.98
    TransRatio=0.18
    ChangeUpPoint=1990.0
    TorqueCurve=(Points=((InVal=0.0,OutVal=15.0),(InVal=200.0,OutVal=10.0),(InVal=600.0,OutVal=8.0),(InVal=1200.0,OutVal=3.0),(InVal=2000.0,OutVal=0.5)))
    TurnDamping=25.0
    SteerSpeed=70.0
    MaxSteerAngleCurve=(Points=((InVal=0.0,OutVal=45.0),(InVal=200.0,OutVal=35.0),(InVal=800.0,OutVal=6.0),(InVal=1000000000.0,OutVal=0.0)))
    MinBrakeFriction=3.0
    MaxBrakeTorque=10.0
    bHasHandbrake=true
    HandbrakeThresh=100.0

    // Physics wheels properties
    WheelLongFrictionFunc=(Points=((InVal=0.0,OutVal=0.1),(InVal=100.0,OutVal=1.0),(InVal=200.0,OutVal=0.3),(InVal=400.0,OutVal=0.1),(InVal=10000000000.0,OutVal=0.0)))
    WheelLatSlipFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=30.0,OutVal=0.009),(InVal=45.0,OutVal=0.09),(InVal=10000000000.0,OutVal=0.9)))
    WheelLatFrictionScale=2.0
    WheelHandbrakeSlip=0.1

    // Damage
    Health=1000
    HealthMax=1000.0
    EngineHealth=40
    VehHitpoints(1)=(PointRadius=18.0,PointScale=1.0,PointBone="wheel_FL",DamageMultiplier=1.0,HitPointType=HP_Engine) // note VHP(0) is inherited default for engine
    VehHitpoints(2)=(PointRadius=18.0,PointScale=1.0,PointBone="wheel_FR",DamageMultiplier=1.0,HitPointType=HP_Engine)
    ImpactWorldDamageMult=1.0
    HeavyEngineDamageThreshold=0.33
    DamagedEffectScale=0.8
    DamagedEffectOffset=(X=135.0,Y=0.0,Z=65.0)
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Trucks.GMC_destroyed'

    // Vehicle destruction
    ExplosionDamage=50.0
    ExplosionRadius=100.0
    ExplosionSoundRadius=200.0
    DestructionLinearMomentum=(Min=50.0,Max=100.0)
    DestructionAngularMomentum=(Min=10.0,Max=50.0)

    // Exit
    ExitPositions(0)=(X=57.0,Y=-132.0,Z=25.0) // driver
    ExitPositions(1)=(X=65.0,Y=137.0,Z=25.0)  // front passenger

    // Sounds
    IdleSound=SoundGroup'Vehicle_Engines.sdkfz251.sdkfz251_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_stop'

    // Visual effects
    ExhaustPipes(0)=(ExhaustPosition=(X=-150.0,Y=-35.0,Z=-12.0),ExhaustRotation=(Pitch=36000,Yaw=5000))
    ExhaustPipes(1)=(ExhaustPosition=(X=-150.0,Y=35.0,Z=-12.0),ExhaustRotation=(Pitch=36000,Yaw=5000))
    SteerBoneName="WheelDrive"

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.GMC_body'
    VehicleHudEngineY=0.25
    VehicleHudOccupantsX(0)=0.45
    VehicleHudOccupantsY(0)=0.4
    VehicleHudOccupantsX(1)=0.55
    VehicleHudOccupantsY(1)=0.4
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.gmc'

    // Physics wheels
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
        BoneName="wheel_MR"
        BoneRollAxis=AXIS_Y
        WheelRadius=26.0
        SupportBoneName="Axle_M_R"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_GMCTruck.MRWheel'
    Begin Object Class=SVehicleWheel Name=MLWheel
        bPoweredWheel=true
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

    // Karma
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
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_GMCTruck.KParams0'
}
