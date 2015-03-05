//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_StuH42Destroyer extends DH_ROTreadCraft;

#exec OBJ LOAD FILE=..\Animations\DH_Stug3G_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex2.utx

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.stug3G_body_ext');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.treads.stug3g_treads');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.stug3G_armor_camo1');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.stug3G_body_ext');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.treads.stug3g_treads');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex2.ext_vehicles.stug3G_armor_camo1');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    NewVehHitpoints(0)=(PointRadius=5.0,PointScale=1.0,PointBone="body",PointOffset=(X=22.0,Y=-30.5,Z=61.0),NewHitPointType=NHP_GunOptics)
    NewVehHitpoints(1)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=15.0,Y=5.0,Z=35.0),NewHitPointType=NHP_Traverse)
    NewVehHitpoints(2)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=15.0,Y=5.0,Z=35.0),NewHitPointType=NHP_GunPitch)
    LeftTreadIndex=3
    MaxCriticalSpeed=729.0
    UFrontArmorFactor=8.1
    URightArmorFactor=3.1
    ULeftArmorFactor=3.1
    URearArmorFactor=5.0
    UFrontArmorSlope=20.0
    URearArmorSlope=10.0
    PointValue=3.0
    MaxPitchSpeed=150.0
    TreadVelocityScale=146.0
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L08'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_R08'
    RumbleSound=sound'Vehicle_Engines.interior.tank_inside_rumble01'
    LeftTrackSoundBone="Track_L"
    RightTrackSoundBone="Track_R"
    RumbleSoundBone="driver_attachment"
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Stug3g_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Stug3g_turret_look'
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
    WheelRotationScale=1000
    bHasAddedSideArmor=true
    TreadHitMinAngle=1.8
    FrontLeftAngle=330.0
    FrontRightAngle=30.0
    RearRightAngle=150.0
    RearLeftAngle=210.0
    LeftLeverBoneName="lever_L"
    LeftLeverAxis=AXIS_Z
    RightLeverBoneName="lever_R"
    RightLeverAxis=AXIS_Z
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-175.0,Y=40.0,Z=-25.0),ExhaustRotation=(Pitch=34000))
    ExhaustPipes(1)=(ExhaustPosition=(X=-175.0,Y=-40.0,Z=-25.0),ExhaustRotation=(Pitch=34000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_StuH42CannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_StuH42MountedMGPawn',WeaponBone="mg_base")
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_Stug3GPassengerOne',WeaponBone="passenger_01")
    PassengerWeapons(3)=(WeaponPawnClass=class'DH_Vehicles.DH_Stug3GPassengerTwo',WeaponBone="passenger_02")
    PassengerWeapons(4)=(WeaponPawnClass=class'DH_Vehicles.DH_Stug3GPassengerThree',WeaponBone="passenger_03")
    PassengerWeapons(5)=(WeaponPawnClass=class'DH_Vehicles.DH_Stug3GPassengerFour',WeaponBone="passenger_04x")
    IdleSound=SoundGroup'Vehicle_Engines.STUGiii.stugiii_engine_loop'
    StartUpSound=sound'Vehicle_Engines.STUGiii.stugiii_engine_start'
    ShutDownSound=sound'Vehicle_Engines.STUGiii.stugiii_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.StuH.Stuh_dest'
    DamagedEffectScale=0.9
    DamagedEffectOffset=(X=-100.0,Y=20.0,Z=26.0)
    SteeringScaleFactor=0.75
    BeginningIdleAnim="driver_hatch_idle_open"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug3g_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=12000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,ViewFOV=90.0)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Stug3G_anm.Stug3g_body_int',TransitionDownAnim="Overlay_In",ViewPitchUpLimit=2000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,ViewFOV=90.0)
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.stug3g_body'
    VehicleHudOccupantsX(0)=0.44
    VehicleHudOccupantsX(1)=0.44
    VehicleHudOccupantsX(2)=0.59
    VehicleHudOccupantsX(3)=0.4
    VehicleHudOccupantsX(4)=0.5
    VehicleHudOccupantsX(5)=0.6
    VehicleHudOccupantsX(6)=0.5
    VehicleHudOccupantsY(0)=0.4
    VehicleHudOccupantsY(1)=0.55
    VehicleHudOccupantsY(2)=0.56
    VehicleHudOccupantsY(3)=0.7
    VehicleHudOccupantsY(4)=0.65
    VehicleHudOccupantsY(5)=0.7
    VehicleHudOccupantsY(6)=0.75
    VehHitpoints(0)=(PointRadius=2.0,PointOffset=(X=-15.0,Z=-22.0),bPenetrationPoint=false)
    VehHitpoints(1)=(PointRadius=20.0,PointHeight=25.0,PointOffset=(X=-90.0),DamageMultiplier=1.0)
    VehHitpoints(2)=(PointRadius=10.0,PointHeight=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=-60.0,Y=-30.0,Z=15.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=10.0,PointHeight=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=5.0,Y=30.0,Z=30.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DriverAttachmentBone="driver_attachment"
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=35.0,Y=-5.0,Z=6.0)
        WheelRadius=30.0
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_StuH42Destroyer.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=35.0,Y=5.0,Z=6.0)
        WheelRadius=30.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_StuH42Destroyer.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-7.0,Y=-5.0,Z=6.0)
        WheelRadius=30.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_StuH42Destroyer.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-7.0,Y=5.0,Z=6.0)
        WheelRadius=30.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_StuH42Destroyer.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=6.0)
        WheelRadius=30.0
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_StuH42Destroyer.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=6.0)
        WheelRadius=30.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_StuH42Destroyer.Right_Drive_Wheel'
    VehicleMass=12.0
    bDrawDriverInTP=false
    bFPNoZFromCameraPitch=true
    DrivePos=(X=-5.0,Y=-5.0,Z=0.0)
    DriveAnim="VStug3_driver_idle_close"
    ExitPositions(0)=(X=-49.0,Y=-40.0,Z=130.0)
    ExitPositions(1)=(X=-49.0,Y=-40.0,Z=130.0)
    ExitPositions(2)=(X=-30.0,Y=38.0,Z=150.0)
    ExitPositions(3)=(X=-80.0,Y=-167.0,Z=5.0)
    ExitPositions(4)=(X=-235.0,Y=-3.0,Z=5.0)
    ExitPositions(5)=(X=-80.0,Y=167.0,Z=5.0)
    ExitPositions(6)=(X=-235.0,Y=-3.0,Z=5.0)
    EntryRadius=375.0
    FPCamPos=(X=-5.0,Y=0.0,Z=25.0)
    TPCamDistance=600.0
    TPCamLookat=(X=-50.0)
    TPCamWorldOffset=(Z=250.0)
    DriverDamageMult=1.0
    VehicleNameString="StuH42 Ausf.G"
    MaxDesireability=1.9
    FlagBone="Mg_placement"
    FlagRotation=(Yaw=32768)
    HUDOverlayOffset=(X=5.0)
    HUDOverlayFOV=90.0
    PitchUpLimit=5000
    PitchDownLimit=60000
    HealthMax=525.0
    Health=525
    Mesh=SkeletalMesh'DH_Stug3G_anm.StuH_body_ext'
    Skins(0)=texture'DH_VehiclesGE_tex2.ext_vehicles.Stug3g_body_ext'
    Skins(1)=texture'DH_VehiclesGE_tex2.ext_vehicles.stug3g_armor_camo1'
    Skins(2)=texture'DH_VehiclesGE_tex2.Treads.Stug3g_treads'
    Skins(3)=texture'DH_VehiclesGE_tex2.Treads.Stug3g_treads'
    Skins(4)=texture'DH_VehiclesGE_tex2.int_vehicles.Stug3g_body_int'
    SoundRadius=800.0
    TransientSoundRadius=1200.0
    CollisionRadius=175.0
    CollisionHeight=60.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-1.5)
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_StuH42Destroyer.KParams0'
    HighDetailOverlayIndex=4
}
