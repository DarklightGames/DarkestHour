//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_GreyhoundArmoredCar extends DH_ArmoredWheeledVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_Greyhound_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex4.utx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_allies_vehicles_stc3.usx

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex4.ext_vehicles.Greyhound_body_ext');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex4.ext_vehicles.Greyhound_turret_ext');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex4.ext_vehicles.Greyhound_wheels');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex4.int_vehicles.Greyhound_body_int');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex4.ext_vehicles.Greyhound_body_ext');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex4.ext_vehicles.Greyhound_turret_ext');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex4.ext_vehicles.Greyhound_wheels');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex4.int_vehicles.Greyhound_body_int');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    bMustBeTankCommander=true
    MaxCriticalSpeed=1077.000000
    EngineHealthMax=100
    UFrontArmorFactor=1.600000
    URightArmorFactor=0.900000
    ULeftArmorFactor=0.900000
    URearArmorFactor=0.900000
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Greyhound_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Greyhound_turret_look'
    FrontLeftAngle=332.000000
    RearLeftAngle=208.000000
    WheelPenScale=1.200000
    WheelLatSlipFunc=(Points=(,(InVal=30.000000,OutVal=0.009000),(InVal=45.000000),(InVal=10000000000.000000)))
    WheelLongFrictionScale=1.100000
    WheelLatFrictionScale=1.550000
    WheelSuspensionTravel=10.000000
    WheelSuspensionMaxRenderTravel=5.000000
    ChassisTorqueScale=0.095000
    MaxSteerAngleCurve=(Points=((OutVal=20.000000),(InVal=500.000000,OutVal=20.000000),(InVal=600.000000,OutVal=15.000000),(InVal=1000000000.000000,OutVal=10.000000)))
    GearRatios(3)=0.600000
    GearRatios(4)=0.750000
    ChangeUpPoint=1990.000000
    ChangeDownPoint=1000.000000
    SteerSpeed=75.000000
    TurnDamping=100.000000
    SteerBoneName="Drive_wheel"
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-170.000000,Y=34.000000,Z=45.000000),ExhaustRotation=(Pitch=34000,Yaw=-5000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_GreyhoundCannonPawn',WeaponBone="Turret_placement")
    IdleSound=SoundGroup'Vehicle_Engines.sdkfz251.sdkfz251_engine_loop'
    StartUpSound=sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_start'
    ShutDownSound=sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc3.M8_Greyhound.M8_Destroyed'
    DisintegrationHealth=-100000.000000
    DamagedEffectScale=0.750000
    DamagedEffectOffset=(X=-130.000000,Y=0.000000,Z=100.000000)
    VehicleTeam=1
    SteeringScaleFactor=2.000000
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Greyhound_anm.Greyhound_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=2730,ViewPitchDownLimit=60065,ViewPositiveYawLimit=9500,ViewNegativeYawLimit=-9500,ViewFOV=90.000000)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Greyhound_anm.Greyhound_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="VBA64_driver_close",ViewPitchUpLimit=9500,ViewPitchDownLimit=60065,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,ViewFOV=90.000000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Greyhound_anm.Greyhound_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VBA64_driver_open",ViewPitchUpLimit=9500,ViewPitchDownLimit=62835,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true,ViewFOV=90.000000)
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.greyhound_body'
    VehicleHudOccupantsX(0)=0.450000
    VehicleHudOccupantsX(2)=0.550000
    VehicleHudOccupantsY(0)=0.350000
    VehicleHudOccupantsY(2)=0.350000
    VehicleHudEngineX=0.510000
    VehHitpoints(0)=(PointOffset=(X=4.000000),bPenetrationPoint=false)
    VehHitpoints(1)=(PointBone="Engine",PointOffset=(Z=-10.000000),DamageMultiplier=1.000000)
    EngineHealth=100
    bIsApc=true
    DriverAttachmentBone="driver_attachment"
    Begin Object Class=SVehicleWheel Name=RFWheel
        SteerType=VST_Steered
        BoneName="wheel_FR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=11.000000)
        SupportBoneName="axel_F_R"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_GreyhoundArmoredCar.RFWheel'
    Begin Object Class=SVehicleWheel Name=LFWheel
        SteerType=VST_Steered
        BoneName="wheel_FL"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-11.000000)
        SupportBoneName="axel_F_L"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_GreyhoundArmoredCar.LFWheel'
    Begin Object Class=SVehicleWheel Name=MRWheel
        bPoweredWheel=true
        BoneName="wheel_MR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=11.000000)
        SupportBoneName="axel_M_R"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_GreyhoundArmoredCar.MRWheel'
    Begin Object Class=SVehicleWheel Name=MLWheel
        bPoweredWheel=true
        BoneName="wheel_ML"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-11.000000)
        SupportBoneName="axel_M_L"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_GreyhoundArmoredCar.MLWheel'
    Begin Object Class=SVehicleWheel Name=RRWheel
        bPoweredWheel=true
        BoneName="wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=11.000000)
        SupportBoneName="axel_R_R"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_GreyhoundArmoredCar.RRWheel'
    Begin Object Class=SVehicleWheel Name=LRWheel
        bPoweredWheel=true
        BoneName="wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-11.000000)
        SupportBoneName="axel_R_L"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_GreyhoundArmoredCar.LRWheel'
    VehicleMass=5.000000
    bHasHandbrake=false
    DrivePos=(X=5.000000,Y=-2.000000,Z=5.000000)
    DriveAnim="VBA64_driver_idle_close"
    ExitPositions(0)=(Y=-200.000000,Z=100.000000)
    ExitPositions(1)=(Y=200.000000,Z=100.000000)
    ExitPositions(2)=(Y=-200.000000,Z=100.000000)
    ExitPositions(3)=(Y=200.000000,Z=100.000000)
    EntryRadius=375.000000
    FPCamPos=(X=42.000000,Y=-18.000000,Z=33.000000)
    DriverDamageMult=1.000000
    VehicleNameString="M8 Armored Car"
    MaxDesireability=0.100000
    HUDOverlayOffset=(X=2.000000)
    HUDOverlayFOV=90.000000
    PitchUpLimit=500
    PitchDownLimit=58000
    Mesh=SkeletalMesh'DH_Greyhound_anm.Greyhound_body_ext'
    Skins(0)=texture'DH_VehiclesUS_tex4.ext_vehicles.Greyhound_body_ext'
    Skins(1)=texture'DH_VehiclesUS_tex4.ext_vehicles.Greyhound_turret_ext'
    Skins(2)=texture'DH_VehiclesUS_tex4.ext_vehicles.Greyhound_wheels'
    SoundRadius=800.000000
    TransientSoundRadius=1500.000000
    CollisionRadius=175.000000
    CollisionHeight=60.000000
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.300000
        KInertiaTensor(3)=3.000000
        KInertiaTensor(5)=3.000000
        KCOMOffset=(X=0.300000,Z=-0.525000)
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_GreyhoundArmoredCar.KParams0'
    HighDetailOverlayIndex=1
}
