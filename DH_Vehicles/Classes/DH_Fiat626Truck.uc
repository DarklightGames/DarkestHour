//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// [ ] Engine Sounds (Napoleon)
// [ ] Add hitpoint for the supply cache on the support version
//==============================================================================

class DH_Fiat626Truck extends DHVehicle
    abstract;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Fiat 626"
    VehicleTeam=0
    VehicleMass=5.0
    ReinforcementCost=2
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_Vehicle'
    MapIconMaterial=Texture'DH_InterfaceArt2_tex.truck_topdown'

    // Hull mesh
    Mesh=SkeletalMesh'DH_Fiat626_anm.fiat626_body_ext'
    Skins(0)=Texture'DH_Fiat626_tex.fiat626.fiat626_exterior_green'
    Skins(1)=Texture'DH_Fiat626_tex.fiat626.fiat626_interior_green'
    Skins(2)=Texture'DH_Fiat626_tex.fiat626.fiat626_canvas'
    Skins(3)=FinalBlend'DH_Fiat626_tex.fiat626.fiat626_windows_fb'
    BeginningIdleAnim="" // override unwanted inherited value, as GMC has no animations

    // Passengers
    PassengerPawns(0)=(AttachBone="passenger_01",DriveAnim="fiat626_passenger_01",DrivePos=(Z=59.0),DriveRot=(Yaw=-16384))

    // Driver
    bMultiPosition=false
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Fiat626_anm.fiat626_body_ext',ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    InitialPositionIndex=0
    DrivePos=(X=0.0,Y=0.0,Z=59.0)
    DriveRot=(Yaw=-16384)
    DriveAnim="fiat626_driver"

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
    Health=1000
    HealthMax=1000
    DamagedEffectHealthFireFactor=0.9
    EngineHealth=20
    EngineDamageFromGrenadeModifier=0.15
    ImpactWorldDamageMult=1.0
    DirectHEImpactDamageMult=9.0

    VehHitpoints(0)=(PointRadius=32.0,PointBone="body",PointOffset=(X=126,Z=56),DamageMultiplier=1.0,HitPointType=HP_Engine)

    // Effects
    DamagedEffectOffset=(X=130.0,Y=0.0,Z=80.0)
    DamagedEffectScale=1.0
    DestroyedVehicleMesh=StaticMesh'DH_Fiat626_stc.Destroyed.fiat626_destroyed'

    // Vehicle destruction
    ExplosionDamage=50.0
    ExplosionRadius=100.0
    ExplosionSoundRadius=200.0
    DestructionLinearMomentum=(Min=50.0,Max=100.0)
    DestructionAngularMomentum=(Min=10.0,Max=50.0)

    // Exit
    ExitPositions(0)=(X=116.0,Y=128.0,Z=48.0)  // driver
    ExitPositions(1)=(X=116.0,Y=-128.0,Z=48.0) // front passenger
    ExitPositions(2)=(X=-240.0,Y=-28.0,Z=48.0) // rear left passengers
    ExitPositions(3)=(X=-240.0,Y=28.0,Z=48.0)  // rear right passengers

    // Sounds
    SoundPitch=32.0
    MaxPitchSpeed=10.0 //150.0
    IdleSound=SoundGroup'DH_alliedvehiclesounds.gmc.gmctruck_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_stop'
    RumbleSound=Sound'Vehicle_Engines.tank_inside_rumble01'
    RumbleSoundBone="body"

    // Visual effects
    ExhaustPipes(0)=(ExhaustPosition=(X=-163.2,y=50.3,Z=29.7),ExhaustRotation=(Yaw=16384))

    ShadowZOffset=40.0

    // Steering Wheel
    SteerBoneName="STEERING_WHEEL"
    SteerBoneAxis=AXIS_Z

    // HUD
    VehicleHudImage=Texture'DH_Fiat626_tex.interface.fiat626_body_icon'
    VehicleHudEngineY=0.25
    VehicleHudOccupantsX(0)=0.55
    VehicleHudOccupantsY(0)=0.25
    VehicleHudOccupantsX(1)=0.45
    VehicleHudOccupantsY(1)=0.25
    SpawnOverlay(0)=Material'DH_Fiat626_tex.interface.fiat626_profile_icon'

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=RFWheel
        SteerType=VST_Steered
        BoneName="WHEEL_F_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=28
        SupportBoneName="SUSPENSION_F_R"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_Fiat626Truck.RFWheel'

    Begin Object Class=SVehicleWheel Name=LFWheel
        SteerType=VST_Steered
        BoneName="WHEEL_F_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=28
        SupportBoneName="SUSPENSION_F_L"
        SupportBoneAxis=AXIS_X
        bLeftTrack=true
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_Fiat626Truck.LFWheel'

    Begin Object Class=SVehicleWheel Name=BRWheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="WHEEL_B_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=28
        SupportBoneName="SUSPENSION_B_R"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_Fiat626Truck.BRWheel'

    Begin Object Class=SVehicleWheel Name=BLWheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="WHEEL_B_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=28
        SupportBoneName="SUSPENSION_B_L"
        SupportBoneAxis=AXIS_X
        bLeftTrack=true
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_Fiat626Truck.BLWheel'

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=0.125,Y=0.0,Z=0.675)
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_Fiat626Truck.KParams0'
}
