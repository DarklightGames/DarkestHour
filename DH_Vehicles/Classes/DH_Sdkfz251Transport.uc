//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_Sdkfz251Transport extends DHVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_Sdkfz251Halftrack_anm.ukx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_German_vehicles_stc.usx

defaultproperties
{
    bIsApc=true
    bHasTreads=true
    TreadHitMaxHeight=-5.0
    VehicleHudTreadsPosX(0)=0.4
    VehicleHudTreadsPosX(1)=0.6
    VehicleHudTreadsPosY=0.55
    VehicleHudTreadsScale=0.48
    FrontRightAngle=30.0 // angles set specifically for tread hits
    RearRightAngle=160.5
    RearLeftAngle=199.5
    FrontLeftAngle=330.0
    PointValue=2.0
    FriendlyResetDistance=6000.0
    IdleTimeBeforeReset=300.0
    VehicleSpikeTime=60.0
    MaxPitchSpeed=350.0
    TreadVelocityScale=80.0
    WheelRotationScale=32500.0
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L02'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_R02'
    RumbleSound=sound'Vehicle_Engines.interior.tank_inside_rumble03'
    LeftTrackSoundBone="steer_wheel_LF"
    RightTrackSoundBone="steer_wheel_RF"
    RumbleSoundBone="body"
    MaxCriticalSpeed=674.0 // 40 kph
    LeftTreadIndex=1
    RightTreadIndex=2
    LeftWheelBones(0)="Wheel_T_L_1"
    LeftWheelBones(1)="Wheel_T_L_2"
    LeftWheelBones(2)="Wheel_T_L_3"
    LeftWheelBones(3)="Wheel_T_L_4"
    LeftWheelBones(4)="Wheel_T_L_5"
    LeftWheelBones(5)="Wheel_T_L_6"
    LeftWheelBones(6)="Wheel_T_L_7"
    LeftWheelBones(7)="Wheel_T_L_8"
    RightWheelBones(0)="Wheel_T_R_1"
    RightWheelBones(1)="Wheel_T_R_2"
    RightWheelBones(2)="Wheel_T_R_3"
    RightWheelBones(3)="Wheel_T_R_4"
    RightWheelBones(4)="Wheel_T_R_5"
    RightWheelBones(5)="Wheel_T_R_6"
    RightWheelBones(6)="Wheel_T_R_7"
    RightWheelBones(7)="Wheel_T_R_8"
    WheelSoftness=0.025
    WheelPenScale=1.2
    WheelPenOffset=0.01
    WheelRestitution=0.1
    WheelInertia=0.1
    WheelLongFrictionFunc=(Points=(,(InVal=100.0,OutVal=1.0),(InVal=200.0,OutVal=0.9),(InVal=10000000000.0,OutVal=0.9)))
    WheelLongSlip=0.001
    WheelLatSlipFunc=(Points=(,(InVal=30.0,OutVal=0.009),(InVal=45.0),(InVal=10000000000.0)))
    WheelLongFrictionScale=1.1
    WheelLatFrictionScale=2.0
    WheelHandbrakeSlip=0.01
    WheelHandbrakeFriction=0.1
    WheelSuspensionTravel=15.0
    WheelSuspensionMaxRenderTravel=15.0
    FTScale=0.03
    ChassisTorqueScale=0.4
    MinBrakeFriction=4.0
    MaxSteerAngleCurve=(Points=((OutVal=35.0),(InVal=1500.0,OutVal=10.0),(InVal=1000000000.0,OutVal=15.0)))
    TorqueCurve=(Points=((OutVal=10.0),(InVal=200.0,OutVal=1.0),(InVal=1500.0,OutVal=2.5),(InVal=2200.0)))
    GearRatios(0)=-0.25
    GearRatios(1)=0.2
    GearRatios(2)=0.35
    GearRatios(3)=0.5
    GearRatios(4)=0.72
    TransRatio=0.12
    LSDFactor=1.0
    EngineBrakeFactor=0.0001
    EngineBrakeRPMScale=0.1
    MaxBrakeTorque=20.0
    SteerSpeed=50.0
    TurnDamping=35.0
    StopThreshold=100.0
    HandbrakeThresh=200.0
    EngineInertia=0.1
    IdleRPM=500.0
    EngineRPMSoundRange=5000.0
    SteerBoneName="Steering"
    RevMeterScale=4000.0
    ExhaustPipes(0)=(ExhaustPosition=(X=105.0,Y=-70.0,Z=-15.0),ExhaustRotation=(Pitch=36000,Yaw=5000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Sdkfz251MGPawn',WeaponBone="mg_base")
    PassengerPawns(0)=(AttachBone="passenger_l_1",DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(1)=(AttachBone="passenger_l_2",DriveAnim="VHalftrack_Rider2_idle")
    PassengerPawns(2)=(AttachBone="passenger_l_3",DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(3)=(AttachBone="passenger_r_1",DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(4)=(AttachBone="passenger_r_2",DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(5)=(AttachBone="passenger_r_3",DriveAnim="VHalftrack_Rider6_idle")
    IdleSound=SoundGroup'Vehicle_Engines.sdkfz251.sdkfz251_engine_loop'
    StartUpSound=sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_start'
    ShutDownSound=sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_stop'
    DestroyedVehicleMesh=StaticMesh'axis_vehicles_stc.Halftrack.Halftrack_Destoyed'
    DestructionEffectClass=class'ROEffects.ROVehicleDestroyedEmitter'
    DisintegrationHealth=-10000.0
    DestructionLinearMomentum=(Min=100.0,Max=350.0)
    DestructionAngularMomentum=(Max=150.0)
    DamagedEffectScale=0.75
    DamagedEffectOffset=(X=120.0,Y=00.0,Z=20.0)
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Sdkfz251Halftrack_anm.halftrack_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,bExposed=true,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Sdkfz251Halftrack_anm.halftrack_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",ViewPitchUpLimit=500,ViewPitchDownLimit=49000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Sdkfz251Halftrack_anm.halftrack_body_int',TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=500,ViewPitchDownLimit=49000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true)
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.sdkfz251_body'

    VehicleHudOccupantsX(0)=0.45
    VehicleHudOccupantsY(0)=0.4

    VehicleHudOccupantsX(1)=0.5
    VehicleHudOccupantsY(1)=0.5

    VehicleHudOccupantsX(2)=0.45
    VehicleHudOccupantsY(2)=0.6

    VehicleHudOccupantsX(3)=0.45
    VehicleHudOccupantsY(3)=0.7

    VehicleHudOccupantsX(4)=0.45
    VehicleHudOccupantsY(4)=0.8

    VehicleHudOccupantsX(5)=0.55
    VehicleHudOccupantsY(5)=0.6

    VehicleHudOccupantsX(6)=0.55
    VehicleHudOccupantsY(6)=0.7

    VehicleHudOccupantsX(7)=0.55
    VehicleHudOccupantsY(7)=0.8

    VehicleHudEngineY=0.3

    VehHitpoints(0)=(PointRadius=30.0,PointOffset=(X=15.0,Z=-15.0)) // engine
    EngineHealth=150
    DriverAttachmentBone="driver_player"
    Begin Object Class=SVehicleWheel Name=RFWheel
        SteerType=VST_Steered
        BoneName="Wheel_F_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=27.5
        SupportBoneName="Axle_LF"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_Sdkfz251Transport.RFWheel'
    Begin Object Class=SVehicleWheel Name=LFWheel
        SteerType=VST_Steered
        BoneName="Wheel_F_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=27.5
        SupportBoneName="Axle_RF"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_Sdkfz251Transport.LFWheel'
    Begin Object Class=SVehicleWheel Name=FLeft_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=7.0)
        WheelRadius=30.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_Sdkfz251Transport.FLeft_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=FRight_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=7.0)
        WheelRadius=30.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_Sdkfz251Transport.FRight_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=RLeft_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=-2.0)
        WheelRadius=30.0
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_Sdkfz251Transport.RLeft_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=RRight_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=-2.0)
        WheelRadius=30.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_Sdkfz251Transport.RRight_Drive_Wheel'
    VehicleMass=8.5
    DrivePos=(X=2.0,Y=2.0,Z=3.5)
    DriveAnim="Vhalftrack_driver_idle"

    ExitPositions(0)=(X=-240.0,Y=-30.0,Z=5.0)   // Back 1 Driver
    ExitPositions(1)=(X=-240.0,Y=30.0,Z=5.0)    // Back 2 MG
    ExitPositions(2)=(X=-285.0,Y=0.0,Z=5.0)     // Back 3 Passenger 1
    ExitPositions(3)=(X=-240.0,Y=-30.0,Z=5.0)   // Back 1 Passenger 2
    ExitPositions(4)=(X=-240.0,Y=30.0,Z=5.0)    // Back 2 Passenger 3
    ExitPositions(5)=(X=-285.0,Y=0.0,Z=5.0)     // Back 3 Passenger 4
    ExitPositions(6)=(X=-240.0,Y=-30.0,Z=5.0)   // Back 1 Passenger 5
    ExitPositions(7)=(X=-240.0,Y=30.0,Z=5.0)    // Back 2 Passenger 6
    ExitPositions(8)=(X=-35.0,Y=-125.0,Z=5.0)   // Left Side Extra
    ExitPositions(9)=(X=-35.0,Y=117.0,Z=5.0)    // Right Side Extra
    ExitPositions(10)=(X=-111.0,Y=36.0,Z=112.0) // Top Extra

    CenterSpringForce="SpringONSSRV"
    ImpactDamageMult=0.001
    VehicleNameString="Sd.Kfz.251 Halftrack"
    MaxDesireability=1.2
    HUDOverlayClass=class'ROVehicles.Sdkfz251DriverOverlay'
    HUDOverlayOffset=(Z=0.8)
    HUDOverlayFOV=100.0
    GroundSpeed=325.0
    PitchUpLimit=500
    PitchDownLimit=49000
    HealthMax=325.0
    Health=325
    Mesh=SkeletalMesh'DH_Sdkfz251Halftrack_anm.halftrack_body_ext'
    Skins(0)=texture'axis_vehicles_tex.ext_vehicles.halftrack_ext'
    Skins(1)=texture'axis_vehicles_tex.Treads.Halftrack_treads'
    Skins(2)=texture'axis_vehicles_tex.Treads.Halftrack_treads'
    Skins(3)=texture'axis_vehicles_tex.int_vehicles.halftrack_int'
    CollisionAttachments(0)=(StaticMesh=StaticMesh'DH_German_vehicles_stc.Halftrack.Halftrack_visor_Coll',AttachBone="driver_hatch") // collision attachment for driver's armoured visor
    CollisionRadius=175.0
    CollisionHeight=40.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-0.7) // default is zero (RO halftrack is zero, different to DH version)
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_Sdkfz251Transport.KParams0'
    HighDetailOverlay=shader'axis_vehicles_tex.int_vehicles.halftrack_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3
    LeftTreadPanDirection=(Pitch=0,Yaw=0,Roll=16384)
    RightTreadPanDirection=(Pitch=0,Yaw=0,Roll=16384)
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.hanomag'
}
