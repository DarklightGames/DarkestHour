//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ZiS5vTruck extends DHVehicle
    abstract;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="ZiS-5V"
    VehicleTeam=1
    VehicleMass=2.5
    ReinforcementCost=2
    MaxDesireability=0.12
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_Vehicle'

    // Hull mesh
    Mesh=SkeletalMesh'DH_ZiS5V_anm.ZiS5V_ext'
    Skins(0)=Texture'MilitaryAlliesSMT.Vehicles.Zis-5v'
    Skins(1)=FinalBlend'DH_VehiclesSOV_tex.ext_vehicles.ZiS5V_ForGlass_FB' // cab window glass
    Skins(2)=Texture'MilitaryAlliesSMT.Vehicles.Zis-5v' // rear bench seats (separate material slot so can be hidden in support truck to make room for supplies)
    BeginningIdleAnim="" // override unwanted inherited value as has no animations

    // Passengers (others are added in subclasses)
    PassengerPawns(0)=(AttachBone="Passenger_front",DriveAnim="VHalftrack_Rider1_idle")

    // Driver
    DriverPositions(0)=(ViewPitchUpLimit=4000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=20000,ViewNegativeYawLimit=-20000,bExposed=true)
    InitialPositionIndex=0
    DriveAnim="VUC_driver_idle_close"

    // Movement
    GearRatios(0)=-0.3
    GearRatios(4)=0.98
    TransRatio=0.198
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
    WheelSuspensionMaxRenderTravel=5.0

    // Damage
    Health=1500
    HealthMax=1500.0
    DamagedEffectHealthFireFactor=0.9
    EngineHealth=20
    VehHitpoints(0)=(PointRadius=32.0,PointScale=1.0,PointBone="Body",PointOffset=(X=100.0,Y=0.0,Z=11.0),bPenetrationPoint=false,DamageMultiplier=1.0,HitPointType=HP_Engine) // engine
    VehHitpoints(1)=(PointRadius=24.0,PointScale=1.0,PointBone="Axle_FR",DamageMultiplier=1.0,HitPointType=HP_Driver) // wheel
    VehHitpoints(2)=(PointRadius=24.0,PointScale=1.0,PointBone="Axle_FL",DamageMultiplier=1.0,HitPointType=HP_Driver) // wheel
    VehHitpoints(3)=(PointRadius=12.0,PointScale=1.0,PointBone="Wheel_BR",DamageMultiplier=1.0,HitPointType=HP_Driver) // reinforced wheel
    VehHitpoints(4)=(PointRadius=12.0,PointScale=1.0,PointBone="Wheel_BL",DamageMultiplier=1.0,HitPointType=HP_Driver) // reinforced wheel
    EngineDamageFromGrenadeModifier=0.15
    DirectHEImpactDamageMult=9.0
    ImpactWorldDamageMult=1.0
    DamagedEffectScale=0.7
    DamagedEffectOffset=(X=105.0,Y=0.0,Z=20.0)
    DestroyedVehicleMesh=StaticMesh'DH_Soviet_vehicles_stc.ZiS5.ZiS5V_destroyed'

    // Vehicle destruction
    ExplosionDamage=50.0
    ExplosionRadius=100.0
    ExplosionSoundRadius=200.0
    DestructionLinearMomentum=(Min=50.0,Max=100.0)
    DestructionAngularMomentum=(Min=10.0,Max=50.0)

    // Exit
    ExitPositions(0)=(X=40.0,Y=-100.0,Z=25.0) // driver
    ExitPositions(1)=(X=40.0,Y=100.0,Z=25.0)  // front passenger

    // Sounds
    IdleSound=SoundGroup'Vehicle_Engines.BA64.ba64_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.BA64.BA64_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.BA64.BA64_engine_stop'

    // Visual effects
    ExhaustPipes(0)=(ExhaustPosition=(X=0.0,Y=40.0,Z=-20.0),ExhaustRotation=(Pitch=-2000,Yaw=25000))
    SteerBoneName="Steering_wheel"

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.ZiS5V_body'
    VehicleHudEngineY=0.19
    VehicleHudOccupantsX(0)=0.44
    VehicleHudOccupantsY(0)=0.35
    VehicleHudOccupantsX(1)=0.55
    VehicleHudOccupantsY(1)=0.35
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.zis5v'

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=Wheel_FrontL
        SteerType=VST_Steered
        BoneName="Wheel_FL"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-6.4)
        WheelRadius=23.5
        SupportBoneName="Axle_FR" // means left side vertices are rotated around right axle bone - just makes axle move correctly with wheels, purely a visual thing
        SupportBoneAxis=AXIS_X
        bLeftTrack=true
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_ZiS5vTruck.Wheel_FrontL'
    Begin Object Class=SVehicleWheel Name=Wheel_FrontR
        SteerType=VST_Steered
        BoneName="Wheel_FR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=6.4)
        WheelRadius=23.5
        SupportBoneName="Axle_FL"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_ZiS5vTruck.Wheel_FrontR'
    Begin Object Class=SVehicleWheel Name=Wheel_BackL
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="Wheel_BL"
        BoneRollAxis=AXIS_Y
        WheelRadius=23.5
        SupportBoneName="Axle_BR"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_ZiS5vTruck.Wheel_BackL'
    Begin Object Class=SVehicleWheel Name=Wheel_BackR
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="Wheel_BR"
        BoneRollAxis=AXIS_Y
        WheelRadius=23.5
        SupportBoneName="Axle_BL"
        SupportBoneAxis=AXIS_X
        bLeftTrack=true
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_ZiS5vTruck.Wheel_BackR'

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.3
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=0.45,Y=0.0,Z=-0.9) // default is zero
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_ZiS5vTruck.KParams0'
}
