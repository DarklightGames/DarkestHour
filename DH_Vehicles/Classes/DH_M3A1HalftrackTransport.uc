//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_M3A1HalftrackTransport extends DH_ROTransportCraft;

#exec OBJ LOAD FILE=..\Animations\DH_M3A1Halftrack_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex.utx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_allies_vehicles_stc.usx

simulated function SetupTreads()
{
    LeftTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));
    if (LeftTreadPanner != none)
    {
        LeftTreadPanner.Material = Skins[LeftTreadIndex];
        LeftTreadPanner.PanDirection = rot(0, 32768, -16384);
        LeftTreadPanner.PanRate = 0.0;
        Skins[LeftTreadIndex] = LeftTreadPanner;
    }
    RightTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));
    if (RightTreadPanner != none)
    {
        RightTreadPanner.Material = Skins[RightTreadIndex];
        RightTreadPanner.PanDirection = rot(0, 32768, -16384);
        RightTreadPanner.PanRate = 0.0;
        Skins[RightTreadIndex] = RightTreadPanner;
    }
}

static function StaticPrecache(LevelInfo L)
{
        super.StaticPrecache(L);

      L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.ext_vehicles.M3A1Halftrack_body_ext');
      L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.M3A1Halftrack_details_int');
      L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.M3A1Halftrack_seats_int');
      L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.treads.M3A1Halftrack_treads');
      L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.ext_vehicles.Green');
}

