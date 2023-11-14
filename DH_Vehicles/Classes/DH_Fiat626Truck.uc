//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// [ ] Exit Positions
// [ ] Fix wheel bone origins
// [ ] move driver camera forward a little bit more
// [ ] figure out why passenger 1 is facing the wrong way
// [ ] Exhaust
// [ ] Hit points (engine etc.)
// [ ] Sounds
// [ ] Fire effect locations
// [ ] HUD
// [ ] Investigate wonky suspension
// [ ] Bullet collision mesh
// [ ] Destroyed mesh
// [ ] Passengers
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

    // Hull mesh
    Mesh=SkeletalMesh'DH_Fiat626_anm.fiat626_body_ext'
    //Skins(0)=Texture'DH_GMC_tex.GMC.GMC_USOD'
    //Skins(1)=Texture'DH_GMC_tex.GMC.GMC_Canvas'
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
    // TODO: these are just copypaste from the GMC
    TorqueCurve=(Points=((InVal=0.0,OutVal=15.0),(InVal=200.0,OutVal=10.0),(InVal=600.0,OutVal=8.0),(InVal=1200.0,OutVal=3.0),(InVal=2000.0,OutVal=0.5)))
    GearRatios(0)=-0.3
    GearRatios(1)=0.4  //0.2
    GearRatios(2)=0.65   //0.350000
    GearRatios(3)=0.85    //0.6
    GearRatios(4)=1.1    //0.98
    TransRatio=0.18
    ChangeUpPoint=1990.0
    ChangeDownPoint=1000.0

    // Vehicle properties
    WheelSoftness=0.025000
    WheelPenScale=1.200000
    WheelPenOffset=0.010000
    WheelRestitution=0.100000
    WheelInertia=0.100000
    WheelLongFrictionFunc=(Points=(,(InVal=100.000000,OutVal=1.000000),(InVal=200.000000,OutVal=0.900000),(InVal=10000000000.000000,OutVal=0.900000)))
    WheelLongSlip=0.001000
    WheelLatSlipFunc=(Points=(,(InVal=30.000000,OutVal=0.009000),(InVal=45.000000),(InVal=10000000000.000000)))
    WheelLongFrictionScale=1.100000
    WheelLatFrictionScale=1.55
    WheelHandbrakeSlip=0.010000
    WheelHandbrakeFriction=0.1
    WheelSuspensionTravel=2.0
    WheelSuspensionMaxRenderTravel=2.0
    WheelSuspensionOffset=-4.0
    FTScale=0.030000
    ChassisTorqueScale=0.095
    MinBrakeFriction=4.000000
    MaxSteerAngleCurve=(Points=((InVal=0.0,OutVal=45.0),(InVal=200.0,OutVal=35.0),(InVal=800.0,OutVal=6.0),(InVal=1000000000.0,OutVal=0.0)))
    SteerSpeed=70.0
    TurnDamping=25.0
    StopThreshold=100.000000
    HandbrakeThresh=100.0 //200.000000
    LSDFactor=1.000000
    CenterSpringForce="SpringONSSRV"

    //MaxSteerAngleCurve=(Points=((InVal=0.0,OutVal=45.0),(InVal=200.0,OutVal=35.0),(InVal=800.0,OutVal=6.0),(InVal=1000000000.0,OutVal=0.0)))
    MaxBrakeTorque=20.0 //10.0
    bHasHandbrake=true
    MaxCriticalSpeed=1077.0 // 64 kph

    // Physics wheels properties
    //WheelLongFrictionFunc=(Points=((InVal=0.0,OutVal=0.1),(InVal=100.0,OutVal=1.0),(InVal=200.0,OutVal=0.3),(InVal=400.0,OutVal=0.1),(InVal=10000000000.0,OutVal=0.0)))
    //WheelLatSlipFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=30.0,OutVal=0.009),(InVal=45.0,OutVal=0.09),(InVal=10000000000.0,OutVal=0.9)))
    //WheelLatFrictionScale=1.0

    // Damage
    Health=1500
    HealthMax=1500.0
    DamagedEffectHealthFireFactor=0.9
    EngineHealth=20

    // VehHitpoints(0)=(PointRadius=32.0,PointBone="Engine",bPenetrationPoint=false,DamageMultiplier=1.0,HitPointType=HP_Engine) // engine
    // VehHitpoints(1)=(PointRadius=24.0,PointBone="wheel.F.R",DamageMultiplier=1.0,HitPointType=HP_Driver) // wheel
    // VehHitpoints(2)=(PointRadius=24.0,PointBone="Wheel.F.L",DamageMultiplier=1.0,HitPointType=HP_Driver) // wheel
    // VehHitpoints(3)=(PointRadius=12.0,PointBone="Wheel.M.R",DamageMultiplier=1.0,HitPointType=HP_Driver) // reinforced wheel
    // VehHitpoints(4)=(PointRadius=12.0,PointBone="Wheel.M.L",DamageMultiplier=1.0,HitPointType=HP_Driver) // reinforced wheel
    // VehHitpoints(5)=(PointRadius=12.0,PointBone="Wheel.B.R",DamageMultiplier=1.0,HitPointType=HP_Driver) // reinforced wheel
    // VehHitpoints(6)=(PointRadius=12.0,PointBone="Wheel.B.L",DamageMultiplier=1.0,HitPointType=HP_Driver) // reinforced wheel
    
    EngineDamageFromGrenadeModifier=0.15
    ImpactWorldDamageMult=1.0
    DirectHEImpactDamageMult=9.0
    DamagedEffectOffset=(X=130.0,Y=0.0,Z=80.0)
    DamagedEffectScale=1.0
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Trucks.GMC_destroyed'    // TODO: replace

    // Vehicle destruction
    ExplosionDamage=50.0
    ExplosionRadius=100.0
    ExplosionSoundRadius=200.0
    DestructionLinearMomentum=(Min=50.0,Max=100.0)
    DestructionAngularMomentum=(Min=10.0,Max=50.0)

    // Exit
    ExitPositions(0)=(X=65.0,Y=137.0,Z=25.0)  // driver
    ExitPositions(1)=(X=57.0,Y=-132.0,Z=25.0) // front passenger

    // Sounds
    SoundPitch=32.0
    MaxPitchSpeed=10.0 //150.0
    IdleSound=SoundGroup'DH_alliedvehiclesounds.gmc.gmctruck_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_stop'
    RumbleSound=Sound'Vehicle_Engines.tank_inside_rumble01'
    RumbleSoundBone="body"

    // Visual effects
    ExhaustPipes(0)=(ExhaustPosition=(X=-163.2,y=50.3,Z=29.7),ExhaustRotation=(Yaw=-16384))

    ShadowZOffset=40.0

    // Steering Wheel
    SteerBoneName="STEERING_WHEEL"
    SteerBoneAxis=AXIS_Z

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
        KCOMOffset=(X=0.0,Y=0.0,Z=0.3)
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
