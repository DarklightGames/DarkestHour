//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Sdkfz251Transport extends DH_ROTransportCraft;

#exec OBJ LOAD FILE=..\Animations\DH_Sdkfz251Halftrack_anm.ukx

defaultproperties
{
    FriendlyResetDistance=6000.0
    IdleTimeBeforeReset=300.0
    MaxPitchSpeed=350.0
    TreadVelocityScale=80.0
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L02'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_R02'
    RumbleSound=sound'Vehicle_Engines.interior.tank_inside_rumble03'
    LeftTrackSoundBone="steer_wheel_LF"
    RightTrackSoundBone="steer_wheel_RF"
    RumbleSoundBone="body"
    MaxCriticalSpeed=674.0
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
    WheelRotationScale=1600
    WheelSoftness=0.025
    WheelPenScale=1.2
    WheelPenOffset=0.01
    WheelRestitution=0.1
    WheelInertia=0.1
    WheelLongFrictionFunc=(Points=(,(InVal=100.0,OutVal=1.0),(InVal=200.0,OutVal=0.9),(InVal=10000000000.0,OutVal=0.9)))
    WheelLongSlip=0.001
    WheelLatSlipFunc=(Points=(,(InVal=30.0,OutVal=0.009),(InVal=45.0),(InVal=10000000000.0)))
    WheelLongFrictionScale=1.1
    WheelLatFrictionScale=1.35
    WheelHandbrakeSlip=0.01
    WheelHandbrakeFriction=0.1
    WheelSuspensionTravel=15.0
    WheelSuspensionMaxRenderTravel=15.0
    FTScale=0.03
    ChassisTorqueScale=0.4
    MinBrakeFriction=4.0
    MaxSteerAngleCurve=(Points=((OutVal=35.0),(InVal=1500.0,OutVal=20.0),(InVal=1000000000.0,OutVal=15.0)))
    TorqueCurve=(Points=((OutVal=10.0),(InVal=200.0,OutVal=1.0),(InVal=1500.0,OutVal=2.5),(InVal=2200.0)))
    GearRatios(0)=-0.2
    GearRatios(1)=0.2
    GearRatios(2)=0.35
    GearRatios(3)=0.55
    GearRatios(4)=0.75
    TransRatio=0.13
    ChangeUpPoint=2000.0
    ChangeDownPoint=1000.0
    LSDFactor=1.0
    EngineBrakeFactor=0.0001
    EngineBrakeRPMScale=0.1
    MaxBrakeTorque=20.0
    SteerSpeed=160.0
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
    ExhaustPipes(0)=(ExhaustPosition=(X=105.0,Y=-70.0,Z=-15.0),ExhaustRotation=(Pitch=36000,Yaw=5000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Sdkfz251GunPawn',WeaponBone="mg_base")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_Sdkfz251PassengerOne',WeaponBone="passenger_l_1")
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_Sdkfz251PassengerTwo',WeaponBone="passenger_l_2")
    PassengerWeapons(3)=(WeaponPawnClass=class'DH_Vehicles.DH_Sdkfz251PassengerThree',WeaponBone="passenger_l_3")
    PassengerWeapons(4)=(WeaponPawnClass=class'DH_Vehicles.DH_Sdkfz251PassengerFour',WeaponBone="passenger_r_1")
    PassengerWeapons(5)=(WeaponPawnClass=class'DH_Vehicles.DH_Sdkfz251PassengerFive',WeaponBone="passenger_r_2")
    PassengerWeapons(6)=(WeaponPawnClass=class'DH_Vehicles.DH_Sdkfz251PassengerSix',WeaponBone="passenger_r_3")
    IdleSound=SoundGroup'Vehicle_Engines.sdkfz251.sdkfz251_engine_loop'
    StartUpSound=sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_start'
    ShutDownSound=sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_stop'
    DestroyedVehicleMesh=StaticMesh'axis_vehicles_stc.Halftrack.Halftrack_Destoyed'
    DisintegrationHealth=-10000.0
    DestructionLinearMomentum=(Min=100.0,Max=350.0)
    DestructionAngularMomentum=(Max=150.0)
    DamagedEffectScale=0.75
    DamagedEffectOffset=(X=-40.0,Y=10.0,Z=10.0)
    SteeringScaleFactor=4.0
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Sdkfz251Halftrack_anm.halftrack_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewFOV=90.0,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Sdkfz251Halftrack_anm.halftrack_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="Vhalftrack_driver_idle",ViewPitchUpLimit=500,ViewPitchDownLimit=49000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,ViewFOV=90.0)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Sdkfz251Halftrack_anm.halftrack_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="Vhalftrack_driver_idle",ViewPitchUpLimit=500,ViewPitchDownLimit=49000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true,ViewFOV=90.0)
    VehicleHudImage=texture'InterfaceArt_tex.Tank_Hud.halftrack_body'
    VehicleHudOccupantsX(0)=0.45
    VehicleHudOccupantsX(2)=0.45
    VehicleHudOccupantsX(3)=0.45
    VehicleHudOccupantsX(4)=0.45
    VehicleHudOccupantsX(5)=0.55
    VehicleHudOccupantsX(6)=0.55
    VehicleHudOccupantsX(7)=0.55
    VehicleHudOccupantsY(0)=0.45
    VehicleHudOccupantsY(1)=0.525
    VehicleHudOccupantsY(2)=0.6
    VehicleHudOccupantsY(3)=0.7
    VehicleHudOccupantsY(4)=0.8
    VehicleHudOccupantsY(5)=0.6
    VehicleHudOccupantsY(6)=0.7
    VehicleHudOccupantsY(7)=0.8
    VehicleHudEngineY=0.25
    VehHitpoints(0)=(PointBone="Camera_driver",bPenetrationPoint=false)
    VehHitpoints(1)=(PointRadius=30.0,PointBone="Engine",PointOffset=(X=15.0,Z=-15.0),DamageMultiplier=1.0)
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

    EntryRadius=375.0
    TPCamDistance=1000.0
    CenterSpringForce="SpringONSSRV"
    TPCamLookat=(X=0.0,Z=0.0)
    TPCamWorldOffset=(Z=50.0)
    DriverDamageMult=1.0
    VehicleNameString="SdKfz-251 Halftrack"
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_Sdkfz251Transport.KParams0'
    HighDetailOverlay=Shader'axis_vehicles_tex.int_vehicles.halftrack_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3
    LeftTreadPanDirection=(Pitch=0,Yaw=0,Roll=16384)
    RightTreadPanDirection=(Pitch=0,Yaw=0,Roll=16384)
    bIsSpawnVehicle=true
}
