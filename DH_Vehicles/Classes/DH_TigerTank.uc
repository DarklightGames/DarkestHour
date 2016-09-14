//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_TigerTank extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_Tiger_anm.ukx
#exec OBJ LOAD FILE=..\Textures\axis_vehicles_tex.utx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex.utx

defaultproperties
{
    MaxCriticalSpeed=693.0
    TreadDamageThreshold=1.0
    UFrontArmorFactor=10.8
    URightArmorFactor=8.7
    ULeftArmorFactor=8.7
    URearArmorFactor=8.7
    UFrontArmorSlope=24.0
    URearArmorSlope=8.0
    PointValue=5.0
    MaxPitchSpeed=150.0
    TreadVelocityScale=104.0
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L04'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_R04'
    RumbleSound=sound'Vehicle_Engines.interior.tank_inside_rumble02'
    LeftTrackSoundBone="Track_L"
    RightTrackSoundBone="Track_R"
    RumbleSoundBone="body"
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.tiger1_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.tiger1_turret_look'
    VehicleHudTreadsPosX(0)=0.34
    VehicleHudTreadsPosX(1)=0.66
    VehicleHudTreadsPosY=0.52
    VehicleHudTreadsScale=0.68
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
    WheelRotationScale=600
    TreadHitMinAngle=1.7
    FrontLeftAngle=329.0
    FrontRightAngle=31.0
    RearRightAngle=149.0
    RearLeftAngle=211.0
    GearRatios(4)=0.7
    TransRatio=0.09
    SteerSpeed=50.0
    SteerBoneName="Steering"
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-190.0,Y=25.0,Z=65.0),ExhaustRotation=(Pitch=18000))
    ExhaustPipes(1)=(ExhaustPosition=(X=-190.0,Y=-25.0,Z=65.0),ExhaustRotation=(Pitch=18000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_TigerCannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_TigerMountedMGPawn',WeaponBone="Mg_placement")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-95.0,Y=-82.5,Z=55.5),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider6_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-160.0,Y=-82.5,Z=55.5),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-160.0,Y=82.5,Z=55.5),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(3)=(AttachBone="body",DrivePos=(X=-95.0,Y=82.5,Z=55.5),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider1_idle")
    IdleSound=SoundGroup'Vehicle_Engines.Tiger.Tiger_engine_loop'
    StartUpSound=sound'Vehicle_Engines.Tiger.tiger_engine_start'
    ShutDownSound=sound'Vehicle_Engines.Tiger.tiger_engine_stop'
    DestroyedVehicleMesh=StaticMesh'axis_vehicles_stc.Tiger1.Tiger1_Destroyed'
    DamagedEffectOffset=(X=-100.0,Y=20.0,Z=26.0)
    SteeringScaleFactor=2.0
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Tiger_anm.Tiger_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-10000,ViewFOV=90.0)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Tiger_anm.Tiger_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="VTiger_driver_close",ViewPitchUpLimit=2730,ViewPitchDownLimit=61923,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,ViewFOV=90.0)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Tiger_anm.Tiger_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VTiger_driver_open",ViewPitchUpLimit=15000,ViewPitchDownLimit=65250,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true,ViewFOV=90.0)
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.tiger1_body'
    VehHitpoints(0)=(PointRadius=40.0,PointHeight=40.0,PointOffset=(X=-100.0,Z=10.0)) // engine
    VehHitpoints(1)=(PointRadius=25.0,PointHeight=10.0,PointScale=1.0,PointBone="body",PointOffset=(X=50.0,Y=-50.0,Z=35.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=25.0,PointHeight=10.0,PointScale=1.0,PointBone="body",PointOffset=(X=-5.0,Y=-50.0,Z=35.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=25.0,PointHeight=10.0,PointScale=1.0,PointBone="body",PointOffset=(X=50.0,Y=50.0,Z=35.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(4)=(PointRadius=25.0,PointHeight=10.0,PointScale=1.0,PointBone="body",PointOffset=(X=-5.0,Y=50.0,Z=35.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DriverAttachmentBone="driver_attachment"
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=25.0,Y=-10.0,Z=1.0)
        WheelRadius=33.0
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_TigerTank.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=25.0,Y=10.0,Z=1.0)
        WheelRadius=33.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_TigerTank.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-7.0,Y=-10.0,Z=1.0)
        WheelRadius=33.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_TigerTank.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-7.0,Y=10.0,Z=1.0)
        WheelRadius=33.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_TigerTank.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-10.0,Z=1.0)
        WheelRadius=33.0
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_TigerTank.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-10.0,Z=1.0)
        WheelRadius=33.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_TigerTank.Right_Drive_Wheel'
    VehicleMass=16.0
    bFPNoZFromCameraPitch=true
    DriveAnim="VTiger_driver_idle_close"
    ExitPositions(0)=(X=122.0,Y=-56.0,Z=115.0)
    ExitPositions(1)=(X=-81.0,Y=-36.0,Z=165.0)
    ExitPositions(2)=(X=123.0,Y=57.0,Z=115.0)
    ExitPositions(3)=(X=-90.0,Y=-160.0,Z=5.0)
    ExitPositions(4)=(X=-155.0,Y=-160.0,Z=5.0)
    ExitPositions(5)=(X=-155.0,Y=160.0,Z=5.0)
    ExitPositions(6)=(X=-90.0,Y=160.0,Z=5.0)
    VehicleNameString="Panzer VI 'Tiger' Ausf.E"
    MaxDesireability=1.9
    FlagBone="Mg_placement"
    FlagRotation=(Yaw=32768)
    PitchUpLimit=5000
    PitchDownLimit=60000
    HealthMax=650.0
    Health=650
    Mesh=SkeletalMesh'DH_Tiger_anm.Tiger_body_ext'
    Skins(0)=texture'axis_vehicles_tex.ext_vehicles.Tiger1_ext'
    Skins(1)=texture'axis_vehicles_tex.Treads.Tiger1_treads'
    Skins(2)=texture'axis_vehicles_tex.Treads.Tiger1_treads'
    Skins(3)=texture'axis_vehicles_tex.int_vehicles.tiger1_int'
    SoundPitch=32
    CollisionRadius=175.0
    CollisionHeight=60.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-0.6) // default is -0.5
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=0.85 // default is 1.0 (RO tiger has 0.9)
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_TigerTank.KParams0'
    HighDetailOverlay=Shader'axis_vehicles_tex.int_vehicles.tiger1_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3
    VehicleHudOccupantsX(3)=0.375
    VehicleHudOccupantsY(3)=0.69
    VehicleHudOccupantsX(4)=0.375
    VehicleHudOccupantsY(4)=0.79
    VehicleHudOccupantsX(5)=0.625
    VehicleHudOccupantsY(5)=0.79
    VehicleHudOccupantsX(6)=0.625
    VehicleHudOccupantsY(6)=0.69
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.tiger'
}
