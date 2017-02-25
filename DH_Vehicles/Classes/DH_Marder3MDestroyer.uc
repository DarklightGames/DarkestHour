//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_Marder3MDestroyer extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex7.utx
#exec OBJ LOAD FILE=..\Animations\DH_Marder3M_anm.ukx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_German_vehicles_stc3.usx

defaultproperties
{
    LeftTreadIndex=3
    MaxCriticalSpeed=729.0
    UFrontArmorFactor=1.0
    URightArmorFactor=1.5
    ULeftArmorFactor=1.5
    URearArmorFactor=1.0
    UFrontArmorSlope=30.0
    URightArmorSlope=15.0
    ULeftArmorSlope=15.0
    MaxPitchSpeed=450.0
    TreadVelocityScale=300.0
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L03'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_R03'
    RumbleSound=sound'DH_AlliedVehicleSounds.Sherman.inside_rumble01'
    LeftTrackSoundBone="Track_L"
    RightTrackSoundBone="Track_R"
    RumbleSoundBone="body"
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.MarderIII_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.MarderIII_turret_look'
    VehicleHudTreadsPosX(0)=0.36
    VehicleHudTreadsPosX(1)=0.64
    VehicleHudTreadsPosY=0.51
    VehicleHudTreadsScale=0.72
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
    WheelRotationScale=1700
    TreadHitMaxHeight=-5.0
    FrontLeftAngle=330.0
    FrontRightAngle=30.0
    RearRightAngle=150.0
    RearLeftAngle=210.0
    GearRatios(4)=0.72
    TransRatio=0.1
    SteerBoneName="Steering"
    LeftLeverBoneName="lever_L"
    LeftLeverAxis=AXIS_Z
    RightLeverBoneName="lever_R"
    RightLeverAxis=AXIS_Z
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-142.0,Y=-28.0,Z=18.0),ExhaustRotation=(Pitch=40050))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Marder3MCannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_Marder3MMountedMGPawn',WeaponBone="Mg34_placment")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=7.5,Y=30.0,Z=41.0),DriveAnim="VUC_rider1_idle")
    IdleSound=SoundGroup'Vehicle_Engines.Kv1s.KV1s_engine_loop'
    StartUpSound=sound'Vehicle_Engines.Kv1s.KV1s_engine_start'
    ShutDownSound=sound'Vehicle_Engines.Kv1s.KV1s_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc3.Marder3.Marder3M_dest'
    DamagedEffectOffset=(X=30.0,Y=0.0,Z=20.0)
    FireEffectOffset=(X=10.0,Y=0.0,Z=-20.0)
    SteeringScaleFactor=0.75
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Marder3M_anm.marder3_body_int',TransitionUpAnim="driver_slit_close",ViewPitchUpLimit=2000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,ViewFOV=90.0)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Marder3M_anm.marder3_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="driver_slit_open",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,ViewFOV=90.0)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Marder3M_anm.marder3_body_int',TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true,ViewFOV=90.0)
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.MarderIII_body'
    VehicleHudOccupantsX(0)=0.55
    VehicleHudOccupantsX(1)=0.45
    VehicleHudOccupantsX(2)=0.55
    VehicleHudOccupantsX(3)=0.575
    VehicleHudOccupantsY(0)=0.33
    VehicleHudOccupantsY(1)=0.71
    VehicleHudOccupantsY(2)=0.71
    VehicleHudOccupantsY(3)=0.5
    VehicleHudEngineX=0.51
    VehicleHudEngineY=0.47
    VehHitpoints(0)=(PointRadius=30.0,PointOffset=(Z=-5.0)) // engine
    VehHitpoints(1)=(PointRadius=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=-50.0,Y=-20.0,Z=-15.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=-90.0,Y=-40.0,Z=40.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=-90.0,Y=40.0,Z=40.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DriverAttachmentBone="driver_attachment"
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=10.0)
        WheelRadius=30.0
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_Marder3MDestroyer.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=10.0)
        WheelRadius=30.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_Marder3MDestroyer.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-30.0)
        WheelRadius=30.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_Marder3MDestroyer.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-30.0)
        WheelRadius=30.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_Marder3MDestroyer.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_Marder3MDestroyer.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_Marder3MDestroyer.Right_Drive_Wheel'
    VehicleMass=11.0
    bFPNoZFromCameraPitch=true
    DrivePos=(X=-5.0,Y=0.0,Z=2.0)
    DriveAnim="VPanzer3_driver_idle_open"
    ExitPositions(0)=(X=78.0,Y=96.0,Z=5.0)
    ExitPositions(1)=(X=-133.0,Y=-27.0,Z=120.0)
    ExitPositions(2)=(X=-135.0,Y=24.0,Z=120.0)
    ExitPositions(3)=(X=25.0,Y=106.0,Z=5.0)
    DriverDamageMult=1.0
    VehicleNameString="Marder III Ausf.M"
    MaxDesireability=1.9
    FlagBone="Mg_placement"
    FlagRotation=(Yaw=32768)
    PitchUpLimit=5000
    PitchDownLimit=60000
    HealthMax=400.0
    Health=400
    Mesh=SkeletalMesh'DH_Marder3M_anm.marder3_body_ext'
    Skins(0)=texture'DH_VehiclesGE_tex7.ext_vehicles.marder_turret_ext'
    Skins(1)=texture'DH_VehiclesGE_tex7.ext_vehicles.marder_body_ext'
    Skins(2)=texture'DH_VehiclesGE_tex7.Treads.marder_treads'
    Skins(3)=texture'DH_VehiclesGE_tex7.Treads.marder_treads'
    Skins(4)=texture'DH_VehiclesGE_tex7.int_vehicles.marder3m_body_int'
    CollisionRadius=175.0
    CollisionHeight=60.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-1.0) // default is -0.5
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=0.9 // default is 1.0
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_Marder3MDestroyer.KParams0'
    LeftTreadPanDirection=(Pitch=0,Yaw=32768,Roll=16384)
    RightTreadPanDirection=(Pitch=32768,Yaw=0,Roll=16384)
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.marder3'
}
