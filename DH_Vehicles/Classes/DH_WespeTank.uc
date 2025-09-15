//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// https://tanks-encyclopedia.com/ww2/nazi_germany/sdkfz-124_wespe.php
//==============================================================================
// BUGS
//==============================================================================
// [ ] water hit sound on the 105 shell can be heard from infinity (splash sound
// probably has no distant variant or is using enormous transient radius).
//==============================================================================

class DH_WespeTank extends DHArmoredVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Sd.Kfz. 124 Wespe"
    VehicleTeam=0
    VehicleMass=11.5
    ReinforcementCost=5

    MapIconMaterial=Texture'DH_InterfaceArt2_tex.tank_artillery_topdown'

    // Artillery
    bIsArtilleryVehicle=true

    // Hull mesh
    Mesh=SkeletalMesh'DH_Wespe_anm.WESPE_BODY_EXT'
    Skins(0)=Texture'DH_Wespe_tex.wespe_body_ext_camo'
    Skins(1)=Texture'DH_Wespe_tex.wespe_treads'
    Skins(2)=Texture'DH_Wespe_tex.wespe_treads'
    Skins(3)=Texture'DH_Wespe_tex.wespe_body_int'

    CollisionAttachments(0)=(StaticMesh=StaticMesh'DH_Wespe_stc.wespe_hatch_collision_front',AttachBone="driver_hatch_front")
    CollisionAttachments(1)=(StaticMesh=StaticMesh'DH_Wespe_stc.wespe_hatch_collision_top_front',AttachBone="driver_hatch_top_01")
    CollisionAttachments(2)=(StaticMesh=StaticMesh'DH_Wespe_stc.wespe_hatch_collision_top_back',AttachBone="driver_hatch_top_02")

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_WespeCannonPawn',WeaponBone="turret_placement")

    // Driver
    UnbuttonedPositionIndex=3
    InitialPositionIndex=2
    PeriscopePositionIndex=1
    PeriscopeCameraBone="PERISCOPE_CAMERA"

    bLockCameraDuringTransition=true

    BeginningIdleAnim="idle"

    DriveAnim="wespe_driver_idle"
    DriverAttachmentBone="body"
    DrivePos=(Z=58)

    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Wespe_anm.wespe_body_int',TransitionUpAnim="hatch_close",ViewPitchUpLimit=4096,ViewPitchDownLimit=61440,ViewPositiveYawLimit=8192,ViewNegativeYawLimit=-8192,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Wespe_anm.wespe_body_int',TransitionUpAnim="overlay_out",TransitionDownAnim="hatch_open",ViewPitchUpLimit=1,ViewPitchDownLimit=65536,ViewPositiveYawLimit=0,ViewNegativeYawLimit=-1,bDrawOverlays=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Wespe_anm.wespe_body_int',DriverTransitionAnim="wespe_driver_lower",TransitionUpAnim="raise",TransitionDownAnim="overlay_in",ViewPitchUpLimit=8192,ViewPitchDownLimit=56000,ViewPositiveYawLimit=22000,ViewNegativeYawLimit=-22000)
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_Wespe_anm.wespe_body_int',DriverTransitionAnim="wespe_driver_raise",TransitionDownAnim="lower",ViewPitchUpLimit=8192,ViewPitchDownLimit=56000,ViewPositiveYawLimit=22000,ViewNegativeYawLimit=-22000,bExposed=true)

    // Hull armor
    FrontArmor(0)=(Thickness=3.0,Slope=-70.0,MaxRelativeHeight=30.6597)
    FrontArmor(1)=(Thickness=3.0,Slope=-20.0,MaxRelativeHeight=56.3219)
    FrontArmor(2)=(Thickness=5.08,Slope=75.0,MaxRelativeHeight=85.894)
    FrontArmor(3)=(Thickness=1.0,Slope=18.0)

    RightArmor(0)=(Thickness=1.45,MaxRelativeHeight=85.894)
    RightArmor(1)=(Thickness=1.0)

    LeftArmor(0)=(Thickness=1.45,MaxRelativeHeight=85.894)
    LeftArmor(1)=(Thickness=1.0)

    RearArmor(0)=(Thickness=3.81,MaxRelativeHeight=85.894)
    RearArmor(1)=(Thickness=1.0)

    FrontLeftAngle=334.7
    FrontRightAngle=26.7
    RearRightAngle=153.4
    RearLeftAngle=206.6

    // Movement
    GearRatios(4)=0.72
    TransRatio=0.1

    // Damage
    Health=620
    HealthMax=620.0
    EngineHealth=300
    EngineToHullFireChance=0.1
    DisintegrationHealth=-800.0
    VehHitpoints(0)=(HitPointType=HP_Engine,PointRadius=30.0,PointBone="body",PointOffset=(X=-22.0,Z=52.0))
    VehHitpoints(1)=(HitPointType=HP_AmmoStore,PointRadius=20.0,PointBone="body",PointOffset=(X=-117,Y=50,Z=78),DamageMultiplier=5.0)
    VehHitpoints(2)=(HitPointType=HP_AmmoStore,PointRadius=20.0,PointBone="body",PointOffset=(X=-77,Y=50,Z=78),DamageMultiplier=5.0)
    VehHitpoints(3)=(HitPointType=HP_AmmoStore,PointRadius=20.0,PointBone="body",PointOffset=(X=-117,Y=-50,Z=78),DamageMultiplier=5.0)
    VehHitpoints(4)=(HitPointType=HP_AmmoStore,PointRadius=20.0,PointBone="body",PointOffset=(X=-77,Y=-50,Z=78),DamageMultiplier=5.0)
    VehHitpoints(5)=(HitPointType=HP_AmmoStore,PointRadius=16.0,PointBone="body",PointOffset=(X=-124,Y=-26,Z=52),DamageMultiplier=5.0)
    VehHitpoints(6)=(HitPointType=HP_AmmoStore,PointRadius=16.0,PointBone="body",PointOffset=(X=-124,Y=26,Z=52),DamageMultiplier=5.0)
    TreadHitMaxHeight=-30.0

    DamagedEffectScale=0.9
    DamagedEffectOffset=(X=-100.0,Y=0.0,Z=70.0)

    FireAttachBone="Body"
    FireEffectOffset=(X=80,Y=-20,Z=70)

    DestroyedVehicleMesh=StaticMesh'DH_Wespe_stc.WESPE_DESTROYED'

    LeftTrackSoundBone="DRIVE_WHEEL_L"
    RightTrackSoundBone="DRIVE_WHEEL_R"
    DamagedTrackStaticMeshLeft=StaticMesh'DH_Wespe_stc.wespe_track_destroyed_l'
    DamagedTrackStaticMeshRight=StaticMesh'DH_Wespe_stc.wespe_track_destroyed_r'

    // Exit
    ExitPositions(0)=(X=50.0,Y=-130.0,Z=58.0)
    ExitPositions(1)=(X=-200.0,Y=0.0,Z=58.0)
    ExitPositions(2)=(X=-50.0,Y=-130.0,Z=58.0)
    ExitPositions(3)=(X=0.0,Y=130.0,Z=58.0)
    ExitPositions(4)=(X=15.0,Y=-130.0,Z=58.0)
    ExitPositions(5)=(X=-52.0,Y=130.0,Z=58.0)
    ExitPositions(6)=(X=-120.0,Y=-130.0,Z=58.0)
    ExitPositions(7)=(X=-120.0,Y=130.0,Z=58.0)

    // Sounds
    IdleSound=SoundGroup'Vehicle_Engines.KV1s_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.KV1s_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.KV1s_engine_stop'
    LeftTreadSound=Sound'Vehicle_Engines.track_squeak_L03'
    RightTreadSound=Sound'Vehicle_Engines.track_squeak_R03'
    RumbleSound=Sound'DH_AlliedVehicleSounds.inside_rumble01'
    RumbleSoundBone="DRIVER_CAMERA"
    PlayerCameraBone="DRIVER_CAMERA"

    // Visual effects
    LeftTreadIndex=1
    RightTreadIndex=2
    LeftTreadPanDirection=(Pitch=0,Yaw=0,Roll=0)
    RightTreadPanDirection=(Pitch=0,Yaw=0,Roll=0)
    TreadVelocityScale=110.0
    WheelRotationScale=42250.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-140.30823,Y=37.3244,Z=60.6315),ExhaustRotation=(Pitch=0,Yaw=16384))
    LeftLeverBoneName="LEVER_L"
    LeftLeverAxis=AXIS_Z
    RightLeverBoneName="LEVER_R"
    RightLeverAxis=AXIS_Z

    // HUD
    VehicleHudImage=Texture'DH_Wespe_tex.wespe_body_icon'
    VehicleHudTurret=TexRotator'DH_Wespe_tex.wespe_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Wespe_tex.wespe_turret_look'
    VehicleHudTreadsPosX(0)=0.325
    VehicleHudTreadsPosX(1)=0.675
    VehicleHudTreadsPosY=0.5
    VehicleHudTreadsScale=0.725
    VehicleHudOccupantsX(0)=0.455
    VehicleHudOccupantsY(0)=0.3
    VehicleHudOccupantsX(1)=0.4
    VehicleHudOccupantsY(1)=0.7
    SpawnOverlay(0)=Material'DH_Wespe_tex.wespe_profile_icon'
    VehicleHudEngineX=0.5
    VehicleHudEngineY=0.75

    // Visible wheels
    LeftWheelBones(0)="WHEEL_01_L"
    LeftWheelBones(1)="WHEEL_02_L"
    LeftWheelBones(2)="WHEEL_03_L"
    LeftWheelBones(3)="WHEEL_04_L"
    LeftWheelBones(4)="WHEEL_05_L"
    LeftWheelBones(5)="WHEEL_06_L"
    LeftWheelBones(6)="WHEEL_07_L"
    LeftWheelBones(7)="WHEEL_08_L"
    LeftWheelBones(8)="WHEEL_09_L"
    LeftWheelBones(9)="WHEEL_10_L"
    RightWheelBones(0)="WHEEL_01_R"
    RightWheelBones(1)="WHEEL_02_R"
    RightWheelBones(2)="WHEEL_03_R"
    RightWheelBones(3)="WHEEL_04_R"
    RightWheelBones(4)="WHEEL_05_R"
    RightWheelBones(5)="WHEEL_06_R"
    RightWheelBones(6)="WHEEL_07_R"
    RightWheelBones(7)="WHEEL_08_R"
    RightWheelBones(8)="WHEEL_09_R"
    RightWheelBones(9)="WHEEL_10_R"

    ShadowZOffset=40.0

    VehicleAttachments(0)=(AttachClass=Class'DH_WespeIdentifierAttachment',AttachBone="BODY",Skins=(Texture'DH_Wespe_tex.wespe_body_ext_camo',Texture'DH_Wespe_tex.wespe_body_ext_camo',Texture'DH_Wespe_tex.wespe_body_ext_camo',Texture'DH_Wespe_tex.wespe_body_ext_camo'))

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=STEER_WHEEL_F_L
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="STEER_WHEEL_F_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=24.0
        bLeftTrack=true
    End Object
    Wheels(0)=STEER_WHEEL_F_L
    Begin Object Class=SVehicleWheel Name=STEER_WHEEL_F_R
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="STEER_WHEEL_F_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=24.0
    End Object
    Wheels(1)=STEER_WHEEL_F_R
    Begin Object Class=SVehicleWheel Name=STEER_WHEEL_B_L
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="STEER_WHEEL_B_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=24.0
        bLeftTrack=true
    End Object
    Wheels(2)=STEER_WHEEL_B_L
    Begin Object Class=SVehicleWheel Name=STEER_WHEEL_B_R
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="STEER_WHEEL_B_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=24.0
    End Object
    Wheels(3)=STEER_WHEEL_B_R
    Begin Object Class=SVehicleWheel Name=DRIVE_WHEEL_L
        bPoweredWheel=true
        BoneName="DRIVE_WHEEL_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=24.0
        bLeftTrack=true
    End Object
    Wheels(4)=DRIVE_WHEEL_L
    Begin Object Class=SVehicleWheel Name=DRIVE_WHEEL_R
        bPoweredWheel=true
        BoneName="DRIVE_WHEEL_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=24.0
    End Object
    Wheels(5)=DRIVE_WHEEL_R

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=0.3)
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
    KParams=KParams0
}
