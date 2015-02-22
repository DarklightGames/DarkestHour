//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WolverineTank extends DH_ROTreadCraft;

#exec OBJ LOAD FILE=..\Animations\DH_Wolverine_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex.utx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex2.utx

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.ext_vehicles.M10_body_ext');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.treads.M10_treads');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.M10_body_int2');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.M10_body_int');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.ext_vehicles.M10_body_ext');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.treads.M10_treads');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.M10_body_int2');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex.int_vehicles.M10_body_int');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    bAllowRiders=false
    LeftTreadIndex=3
    MaxCriticalSpeed=766.000000
    TreadDamageThreshold=0.750000
    UFrontArmorFactor=3.800000
    URightArmorFactor=1.900000
    ULeftArmorFactor=1.900000
    URearArmorFactor=2.500000
    UFrontArmorSlope=55.000000
    URightArmorSlope=38.000000
    ULeftArmorSlope=38.000000
    PointValue=3.000000
    MaxPitchSpeed=150.000000
    TreadVelocityScale=228.000000
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L03'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_R03'
    RumbleSound=sound'DH_AlliedVehicleSounds.Sherman.inside_rumble01'
    LeftTrackSoundBone="Track_L"
    RightTrackSoundBone="Track_R"
    RumbleSoundBone="placeholder_int"
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Wolverine_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Wolverine_turret_look'
    VehicleHudThreadsPosX(0)=0.360000
    VehicleHudThreadsPosX(1)=0.640000
    VehicleHudThreadsPosY=0.510000
    VehicleHudThreadsScale=0.720000
    LeftWheelBones(0)="Wheel_L_1"
    LeftWheelBones(1)="Wheel_L_2"
    LeftWheelBones(2)="Wheel_L_3"
    LeftWheelBones(3)="Wheel_L_4"
    LeftWheelBones(4)="Wheel_L_5"
    LeftWheelBones(5)="Wheel_L_6"
    LeftWheelBones(6)="Wheel_L_7"
    LeftWheelBones(7)="Wheel_L_8"
    LeftWheelBones(8)="Wheel_L_9"
    LeftWheelBones(9)="Wheel_L_10"
    LeftWheelBones(10)="Wheel_L_11"
    RightWheelBones(0)="Wheel_R_1"
    RightWheelBones(1)="Wheel_R_2"
    RightWheelBones(2)="Wheel_R_3"
    RightWheelBones(3)="Wheel_R_4"
    RightWheelBones(4)="Wheel_R_5"
    RightWheelBones(5)="Wheel_R_6"
    RightWheelBones(6)="Wheel_R_7"
    RightWheelBones(7)="Wheel_R_8"
    RightWheelBones(8)="Wheel_R_9"
    RightWheelBones(9)="Wheel_R_10"
    RightWheelBones(10)="Wheel_R_11"
    WheelRotationScale=2000
    TreadHitMinAngle=1.300000
    FrontLeftAngle=332.000000
    RearLeftAngle=208.000000
    GearRatios(4)=0.750000
    TransRatio=0.100000
    SteerBoneName="Steering"
    LeftLeverBoneName="lever_L"
    LeftLeverAxis=AXIS_Z
    RightLeverBoneName="lever_R"
    RightLeverAxis=AXIS_Z
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-100.000000,Z=40.000000),ExhaustRotation=(Pitch=31000,Yaw=-16384))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_WolverineCannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_WolverinePassengerOne',WeaponBone="body")
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_WolverinePassengerTwo',WeaponBone="body")
    PassengerWeapons(3)=(WeaponPawnClass=class'DH_Vehicles.DH_WolverinePassengerThree',WeaponBone="body")
    PassengerWeapons(4)=(WeaponPawnClass=class'DH_Vehicles.DH_WolverinePassengerFour',WeaponBone="body")
    IdleSound=SoundGroup'Vehicle_Engines.SU76.SU76_engine_loop'
    StartUpSound=sound'Vehicle_Engines.SU76.SU76_engine_start'
    ShutDownSound=sound'Vehicle_Engines.SU76.SU76_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.M10.M10_Dest'
    DamagedEffectOffset=(X=-126.000000,Y=20.000000,Z=105.000000)
    VehicleTeam=1
    SteeringScaleFactor=0.750000
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Wolverine_anm.M10_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,ViewFOV=90.000000,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Wolverine_anm.M10_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="VPanzer3_driver_idle_open",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,ViewFOV=90.000000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Wolverine_anm.M10_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VPanzer3_driver_idle_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true,ViewFOV=90.000000)
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.wolverine_body'
    VehicleHudOccupantsX(0)=0.430000
    VehicleHudOccupantsY(0)=0.320000
    VehicleHudOccupantsX(1)=0.500000
    VehicleHudOccupantsY(1)=0.500000
    VehicleHudOccupantsX(2)=0.4
    VehicleHudOccupantsY(2)=0.75
    VehicleHudOccupantsX(3)=0.45
    VehicleHudOccupantsY(3)=0.825
    VehicleHudOccupantsX(4)=0.55
    VehicleHudOccupantsY(4)=0.825
    VehicleHudOccupantsX(5)=0.6
    VehicleHudOccupantsY(5)=0.75
    VehicleHudEngineX=0.510000
    VehHitpoints(0)=(PointOffset=(X=2.000000),bPenetrationPoint=false)
    VehHitpoints(1)=(PointRadius=35.000000,PointOffset=(X=-90.000000,Z=-35.000000),DamageMultiplier=1.000000)
    VehHitpoints(2)=(PointRadius=15.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=20.000000,Y=55.000000,Z=-8.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=15.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=20.000000,Y=-55.000000,Z=-8.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
    VehHitpoints(4)=(PointRadius=15.000000,PointScale=1.000000,PointBone="body",PointOffset=(Z=-8.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
    DriverAttachmentBone="driver_attachment"
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=10.000000,Z=10.000000)
        WheelRadius=33.000000
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_WolverineTank.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=10.000000,Z=10.000000)
        WheelRadius=33.000000
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_WolverineTank.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-30.000000,Z=10.000000)
        WheelRadius=33.000000
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_WolverineTank.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-30.000000,Z=10.000000)
        WheelRadius=33.000000
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_WolverineTank.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.000000)
        WheelRadius=33.000000
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_WolverineTank.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.000000)
        WheelRadius=33.000000
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_WolverineTank.Right_Drive_Wheel'
    VehicleMass=13.000000
    bFPNoZFromCameraPitch=true
    DrivePos=(X=-3.000000,Y=0.000000,Z=3.000000)
    DriveAnim="VPanzer3_driver_idle_close"
    ExitPositions(0)=(X=150.0,Y=-35.0,Z=175.0)  //driver
    ExitPositions(1)=(X=-20.0,Y=0.0,Z=250.0)    //commander
    ExitPositions(2)=(X=-125.0,Y=-150.0,Z=75.0) //passenger (l)
    ExitPositions(3)=(X=-250.0,Y=-35.0,Z=75.0)  //passenger (rl)
    ExitPositions(4)=(X=-250.0,Y=35.0,Z=75.0)   //passenger (rr)
    ExitPositions(5)=(X=-125.0,Y=150.0,Z=75.0)  //passenger (r)
    EntryRadius=375.000000
    FPCamPos=(X=120.000000,Y=-21.000000,Z=17.000000)
    TPCamDistance=600.000000
    TPCamLookat=(X=-50.000000)
    TPCamWorldOffset=(Z=250.000000)
    DriverDamageMult=1.000000
    VehicleNameString="M10 Wolverine"
    MaxDesireability=1.900000
    FlagBone="Mg_placement"
    FlagRotation=(Yaw=32768)
    HUDOverlayOffset=(X=5.000000)
    HUDOverlayFOV=90.000000
    PitchUpLimit=5000
    PitchDownLimit=60000
    HealthMax=500.000000
    Health=500
    Mesh=SkeletalMesh'DH_Wolverine_anm.M10_body_ext'
    Skins(0)=texture'DH_VehiclesUS_tex.ext_vehicles.M10_body_ext'
    Skins(2)=texture'DH_VehiclesUS_tex.Treads.M10_treads'
    Skins(3)=texture'DH_VehiclesUS_tex.Treads.M10_treads'
    SoundRadius=800.000000
    TransientSoundRadius=1500.000000
    CollisionRadius=175.000000
    CollisionHeight=60.000000
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.000000
        KInertiaTensor(3)=3.000000
        KInertiaTensor(5)=3.000000
        KCOMOffset=(Z=-0.900000)
        KLinearDamping=0.050000
        KAngularDamping=0.050000
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=0.900000
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.500000
        KImpactThreshold=700.000000
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_WolverineTank.KParams0'
    LeftTreadPanDirection=(Pitch=0,Yaw=32768,Roll=16384)
    RightTreadPanDirection=(Pitch=0,Yaw=32768,Roll=16384)
}
