//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// [ ] finalize textures
// [ ] destroyed meshes
// [ ] set up the variants correctly
//==============================================================================

class DH_OpelBlitz extends DHVehicle
    abstract;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Opel Blitz"
    VehicleMass=3.35
    ReinforcementCost=2
    MaxDesireability=0.12
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.truck_topdown'

    ShadowZOffset=40.0

    // Hull mesh
    Mesh=SkeletalMesh'DH_OpelBlitz_anm.OpelBlitz_body_ext'
    // Skins(0)=Texture'DH_VehiclesGE_texmaterial2.ext_vehicles.OpelBlitz_body_ext'
    // Skins(1)=Texture'DH_VehiclesGE_tex2.ext_vehicles.OpelBlitz_body_ext'
    // Skins(2)=Texture'DH_VehiclesGE_tex2.int_vehicles.OpelBlitz_body_int'
    BeginningIdleAnim="idle"

    // Passengers
    PassengerPawns(0)=(AttachBone="BODY",DrivePos=(X=71.79,Y=24.04,Z=107.39),DriveAnim="opelblitz_passenger_f")

    // Driver
    DriverPositions(0)=(TransitionUpAnim="Overlay_In",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(1)=(TransitionDownAnim="Overlay_Out",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    InitialPositionIndex=0

    DriverAttachmentBone="BODY"
    DrivePos=(X=71.79,Y=-21.16,Z=107.39)
    DriveRot=(Yaw=0)
    DriveAnim="opelblitz_driver"

    // Engine/Transmission
    TorqueCurve=(Points=((InVal=0.0,OutVal=1.0),(InVal=500.0,OutVal=5.0),(InVal=600.0,OutVal=1.25),(InVal=1200.0,OutVal=1.0),(InVal=2500.0,OutVal=0)))
    GearRatios(0)=-0.3
    GearRatios(1)=0.4
    GearRatios(2)=0.6
    GearRatios(3)=0.8
    GearRatios(4)=1.0
    TransRatio=0.19
    ChangeUpPoint=2000
    ChangeDownPoint=1000.0
    EngineBrakeRPMScale=0.000001
    EngineBrakeFactor=0.000001
    EngineInertia=0.005 // Lowering this makes the vehicle not immediately stop once the gas is released.

    // Wheel Properties
    WheelSoftness=0.025000
    WheelPenScale=1.200000
    WheelPenOffset=0.010000
    WheelRestitution=0.100000
    WheelInertia=0.100000

    // Wheel Friction
    WheelLongFrictionFunc=(Points=((),(InVal=100.000000,OutVal=1.000000),(InVal=200.000000,OutVal=0.900000),(InVal=10000000000.000000,OutVal=0.900000)))
    WheelLongSlip=0.001000
    WheelLatSlipFunc=(Points=((),(InVal=30.000000,OutVal=0.009000),(InVal=45.000000),(InVal=10000000000.000000)))
    WheelLongFrictionScale=1.0
    WheelLatFrictionScale=1.0

    // Suspension
    WheelSuspensionTravel=8.0
    WheelSuspensionMaxRenderTravel=8.0
    WheelSuspensionOffset=-8.0

    FTScale=0.012500
    ChassisTorqueScale=0.25
    MaxSteerAngleCurve=(Points=((InVal=0.0,OutVal=45.0),(InVal=400.0,OutVal=20.0),(InVal=800.0,OutVal=8.0),(InVal=1000000000.0,OutVal=0.0)))
    SteerSpeed=50.0
    TurnDamping=25.0
    StopThreshold=100.000000
    LSDFactor=1.000000
    CenterSpringForce="SpringONSSRV"

    // Braking
    MaxBrakeTorque=25.0
    MinBrakeFriction=4.0

    //  Handbrake
    HandbrakeThresh=50.0
    bHasHandbrake=true
    WheelHandbrakeSlip=0.6
    WheelHandbrakeFriction=0.6

    // Damage
    Health=1500
    HealthMax=1500.0
    DamagedEffectHealthFireFactor=0.9
    EngineHealth=20
    VehHitpoints(0)=(PointRadius=32.0,PointBone="BODY",PointOffset=(X=109,Z=65),bPenetrationPoint=false,DamageMultiplier=1.0,HitPointType=HP_Engine)
    EngineDamageFromGrenadeModifier=0.15
    DirectHEImpactDamageMult=9.0
    ImpactWorldDamageMult=1.0
    DamagedEffectScale=0.8
    DamagedEffectOffset=(X=115.0,Y=0.0,Z=70.0)
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Trucks.OpelBlitz_dest'

    // Vehicle destruction
    ExplosionDamage=50.0
    ExplosionRadius=100.0
    ExplosionSoundRadius=200.0
    DestructionLinearMomentum=(Min=50.0,Max=100.0)
    DestructionAngularMomentum=(Min=10.0,Max=50.0)

    // Exit
    ExitPositions(0)=(X=45,Y=-100,Z=60)
    ExitPositions(1)=(X=45,Y=100,Z=60)

    // Sounds
    IdleSound=SoundGroup'Vehicle_Engines.BA64.ba64_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.BA64.BA64_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.BA64.BA64_engine_stop'

    // Visual effects
    ExhaustPipes(0)=(ExhaustPosition=(X=-172.7,Y=-37.0,Z=33.0),ExhaustRotation=(Pitch=36000,Yaw=5000))
    SteerBoneName="STEERING_WHEEL"
    SteerBoneAxis=AXIS_Y

    RandomAttachmentGroups(0)=(Options=((Probability=0.5,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_OpelBlitz_stc.OPELBLITZ_ATTACHMENT_LIGHTS_01')),(Probability=0.5,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_OpelBlitz_stc.OPELBLITZ_ATTACHMENT_LIGHTS_02'))))
    RandomAttachmentGroups(1)=(Options=((Probability=0.9,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_OpelBlitz_stc.OPELBLITZ_ATTACHMENT_TOOLS'))))
    RandomAttachmentGroups(2)=(Options=((Probability=0.8,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_OpelBlitz_stc.OPELBLITZ_ATTACHMENT_PLATE'))))

    // HUD
    VehicleHudImage=Texture'DH_OpelBlitz_tex.interface.opelblitz_body'
    VehicleHudEngineY=0.125
    VehicleHudOccupantsX(0)=0.45
    VehicleHudOccupantsY(0)=0.325
    VehicleHudOccupantsX(1)=0.55
    VehicleHudOccupantsY(1)=0.325
    SpawnOverlay(0)=Material'DH_OpelBlitz_tex.interface.opelblitz_profile'

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=RFWheel
        SteerType=VST_Steered
        BoneName="WHEEL_F_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=27.0
        SupportBoneName="SUSPENSION_F_R"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(0)=RFWheel
    Begin Object Class=SVehicleWheel Name=LFWheel
        SteerType=VST_Steered
        BoneName="WHEEL_F_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=27.0
        SupportBoneName="SUSPENSION_F_L"
        SupportBoneAxis=AXIS_X
        bLeftTrack=true
    End Object
    Wheels(1)=LFWheel
    Begin Object Class=SVehicleWheel Name=RRWheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="WHEEL_B_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=27.0
        SupportBoneName="SUSPENSION_B_R"
        SupportBoneAxis=AXIS_Z
    End Object
    Wheels(2)=RRWheel
    Begin Object Class=SVehicleWheel Name=LRWheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="WHEEL_B_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=27.0
        SupportBoneName="SUSPENSION_B_L"
        SupportBoneAxis=AXIS_Z
        bLeftTrack=true
    End Object
    Wheels(3)=LRWheel

    // Karma
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
        KCOMOffset=(Z=0.73)
    End Object
    KParams=KParams0
}
