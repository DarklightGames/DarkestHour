//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Fiat508CMTransport extends DHVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Fiat 508CM"
    VehicleTeam=0
    VehicleMass=2.0
    ReinforcementCost=1
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_Vehicle' // TODO: same as the GAZ (car)

    // Hull mesh
    Mesh=SkeletalMesh'DH_Fiat508CM_anm.fiat508cm_body'
    Skins(0)=Texture'DH_Fiat508CM_tex.fiat508.fiat508cm_tan'
    Skins(1)=Texture'DH_Fiat508CM_tex.fiat508.fiat508cm_gear_tan'
    Skins(2)=FinalBlend'DH_Fiat508CM_tex.fiat508.fiat508_windows_fb'

    BeginningIdleAnim="driver_hatch_idle_close" // TODO: there is no anim here soooo?

    // Passengers
    PassengerPawns(0)=(AttachBone="body",DrivePos=(Z=58),DriveRot=(Yaw=16384),InitialViewRotationOffset=(Yaw=-16384),DriveAnim="fiat508cm_passenger_01")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(Z=58),DriveRot=(Yaw=16384),InitialViewRotationOffset=(Yaw=-16384),DriveAnim="fiat508cm_passenger_02")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(Z=58),DriveRot=(Yaw=16384),InitialViewRotationOffset=(Yaw=-16384),DriveAnim="fiat508cm_passenger_03")

    // Driver
    bMultiPosition=false
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Fiat508CM_anm.fiat508cm_body',ViewPitchUpLimit=8000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=26000,ViewNegativeYawLimit=-24000,bExposed=true)
    InitialPositionIndex=0
    DrivePos=(Z=58)
    DriveRot=(Yaw=16384)
    DriverAttachmentBone="body"
    DriveAnim="fiat508cm_driver"

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
    SteerSpeed=64.0
    MaxSteerAngleCurve=(Points=((InVal=0.0,OutVal=32.0),(InVal=200.0,OutVal=24.0),(InVal=900.0,OutVal=8.0),(InVal=1000000000.0,OutVal=0.0)))
    MinBrakeFriction=2.0
    MaxBrakeTorque=10.0
    EngineBrakeFactor=0.0002
    bHasHandbrake=true
    HandbrakeThresh=100.0
    EngineRPMSoundRange=6000.0

    // Physics wheels properties
    WheelLongFrictionFunc=(Points=((InVal=0.0,OutVal=0.1),(InVal=100.0,OutVal=1.0),(InVal=400.0,OutVal=0.3),(InVal=800.0,OutVal=0.1),(InVal=10000000000.0,OutVal=0.0)))
    WheelLatSlipFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=30.0,OutVal=0.009),(InVal=45.0,OutVal=0.09),(InVal=10000000000.0,OutVal=0.9)))
    WheelLatFrictionScale=1.55
    WheelHandbrakeFriction=0.6
    WheelHandbrakeSlip=0.05
    WheelSuspensionTravel=5.0
    WheelSuspensionOffset=-2.0
    WheelSuspensionMaxRenderTravel=5.0

    // Damage
    Health=1500
    HealthMax=1500.0
    DamagedEffectHealthFireFactor=0.95
    EngineHealth=10
    DamagedWheelSpeedFactor=0.3
    VehHitpoints(0)=(PointRadius=25.0,PointBone="body",PointOffset=(X=58.0,Y=0.0,Z=42.0),DamageMultiplier=1.0,HitPointType=HP_Engine)
    EngineDamageFromGrenadeModifier=0.125
    DirectHEImpactDamageMult=10.0
    ImpactDamageMult=0.5
    ImpactWorldDamageMult=0.006
    DamagedEffectScale=0.8
    DamagedEffectOffset=(X=60.0,Y=0.0,Z=70.0)

    DestroyedVehicleMesh=StaticMesh'DH_Fiat508CM_stc.fiat508cm_destroyed'

    // Vehicle destruction
    ExplosionDamage=50.0
    ExplosionRadius=150.0
    ExplosionSoundRadius=200.0
    DestructionLinearMomentum=(Min=10.0,Max=50.0)
    DestructionAngularMomentum=(Min=10.0,Max=50.0)

    // Exit
    ExitPositions(0)=(X=-4.0,Y=90.0,Z=30.0)     // driver
    ExitPositions(1)=(X=-4.0,Y=-90.0,Z=30.0)    // front passenger
    ExitPositions(2)=(X=-53.0,Y=90.0,Z=30.0)    // rear passenger right
    ExitPositions(3)=(X=-53.0,Y=90.0,Z=30.0)    // rear passenger left
    ExitPositions(4)=(X=-163.00,Y=0.00,Z=30.00) // rear (failsafe)

    // Sounds
    MaxPitchSpeed=350.0
    IdleSound=Sound'DH_GerVehicleSounds2.Kubelwagen.kubelwagen_engine_loop01'
    StartUpSound=Sound'DH_GerVehicleSounds2.Kubelwagen.kubelwagen_engine_start'
    ShutDownSound=Sound'DH_GerVehicleSounds2.Kubelwagen.kubelwagen_engine_stop'
    RumbleSound=Sound'DH_GerVehicleSounds2.Kubelwagen.kubelwagen_engine_interior'

    // Visual effects
    ExhaustPipes(0)=(ExhaustPosition=(X=-106.231,Y=6.64981,Z=16.5879),ExhaustRotation=(Yaw=32768))
    SteerBoneName="STEERING_WHEEL"
    SteerBoneAxis=AXIS_Z

    // HUD
    VehicleHudImage=Texture'DH_Fiat508CM_tex.interface.fiat508cm_icon'
    VehicleHudEngineY=0.28
    VehicleHudOccupantsX(0)=0.56125
    VehicleHudOccupantsY(0)=0.51250
    VehicleHudOccupantsX(1)=0.43875
    VehicleHudOccupantsY(1)=0.51250
    VehicleHudOccupantsX(2)=0.56125
    VehicleHudOccupantsY(2)=0.675
    VehicleHudOccupantsX(3)=0.43875
    VehicleHudOccupantsY(3)=0.675
    SpawnOverlay(0)=Texture'DH_Fiat508CM_tex.fiat508cm_menu_icon'

    // Attachments
    VehicleAttachments(0)=(StaticMesh=StaticMesh'DH_Fiat508cm_stc.attachments.fiat508cm_radio',AttachBone="BODY")

    RandomAttachmentGroups(0)=(Options=((Probability=0.5,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_Fiat508CM_stc.attachments.fiat508cm_searchlight'))))
    RandomAttachmentGroups(1)=(Options=((Probability=0.5,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_Fiat508CM_stc.attachments.fiat508cm_tools'))))
    RandomAttachmentGroups(2)=(Options=((Probability=0.5,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_Fiat508CM_stc.attachments.fiat508cm_jerry_can'))))
    RandomAttachmentGroups(3)=(Options=((Probability=0.5,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_Fiat508CM_stc.attachments.fiat508cm_roof'))))
    RandomAttachmentGroups(4)=(Options=((Probability=0.5,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_Fiat508CM_stc.attachments.fiat508cm_windows'))))
    RandomAttachmentGroups(5)=(Options=((Probability=0.5,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_Fiat508CM_stc.attachments.fiat508cm_headlights')),(Probability=0.5,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_Fiat508CM_stc.attachments.fiat508cm_headlights_protected'))))

    RadioAttachmentClass=class'DH_Engine.DHRadio'
    RadioAttachmentHeight=16.0
    RadioAttachmentRadius=16.0
    RadioAttachmentSoundRadius=20.0
    RadioAttachmentBone="RADIO_ATTACHMENT"

    // Shadow
    ShadowZOffset=25

    // Camera
    TPCamLookat=(X=0.0,Y=0.0,Z=50.0)

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LFWheel
        SteerType=VST_Steered
        bPoweredWheel=true
        BoneName="WHEEL_F_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=22
        SupportBoneName="SUSPENSION_F_L"
        SupportBoneAxis=AXIS_X
        // bLeftTrack=true
    End Object
    Wheels(0)=LFWheel
    Begin Object Class=SVehicleWheel Name=RFWheel
        SteerType=VST_Steered
        bPoweredWheel=true
        BoneName="WHEEL_F_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=22
        SupportBoneName="SUSPENSION_F_R"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(1)=RFWheel
    Begin Object Class=SVehicleWheel Name=LRWheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="WHEEL_B_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=22
        SupportBoneName="SUSPENSION_B_L"
        SupportBoneAxis=AXIS_X
        // bLeftTrack=true
    End Object
    Wheels(2)=LRWheel
    Begin Object Class=SVehicleWheel Name=RRWheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="WHEEL_B_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=22
        SupportBoneName="SUSPENSION_B_R"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(3)=RRWheel

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.3
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=0.0,Y=0.0,Z=0.325)
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=false
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KParams0
}

