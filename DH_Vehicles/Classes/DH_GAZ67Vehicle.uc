//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_GAZ67Vehicle extends DHVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="GAZ-67"
    VehicleTeam=1
    VehicleMass=1.0
    ReinforcementCost=2

    // Hull mesh
    Mesh=SkeletalMesh'DH_GAZ67_anm.GAZ67_ext'
    Skins(0)=Texture'MilitaryAlliesSMT.Vehicles.RO_gaz67'
    Skins(1)=FinalBlend'DH_VehiclesSOV_tex.ext_vehicles.GAZ67_glass_finalblend'
    BeginningIdleAnim=""

    // Passengers
    PassengerPawns(0)=(AttachBone="Body",DrivePos=(X=-22.0,Y=24.0,Z=11.0),DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(1)=(AttachBone="Body",DrivePos=(X=-78.0,Y=-23.0,Z=22.0),DriveAnim="VHalftrack_Rider6_idle")
    PassengerPawns(2)=(AttachBone="Body",DrivePos=(X=-78.0,Y=23.0,Z=22.0),DriveAnim="VHalftrack_Rider2_idle")

    // Driver
    bMultiPosition=false
    DriverPositions(0)=(ViewPitchUpLimit=8000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=26000,ViewNegativeYawLimit=-24000,bExposed=true)
    InitialPositionIndex=0
    DriveAnim="Vhalftrack_driver_idle"

    // Movement
    GearRatios(0)=-0.3
    GearRatios(1)=0.3
    GearRatios(2)=0.5
    GearRatios(3)=0.8
    GearRatios(4)=1.25
    TransRatio=0.175
    TorqueCurve=(Points=((InVal=0.0,OutVal=10.0),(InVal=200.0,OutVal=7.0),(InVal=600.0,OutVal=4.0),(InVal=1200.0,OutVal=2.0),(InVal=2000.0,OutVal=1.0)))
    ChassisTorqueScale=0.1
    TurnDamping=5.0
    SteerSpeed=160.0
    MaxSteerAngleCurve=(Points=((InVal=0.0,OutVal=52.0),(InVal=200.0,OutVal=24.0),(InVal=900.0,OutVal=3.0),(InVal=1000000000.0,OutVal=0.0)))
    MinBrakeFriction=2.0
    MaxBrakeTorque=10.0
    EngineBrakeFactor=0.0002
    bHasHandbrake=true
    HandbrakeThresh=100.0
    EngineRPMSoundRange=6000.0

    // Physics wheels properties
    WheelLongFrictionFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=100.0,OutVal=1.0),(InVal=400.0,OutVal=0.2),(InVal=800.0,OutVal=0.001),(InVal=10000000000.0,OutVal=0.0)))
    WheelLatSlipFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=30.0,OutVal=0.009),(InVal=45.0,OutVal=0.09),(InVal=10000000000.0,OutVal=0.9)))
    WheelLatFrictionScale=1.55
    WheelHandbrakeFriction=0.33
    WheelSuspensionTravel=10.0
    WheelSuspensionMaxRenderTravel=5.0

    // Damage
    Health=125
    HealthMax=125.0
    VehHitpoints(0)=(PointRadius=20.0) // engine
    ImpactDamageMult=0.5
    ImpactWorldDamageMult=0.008
    HeavyEngineDamageThreshold=0.33
    DamagedEffectScale=0.8
    DamagedEffectOffset=(X=60.0,Y=0.0,Z=25.0)
    DestroyedVehicleMesh=StaticMesh'DH_Soviet_vehicles_stc.GAZ67.GAZ67_destroyed'
    DestructionLinearMomentum=(Min=50.0,Max=175.0)
    DestructionAngularMomentum=(Min=5.0,Max=15.0)

    // Exit
    ExitPositions(0)=(X=-15.0,Y=-95.0,Z=10.0) // driver
    ExitPositions(1)=(X=-15.0,Y=95.0,Z=10.0)  // front passenger
    ExitPositions(2)=(X=-15.0,Y=-95.0,Z=10.0) // rear passenger left
    ExitPositions(3)=(X=-15.0,Y=-95.0,Z=10.0) // rear passenger right

    // Sounds
    MaxPitchSpeed=350.0
    IdleSound=SoundGroup'DH_AlliedVehicleSounds.Jeep.jeep_engine_loop03'
    StartUpSound=Sound'DH_AlliedVehicleSounds.Jeep.jeep_engine_start'
    ShutDownSound=Sound'DH_AlliedVehicleSounds.Jeep.jeep_engine_stop'
    RumbleSound=Sound'DH_GerVehicleSounds2.Kubelwagen.kubelwagen_engine_interior'

    // Visual effects
    ExhaustPipes(0)=(ExhaustPosition=(X=-30.0,Y=40.0,Z=-28.0),ExhaustRotation=(Yaw=22000))
    SteerBoneName="Steering_wheel"

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.GAZ67_body'
    VehicleHudEngineY=0.29
    VehicleHudOccupantsX(0)=0.43
    VehicleHudOccupantsY(0)=0.53
    VehicleHudOccupantsX(1)=0.57
    VehicleHudOccupantsY(1)=0.53
    VehicleHudOccupantsX(2)=0.43
    VehicleHudOccupantsY(2)=0.7
    VehicleHudOccupantsX(3)=0.57
    VehicleHudOccupantsY(3)=0.7
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.GAZ67'

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=Wheel_FrontL
        SteerType=VST_Steered
        BoneName="Wheel_FL"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-7.4)
        WheelRadius=25.5
        SupportBoneName="Axle_FR" // means left side vertices are rotated around right axle bone - just makes axle move correctly with wheels, purely a visual thing
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_GAZ67Vehicle.Wheel_FrontL'
    Begin Object Class=SVehicleWheel Name=Wheel_FrontR
        SteerType=VST_Steered
        BoneName="Wheel_FR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=7.4)
        WheelRadius=25.5
        SupportBoneName="Axle_FL"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_GAZ67Vehicle.Wheel_FrontR'
    Begin Object Class=SVehicleWheel Name=Wheel_BackL
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="Wheel_BL"
        BoneRollAxis=AXIS_Y
        WheelRadius=25.5
        SupportBoneName="Axle_BR"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_GAZ67Vehicle.Wheel_BackL'
    Begin Object Class=SVehicleWheel Name=Wheel_BackR
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="Wheel_BR"
        BoneRollAxis=AXIS_Y
        WheelRadius=25.5
        SupportBoneName="Axle_BL"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_GAZ67Vehicle.Wheel_BackR'

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.3
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=0.0,Y=0.0,Z=-0.95) // default is zero
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_GAZ67Vehicle.KParams0'
}
