//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerIVJTank extends DH_ROTreadCraft;

#exec OBJ LOAD FILE=..\Animations\DH_PanzerIV_anm.ukx
#exec OBJ LOAD FILE=..\textures\axis_vehicles_tex.utx
#exec OBJ LOAD FILE=..\textures\axis_vehicles_tex2.utx
#exec OBJ LOAD FILE=..\textures\DH_VehiclesGE_tex3.utx
#exec OBJ LOAD FILE=..\textures\DH_VehiclesGE_tex4.utx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_German_vehicles_stc3.usx

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_ext');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.Panzer4F2_int');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.panzer4F2_treads');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.Panzer4f2_int_s');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_armor_ext');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_armor_camo2');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_body_camo2');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_wheels_camo2');

}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_ext');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.Panzer4F2_int');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.panzer4F2_treads');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.int_vehicles.Panzer4f2_int_s');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_armor_ext');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_armor_camo2');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_body_camo2');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_wheels_camo2');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    MaxCriticalSpeed=793.000000
    TreadDamageThreshold=0.750000
    UFrontArmorFactor=8.000000
    URightArmorFactor=3.100000
    ULeftArmorFactor=3.100000
    URearArmorFactor=2.000000
    UFrontArmorSlope=14.000000
    URearArmorSlope=9.000000
    PointValue=3.000000
    MaxPitchSpeed=150.000000
    TreadVelocityScale=103.000000
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L06'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_R06'
    RumbleSound=sound'Vehicle_Engines.interior.tank_inside_rumble02'
    LeftTrackSoundBone="Track_L"
    RightTrackSoundBone="Track_R"
    RumbleSoundBone="body"
    VehicleHudTurret=TexRotator'InterfaceArt2_tex.Tank_Hud.panzer4H_turret_rot'
    VehicleHudTurretLook=TexRotator'InterfaceArt2_tex.Tank_Hud.panzer4H_turret_look'
    VehicleHudThreadsPosX(0)=0.360000
    VehicleHudThreadsPosY=0.510000
    VehicleHudThreadsScale=0.710000
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
    WheelRotationScale=550
    bHasAddedSideArmor=true
    TreadHitMinAngle=1.800000
    FrontLeftAngle=332.000000
    RearLeftAngle=208.000000
    GearRatios(4)=0.650000
    LeftLeverBoneName="lever_L"
    LeftLeverAxis=AXIS_Z
    RightLeverBoneName="lever_R"
    RightLeverAxis=AXIS_Z
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-176.000000,Y=-10.000000,Z=42.000000),ExhaustRotation=(Pitch=22000))
    ExhaustPipes(1)=(ExhaustPosition=(X=-176.000000,Y=46.000000,Z=42.000000),ExhaustRotation=(Pitch=22000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIVJCannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIVMountedMGPawn',WeaponBone="Mg_placement")
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIVPassengerOne',WeaponBone="body")
    PassengerWeapons(3)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIVPassengerTwo',WeaponBone="body")
    PassengerWeapons(4)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIVPassengerThree',WeaponBone="body")
    PassengerWeapons(5)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIVPassengerFour',WeaponBone="body")
    IdleSound=SoundGroup'Vehicle_Engines.PanzerIV.PanzerIV_engine_loop'
    StartUpSound=sound'Vehicle_Engines.PanzerIV.PanzerIV_engine_start'
    ShutDownSound=sound'Vehicle_Engines.PanzerIV.PanzerIV_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc3.PanzerIVJ.PanzerIVJ_dest'
    DisintegrationHealth=-1000.000000
    DamagedEffectScale=0.900000
    DamagedEffectOffset=(X=-100.000000,Y=20.000000,Z=26.000000)
    SteeringScaleFactor=0.750000
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_PanzerIV_anm.panzer4J_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=2300,ViewPitchDownLimit=64000,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,ViewFOV=90.000000)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_PanzerIV_anm.panzer4J_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="VPanzer4_driver_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=61000,ViewPositiveYawLimit=5000,ViewNegativeYawLimit=-10000,ViewFOV=90.000000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_PanzerIV_anm.panzer4J_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VPanzer4_driver_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=65536,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true,ViewFOV=90.000000)
    VehicleHudImage=texture'InterfaceArt_tex.Tank_Hud.panzer4F2_body'
    VehicleHudOccupantsX(0)=0.430000
    VehicleHudOccupantsX(2)=0.570000
    VehicleHudOccupantsX(3)=0.375
    VehicleHudOccupantsY(3)=0.70
    VehicleHudOccupantsX(4)=0.45
    VehicleHudOccupantsY(4)=0.75
    VehicleHudOccupantsX(5)=0.55
    VehicleHudOccupantsY(5)=0.75
    VehicleHudOccupantsX(6)=0.625
    VehicleHudOccupantsY(6)=0.70
    VehHitpoints(0)=(PointRadius=10.000000,PointBone="body",PointOffset=(X=82.000000,Y=-40.000000,Z=63.000000),bPenetrationPoint=false)
    VehHitpoints(1)=(PointRadius=32.000000,PointOffset=(X=-100.000000,Z=12.000000),DamageMultiplier=1.000000)
    VehHitpoints(2)=(PointRadius=20.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=30.000000,Y=-27.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=20.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=-20.000000,Y=-27.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
    VehHitpoints(4)=(PointRadius=20.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=-30.000000,Y=27.000000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
    DriverAttachmentBone="driver_attachment"
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=30.000000,Y=-7.000000,Z=10.000000)
        WheelRadius=30.000000
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_PanzerIVJTank.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=30.000000,Y=7.000000,Z=10.000000)
        WheelRadius=30.000000
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_PanzerIVJTank.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-12.000000,Y=-7.000000,Z=10.000000)
        WheelRadius=30.000000
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_PanzerIVJTank.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-12.000000,Y=7.000000,Z=10.000000)
        WheelRadius=30.000000
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_PanzerIVJTank.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.000000)
        WheelRadius=30.000000
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_PanzerIVJTank.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.000000)
        WheelRadius=30.000000
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_PanzerIVJTank.Right_Drive_Wheel'
    bFPNoZFromCameraPitch=true
    DrivePos=(X=0.000000,Y=0.000000,Z=0.000000)
    ExitPositions(0)=(Y=-200.000000,Z=100.000000)
    ExitPositions(1)=(Y=200.000000,Z=100.000000)
    EntryRadius=375.000000
    FPCamPos=(X=0.000000,Y=0.000000,Z=0.000000)
    TPCamDistance=600.000000
    TPCamLookat=(X=-50.000000)
    TPCamWorldOffset=(Z=250.000000)
    DriverDamageMult=1.000000
    VehiclePositionString="in a Panzer IV Ausf.J"
    VehicleNameString="Panzer IV Ausf.J"
    MaxDesireability=1.800000
    FlagBone="Mg_placement"
    FlagRotation=(Yaw=32768)
    HUDOverlayOffset=(X=2.000000)
    HUDOverlayFOV=90.000000
    PitchUpLimit=5000
    PitchDownLimit=60000
    HealthMax=525.000000
    Health=525
    Mesh=SkeletalMesh'DH_PanzerIV_anm.panzer4J_body_ext'
    Skins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.panzer4J_body_ext'
    Skins(1)=texture'axis_vehicles_tex.Treads.panzer4F2_treads'
    Skins(2)=texture'axis_vehicles_tex.Treads.panzer4F2_treads'
    Skins(3)=texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_armor_camo2'
    Skins(4)=texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_body_camo2'
    Skins(5)=texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_wheels_camo2'
    Skins(6)=texture'axis_vehicles_tex.int_vehicles.Panzer4F2_int'
    Skins(7)=texture'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_armor_ext'
    SoundRadius=800.000000
    TransientSoundRadius=1500.000000
    CollisionRadius=175.000000
    CollisionHeight=60.000000
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.000000
        KInertiaTensor(3)=3.000000
        KInertiaTensor(5)=3.000000
        KCOMOffset=(Z=-0.600000)
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_PanzerIVJTank.KParams0'
    HighDetailOverlay=Shader'axis_vehicles_tex.int_vehicles.Panzer4f2_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=6
}
