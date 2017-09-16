//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_M3Halftrack extends DHVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_M3Halftrack_anm.ukx

defaultproperties
{
    ReinforcementCost=4
    bCanCrash=true
    bIsApc=true
    bHasTreads=true
    TreadHitMaxHeight=2.5
    VehicleHudTreadsPosX(0)=0.39
    VehicleHudTreadsPosX(1)=0.61
    VehicleHudTreadsPosY=0.68
    VehicleHudTreadsScale=0.34
    FrontRightAngle=108.0 // angles set specifically for tread hits
    RearRightAngle=168.0
    RearLeftAngle=191.5
    FrontLeftAngle=251.5
    PointValue=2.0
    FriendlyResetDistance=6000.0
    IdleTimeBeforeReset=300.0
    VehicleSpikeTime=60.0
    MaxPitchSpeed=350.0
    TreadVelocityScale=100.0
    WheelRotationScale=60000.0
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L02'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_R02'
    RumbleSound=sound'Vehicle_Engines.interior.tank_inside_rumble03'
    LeftTrackSoundBone="steer_wheel_L_F"
    RightTrackSoundBone="steer_wheel_R_F"
    RumbleSoundBone="body"
    LeftTreadIndex=2
    RightTreadIndex=3
    MaxCriticalSpeed=1077.0 // 64 kph
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
    Skins(0)=Texture'DH_M3Halftrack_tex.m3.Halftrack'
    Skins(1)=Texture'DH_M3Halftrack_tex.m3.Halftrack_2'
    Skins(2)=Texture'DH_M3Halftrack_tex.m3.Halfrack_tracks'
    Skins(3)=Texture'DH_M3Halftrack_tex.m3.Halfrack_tracks'
    WheelSoftness=0.025
    WheelPenScale=1.2
    WheelPenOffset=0.01
    WheelRestitution=0.1
    WheelInertia=0.1
    WheelLongFrictionFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=100.0,OutVal=1.0),(InVal=200.0,OutVal=0.2),(InVal=600.0,OutVal=0.001),(InVal=10000000000.0,OutVal=0.0)))
    WheelLongSlip=0.001
    WheelLongFrictionScale=1.1
    WheelLatSlipFunc=(Points=(,(InVal=30.0,OutVal=0.009),(InVal=45.0),(InVal=10000000000.0)))
    WheelLatFrictionScale=2.0
    WheelHandbrakeSlip=0.01
    WheelHandbrakeFriction=0.1
    WheelSuspensionTravel=10.0
    WheelSuspensionOffset=-5.0
    WheelSuspensionMaxRenderTravel=10.0
    FTScale=0.03
    ChassisTorqueScale=0.4
    MinBrakeFriction=4.0
    MaxSteerAngleCurve=(Points=((InVal=0.0,OutVal=48.0),(InVal=200.0,OutVal=35.0),(InVal=600.0,OutVal=6.0),(InVal=1000000000.0,OutVal=0.0)))
    TorqueCurve=(Points=((InVal=0.0,OutVal=18.0),(InVal=200.0,OutVal=12.0),(InVal=600.0,OutVal=9.0),(InVal=1200.0,OutVal=4.0),(InVal=2000.0,OutVal=0.5)))
    GearRatios(0)=-0.3
    GearRatios(1)=0.2
    GearRatios(2)=0.35
    GearRatios(3)=0.55
    GearRatios(4)=1.15
    TransRatio=0.12
    LSDFactor=1.0
    EngineBrakeFactor=0.0001
    EngineBrakeRPMScale=0.1
    MaxBrakeTorque=20.0
    SteerSpeed=65.0
    TurnDamping=35.0
    StopThreshold=100.0
    HandbrakeThresh=200.0
    EngineInertia=0.1
    IdleRPM=500.0
    EngineRPMSoundRange=5000.0
    SteerBoneName="steering_wheel"
    SteerBoneAxis=AXIS_Z
    RevMeterScale=4000.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-90.0,Y=50.0,Z=20.0),ExhaustRotation=(Pitch=36000,Yaw=-5000))
    IdleSound=SoundGroup'Vehicle_Engines.sdkfz251.sdkfz251_engine_loop'
    StartUpSound=sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_start'
    ShutDownSound=sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.M3A1Halftrack.M3A1Halftrack_dest'    // TODO: take out later
    DestructionEffectClass=class'ROEffects.ROVehicleDestroyedEmitter'
    DestructionLinearMomentum=(Min=100.0,Max=350.0)
    DestructionAngularMomentum=(Max=150.0)
    DamagedEffectScale=0.75
    DamagedEffectOffset=(X=120.0,Y=0.0,Z=60.0)
    VehicleTeam=1
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_M3Halftrack_anm.m3_body',TransitionUpAnim="overlay_out",ViewPitchUpLimit=5300,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_M3Halftrack_anm.m3_body',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="overlay_in",ViewPitchUpLimit=5300,ViewPitchDownLimit=61000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_M3Halftrack_anm.m3_body',TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=5300,ViewPitchDownLimit=61000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true)
    VehicleHudImage=texture'DH_M3Halftrack_tex.hud.m3a1_body'
    VehicleHudOccupantsX(0)=0.45
    VehicleHudOccupantsY(0)=0.45
    VehicleHudEngineY=0.25
    VehHitpoints(0)=(PointRadius=35.0) // engine
    DriverAttachmentBone="driver_player"
    Begin Object Class=SVehicleWheel Name=RFWheel
        SteerType=VST_Steered
        BoneName="wheel_R_1"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
        SupportBoneName="axle_F_R"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_M3Halftrack.RFWheel'
    Begin Object Class=SVehicleWheel Name=LFWheel
        SteerType=VST_Steered
        BoneName="wheel_L_1"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
        SupportBoneName="axle_F_L"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_M3Halftrack.LFWheel'
    Begin Object Class=SVehicleWheel Name=FLeft_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_L_F"
        BoneRollAxis=AXIS_Z
        WheelRadius=35.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_M3Halftrack.FLeft_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=FRight_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_R_F"
        BoneRollAxis=AXIS_Z
        WheelRadius=35.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_M3Halftrack.FRight_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=RLeft_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_L_R"
        BoneRollAxis=AXIS_Z
        WheelRadius=35.0
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_M3Halftrack.RLeft_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=RRight_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_R_R"
        BoneRollAxis=AXIS_Z
        WheelRadius=35.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_M3Halftrack.RRight_Drive_Wheel'
    VehicleMass=8.5
    DrivePos=(X=10.0,Y=-1.0,Z=4.0)
    DriveAnim="VUC_driver_idle_close"
    ExitPositions(0)=(X=-242.0,Y=0.0,Z=10.0)    // Back 1 Driver
    ExitPositions(1)=(X=-266.0,Y=28.0,Z=10.0)   // Back 2 MG
    ExitPositions(2)=(X=-266.0,Y=-35.0,Z=10.0)  // Back 3 Passenger 1
    ExitPositions(3)=(X=-242.0,Y=0.0,Z=10.0)    // Back 1 Passenger 2
    ExitPositions(4)=(X=-266.0,Y=-35.0,Z=10.0)  // Back 2 Passenger 3
    ExitPositions(5)=(X=-266.0,Y=28.0,Z=10.0)   // Back 3 Passenger 4
    ExitPositions(6)=(X=-242.0,Y=0.0,Z=10.0)    // Back 1 Passenger 5
    ExitPositions(7)=(X=-266.0,Y=28.0,Z=10.0)   // Back 2 Passenger 6
    ExitPositions(8)=(X=5.0,Y=-117.0,Z=10.0)    // Left Side Extra
    ExitPositions(9)=(X=9.0,Y=122.0,Z=10.0)     // Right Side Extra
    ExitPositions(10)=(X=-107.0,Y=-33.0,Z=116.0)// Top Extra
    CenterSpringForce="SpringONSSRV"
    VehicleNameString="M3A1 Halftrack"
    MaxDesireability=1.5
    GroundSpeed=325.0
    PitchUpLimit=500
    PitchDownLimit=49000
    ImpactDamageThreshold=15.0
    ImpactDamageMult=0.001
    ImpactWorldDamageMult=3.0
    EngineHealth=125
    CollisionAttachments(0)=(StaticMesh=StaticMesh'DH_M3Halftrack_stc.m3.m3_visor_collision',AttachBone="hatch") // collision attachment for driver's armoured visor
    CollisionRadius=10.0
    CollisionHeight=40.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=0.0) // default is zero
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
    LeftTreadPanDirection=(Pitch=0,Yaw=16384,Roll=0)
    RightTreadPanDirection=(Pitch=0,Yaw=16384,Roll=0)

    // Random attachment
    RandomAttachment=(AttachBone="body",bHasCollision=true)
    RandomAttachOptions(0)=(StaticMesh=StaticMesh'DH_M3Halftrack_stc.m3.m3_bumper_01',PercentChance=50)
    RandomAttachOptions(1)=(StaticMesh=StaticMesh'DH_M3Halftrack_stc.m3.m3_bumper_02',PercentChance=50)

    ShadowZOffset=32.0
}

