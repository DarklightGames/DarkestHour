//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_HetzerDestroyer extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_Hetzer_anm.ukx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_Hetzer_stc.usx
#exec OBJ LOAD FILE=..\Textures\DH_Hetzer_tex.utx

simulated event DestroyAppearance()
{
    local Combiner DestroyedSkin;

    DestroyedSkin = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
    DestroyedSkin.Material1 = Skins[0];
    DestroyedSkin.Material2 = Texture'DH_FX_Tex.Overlays.DestroyedVehicleOverlay2';
    DestroyedSkin.FallbackMaterial = Skins[0];
    DestroyedSkin.CombineOperation = CO_Multiply;
    DestroyedMeshSkins[0] = DestroyedSkin;

    DestroyedSkin = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
    DestroyedSkin.Material1 = Texture'axis_vehicles_tex.Treads.Stug3_treads';
    DestroyedSkin.Material2 = Texture'DH_FX_Tex.Overlays.DestroyedVehicleOverlay2';
    DestroyedSkin.FallbackMaterial = Skins[1];
    DestroyedSkin.CombineOperation = CO_Multiply;
    DestroyedMeshSkins[1] = DestroyedSkin;

    super.DestroyAppearance();
}

defaultproperties
{
    PeriscopeOverlay=Texture'DH_VehicleOptics_tex.General.PERISCOPE_overlay_German'
    ReinforcementCost=4
    FrontArmor(0)=(Thickness=6.000000,Slope=-40.000000,MaxRelativeHeight=9.900000,LocationName="lower")
    FrontArmor(1)=(Thickness=6.000000,Slope=60.000000,LocationName="upper")
    RightArmor(0)=(Thickness=2.000000,Slope=-15.000000,MaxRelativeHeight=13.000000,LocationName="lower")
    RightArmor(1)=(Thickness=2.000000,Slope=40.000000,LocationName="upper")
    LeftArmor(0)=(Thickness=2.000000,Slope=-15.000000,MaxRelativeHeight=13.000000,LocationName="lower")
    LeftArmor(1)=(Thickness=2.000000,Slope=40.000000,LocationName="upper")
    RearArmor(0)=(Thickness=2.000000,Slope=15.000000,MaxRelativeHeight=20.299999,LocationName="lower")
    RearArmor(1)=(Thickness=0.800000,Slope=70.000000,LocationName="upper")
    NewVehHitpoints(0)=(PointRadius=2.000000,PointBone="body",PointOffset=(X=32.000000,Y=-9.800000,Z=64.699997),NewHitPointType=NHP_GunOptics)
    NewVehHitpoints(1)=(PointRadius=15.000000,PointBone="Turret",PointOffset=(X=-12.000000),NewHitPointType=NHP_Traverse)
    NewVehHitpoints(2)=(PointRadius=15.000000,PointBone="Turret",PointOffset=(X=-12.000000),NewHitPointType=NHP_GunPitch)
    GunOpticsHitPointIndex=0
    FireAttachBone="body"
    FireEffectOffset=(X=103.000000,Y=-35.000000,Z=30.000000)
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-70.000000,Y=-25.000000,Z=110.000000),DriveRot=(Pitch=3850),DriveAnim="crouch_idle_binoc")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-80.000000,Y=45.000000,Z=105.000000),DriveRot=(Pitch=4400,Yaw=-3100,Roll=-1700),DriveAnim="prone_idle_nade")
    FrontLeftAngle=340.000000
    FrontRightAngle=35.000000
    RearRightAngle=145.000000
    RearLeftAngle=201.000000
    MaxPitchSpeed=450.000000
    RumbleSound=Sound'DH_AlliedVehicleSounds.Sherman.inside_rumble01'
    TreadVelocityScale=55.000000
    LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L03'
    RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_R03'
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
    WheelRotationScale=20000.000000
    TreadHitMaxHeight=8.000000
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.hetzer_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.hetzer_turret_look'
    VehicleHudTreadsPosX(0)=0.375000
    VehicleHudTreadsPosX(1)=0.625000
    VehicleHudTreadsPosY=0.54
    VehicleHudTreadsScale=0.575
    GearRatios(4)=0.720000
    TransRatio=0.100000
    LeftLeverBoneName="lever_L"
    LeftLeverAxis=AXIS_Y
    RightLeverBoneName="lever_R"
    RightLeverAxis=AXIS_Y
    ExhaustPipes(0)=(ExhaustPosition=(X=-140.000000,Y=-23.000000,Z=23.000000),ExhaustRotation=(Yaw=34000))
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_HetzerCannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=Class'DH_Vehicles.DH_HetzerMountedMGPawn',WeaponBone="Mg_placement")
    IdleSound=SoundGroup'Vehicle_Engines.Kv1s.KV1s_engine_loop'  //KV sound for pz38(t)?? this definitely needs to be changed
    StartUpSound=Sound'Vehicle_Engines.Kv1s.KV1s_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.Kv1s.KV1s_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_Hetzer_stc.Destroyed.Hetzer_destroyed'
    DamagedEffectOffset=(X=-60.000000,Y=25.000000)
    BeginningIdleAnim="periscope_idle_out"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Hetzer_anm.Hetzer_body_int',TransitionUpAnim="periscope_out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,bDrawOverlays=True)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Hetzer_anm.Hetzer_body_int',TransitionDownAnim="Periscope_in",ViewPitchUpLimit=3500,ViewPitchDownLimit=63000,ViewPositiveYawLimit=3500,ViewNegativeYawLimit=-3000)
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.hetzer_body'
    VehicleHudOccupantsX(0)=0.440000
    VehicleHudOccupantsX(1)=0.540000
    VehicleHudOccupantsX(2)=0.440000
    VehicleHudOccupantsX(3)=0.450000
    VehicleHudOccupantsX(4)=0.560000
    VehicleHudOccupantsY(0)=0.330000
    VehicleHudOccupantsY(2)=0.500000
    VehicleHudOccupantsY(3)=0.610000
    VehicleHudOccupantsY(4)=0.610000
    VehicleHudEngineY=0.610000
    VehHitpoints(0)=(PointRadius=30.000000,PointOffset=(X=-60.000000))
    VehHitpoints(1)=(PointRadius=18.000000,PointScale=1.000000,PointBone="body",PointOffset=(Y=-28.299999,Z=-5.500000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=14.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=74.000000,Y=26.700001,Z=-9.400000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=14.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=29.000000,Y=26.700001,Z=-9.400000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
    VehHitpoints(4)=(PointRadius=14.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=38.500000,Y=35.299999,Z=37.299999),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
    VehHitpoints(5)=(PointRadius=14.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=1.000000,Y=35.299999,Z=37.299999),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
    DriverAttachmentBone=
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=True
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=12.000000)
        WheelRadius=30.000000
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_HetzerDestroyer.LF_Steering'

    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=True
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=12.000000)
        WheelRadius=30.000000
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_HetzerDestroyer.RF_Steering'

    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=True
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-18.000000)
        WheelRadius=30.000000
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_HetzerDestroyer.LR_Steering'

    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=True
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-18.000000)
        WheelRadius=30.000000
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_HetzerDestroyer.RR_Steering'

    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=True
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-3.000000)
        WheelRadius=30.000000
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_HetzerDestroyer.Left_Drive_Wheel'

    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=True
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-3.000000)
        WheelRadius=30.000000
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_HetzerDestroyer.Right_Drive_Wheel'

    VehicleMass=11.000000
    bDrawDriverInTP=False
    ExitPositions(0)=(X=90.000000,Y=-80.000000,Z=50.000000)
    ExitPositions(1)=(X=-10.000000,Y=50.000000,Z=120.000000)
    ExitPositions(2)=(X=-32.000000,Y=-10.000000,Z=120.000000)
    ExitPositions(3)=(X=-50.000000,Y=-80.000000,Z=50.000000)
    ExitPositions(4)=(X=-50.000000,Y=150.000000,Z=50.000000)
    ExitPositions(5)=(X=-160.000000,Y=20.000000,Z=50.000000)
    VehicleNameString="Jagdpanzer 38(t) 'Hetzer'"
    SpawnOverlay(0)=Texture'DH_InterfaceArt_tex.Vehicles.hetzer'

    //Health cons: petrol fuel
    //4 men crew
    Health=525
    HealthMax=525.0
    EngineHealth=260 //slightly overloaded

    EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
    DisintegrationHealth=-800.0 //petrol
    // reduced reliability due to increased weight
    Mesh=SkeletalMesh'DH_Hetzer_anm.Hetzer_body_ext'
    Skins(0)=Texture'DH_Hetzer_tex.hetzer_body'
    Skins(1)=Texture'axis_vehicles_tex.Treads.Stug3_treads'
    Skins(2)=Texture'axis_vehicles_tex.Treads.Stug3_treads'
    Skins(3)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha'
    Skins(4)=Texture'DH_Hetzer_tex.hetzer_int'
    Skins(5)=Texture'DH_Hetzer_tex.Hetzer_driver_glass'
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.000000
        KInertiaTensor(3)=3.000000
        KInertiaTensor(5)=3.000000
        KCOMOffset=(X=0.040000,Y=0.440000,Z=-1.000000)
        KLinearDamping=0.050000
        KAngularDamping=0.050000
        KStartEnabled=True
        bKNonSphericalInertia=True
        KMaxAngularSpeed=0.600000
        bHighDetailOnly=False
        bClientOnly=False
        bKDoubleTickRate=True
        bDestroyOnWorldPenetrate=True
        bDoSafetime=True
        KFriction=0.500000
        KImpactThreshold=700.000000
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_HetzerDestroyer.KParams0'
}