simulated function UpdatePrecacheMaterials()
{
        Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.ext_vehicles.M3A1Halftrack_body_ext');
        Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.M3A1Halftrack_details_int');
        Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.M3A1Halftrack_seats_int');
        Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.treads.M3A1Halftrack_treads');
        Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.ext_vehicles.Green');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    MaxPitchSpeed=350.000000
    TreadVelocityScale=80.000000
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L02'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_R02'
    RumbleSound=sound'Vehicle_Engines.interior.tank_inside_rumble03'
    LeftTrackSoundBone="steer_wheel_L_F"
    RightTrackSoundBone="steer_wheel_R_F"
    RumbleSoundBone="body"
    LeftTreadIndex=6
    RightTreadIndex=5
    MaxCriticalSpeed=729.000000
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
    WheelRotationScale=1600
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
    TransRatio=0.120000
    ChangeUpPoint=2000.000000
    ChangeDownPoint=1000.000000
    LSDFactor=1.000000
    EngineBrakeFactor=0.000100
    EngineBrakeRPMScale=0.100000
    MaxBrakeTorque=20.000000
    SteerSpeed=75.000000
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
    ExhaustPipes(0)=(ExhaustPosition=(X=-100.000000,Y=60.000000,Z=-10.000000),ExhaustRotation=(Pitch=36000,Yaw=-5000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_M3A1HalftrackGunPawn',WeaponBone="mg_base")
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
    DestructionLinearMomentum=(Min=100.000000,Max=350.000000)
    DestructionAngularMomentum=(Max=150.000000)
    DamagedEffectScale=0.750000
    DamagedEffectOffset=(Y=10.000000,Z=80.000000)
    VehicleTeam=1
    SteeringScaleFactor=4.000000
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_M3A1Halftrack_anm.M3A1Halftrack_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=5300,ViewPitchDownLimit=63500,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,ViewFOV=90.000000)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_M3A1Halftrack_anm.M3A1Halftrack_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="VUC_driver_idle_close",ViewPitchUpLimit=5300,ViewPitchDownLimit=61000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,ViewFOV=90.000000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_M3A1Halftrack_anm.M3A1Halftrack_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VUC_driver_idle_close",ViewPitchUpLimit=5300,ViewPitchDownLimit=61000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true,ViewFOV=90.000000)
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.M3A1Halftrack_body'
    VehicleHudOccupantsX(0)=0.450000
    VehicleHudOccupantsX(1)=0.550000
    VehicleHudOccupantsX(2)=0.450000
    VehicleHudOccupantsX(3)=0.450000
    VehicleHudOccupantsX(4)=0.450000
    VehicleHudOccupantsX(5)=0.550000
    VehicleHudOccupantsX(6)=0.550000
    VehicleHudOccupantsX(7)=0.550000
    VehicleHudOccupantsY(0)=0.450000
    VehicleHudOccupantsY(2)=0.600000
    VehicleHudOccupantsY(3)=0.700000
    VehicleHudOccupantsY(4)=0.800000
    VehicleHudOccupantsY(5)=0.600000
    VehicleHudOccupantsY(6)=0.700000
    VehicleHudOccupantsY(7)=0.800000
    VehicleHudEngineY=0.250000
    VehHitpoints(0)=(PointOffset=(X=2.000000,Z=19.000000),bPenetrationPoint=false)
    VehHitpoints(1)=(PointRadius=15.000000,PointBone="driver_player",PointOffset=(X=2.000000,Z=-2.000000),HitPointType=HP_Driver)
    VehHitpoints(2)=(PointRadius=35.000000,PointScale=1.000000,PointBone="Engine",PointOffset=(Z=-20.000000),DamageMultiplier=1.000000,HitPointType=HP_Engine)
    EngineHealth=125
    DriverAttachmentBone="driver_player"
    Begin Object Class=SVehicleWheel Name=RFWheel
        SteerType=VST_Steered
        BoneName="Wheel_F_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=29.000000
        SupportBoneName="Axle_F_R"
        SupportBoneAxis=AXIS_Z
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_M3A1HalftrackTransport.RFWheel'
    Begin Object Class=SVehicleWheel Name=LFWheel
        SteerType=VST_Steered
        BoneName="Wheel_F_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=29.000000
        SupportBoneName="Axle_F_L"
        SupportBoneAxis=AXIS_Z
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_M3A1HalftrackTransport.LFWheel'
    Begin Object Class=SVehicleWheel Name=FLeft_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_L_F"
        BoneRollAxis=AXIS_Z
        BoneOffset=(Y=-3.000000,Z=-12.000000)
        WheelRadius=31.000000
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_M3A1HalftrackTransport.FLeft_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=FRight_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_R_F"
        BoneRollAxis=AXIS_Z
        BoneOffset=(Y=-3.000000,Z=12.000000)
        WheelRadius=31.000000
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_M3A1HalftrackTransport.FRight_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=RLeft_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_L_F"
        BoneRollAxis=AXIS_Z
        BoneOffset=(X=-120.000000,Y=-3.000000,Z=-12.000000)
        WheelRadius=30.000000
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_M3A1HalftrackTransport.RLeft_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=RRight_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_R_F"
        BoneRollAxis=AXIS_Z
        BoneOffset=(X=-120.000000,Y=-3.000000,Z=12.000000)
        WheelRadius=30.000000
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_M3A1HalftrackTransport.RRight_Drive_Wheel'
    VehicleMass=8.500000
    DrivePos=(X=4.000000,Y=5.000000,Z=-10.000000)
    DriveAnim="VUC_driver_idle_close"
    ExitPositions(0)=(X=40.000000,Y=-165.000000,Z=125.000000)
    ExitPositions(1)=(X=40.000000,Y=165.000000,Z=125.000000)
    EntryRadius=375.000000
    FPCamPos=(Z=-60.000000)
    TPCamDistance=1000.000000
    CenterSpringForce="SpringONSSRV"
    TPCamLookat=(X=0.000000,Z=0.000000)
    TPCamWorldOffset=(Z=50.000000)
    DriverDamageMult=1.000000
    VehicleNameString="M3A1 Halftrack"
    MaxDesireability=1.500000
    HUDOverlayOffset=(X=-1.500000)
    HUDOverlayFOV=90.000000
    GroundSpeed=325.000000
    PitchUpLimit=500
    PitchDownLimit=49000
    HealthMax=325.000000
    Health=325
    Mesh=SkeletalMesh'DH_M3A1Halftrack_anm.M3A1Halftrack_body_ext'
    Skins(0)=texture'DH_VehiclesUS_tex.ext_vehicles.M3A1Halftrack_body_ext'
    Skins(1)=texture'DH_VehiclesUS_tex.int_vehicles.M3A1Halftrack_body_int'
    Skins(2)=texture'DH_VehiclesUS_tex.int_vehicles.M3A1Halftrack_seats_int'
    Skins(3)=texture'DH_VehiclesUS_tex.ext_vehicles.Green'
    Skins(4)=texture'DH_VehiclesUS_tex.int_vehicles.M3A1Halftrack_details_int'
    Skins(5)=texture'DH_VehiclesUS_tex.Treads.M3A1Halftrack_treads'
    Skins(6)=texture'DH_VehiclesUS_tex.Treads.M3A1Halftrack_treads'
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_M3A1HalftrackTransport.KParams0'
}
