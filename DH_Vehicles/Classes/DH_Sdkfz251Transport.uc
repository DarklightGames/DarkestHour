//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Sdkfz251Transport extends DH_ROTransportCraft;

#exec OBJ LOAD FILE=..\Animations\DH_Sdkfz251Halftrack_anm.ukx

simulated function SetupTreads()
{
    LeftTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));
    if (LeftTreadPanner != none)
    {
        LeftTreadPanner.Material = Skins[LeftTreadIndex];
        LeftTreadPanner.PanDirection = rot(0, 0, 16384);
        LeftTreadPanner.PanRate = 0.0;
        Skins[LeftTreadIndex] = LeftTreadPanner;
    }
    RightTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));
    if (RightTreadPanner != none)
    {
        RightTreadPanner.Material = Skins[RightTreadIndex];
        RightTreadPanner.PanDirection = rot(0, 0, 16384);
        RightTreadPanner.PanRate = 0.0;
        Skins[RightTreadIndex] = RightTreadPanner;
    }
}

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'axis_vehicles_tex.ext_vehicles.halftrack_ext');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.Halftrack_treads');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.halftrack_int');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.halftrack_int_s');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.ext_vehicles.halftrack_ext');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.Halftrack_treads');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.halftrack_int');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.halftrack_int_s');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    MaxPitchSpeed=350.000000
    TreadVelocityScale=80.000000
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L02'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_R02'
    RumbleSound=sound'Vehicle_Engines.interior.tank_inside_rumble03'
    LeftTrackSoundBone="steer_wheel_LF"
    RightTrackSoundBone="steer_wheel_RF"
    RumbleSoundBone="body"
    MaxCriticalSpeed=674.000000
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
    EngineHealthMax=150
    WheelSoftness=0.025000
    WheelPenScale=1.200000
    WheelPenOffset=0.010000
    WheelRestitution=0.100000
    WheelInertia=0.100000
    WheelLongFrictionFunc=(Points=(,(InVal=100.000000,OutVal=1.000000),(InVal=200.000000,OutVal=0.900000),(InVal=10000000000.000000,OutVal=0.900000)))
    WheelLongSlip=0.001000
    WheelLatSlipFunc=(Points=(,(InVal=30.000000,OutVal=0.009000),(InVal=45.000000),(InVal=10000000000.000000)))
    WheelLongFrictionScale=1.100000
    WheelLatFrictionScale=1.350000
    WheelHandbrakeSlip=0.010000
    WheelHandbrakeFriction=0.100000
    WheelSuspensionTravel=15.000000
    WheelSuspensionMaxRenderTravel=15.000000
    FTScale=0.030000
    ChassisTorqueScale=0.400000
    MinBrakeFriction=4.000000
    MaxSteerAngleCurve=(Points=((OutVal=35.000000),(InVal=1500.000000,OutVal=20.000000),(InVal=1000000000.000000,OutVal=15.000000)))
    TorqueCurve=(Points=((OutVal=10.000000),(InVal=200.000000,OutVal=1.000000),(InVal=1500.000000,OutVal=2.500000),(InVal=2200.000000)))
    GearRatios(0)=-0.200000
    GearRatios(1)=0.200000
    GearRatios(2)=0.350000
    GearRatios(3)=0.550000
    GearRatios(4)=0.750000
    TransRatio=0.130000
    ChangeUpPoint=2000.000000
    ChangeDownPoint=1000.000000
    LSDFactor=1.000000
    EngineBrakeFactor=0.000100
    EngineBrakeRPMScale=0.100000
    MaxBrakeTorque=20.000000
    SteerSpeed=160.000000
    TurnDamping=35.000000
    StopThreshold=100.000000
    HandbrakeThresh=200.000000
    EngineInertia=0.100000
    IdleRPM=500.000000
    EngineRPMSoundRange=5000.000000
    SteerBoneName="Steering"
    RevMeterScale=4000.000000
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=105.000000,Y=-70.000000,Z=-15.000000),ExhaustRotation=(Pitch=36000,Yaw=5000))
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
    DisintegrationHealth=-10000.000000
    DestructionLinearMomentum=(Min=100.000000,Max=350.000000)
    DestructionAngularMomentum=(Max=150.000000)
    DamagedEffectScale=0.750000
    DamagedEffectOffset=(X=-40.000000,Y=10.000000,Z=10.000000)
    SteeringScaleFactor=4.000000
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Sdkfz251Halftrack_anm.halftrack_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewFOV=90.000000,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Sdkfz251Halftrack_anm.halftrack_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="Vhalftrack_driver_idle",ViewPitchUpLimit=500,ViewPitchDownLimit=49000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,ViewFOV=90.000000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Sdkfz251Halftrack_anm.halftrack_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="Vhalftrack_driver_idle",ViewPitchUpLimit=500,ViewPitchDownLimit=49000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true,ViewFOV=90.000000)
    VehicleHudImage=texture'InterfaceArt_tex.Tank_Hud.halftrack_body'
    VehicleHudOccupantsX(0)=0.450000
    VehicleHudOccupantsX(2)=0.450000
    VehicleHudOccupantsX(3)=0.450000
    VehicleHudOccupantsX(4)=0.450000
    VehicleHudOccupantsX(5)=0.550000
    VehicleHudOccupantsX(6)=0.550000
    VehicleHudOccupantsX(7)=0.550000
    VehicleHudOccupantsY(0)=0.450000
    VehicleHudOccupantsY(1)=0.525000
    VehicleHudOccupantsY(2)=0.600000
    VehicleHudOccupantsY(3)=0.700000
    VehicleHudOccupantsY(4)=0.800000
    VehicleHudOccupantsY(5)=0.600000
    VehicleHudOccupantsY(6)=0.700000
    VehicleHudOccupantsY(7)=0.800000
    VehicleHudEngineY=0.250000
    VehHitpoints(0)=(PointBone="Camera_driver",bPenetrationPoint=false)
    VehHitpoints(1)=(PointRadius=30.000000,PointBone="Engine",PointOffset=(X=15.000000,Z=-15.000000),DamageMultiplier=1.000000)
    EngineHealth=150
    DriverAttachmentBone="driver_player"
    Begin Object Class=SVehicleWheel Name=RFWheel
        SteerType=VST_Steered
        BoneName="Wheel_F_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=27.500000
        SupportBoneName="Axle_LF"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_Sdkfz251Transport.RFWheel'
    Begin Object Class=SVehicleWheel Name=LFWheel
        SteerType=VST_Steered
        BoneName="Wheel_F_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=27.500000
        SupportBoneName="Axle_RF"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_Sdkfz251Transport.LFWheel'
    Begin Object Class=SVehicleWheel Name=FLeft_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=7.000000)
        WheelRadius=30.000000
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_Sdkfz251Transport.FLeft_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=FRight_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=7.000000)
        WheelRadius=30.000000
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_Sdkfz251Transport.FRight_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=RLeft_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=-2.000000)
        WheelRadius=30.000000
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_Sdkfz251Transport.RLeft_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=RRight_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=-2.000000)
        WheelRadius=30.000000
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_Sdkfz251Transport.RRight_Drive_Wheel'
    VehicleMass=8.500000
    DriveAnim="Vhalftrack_driver_idle"
    ExitPositions(0)=(X=40.000000,Y=-165.000000,Z=100.000000)
    ExitPositions(1)=(X=40.000000,Y=165.000000,Z=100.000000)
    EntryRadius=375.000000
    TPCamDistance=1000.000000
    CenterSpringForce="SpringONSSRV"
    TPCamLookat=(X=0.000000,Z=0.000000)
    TPCamWorldOffset=(Z=50.000000)
    DriverDamageMult=1.000000
    VehicleNameString="SdKfz-251 Halftrack"
    MaxDesireability=1.200000
    HUDOverlayClass=class'ROVehicles.Sdkfz251DriverOverlay'
    HUDOverlayOffset=(Z=0.800000)
    HUDOverlayFOV=100.000000
    GroundSpeed=325.000000
    PitchUpLimit=500
    PitchDownLimit=49000
    HealthMax=325.000000
    Health=325
    Mesh=SkeletalMesh'DH_Sdkfz251Halftrack_anm.halftrack_body_ext'
    Skins(0)=texture'axis_vehicles_tex.ext_vehicles.halftrack_ext'
    Skins(1)=texture'axis_vehicles_tex.Treads.Halftrack_treads'
    Skins(2)=texture'axis_vehicles_tex.Treads.Halftrack_treads'
    Skins(3)=texture'axis_vehicles_tex.int_vehicles.halftrack_int'
    CollisionRadius=175.000000
    CollisionHeight=40.000000
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.000000
        KInertiaTensor(3)=3.000000
        KInertiaTensor(5)=3.000000
        KCOMOffset=(Z=-0.700000)
        KLinearDamping=0.050000
        KAngularDamping=0.050000
        KStartEnabled=true
        bKNonSphericalInertia=true
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.500000
        KImpactThreshold=700.000000
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_Sdkfz251Transport.KParams0'
    HighDetailOverlay=Shader'axis_vehicles_tex.int_vehicles.halftrack_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3
}
