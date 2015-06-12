//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_JagdtigerTank extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_Jagdtiger_anm.ukx
#exec OBJ LOAD FILE=..\Sounds\DH_GerVehicleSounds2.uax
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex2.utx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex3.utx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_German_vehicles_stc2.usx

defaultproperties
{
    bAllowRiders=true
    NewVehHitpoints(0)=(PointRadius=6.0,PointScale=1.0,PointBone="body",PointOffset=(X=50.0,Y=-37.0,Z=98.0),NewHitPointType=NHP_GunOptics)
    NewVehHitpoints(1)=(PointRadius=25.0,PointScale=1.0,PointBone="body",PointOffset=(X=50.0,Z=55.0),NewHitPointType=NHP_Traverse)
    NewVehHitpoints(2)=(PointRadius=25.0,PointScale=1.0,PointBone="body",PointOffset=(X=50.0,Z=55.0),NewHitPointType=NHP_GunPitch)
    MaxCriticalSpeed=638.0
    TreadDamageThreshold=1.0
    UFrontArmorFactor=15.0
    URightArmorFactor=8.0
    ULeftArmorFactor=8.0
    URearArmorFactor=8.0
    UFrontArmorSlope=50.0
    URightArmorSlope=25.0
    ULeftArmorSlope=25.0
    URearArmorSlope=30.0
    PointValue=5.0
    MaxPitchSpeed=50.0
    TreadVelocityScale=350.0
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L08'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_R08'
    RumbleSound=sound'Vehicle_Engines.interior.tank_inside_rumble02'
    LeftTrackSoundBone="Track_L"
    RightTrackSoundBone="Track_R"
    RumbleSoundBone="driver_attachment"
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.JT_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.JT_turret_look'
    VehicleHudThreadsPosX(0)=0.36
    VehicleHudThreadsPosY=0.52
    VehicleHudThreadsScale=0.72
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
    WheelRotationScale=800
    TreadHitMinAngle=1.9
    FrontLeftAngle=332.0
    RearLeftAngle=208.0
    GearRatios(1)=0.25
    GearRatios(3)=0.45
    GearRatios(4)=0.67
    TransRatio=0.07
    SteerSpeed=50.0
    SteerBoneName="Steering"
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-252.0,Y=24.0,Z=30.0),ExhaustRotation=(Pitch=22000))
    ExhaustPipes(1)=(ExhaustPosition=(X=-252.0,Y=-28.0,Z=30.0),ExhaustRotation=(Pitch=22000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdtigerCannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdtigerMountedMGPawn',WeaponBone="Mg_placement")
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdtigerPassengerOne',WeaponBone="body")
    PassengerWeapons(3)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdtigerPassengerTwo',WeaponBone="body")
    PassengerWeapons(4)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdtigerPassengerThree',WeaponBone="body")
    PassengerWeapons(5)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdtigerPassengerFour',WeaponBone="body")
    IdleSound=SoundGroup'Vehicle_Engines.Tiger.Tiger_engine_loop'
    StartUpSound=sound'Vehicle_Engines.Tiger.tiger_engine_start'
    ShutDownSound=sound'Vehicle_Engines.Tiger.tiger_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Jagdtiger.Jagdtiger_dest'
    DamagedEffectScale=1.25
    DamagedEffectOffset=(X=-135.0,Y=20.0,Z=20.0)
    SteeringScaleFactor=2.0
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Jagdtiger_anm.jagdtiger_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,ViewFOV=90.0,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Jagdtiger_anm.jagdtiger_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="VPanther_driver_close",ViewPitchUpLimit=4000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,ViewFOV=90.0)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Jagdtiger_anm.jagdtiger_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VPanther_driver_open",ViewPitchUpLimit=6000,ViewPitchDownLimit=65000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true,ViewFOV=90.0)
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.JT_body'
    VehicleHudOccupantsX(0)=0.45
    VehicleHudOccupantsX(1)=0.54
    VehicleHudOccupantsX(2)=0.56
    VehicleHudOccupantsX(3)=0.4
    VehicleHudOccupantsY(3)=0.69
    VehicleHudOccupantsX(4)=0.4
    VehicleHudOccupantsY(4)=0.79
    VehicleHudOccupantsX(5)=0.605
    VehicleHudOccupantsY(5)=0.79
    VehicleHudOccupantsX(6)=0.605
    VehicleHudOccupantsY(6)=0.69
    VehicleHudEngineY=0.75
    bVehicleHudUsesLargeTexture=true
    VehHitpoints(0)=(PointOffset=(X=8.0,Z=7.0),bPenetrationPoint=false)
    VehHitpoints(1)=(PointRadius=40.0,PointOffset=(X=-150.0,Z=-20.0),DamageMultiplier=1.0)
    VehHitpoints(2)=(PointRadius=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=-55.0,Y=-65.0,Z=4.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=-55.0,Y=65.0,Z=4.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(4)=(PointRadius=15.0,PointScale=1.0,PointBone="body",PointOffset=(Y=-65.0,Z=4.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(5)=(PointRadius=15.0,PointScale=1.0,PointBone="body",PointOffset=(Y=65.0,Z=4.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DriverAttachmentBone="driver_attachment"
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=25.0,Y=-10.0,Z=1.0)
        WheelRadius=38.0
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_JagdtigerTank.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=25.0,Y=10.0,Z=1.0)
        WheelRadius=38.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_JagdtigerTank.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-7.0,Y=-10.0,Z=1.0)
        WheelRadius=38.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_JagdtigerTank.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-7.0,Y=10.0,Z=1.0)
        WheelRadius=38.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_JagdtigerTank.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-10.0,Z=1.0)
        WheelRadius=38.0
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_JagdtigerTank.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-10.0,Z=1.0)
        WheelRadius=38.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_JagdtigerTank.Right_Drive_Wheel'
    VehicleMass=18.0
    bFPNoZFromCameraPitch=true
    DrivePos=(X=10.0,Y=2.0,Z=-25.0)
    DriveAnim="VPanther_driver_idle_close"
    ExitPositions(0)=(X=134.0,Y=-37.0,Z=85.0)
    ExitPositions(1)=(X=-45.0,Y=21.0,Z=155.0)
    ExitPositions(2)=(X=132.0,Y=41.0,Z=85.0)
    ExitPositions(3)=(X=-142.0,Y=-175.0,Z=-40.0)
    ExitPositions(4)=(X=-202.0,Y=-175.0,Z=-40.0)
    ExitPositions(5)=(X=-142.0,Y=175.0,Z=-40.0)
    ExitPositions(6)=(X=-202.0,Y=175.0,Z=-40.0)
    EntryRadius=375.0
    DriverDamageMult=1.0
    VehicleNameString="Jagdpanzer VI Ausf.B"
    MaxDesireability=1.9
    FlagBone="Mg_placement"
    FlagRotation=(Yaw=32768)
    PitchUpLimit=5000
    PitchDownLimit=60000
    HealthMax=700.0
    Health=700
    Mesh=SkeletalMesh'DH_Jagdtiger_anm.JagdTiger_body_ext'
    Skins(0)=texture'DH_VehiclesGE_tex2.ext_vehicles.JagdTiger_body_ext'
    Skins(1)=texture'DH_VehiclesGE_tex2.Treads.tiger2B_treads'
    Skins(2)=texture'DH_VehiclesGE_tex2.Treads.tiger2B_treads'
    Skins(3)=texture'DH_VehiclesGE_tex2.int_vehicles.tiger2B_body_int'
    Skins(4)=texture'DH_VehiclesGE_tex2.ext_vehicles.JagdTiger_skirtdetails'
    SoundPitch=32
    CollisionRadius=175.0
    CollisionHeight=60.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-2.0)
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_JagdtigerTank.KParams0'
    HighDetailOverlay=texture'DH_VehiclesGE_tex2.int_vehicles.tiger2B_body_int'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3
    LeftTreadPanDirection=(Pitch=0,Yaw=32768,Roll=16384)
    RightTreadPanDirection=(Pitch=32768,Yaw=0,Roll=16384)
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.jagdtiger'
}
