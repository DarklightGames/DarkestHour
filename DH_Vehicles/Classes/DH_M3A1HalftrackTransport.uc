//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_M3A1HalftrackTransport extends DHApcVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_M3A1Halftrack_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex.utx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_allies_vehicles_stc.usx

defaultproperties
{
    FriendlyResetDistance=6000.0
    IdleTimeBeforeReset=300.0
    MaxPitchSpeed=350.0
    TreadVelocityScale=400
    WheelRotationScale=3000
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L02'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_R02'
    RumbleSound=sound'Vehicle_Engines.interior.tank_inside_rumble03'
    LeftTrackSoundBone="steer_wheel_L_F"
    RightTrackSoundBone="steer_wheel_R_F"
    RumbleSoundBone="body"
    LeftTreadIndex=6
    RightTreadIndex=5
    MaxCriticalSpeed=680.0
    LeftWheelBones(0)="SRWL02"
    LeftWheelBones(1)="SRWL2"
    LeftWheelBones(2)="SRWL3"
    LeftWheelBones(3)="SRWL4"
    LeftWheelBones(4)="RWLF"
    LeftWheelBones(5)="RWRL"
    LeftWheelBones(6)="RL1"
    RightWheelBones(0)="SRWR1"
    RightWheelBones(1)="SRWR2"
    RightWheelBones(2)="SRWR3"
    RightWheelBones(3)="SRWR4"
    RightWheelBones(4)="RWFR"
    RightWheelBones(5)="RWRR"
    RightWheelBones(6)="RR1"
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
    MaxSteerAngleCurve=(Points=((OutVal=20.0),(InVal=1500.0,OutVal=10.0),(InVal=1000000000.0,OutVal=8.0)))
    TorqueCurve=(Points=((OutVal=10.0),(InVal=200.0,OutVal=1.0),(InVal=1500.0,OutVal=2.5),(InVal=2200.0)))
    GearRatios(0)=-0.25
    GearRatios(1)=0.2
    GearRatios(2)=0.35
    GearRatios(3)=0.5
    GearRatios(4)=0.69
    TransRatio=0.12
    ChangeUpPoint=2000.0
    ChangeDownPoint=1000.0
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
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-100.0,Y=60.0,Z=-10.0),ExhaustRotation=(Pitch=36000,Yaw=-5000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_M3A1HalftrackMGPawn',WeaponBone="mg_base")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_M3A1HalftrackPassengerOne',WeaponBone="passenger_l_1")
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_M3A1HalftrackPassengerTwo',WeaponBone="passenger_l_3")
    PassengerWeapons(3)=(WeaponPawnClass=class'DH_Vehicles.DH_M3A1HalftrackPassengerThree',WeaponBone="passenger_l_5")
    PassengerWeapons(4)=(WeaponPawnClass=class'DH_Vehicles.DH_M3A1HalftrackPassengerFour',WeaponBone="passenger_r_2")
    PassengerWeapons(5)=(WeaponPawnClass=class'DH_Vehicles.DH_M3A1HalftrackPassengerFive',WeaponBone="passenger_r_3")
    PassengerWeapons(6)=(WeaponPawnClass=class'DH_Vehicles.DH_M3A1HalftrackPassengerSix',WeaponBone="passenger_r_5")
    IdleSound=SoundGroup'Vehicle_Engines.sdkfz251.sdkfz251_engine_loop'
    StartUpSound=sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_start'
    ShutDownSound=sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.M3A1Halftrack.M3A1Halftrack_dest'
    DestructionLinearMomentum=(Min=100.0,Max=350.0)
    DestructionAngularMomentum=(Max=150.0)
    DamagedEffectScale=0.75
    DamagedEffectOffset=(Y=10.0,Z=80.0)
    VehicleTeam=1
    SteeringScaleFactor=4.0
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_M3A1Halftrack_anm.M3A1Halftrack_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=5300,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,bExposed=true,ViewFOV=90.0)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_M3A1Halftrack_anm.M3A1Halftrack_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",ViewPitchUpLimit=5300,ViewPitchDownLimit=61000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true,ViewFOV=90.0)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_M3A1Halftrack_anm.M3A1Halftrack_body_int',TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=5300,ViewPitchDownLimit=61000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true,ViewFOV=90.0)
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.M3A1Halftrack_body'
    VehicleHudOccupantsX(0)=0.45
    VehicleHudOccupantsX(1)=0.55
    VehicleHudOccupantsX(2)=0.45
    VehicleHudOccupantsX(3)=0.45
    VehicleHudOccupantsX(4)=0.45
    VehicleHudOccupantsX(5)=0.55
    VehicleHudOccupantsX(6)=0.55
    VehicleHudOccupantsX(7)=0.55
    VehicleHudOccupantsY(0)=0.45
    VehicleHudOccupantsY(2)=0.6
    VehicleHudOccupantsY(3)=0.7
    VehicleHudOccupantsY(4)=0.8
    VehicleHudOccupantsY(5)=0.6
    VehicleHudOccupantsY(6)=0.7
    VehicleHudOccupantsY(7)=0.8
    VehicleHudEngineY=0.25
    VehHitpoints(0)=(PointRadius=35.0,PointOffset=(Z=-20.0))
    EngineHealth=125
    DriverAttachmentBone="driver_player"

    Begin Object Class=SVehicleWheel Name=RFWheel
        SteerType=VST_Steered
        BoneName="Wheel_F_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=29.0
        SupportBoneName="Axle_F_R"
        SupportBoneAxis=AXIS_Z
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_M3A1HalftrackTransport.RFWheel'
    Begin Object Class=SVehicleWheel Name=LFWheel
        SteerType=VST_Steered
        BoneName="Wheel_F_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=29.0
        SupportBoneName="Axle_F_L"
        SupportBoneAxis=AXIS_Z
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_M3A1HalftrackTransport.LFWheel'
    Begin Object Class=SVehicleWheel Name=FLeft_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_L_F"
        BoneRollAxis=AXIS_Z
        BoneOffset=(Y=-3.0,Z=-12.0)
        WheelRadius=31.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_M3A1HalftrackTransport.FLeft_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=FRight_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_R_F"
        BoneRollAxis=AXIS_Z
        BoneOffset=(Y=-3.0,Z=12.0)
        WheelRadius=31.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_M3A1HalftrackTransport.FRight_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=RLeft_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_L_F"
        BoneRollAxis=AXIS_Z
        BoneOffset=(X=-120.0,Y=-3.0,Z=-12.0)
        WheelRadius=30.0
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_M3A1HalftrackTransport.RLeft_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=RRight_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_R_F"
        BoneRollAxis=AXIS_Z
        BoneOffset=(X=-120.0,Y=-3.0,Z=12.0)
        WheelRadius=30.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_M3A1HalftrackTransport.RRight_Drive_Wheel'

    VehicleMass=8.5
    DrivePos=(X=5.0,Y=3.0,Z=-5.0)
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
    EntryRadius=375.0
    CenterSpringForce="SpringONSSRV"
    DriverDamageMult=1.0
    VehicleNameString="M3A1 Halftrack"
    MaxDesireability=1.5
    GroundSpeed=325.0
    PitchUpLimit=500
    PitchDownLimit=49000
    HealthMax=325.0
    Health=325
    Mesh=SkeletalMesh'DH_M3A1Halftrack_anm.M3A1Halftrack_body_ext'
    Skins(0)=texture'DH_VehiclesUS_tex.ext_vehicles.M3A1Halftrack_body_ext'
    Skins(1)=texture'DH_VehiclesUS_tex.int_vehicles.M3A1Halftrack_body_int'
    Skins(2)=texture'DH_VehiclesUS_tex.int_vehicles.M3A1Halftrack_seats_int'
    Skins(3)=texture'DH_VehiclesUS_tex.ext_vehicles.Green'
    Skins(4)=texture'DH_VehiclesUS_tex.int_vehicles.M3A1Halftrack_details_int'
    Skins(5)=texture'DH_VehiclesUS_tex.Treads.M3A1Halftrack_treads'
    Skins(6)=texture'DH_VehiclesUS_tex.Treads.M3A1Halftrack_treads'
    CollisionRadius=175.0
    CollisionHeight=40.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-0.7)
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_M3A1HalftrackTransport.KParams0'
    LeftTreadPanDirection=(Pitch=0,Yaw=32768,Roll=-16384)
    RightTreadPanDirection=(Pitch=0,Yaw=32768,Roll=-16384)
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.m3a1_halftrack'
}
