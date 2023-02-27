//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_OpelBlitz extends DHVehicle
    abstract;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Opel Blitz"
    VehicleMass=3.0
    ReinforcementCost=2
    MaxDesireability=0.12
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_Vehicle'

    // Hull mesh
    Mesh=SkeletalMesh'DH_OpelBlitz_anm.OpelBlitz_body_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.OpelBlitz_body_ext'
    Skins(1)=Texture'DH_VehiclesGE_tex2.ext_vehicles.OpelBlitz_body_ext'
    Skins(2)=Texture'DH_VehiclesGE_tex2.int_vehicles.OpelBlitz_body_int'
    BeginningIdleAnim="Overlay_Idle"

    // Passengers
    PassengerPawns(0)=(AttachBone="passenger1",DrivePos=(X=2.0,Y=0.0,Z=-6.0),DriveAnim="VHalftrack_Rider1_idle")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_OpelBlitz_anm.OpelBlitz_body_int',TransitionUpAnim="Overlay_In",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_OpelBlitz_anm.OpelBlitz_body_int',TransitionDownAnim="Overlay_Out",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    InitialPositionIndex=0
    DriverAttachmentBone="driver_player"
    DrivePos=(X=13.0,Y=-1.0,Z=-5.0)
    DriveAnim="VUC_driver_idle_close"

    // Movement
    GearRatios(0)=-0.3
    GearRatios(4)=0.98
    TransRatio=0.18
    TorqueCurve=(Points=((InVal=0.0,OutVal=15.0),(InVal=200.0,OutVal=10.0),(InVal=600.0,OutVal=8.0),(InVal=1200.0,OutVal=3.0),(InVal=2000.0,OutVal=0.5)))
    ChangeUpPoint=1990.0
    TurnDamping=25.0
    SteerSpeed=70.0
    MaxSteerAngleCurve=(Points=((InVal=0.0,OutVal=45.0),(InVal=200.0,OutVal=35.0),(InVal=800.0,OutVal=6.0),(InVal=1000000000.0,OutVal=0.0)))
    MinBrakeFriction=3.0
    MaxBrakeTorque=10.0
    bHasHandbrake=true
    HandbrakeThresh=100.0
    MaxCriticalSpeed=1077.0 // 64 kph

    // Physics wheels properties
    WheelLongFrictionFunc=(Points=((InVal=0.0,OutVal=0.1),(InVal=100.0,OutVal=1.0),(InVal=200.0,OutVal=0.3),(InVal=400.0,OutVal=0.1),(InVal=10000000000.0,OutVal=0.0)))
    WheelLatSlipFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=30.0,OutVal=0.009),(InVal=45.0,OutVal=0.09),(InVal=10000000000.0,OutVal=0.9)))
    WheelLatFrictionScale=2.0
    WheelHandbrakeSlip=0.1
    WheelSuspensionMaxRenderTravel=4.5

    // Damage
    Health=1500
    HealthMax=1500.0
    DamagedEffectHealthFireFactor=0.9
    EngineHealth=20
    VehHitpoints(0)=(PointRadius=32.0,PointScale=1.0,PointBone="Engine",PointOffset=(X=16.0,Y=0.0,Z=0.0),bPenetrationPoint=false,DamageMultiplier=1.0,HitPointType=HP_Engine) // engine
    VehHitpoints(1)=(PointRadius=24.0,PointScale=1.0,PointBone="Wheel_FR",DamageMultiplier=1.0,HitPointType=HP_Driver) // wheel
    VehHitpoints(2)=(PointRadius=24.0,PointScale=1.0,PointBone="Wheel_FL",DamageMultiplier=1.0,HitPointType=HP_Driver) // wheel
    VehHitpoints(3)=(PointRadius=24.0,PointScale=1.0,PointBone="Wheel_RR",DamageMultiplier=1.0,HitPointType=HP_Driver) // wheel
    VehHitpoints(4)=(PointRadius=24.0,PointScale=1.0,PointBone="Wheel_LR",DamageMultiplier=1.0,HitPointType=HP_Driver) // wheel
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
    ExitPositions(0)=(X=70.0,Y=-130.0,Z=60.0) // driver
    ExitPositions(1)=(X=70.0,Y=130.0,Z=60.0)  // front passenger

    // Sounds
    IdleSound=SoundGroup'Vehicle_Engines.BA64.ba64_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.BA64.BA64_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.BA64.BA64_engine_stop'

    // Visual effects
    ExhaustPipes(0)=(ExhaustPosition=(X=-30.0,Y=180.0,Z=-50.0),ExhaustRotation=(Pitch=36000,Yaw=5000))
    SteerBoneName="WheelDrive"

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.opelblitz_body'
    VehicleHudEngineY=0.25
    VehicleHudOccupantsX(0)=0.45
    VehicleHudOccupantsY(0)=0.35
    VehicleHudOccupantsX(1)=0.55
    VehicleHudOccupantsY(1)=0.35
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.opelblitz'

    // Physics wheels
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
        bLeftTrack=true
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
        bLeftTrack=true
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_OpelBlitz.LRWheel'

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
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_OpelBlitz.KParams0'
}
