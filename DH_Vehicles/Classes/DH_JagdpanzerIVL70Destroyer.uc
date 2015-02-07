//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_JagdpanzerIVL70Destroyer extends DH_ROTreadCraft;

#exec OBJ LOAD FILE=..\Animations\DH_Jagdpanzer4_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex4.utx
#exec OBJ LOAD FILE=..\Textures\axis_vehicles_tex.utx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_German_vehicles_stc4.usx

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_body_camo1');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_armor_camo1');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_wheels_camo1');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.panzer4F2_treads');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.int_vehicles.jagdpanzeriv_body_int');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_body_camo1');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_armor_camo1');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_wheels_camo1');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.panzer4F2_treads');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.int_vehicles.jagdpanzeriv_body_int');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    NewVehHitpoints(0)=(PointRadius=5.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=40.000000,Y=10.500000,Z=65.000000),NewHitPointType=NHP_GunOptics)
    NewVehHitpoints(1)=(PointRadius=20.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=100.000000,Y=10.000000,Z=35.000000),NewHitPointType=NHP_Traverse)
    NewVehHitpoints(2)=(PointRadius=20.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=100.000000,Y=10.000000,Z=35.000000),NewHitPointType=NHP_GunPitch)
    bAllowRiders=true
    UnbuttonedPositionIndex=1
    bSpecialExiting=true
    LeftTreadIndex=4
    RightTreadIndex=3
    MaxCriticalSpeed=638.000000
    TreadDamageThreshold=0.750000
    PeriscopeOverlay=texture'DH_VehicleOptics_tex.German.PERISCOPE_overlay_German'
    UFrontArmorFactor=8.000000
    URightArmorFactor=4.000000
    ULeftArmorFactor=4.000000
    URearArmorFactor=2.000000
    UFrontArmorSlope=50.000000
    URightArmorSlope=30.000000
    ULeftArmorSlope=30.000000
    URearArmorSlope=9.000000
    PointValue=3.000000
    MaxPitchSpeed=150.000000
    TreadVelocityScale=100.000000
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L08'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_R08'
    RumbleSound=sound'Vehicle_Engines.interior.tank_inside_rumble02'
    LeftTrackSoundBone="Track_L"
    RightTrackSoundBone="Track_R"
    RumbleSoundBone="driver_attachment"
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.JPIVL70_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.JPIVL70_turret_look'
    VehicleHudThreadsPosX(0)=0.360000
    VehicleHudThreadsPosY=0.510000
    VehicleHudThreadsScale=0.660000
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
    LeftWheelBones(11)="Wheel_L_12"
    LeftWheelBones(12)="Wheel_L_13"
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
    RightWheelBones(11)="Wheel_R_12"
    RightWheelBones(12)="Wheel_R_13"
    WheelRotationScale=2000
    TreadHitMinAngle=1.900000
    FrontLeftAngle=332.000000
    RearLeftAngle=208.000000
    LeftLeverBoneName="lever_L"
    LeftLeverAxis=AXIS_Z
    RightLeverBoneName="lever_R"
    RightLeverAxis=AXIS_Z
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-190.000000,Y=-10.000000,Z=36.000000),ExhaustRotation=(Pitch=32768))
    ExhaustPipes(1)=(ExhaustPosition=(X=-190.000000,Y=49.000000,Z=36.000000),ExhaustRotation=(Pitch=32768))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdpanzerIVL70CannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdpanzerIVMountedMGPawn',WeaponBone="Mg_placement")
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdpanzerIVPassengerOne',WeaponBone="body")
    PassengerWeapons(3)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdpanzerIVPassengerTwo',WeaponBone="body")
    IdleSound=SoundGroup'Vehicle_Engines.PanzerIV.PanzerIV_engine_loop'
    StartUpSound=sound'Vehicle_Engines.PanzerIV.PanzerIV_engine_start'
    ShutDownSound=sound'Vehicle_Engines.PanzerIV.PanzerIV_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc4.Jagdpanzer4.Jagdpanzer4_dest70'
    DamagedEffectScale=0.900000
    DamagedEffectOffset=(X=-100.000000,Y=20.000000,Z=26.000000)
    SteeringScaleFactor=0.750000
    BeginningIdleAnim="Overlay_Idle"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L70_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=5000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=1,ViewNegativeYawLimit=-1,ViewFOV=90.000000,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L70_body_int',TransitionDownAnim="Overlay_In",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5000,ViewNegativeYawLimit=-5500,ViewFOV=90.000000)
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.JPIVL70_body'
    VehicleHudOccupantsX(0)=0.430000
    VehicleHudOccupantsX(1)=0.460000
    VehicleHudOccupantsX(2)=0.600000
    VehicleHudOccupantsX(3)=0.500000
    VehicleHudOccupantsX(4)=0.600000
    VehicleHudOccupantsY(0)=0.420000
    VehicleHudOccupantsY(1)=0.560000
    VehicleHudOccupantsY(2)=0.420000
    VehicleHudOccupantsY(3)=0.700000
    VehicleHudOccupantsY(4)=0.700000
    bVehicleHudUsesLargeTexture=true
    VehHitpoints(0)=(PointRadius=0.000000,PointOffset=(X=-15.000000,Z=-22.000000),bPenetrationPoint=false)
    VehHitpoints(1)=(PointRadius=35.000000,PointOffset=(X=-100.000000,Z=10.000000),DamageMultiplier=1.000000)
    VehHitpoints(2)=(PointRadius=20.000000,PointScale=1.000000,PointBone="body",PointOffset=(Y=50.000000,Z=40.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=20.000000,PointScale=1.000000,PointBone="body",PointOffset=(Y=-50.000000,Z=40.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
    VehHitpoints(4)=(PointRadius=20.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=-20.000000,Y=-40.000000,Z=20.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
    DriverAttachmentBone="driver_attachment"
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=35.000000,Y=-5.000000,Z=6.000000)
        WheelRadius=29.000000
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_JagdpanzerIVL70Destroyer.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=35.000000,Y=5.000000,Z=6.000000)
        WheelRadius=29.000000
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_JagdpanzerIVL70Destroyer.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-7.000000,Y=-5.000000,Z=6.000000)
        WheelRadius=29.000000
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_JagdpanzerIVL70Destroyer.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-7.000000,Y=5.000000,Z=6.000000)
        WheelRadius=29.000000
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_JagdpanzerIVL70Destroyer.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=6.000000)
        WheelRadius=29.000000
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_JagdpanzerIVL70Destroyer.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=6.000000)
        WheelRadius=29.000000
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_JagdpanzerIVL70Destroyer.Right_Drive_Wheel'
    VehicleMass=12.000000
    bDrawDriverInTP=false
    bFPNoZFromCameraPitch=true
    DrivePos=(X=-5.000000,Y=-5.000000,Z=0.000000)
    DriveAnim="VStug3_driver_idle_close"
    ExitPositions(0)=(Y=-125.000000,Z=100.000000)
    ExitPositions(1)=(Y=125.000000,Z=100.000000)
    EntryRadius=375.000000
    FPCamPos=(X=-5.000000,Y=0.000000,Z=25.000000)
    TPCamDistance=600.000000
    TPCamLookat=(X=-50.000000)
    TPCamWorldOffset=(Z=250.000000)
    DriverDamageMult=1.000000
    VehicleNameString="Jagdpanzer IV/70(V)"
    MaxDesireability=1.900000
    FlagBone="Mg_placement"
    FlagRotation=(Yaw=32768)
    PitchUpLimit=5000
    PitchDownLimit=60000
    HealthMax=525.000000
    Health=525
    Mesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L70_body_ext'
    Skins(0)=texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_body_camo1'
    Skins(1)=texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_armor_camo1'
    Skins(2)=texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_wheels_camo1'
    Skins(3)=texture'axis_vehicles_tex.Treads.panzer4F2_treads'
    Skins(4)=texture'axis_vehicles_tex.Treads.panzer4F2_treads'
    Skins(5)=texture'DH_VehiclesGE_tex4.int_vehicles.jagdpanzeriv_body_int'
    SoundRadius=800.000000
    TransientSoundRadius=1500.000000
    CollisionRadius=175.000000
    CollisionHeight=60.000000
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.000000
        KInertiaTensor(3)=3.000000
        KInertiaTensor(5)=3.000000
        KCOMOffset=(Z=-1.500000)
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_JagdpanzerIVL70Destroyer.KParams0'
    HighDetailOverlayIndex=5
    LeftTreadPanDirection=(Pitch=0,Yaw=32768,Roll=16384)
    RightTreadPanDirection=(Pitch=32768,Yaw=0,Roll=16384)
}
