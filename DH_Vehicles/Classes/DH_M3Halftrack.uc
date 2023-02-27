//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M3Halftrack extends DHArmoredVehicle
    abstract;

defaultproperties
{
    // Vehicle properties
    VehicleTeam=1
    bIsApc=true
    bHasTreads=true
    VehicleMass=8.5
    ReinforcementCost=3
    MaxDesireability=1.2
    MinRunOverSpeed=300
    PointValue=500
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_Vehicle'
    PrioritizeWeaponPawnEntryFromIndex=1
    bMustBeTankCommander=false
    UnbuttonedPositionIndex=0

    // Hull mesh
    Skins(0)=Texture'DH_M3Halftrack_tex.m3.Halftrack'
    Skins(1)=Texture'DH_M3Halftrack_tex.m3.Halftrack_2'
    Skins(2)=Texture'DH_M3Halftrack_tex.m3.Halfrack_tracks'
    Skins(3)=Texture'DH_M3Halftrack_tex.m3.Halfrack_tracks'
    CollisionAttachments(0)=(StaticMesh=StaticMesh'DH_M3Halftrack_stc.m3.m3_visor_collision',AttachBone="hatch") // collision attachment for driver's armoured visor
    BeginningIdleAnim="driver_hatch_idle_close"
    bUsesCodedDestroyedSkins=false

    // Driver
    DriverPositions(0)=(TransitionUpAnim="overlay_out",ViewPitchUpLimit=5300,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(1)=(TransitionUpAnim="driver_hatch_open",TransitionDownAnim="overlay_in",ViewPitchUpLimit=5300,ViewPitchDownLimit=61000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true)
    DriverPositions(2)=(TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=5300,ViewPitchDownLimit=61000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true)
    DriverAttachmentBone="driver_player"
    DrivePos=(X=10.0,Y=-1.0,Z=4.0)
    DriveAnim="VUC_driver_idle_close"

    // Movement
    MaxCriticalSpeed=838.22 // 50 kph
    GearRatios(0)=-0.3
    GearRatios(1)=0.3
    GearRatios(2)=0.5
    GearRatios(3)=0.7
    GearRatios(4)=0.9
    TorqueCurve=(Points=((InVal=0.0,OutVal=16.0),(InVal=200.0,OutVal=8.0),(InVal=600.0,OutVal=5.0),(InVal=1200.0,OutVal=2.0),(InVal=2000.0,OutVal=0.5)))
    SteerSpeed=85.0
    MaxSteerAngleCurve=(Points=((InVal=0.0,OutVal=64.0),(InVal=200.0,OutVal=32.0),(InVal=600.0,OutVal=5.0),(InVal=1000000000.0,OutVal=0.0)))
    ChangeUpPoint=2000.0
    ChangeDownPoint=1000.0
    ChassisTorqueScale=0.4
    bSpecialTankTurning=false
    TurnDamping=35.0

    // Physics wheels properties
    WheelLongFrictionScale=1.25
    WheelLongFrictionFunc=(Points=(,(InVal=100.0,OutVal=1.0),(InVal=200.0,OutVal=0.9),(InVal=10000000000.0,OutVal=0.9)))
    WheelLatSlipFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=30.0,OutVal=0.009),(InVal=45.0,OutVal=0.0),(InVal=10000000000.0,OutVal=0.0)))
    WheelLatFrictionScale=1.5
    WheelSuspensionTravel=10.0
    WheelSuspensionOffset=0.0
    WheelSuspensionMaxRenderTravel=10.0

    // Damage
    Health=500.0
    HealthMax=500.0
    DamagedEffectHealthFireFactor=0.2
    EngineHealth=150.0
    VehHitpoints(0)=(PointRadius=40.0,PointOffset=(X=125.0,Z=65.0)) // engine
    VehHitpoints(1)=(PointRadius=22.0,PointScale=1.0,PointBone="Wheel_R_1",DamageMultiplier=1.0,HitPointType=HP_Driver) // wheel
    VehHitpoints(2)=(PointRadius=22.0,PointScale=1.0,PointBone="Wheel_L_1",DamageMultiplier=1.0,HitPointType=HP_Driver) // wheel
    DamagedWheelSpeedFactor=0.4
    EngineDamageFromGrenadeModifier=0.05
    DirectHEImpactDamageMult=8.0
    ImpactWorldDamageMult=2.0
    TreadHitMaxHeight=64.0
    DamagedEffectScale=0.75
    DamagedEffectOffset=(X=120.0,Y=0.0,Z=60.0)
    DestructionEffectClass=class'ROEffects.ROVehicleDestroyedEmitter'
    DestructionEffectLowClass=class'ROEffects.ROVehicleDestroyedEmitter_simple'
    bEnableHatchFires=false

    // Vehicle destruction
    ExplosionDamage=85.0
    ExplosionRadius=150.0
    ExplosionSoundRadius=200.0
    DestructionLinearMomentum=(Min=50.0,Max=100.0)
    DestructionAngularMomentum=(Min=10.0,Max=50.0)

    FrontRightAngle=108.0 // angles set specifically for tread hits
    RearRightAngle=168.0
    RearLeftAngle=191.5
    FrontLeftAngle=251.5

    // Exit
    ExitPositions(0)=(X=-242.0,Y=0.0,Z=10.0)     // back 1 - driver
    ExitPositions(1)=(X=-266.0,Y=28.0,Z=10.0)    // back 2 - MG
    ExitPositions(2)=(X=-266.0,Y=-35.0,Z=10.0)   // back 3 - passenger 1
    ExitPositions(3)=(X=-242.0,Y=0.0,Z=10.0)     // back 1 - passenger 2
    ExitPositions(4)=(X=-266.0,Y=-35.0,Z=10.0)   // back 2 - passenger 3
    ExitPositions(5)=(X=-266.0,Y=28.0,Z=10.0)    // back 3 - passenger 4
    ExitPositions(6)=(X=-242.0,Y=0.0,Z=10.0)     // back 1 - passenger 5
    ExitPositions(7)=(X=-266.0,Y=28.0,Z=10.0)    // back 2 - passenger 6
    ExitPositions(8)=(X=5.0,Y=-117.0,Z=10.0)     // left side - extra
    ExitPositions(9)=(X=9.0,Y=122.0,Z=10.0)      // right side - extra
    ExitPositions(10)=(X=-107.0,Y=-33.0,Z=116.0) // top - extra

    // Sounds
    MaxPitchSpeed=350.0
    IdleSound=SoundGroup'Vehicle_Engines.sdkfz251.sdkfz251_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_stop'
    LeftTrackSoundBone="steer_wheel_L_F"
    LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L02'
    RightTrackSoundBone="steer_wheel_R_F"
    RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_R02'
    RumbleSound=Sound'Vehicle_Engines.interior.tank_inside_rumble03'

    // Visual effects
    LeftTreadIndex=2
    RightTreadIndex=3
    LeftTreadPanDirection=(Pitch=0,Yaw=16384,Roll=0)
    RightTreadPanDirection=(Pitch=0,Yaw=16384,Roll=0)
    TreadVelocityScale=100.0
    WheelRotationScale=60000.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-90.0,Y=50.0,Z=20.0),ExhaustRotation=(Pitch=36000,Yaw=-5000))
    SteerBoneName="steering_wheel"
    SteerBoneAxis=AXIS_Z
    RandomAttachment=(AttachBone="body",bHasCollision=true)
    RandomAttachOptions(0)=(StaticMesh=StaticMesh'DH_M3Halftrack_stc.m3.m3_bumper_01',PercentChance=50)
    RandomAttachOptions(1)=(StaticMesh=StaticMesh'DH_M3Halftrack_stc.m3.m3_bumper_02',PercentChance=50)
    ShadowZOffset=32.0

    // HUD
    VehicleHudImage=Texture'DH_M3Halftrack_tex.hud.m3a1_body'
    VehicleHudEngineY=0.25
    VehicleHudTreadsPosX(0)=0.39
    VehicleHudTreadsPosX(1)=0.61
    VehicleHudTreadsPosY=0.68
    VehicleHudTreadsScale=0.34
    VehicleHudOccupantsX(0)=0.45 // driver
    VehicleHudOccupantsY(0)=0.45

    // Visible wheels
    LeftWheelBones(0)="wheel_L_2"
    LeftWheelBones(1)="wheel_L_3"
    LeftWheelBones(2)="wheel_L_4"
    LeftWheelBones(3)="wheel_L_5"
    LeftWheelBones(4)="wheel_L_6"
    LeftWheelBones(5)="wheel_L_7"
    LeftWheelBones(6)="wheel_L_8"
    RightWheelBones(0)="wheel_R_2"
    RightWheelBones(1)="wheel_R_3"
    RightWheelBones(2)="wheel_R_4"
    RightWheelBones(3)="wheel_R_5"
    RightWheelBones(4)="wheel_R_6"
    RightWheelBones(5)="wheel_R_7"
    RightWheelBones(6)="wheel_R_8"

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=RFWheel
        SteerType=VST_Steered
        BoneName="wheel_R_1"
        BoneRollAxis=AXIS_Y
        WheelRadius=25.0
        SupportBoneName="axle_F_R"
        SupportBoneAxis=AXIS_X
        BoneOffset=(Y=22.0,Z=-5.0)
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_M3Halftrack.RFWheel'
    Begin Object Class=SVehicleWheel Name=LFWheel
        SteerType=VST_Steered
        BoneName="wheel_L_1"
        BoneRollAxis=AXIS_Y
        WheelRadius=25.0
        SupportBoneName="axle_F_L"
        SupportBoneAxis=AXIS_X
        BoneOffset=(Y=-22.0,Z=-5.0)
        bLeftTrack=true
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_M3Halftrack.LFWheel'
    Begin Object Class=SVehicleWheel Name=FLeft_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_L_F"
        BoneRollAxis=AXIS_Z
        WheelRadius=27.0
        BoneOffset=(Y=-10.0,X=15.0,Z=-5.0)
        bLeftTrack=true
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_M3Halftrack.FLeft_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=FRight_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_R_F"
        BoneRollAxis=AXIS_Z
        WheelRadius=27.0
        BoneOffset=(Y=10.0,X=15.0,Z=-5.0)
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_M3Halftrack.FRight_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=RLeft_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_L_R"
        BoneRollAxis=AXIS_Z
        WheelRadius=27.0
        BoneOffset=(Y=-10.0,X=-15.0,Z=-5.0)
        bLeftTrack=true
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_M3Halftrack.RLeft_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=RRight_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_R_R"
        BoneRollAxis=AXIS_Z
        WheelRadius=27.0
        BoneOffset=(Y=10.0,X=-15.0,Z=-5.0)
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_M3Halftrack.RRight_Drive_Wheel'

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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_M3Halftrack.KParams0'
}
