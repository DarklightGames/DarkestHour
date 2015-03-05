//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_HetzerDestroyer extends DH_ROTreadCraft;

#exec OBJ LOAD FILE=..\Animations\DH_Hetzer_anm_V1.ukx
#exec OBJ LOAD FILE=..\Textures\DH_Hetzer_tex_V1.utx
#exec OBJ LOAD FILE=..\Textures\axis_vehicles_tex.utx // for the treads
#exec OBJ LOAD FILE=..\Textures\VegetationSMT.utx     // for the bushes added as extra camo
#exec OBJ LOAD FILE=..\StaticMeshes\DH_Hetzer_stc_V1.usx

static function StaticPrecache(LevelInfo L)
{
    super(ROTreadCraft).StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.hetzer_body');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.Stug3_treads');
    L.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.hetzer_int');
    L.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.Hetzer_driver_glass');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.Alpha');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.hetzer_body');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.Stug3_treads');
    Level.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.hetzer_int');
    Level.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.Hetzer_driver_glass');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.Alpha');

    super(ROTreadCraft).UpdatePrecacheMaterials();
}

defaultproperties
{
    NewVehHitpoints(0)=(PointRadius=3.2,PointScale=1.0,PointBone="body",PointOffset=(X=29.2,Y=-9.04,Z=58.0),NewHitPointType=NHP_GunOptics)
    NewVehHitpoints(1)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=40.8,Y=16.0,Z=32.0),NewHitPointType=NHP_Traverse)
    NewVehHitpoints(2)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=40.8,Y=16.0,Z=32.0),NewHitPointType=NHP_GunPitch)
    MaxCriticalSpeed=730.0
    PeriscopeOverlay=texture'DH_VehicleOptics_tex.German.PERISCOPE_overlay_German'
    UFrontArmorFactor=6.0
    URightArmorFactor=2.0
    ULeftArmorFactor=2.0
    URearArmorFactor=2.0
    UFrontArmorSlope=60.0
    URightArmorSlope=40.0
    ULeftArmorSlope=40.0
    URearArmorSlope=15.0
    PointValue=3.0
    MaxPitchSpeed=450.0
    TreadVelocityScale=110.0
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L03'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_R03'
    RumbleSound=sound'DH_AlliedVehicleSounds.Sherman.inside_rumble01'
    LeftTrackSoundBone="Track_L"
    RightTrackSoundBone="Track_R"
    RumbleSoundBone="body"
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.JPIVL48_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.JPIVL48_turret_look'
    VehicleHudThreadsPosX(0)=0.37
    VehicleHudThreadsPosY=0.51
    VehicleHudThreadsScale=0.66
    LeftWheelBones(0)="Wheel_L_1"
    LeftWheelBones(1)="Wheel_L_2"
    LeftWheelBones(2)="Wheel_L_3"
    LeftWheelBones(3)="Wheel_L_4"
    LeftWheelBones(4)="Wheel_L_5"
    LeftWheelBones(5)="Wheel_L_6"
    LeftWheelBones(6)="Wheel_L_7"
    RightWheelBones(0)="Wheel_R_1"
    RightWheelBones(1)="Wheel_R_2"
    RightWheelBones(2)="Wheel_R_3"
    RightWheelBones(3)="Wheel_R_4"
    RightWheelBones(4)="Wheel_R_5"
    RightWheelBones(5)="Wheel_R_6"
    RightWheelBones(6)="Wheel_R_7"
    WheelRotationScale=2200
    TreadHitMinAngle=1.8
    FrontLeftAngle=321.549988
    FrontRightAngle=23.809999
    RearRightAngle=166.289993
    RearLeftAngle=211.789993
    GearRatios(4)=0.72
    TransRatio=0.1
    LeftLeverBoneName="lever_L"
    LeftLeverAxis=AXIS_Z
    RightLeverBoneName="lever_R"
    RightLeverAxis=AXIS_Z
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-135.0,Y=-20.0,Z=25.0),ExhaustRotation=(Pitch=34000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_HetzerCannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_HetzerMountedMGPawn',WeaponBone="Mg_placement")
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_HetzerPassengerOne',WeaponBone="body")
    PassengerWeapons(3)=(WeaponPawnClass=class'DH_Vehicles.DH_HetzerPassengerTwo',WeaponBone="body")
    IdleSound=SoundGroup'Vehicle_Engines.Kv1s.KV1s_engine_loop'
    StartUpSound=sound'Vehicle_Engines.Kv1s.KV1s_engine_start'
    ShutDownSound=sound'Vehicle_Engines.Kv1s.KV1s_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_Hetzer_stc_V1.hetzer_dest_generic'
    DamagedEffectScale=0.9
    DamagedEffectOffset=(X=-100.0,Y=20.0,Z=26.0)
    SteeringScaleFactor=0.75
    BeginningIdleAnim="Overlay_Idle"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Hetzer_anm_V1.hetzer_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewFOV=80.0,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Hetzer_anm_V1.hetzer_body_int',TransitionDownAnim="Overlay_In",ViewPitchUpLimit=2730,ViewPitchDownLimit=61900,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,ViewFOV=80.0)
    VehicleHudImage=texture'DH_Hetzer_tex_V1.Hetzer_HUDoverlay'
    VehicleHudOccupantsX(0)=0.45
    VehicleHudOccupantsX(1)=0.51
    VehicleHudOccupantsX(2)=0.45
    VehicleHudOccupantsY(2)=0.45
    VehicleHudEngineX=0.45
    VehHitpoints(0)=(PointRadius=1.8,PointOffset=(X=-12.0,Z=-4.0),bPenetrationPoint=false)
    VehHitpoints(1)=(PointRadius=30.0,PointOffset=(X=-68.0),DamageMultiplier=1.0)
    VehHitpoints(2)=(PointRadius=16.0,PointScale=1.0,PointBone="body",PointOffset=(X=28.0,Y=-20.0,Z=4.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=12.0,PointScale=1.0,PointBone="body",PointOffset=(X=11.2,Y=36.0,Z=24.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(4)=(PointRadius=12.0,PointScale=1.0,PointBone="body",PointOffset=(X=-11.2,Y=36.0,Z=24.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DriverAttachmentBone="driver_attachment"
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=10.0)
        WheelRadius=30.0
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_HetzerDestroyer.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=10.0)
        WheelRadius=30.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_HetzerDestroyer.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-30.0)
        WheelRadius=30.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_HetzerDestroyer.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-30.0)
        WheelRadius=30.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_HetzerDestroyer.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_HetzerDestroyer.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_HetzerDestroyer.Right_Drive_Wheel'
    VehicleMass=11.0
    bDrawDriverInTP=false
    bFPNoZFromCameraPitch=true
    DriveAnim="VStug3_driver_idle_close"
    EntryRadius=375.0
    TPCamDistance=600.0
    TPCamLookat=(X=-50.0)
    TPCamWorldOffset=(Z=250.0)
    DriverDamageMult=1.0
    VehicleNameString="Jagdpanzer 38(t) Hetzer"
    MaxDesireability=1.9
    FlagBone="Mg_placement"
    FlagRotation=(Yaw=32768)
    HUDOverlayFOV=85.0
    HealthMax=500.0
    Health=500
    Mesh=SkeletalMesh'DH_Hetzer_anm_V1.hetzer_body_ext'
    Skins(0)=texture'DH_Hetzer_tex_V1.hetzer_body'
    Skins(1)=texture'axis_vehicles_tex.Treads.Stug3_treads'
    Skins(2)=texture'axis_vehicles_tex.Treads.Stug3_treads'
    Skins(3)=texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha'
    Skins(4)=texture'DH_Hetzer_tex_V1.hetzer_int'
    Skins(5)=texture'DH_Hetzer_tex_V1.Hetzer_driver_glass'
    SoundRadius=800.0
    TransientSoundRadius=1500.0
    CollisionRadius=175.0
    CollisionHeight=60.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Y=0.5,Z=-0.5)
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=0.6
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_HetzerDestroyer.KParams0'
}
