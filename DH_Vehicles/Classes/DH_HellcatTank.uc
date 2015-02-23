//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_HellcatTank extends DH_ROTreadCraft;

#exec OBJ LOAD FILE=..\Animations\DH_Hellcat_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex5.utx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_allies_vehicles_stc3

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.ext_vehicles.hellcat_body_ext');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.ext_vehicles.hellcat_armor_ext');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.ext_vehicles.hellcat_turret_ext');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.int_vehicles.hellcat_body_int');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.treads.hellcat_treads');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.ext_vehicles.hellcat_body_ext');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.ext_vehicles.hellcat_armor_ext');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.ext_vehicles.hellcat_turret_ext');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.int_vehicles.hellcat_body_int');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex5.treads.hellcat_treads');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    bAllowRiders=false
    LeftTreadIndex=4
    RightTreadIndex=3
    MaxCriticalSpeed=1193.0
    TreadDamageThreshold=0.75
    UFrontArmorFactor=1.3
    URightArmorFactor=1.3
    ULeftArmorFactor=1.3
    URearArmorFactor=1.3
    UFrontArmorSlope=38.0
    URightArmorSlope=23.0
    ULeftArmorSlope=23.0
    URearArmorSlope=13.0
    PointValue=3.0
    MaxPitchSpeed=150.0
    TreadVelocityScale=110.0
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L03'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_R03'
    RumbleSound=sound'DH_AlliedVehicleSounds.Sherman.inside_rumble01'
    LeftTrackSoundBone="Track_L"
    RightTrackSoundBone="Track_R"
    RumbleSoundBone="driver_attachment"
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.M18_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.M18_turret_look'
    VehicleHudThreadsPosX(0)=0.36
    VehicleHudThreadsPosY=0.51
    VehicleHudThreadsScale=0.7
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
    WheelRotationScale=1100
    TreadHitMinAngle=1.6
    FrontLeftAngle=330.0
    FrontRightAngle=30.0
    RearRightAngle=150.0
    RearLeftAngle=210.0
    GearRatios(3)=0.62
    GearRatios(4)=0.85
    TransRatio=0.17
    SteerBoneName="Steering"
    LeftLeverBoneName="lever_L"
    LeftLeverAxis=AXIS_Z
    RightLeverBoneName="lever_R"
    RightLeverAxis=AXIS_Z
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-160.0,Y=65.0,Z=-10.0),ExhaustRotation=(Pitch=31000,Yaw=-16384))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_HellcatCannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_HellcatPassengerOne',WeaponBone="body")
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_HellcatPassengerTwo',WeaponBone="body")
    PassengerWeapons(3)=(WeaponPawnClass=class'DH_Vehicles.DH_HellcatPassengerThree',WeaponBone="body")
    PassengerWeapons(4)=(WeaponPawnClass=class'DH_Vehicles.DH_HellcatPassengerFour',WeaponBone="body")
    IdleSound=SoundGroup'Vehicle_Engines.SU76.SU76_engine_loop'
    StartUpSound=sound'Vehicle_Engines.SU76.SU76_engine_start'
    ShutDownSound=sound'Vehicle_Engines.SU76.SU76_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc3.Hellcat.Hellcat_dest'
    DamagedEffectOffset=(X=-140.0,Y=0.0,Z=35.0)
    VehicleTeam=1
    SteeringScaleFactor=0.75
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Hellcat_anm.hellcat_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,ViewFOV=90.0,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Hellcat_anm.hellcat_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="VPanzer3_driver_idle_open",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,ViewFOV=90.0)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Hellcat_anm.hellcat_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VPanzer3_driver_idle_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true,ViewFOV=90.0)
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.M18_body'
    VehicleHudOccupantsX(0)=0.43
    VehicleHudOccupantsY(0)=0.32
    VehicleHudOccupantsX(1)=0.5
    VehicleHudOccupantsY(1)=0.5
    VehicleHudOccupantsX(2)=0.375
    VehicleHudOccupantsY(2)=0.75
    VehicleHudOccupantsX(3)=0.45
    VehicleHudOccupantsY(3)=0.8
    VehicleHudOccupantsX(4)=0.55
    VehicleHudOccupantsY(4)=0.8
    VehicleHudOccupantsX(5)=0.625
    VehicleHudOccupantsY(5)=0.75
    VehicleHudEngineX=0.51
    VehHitpoints(0)=(PointRadius=10.0,PointOffset=(X=-5.0,Y=-5.0,Z=-5.0),bPenetrationPoint=false)
    VehHitpoints(1)=(PointRadius=40.0,PointOffset=(X=-100.0,Z=4.0),DamageMultiplier=1.0)
    VehHitpoints(2)=(PointRadius=25.0,PointScale=1.0,PointBone="body",PointOffset=(X=30.0,Y=-30.0,Z=4.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=25.0,PointScale=1.0,PointBone="body",PointOffset=(X=30.0,Y=30.0,Z=4.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DriverAttachmentBone="driver_attachment"
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=10.0,Z=10.0)
        WheelRadius=38.0
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_HellcatTank.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=10.0,Z=10.0)
        WheelRadius=38.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_HellcatTank.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-30.0,Z=10.0)
        WheelRadius=38.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_HellcatTank.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-30.0,Z=10.0)
        WheelRadius=38.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_HellcatTank.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.0)
        WheelRadius=38.0
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_HellcatTank.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.0)
        WheelRadius=38.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_HellcatTank.Right_Drive_Wheel'
    VehicleMass=11.0
    bFPNoZFromCameraPitch=true
    DrivePos=(X=12.0,Y=0.0,Z=-18.0)
    DriveAnim="VPanzer3_driver_idle_close"
    ExitPositions(0)=(X=107.0,Y=-41.0,Z=98.0)
    ExitPositions(1)=(X=-29.0,Y=-37.0,Z=164.0)
    ExitPositions(2)=(X=-125.0,Y=-158.0,Z=5.0)
    ExitPositions(3)=(X=-244.0,Y=-37.0,Z=5.0)
    ExitPositions(4)=(X=-241.0,Y=34.0,Z=5.0)
    ExitPositions(5)=(X=-125.0,Y=156.0,Z=5.0)
    EntryRadius=375.0
    FPCamPos=(X=120.0,Y=-21.0,Z=17.0)
    TPCamDistance=600.0
    TPCamLookat=(X=-50.0)
    TPCamWorldOffset=(Z=250.0)
    DriverDamageMult=1.0
    VehicleNameString="M18 Hellcat"
    MaxDesireability=1.9
    FlagBone="Mg_placement"
    FlagRotation=(Yaw=32768)
    HUDOverlayOffset=(X=5.0)
    HUDOverlayFOV=90.0
    PitchUpLimit=5000
    PitchDownLimit=60000
    HealthMax=500.0
    Health=500
    Mesh=SkeletalMesh'DH_Hellcat_anm.hellcat_body_ext'
    Skins(0)=texture'DH_VehiclesUS_tex5.ext_vehicles.hellcat_body_ext'
    Skins(1)=texture'DH_VehiclesUS_tex5.ext_vehicles.hellcat_armor_ext'
    Skins(2)=texture'DH_VehiclesUS_tex5.ext_vehicles.hellcat_turret_ext'
    Skins(3)=texture'DH_VehiclesUS_tex5.Treads.hellcat_treads'
    Skins(4)=texture'DH_VehiclesUS_tex5.Treads.hellcat_treads'
    Skins(5)=texture'DH_VehiclesUS_tex5.int_vehicles.hellcat_body_int'
    SoundRadius=800.0
    TransientSoundRadius=1500.0
    CollisionRadius=175.0
    CollisionHeight=60.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-1.0)
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=0.9
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_HellcatTank.KParams0'
    LeftTreadPanDirection=(Pitch=0,Yaw=32768,Roll=16384)
    RightTreadPanDirection=(Pitch=32768,Yaw=0,Roll=16384)
}
