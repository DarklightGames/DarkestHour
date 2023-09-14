//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WillysJeep extends DHVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Willys Jeep MB"
    VehicleTeam=1
    VehicleMass=2.0
    ReinforcementCost=1
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_Vehicle'

    // Hull mesh
    Mesh=SkeletalMesh'DH_WillysJeep_anm.jeep_body'
    Skins(0)=Texture'DH_Jeep_tex.body.Willys_Body_OD'
    Skins(1)=Texture'DH_Jeep_tex.body.Willys_Wheels_OD'
    Skins(2)=Texture'DH_Jeep_tex.body.Willys_Gear_OD'
    Skins(3)=Texture'DH_ShermanM4A3E8_tex.hull_stowage_01'

    BeginningIdleAnim="driver_hatch_idle_close"

    // Passengers
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-30.0,Y=25.0,Z=50.0),DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-90,Y=-20,Z=55.0),DriveRot=(Yaw=2048),DriveAnim="VHalftrack_Rider6_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-90,Y=20,Z=55.0),DriveRot=(Yaw=-2048),DriveAnim="VHalftrack_Rider2_idle")

    // Driver
    bMultiPosition=false
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_WillysJeep_anm.jeep_body',ViewPitchUpLimit=8000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=26000,ViewNegativeYawLimit=-24000,bExposed=true)
    InitialPositionIndex=0
    DrivePos=(X=-30.0,Y=-25.0,Z=50.0)
    DriverAttachmentBone=body
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
    WheelSuspensionOffset=-4.0
    WheelSuspensionMaxRenderTravel=5.0

    // Damage
    Health=1500
    HealthMax=1500.0
    DamagedEffectHealthFireFactor=0.95
    EngineHealth=10
    DamagedWheelSpeedFactor=0.3
    VehHitpoints(0)=(PointRadius=32.0,PointBone="body",PointOffset=(X=35.0,Y=0.0,Z=50.0),DamageMultiplier=1.0,HitPointType=HP_Engine) // engine
    VehHitpoints(1)=(PointRadius=24.0,PointScale=1.0,PointBone="wheel.L.F",DamageMultiplier=1.0,HitPointType=HP_Driver) // wheel
    VehHitpoints(2)=(PointRadius=24.0,PointScale=1.0,PointBone="wheel.R.F",DamageMultiplier=1.0,HitPointType=HP_Driver) // wheel
    VehHitpoints(3)=(PointRadius=24.0,PointScale=1.0,PointBone="wheel.L.B",DamageMultiplier=1.0,HitPointType=HP_Driver) // wheel
    VehHitpoints(4)=(PointRadius=24.0,PointScale=1.0,PointBone="wheel.R.B",DamageMultiplier=1.0,HitPointType=HP_Driver) // wheel
    EngineDamageFromGrenadeModifier=0.125
    DirectHEImpactDamageMult=10.0
    ImpactDamageMult=0.5
    ImpactWorldDamageMult=0.006
    DamagedEffectScale=0.8
    DamagedEffectOffset=(X=40.0,Y=0.0,Z=70.0)
    DestroyedVehicleMesh=StaticMesh'DH_Jeep_stc.Destroyed.jeep_destroyed'
    DestroyedMeshSkins(0)=Combiner'DH_Jeep_tex.body.Willys_Body_OD_Destroyed'
    DestroyedMeshSkins(1)=Combiner'DH_Jeep_tex.body.Willys_Wheels_OD_Destroyed'
    DestroyedMeshSkins(2)=Combiner'DH_Jeep_tex.body.Willys_Gear_OD_Destroyed'

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
    ExitPositions(4)=(X=-200.00,Y=0.00,Z=30.00)// rear (failsafe)

    // Sounds
    MaxPitchSpeed=350.0
    IdleSound=SoundGroup'DH_AlliedVehicleSounds.Jeep.jeep_engine_loop03'
    StartUpSound=Sound'DH_AlliedVehicleSounds.Jeep.jeep_engine_start'
    ShutDownSound=Sound'DH_AlliedVehicleSounds.Jeep.jeep_engine_stop'
    RumbleSound=Sound'DH_GerVehicleSounds2.Kubelwagen.kubelwagen_engine_interior'

    // Visual effects
    ExhaustPipes(0)=(ExhaustPosition=(X=-40.0,Y=50,Z=22.0),ExhaustRotation=(Pitch=-2048,Yaw=24000))
    SteerBoneName="Steer_Wheel"
    SteerBoneAxis=AXIS_Z

    // HUD
    VehicleHudImage=Texture'DH_Jeep_tex.HUD.jeep_body1'
    VehicleHudEngineY=0.28
    VehicleHudOccupantsX(0)=0.42
    VehicleHudOccupantsY(0)=0.57
    VehicleHudOccupantsX(1)=0.58
    VehicleHudOccupantsY(1)=0.57
    VehicleHudOccupantsX(2)=0.45
    VehicleHudOccupantsY(2)=0.76
    VehicleHudOccupantsX(3)=0.55
    VehicleHudOccupantsY(3)=0.76
    SpawnOverlay(0)=Material'DH_Jeep_tex.HUD.profile'

    // Attachments
    VehicleAttachments(0)=(StaticMesh=StaticMesh'DH_Jeep_stc.Roof.jeep_roof_down',AttachBone="Body")

    // Shadow
    ShadowZOffset=40

    // Camera
    TPCamLookat=(X=0.0,Y=0.0,Z=50.0)

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LFWheel
        SteerType=VST_Steered
        bPoweredWheel=true
        BoneName="wheel.L.F"
        BoneRollAxis=AXIS_Y
        WheelRadius=22
        SupportBoneName="suspension.L.F"
        SupportBoneAxis=AXIS_X
        bLeftTrack=true
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_WillysJeep.LFWheel'
    Begin Object Class=SVehicleWheel Name=RFWheel
        SteerType=VST_Steered
        bPoweredWheel=true
        BoneName="wheel.R.F"
        BoneRollAxis=AXIS_Y
        WheelRadius=22
        SupportBoneName="suspension.R.F"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_WillysJeep.RFWheel'
    Begin Object Class=SVehicleWheel Name=LRWheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="wheel.L.B"
        BoneRollAxis=AXIS_Y
        WheelRadius=22
        SupportBoneName="suspension.L.B"
        SupportBoneAxis=AXIS_X
        bLeftTrack=true
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_WillysJeep.LRWheel'
    Begin Object Class=SVehicleWheel Name=RRWheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="wheel.R.B"
        BoneRollAxis=AXIS_Y
        WheelRadius=22
        SupportBoneName="suspension.R.B"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_WillysJeep.RRWheel'

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.3
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=0.0,Y=0.0,Z=0.5) // default is zero
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

