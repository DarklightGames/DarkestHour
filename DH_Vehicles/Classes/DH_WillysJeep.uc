//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_WillysJeep extends DHVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Willys Jeep MB"
    VehicleTeam=1
    VehicleMass=2.0
    ReinforcementCost=3
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_Vehicle'

    // Hull mesh
    Mesh=SkeletalMesh'DH_WillysJeep_anm.jeep_body_ext'
    Skins(0)=Texture'DH_VehiclesUS_tex2.ext_vehicles.WillysJeep'
    BeginningIdleAnim="driver_hatch_idle_close"

    // Passengers
    PassengerPawns(0)=(AttachBone="passenger2",DrivePos=(X=5.0,Y=0.0,Z=11.0),DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(1)=(AttachBone="Passenger3",DrivePos=(X=0.0,Y=0.0,Z=7.0),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider6_idle")
    PassengerPawns(2)=(AttachBone="Passenger4",DrivePos=(X=0.0,Y=0.0,Z=7.0),DriveAnim="VHalftrack_Rider2_idle")

    // Driver
    bMultiPosition=false
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_WillysJeep_anm.jeep_body_ext',ViewPitchUpLimit=8000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=26000,ViewNegativeYawLimit=-24000,bExposed=true)
    InitialPositionIndex=0
    DrivePos=(X=3.0,Y=0.0,Z=15.0)
    DriveAnim="Vhalftrack_driver_idle"

    // Movement
    GearRatios(0)=-0.3
    GearRatios(1)=0.3
    GearRatios(2)=0.5
    GearRatios(3)=0.8
    GearRatios(4)=1.25
    TransRatio=0.18
    TorqueCurve=(Points=((InVal=0.0,OutVal=10.0),(InVal=200.0,OutVal=7.0),(InVal=600.0,OutVal=4.0),(InVal=1200.0,OutVal=2.0),(InVal=2000.0,OutVal=1.0)))
    ChassisTorqueScale=0.1
    TurnDamping=5.0
    SteerSpeed=130.0
    MaxSteerAngleCurve=(Points=((InVal=0.0,OutVal=64.0),(InVal=200.0,OutVal=35.0),(InVal=900.0,OutVal=3.0),(InVal=1000000000.0,OutVal=0.0)))
    MinBrakeFriction=2.0
    MaxBrakeTorque=10.0
    EngineBrakeFactor=0.0002
    bHasHandbrake=true
    HandbrakeThresh=100.0
    EngineRPMSoundRange=6000.0
    MaxCriticalSpeed=1341.0 // approx 80 kph

    // Physics wheels properties
    WheelLongFrictionFunc=(Points=((InVal=0.0,OutVal=0.1),(InVal=100.0,OutVal=1.0),(InVal=400.0,OutVal=0.3),(InVal=800.0,OutVal=0.1),(InVal=10000000000.0,OutVal=0.0)))
    WheelLatSlipFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=30.0,OutVal=0.009),(InVal=45.0,OutVal=0.09),(InVal=10000000000.0,OutVal=0.9)))
    WheelLatFrictionScale=1.55
    WheelHandbrakeFriction=0.6
    WheelHandbrakeSlip=0.05
    WheelSuspensionTravel=10.0
    WheelSuspensionMaxRenderTravel=5.0

    // Damage
    Health=1500
    HealthMax=1500.0
    DamagedEffectHealthFireFactor=0.95
    EngineHealth=10
    DamagedWheelSpeedFactor=0.3
    VehHitpoints(0)=(PointRadius=32.0,PointBone="body",PointOffset=(X=65.0,Y=0.0,Z=15.0),DamageMultiplier=1.0,HitPointType=HP_Engine) // engine
    VehHitpoints(1)=(PointRadius=24.0,PointScale=1.0,PointBone="LeftFrontWheel",DamageMultiplier=1.0,HitPointType=HP_Driver) // wheel
    VehHitpoints(2)=(PointRadius=24.0,PointScale=1.0,PointBone="RightFrontWheel",DamageMultiplier=1.0,HitPointType=HP_Driver) // wheel
    VehHitpoints(3)=(PointRadius=24.0,PointScale=1.0,PointBone="LeftRearWheel",DamageMultiplier=1.0,HitPointType=HP_Driver) // wheel
    VehHitpoints(4)=(PointRadius=24.0,PointScale=1.0,PointBone="RightRearWheel",DamageMultiplier=1.0,HitPointType=HP_Driver) // wheel
    EngineDamageFromGrenadeModifier=0.125
    DirectHEImpactDamageMult=10.0
    ImpactDamageMult=0.5
    ImpactWorldDamageMult=0.006
    DamagedEffectScale=0.8
    DamagedEffectOffset=(X=75.0,Y=5.0,Z=45.0)
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Jeep.WillysJeep_dest1'

    // Vehicle destruction
    ExplosionDamage=50.0
    ExplosionRadius=150.0
    ExplosionSoundRadius=200.0
    DestructionLinearMomentum=(Min=10.0,Max=50.0)
    DestructionAngularMomentum=(Min=10.0,Max=50.0)

    // Exit
    ExitPositions(0)=(X=-4.0,Y=-111.0,Z=30.0)  // driver
    ExitPositions(1)=(X=-3.0,Y=107.0,Z=30.0)   // front passenger
    ExitPositions(2)=(X=-64.0,Y=-109.0,Z=30.0) // rear passenger left
    ExitPositions(3)=(X=-71.0,Y=109.0,Z=30.0)  // rear passenger right

    // Sounds
    MaxPitchSpeed=350.0
    IdleSound=SoundGroup'DH_AlliedVehicleSounds.Jeep.jeep_engine_loop03'
    StartUpSound=Sound'DH_AlliedVehicleSounds.Jeep.jeep_engine_start'
    ShutDownSound=Sound'DH_AlliedVehicleSounds.Jeep.jeep_engine_stop'
    RumbleSound=Sound'DH_GerVehicleSounds2.Kubelwagen.kubelwagen_engine_interior'

    // Visual effects
    ExhaustPipes(0)=(ExhaustPosition=(X=-120.0,Y=30.0,Z=-5.0),ExhaustRotation=(Pitch=34000,Roll=-5000))
    SteerBoneName="Steer_Wheel"

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.Willys_body'
    VehicleHudEngineY=0.28
    VehicleHudOccupantsX(0)=0.44
    VehicleHudOccupantsX(1)=0.57
    VehicleHudOccupantsX(2)=0.41
    VehicleHudOccupantsX(3)=0.6
    VehicleHudOccupantsY(0)=0.53
    VehicleHudOccupantsY(1)=0.53
    VehicleHudOccupantsY(2)=0.66
    VehicleHudOccupantsY(3)=0.66
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.jeep'

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LFWheel
        SteerType=VST_Steered
        bPoweredWheel=true
        BoneName="LeftFrontWheel"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=0.0,Y=9.0,Z=1.0)
        WheelRadius=25.0
        SupportBoneName="RightFrontSusp00"
        SupportBoneAxis=AXIS_X
        bLeftTrack=true
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_WillysJeep.LFWheel'
    Begin Object Class=SVehicleWheel Name=RFWheel
        SteerType=VST_Steered
        bPoweredWheel=true
        BoneName="RightFrontWheel"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=0.0,Y=-9.0,Z=1.0)
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
        BoneOffset=(X=0.0,Y=9.0,Z=1.0)
        WheelRadius=25.0
        SupportBoneName="LeftRearAxle"
        SupportBoneAxis=AXIS_X
        bLeftTrack=true
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_WillysJeep.LRWheel'
    Begin Object Class=SVehicleWheel Name=RRWheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="RightRearWheel"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=0.0,Y=-9.0,Z=1.0)
        WheelRadius=25.0
        SupportBoneName="RightRearAxle"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_WillysJeep.RRWheel'

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.3
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=0.0,Y=0.0,Z=-0.2) // default is zero
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
}
