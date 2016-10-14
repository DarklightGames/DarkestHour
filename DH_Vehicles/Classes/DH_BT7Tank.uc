//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_BT7Tank extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\Animations\allies_ahz_bt7_anm.ukx
#exec OBJ LOAD FILE=..\StaticMeshes\allies_ahz_vehicles_stc.usx
#exec OBJ LOAD FILE=..\Textures\allies_ahz_vehicles_tex.utx

defaultproperties
{
    // Vehicle properties
    VehicleNameString="BT-7"
    VehicleTeam=1
    PointValue=2.0
    MaxDesireability=1.5
    CollisionRadius=150.0
    CollisionHeight=70.0

    // Hull mesh
    Mesh=SkeletalMesh'allies_ahz_bt7_anm.bt7_body_ext'
    Skins(0)=texture'allies_ahz_vehicles_tex.ext_vehicles.BT7_ext'
    Skins(1)=texture'allies_ahz_vehicles_tex.Treads.bt7_treads'
    Skins(2)=texture'allies_ahz_vehicles_tex.Treads.bt7_treads'
    Skins(3)=texture'allies_ahz_vehicles_tex.int_vehicles.BT7_int'
    BeginningIdleAnim="driver_hatch_idle_close"

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_BT7CannonPawn',WeaponBone=Turret_Placement)
    PassengerPawns(0)=(AttachBone="passenger_01",DrivePos=(X=0.0,Y=0.0,Z=20.0),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(1)=(AttachBone="passenger_02",DrivePos=(X=0.0,Y=0.0,Z=20.0),DriveAnim="VHalftrack_Rider2_idle")
    PassengerPawns(2)=(AttachBone="passenger_03",DrivePos=(X=0.0,Y=0.0,Z=20.0),DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(3)=(AttachBone="passenger_04",DrivePos=(X=0.0,Y=0.0,Z=20.0),DriveAnim="VHalftrack_Rider4_idle")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'allies_ahz_bt7_anm.BT7_body_int',DriverTransitionAnim=none,TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=0,ViewNegativeYawLimit=0,bExposed=false,bDrawOverlays=true,ViewFOV=90.0)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'allies_ahz_bt7_anm.BT7_body_int',DriverTransitionAnim="VT60_driver_close",TransitionUpAnim="driver_hatch_open",TransitionDownAnim=Overlay_In,ViewPitchUpLimit=2730,ViewPitchDownLimit=61923,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bExposed=false,ViewFOV=90.0)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'allies_ahz_bt7_anm.BT7_body_int',DriverTransitionAnim="VT60_driver_open",TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=2730,ViewPitchDownLimit=60000,ViewPositiveYawLimit=9500,ViewNegativeYawLimit=-9500,bExposed=true,ViewFOV=90.0)
    DriverAttachmentBone="driver_attachment"
    DrivePos=(X=35.0,Y=0.0,Z=-5.0)
    DriveAnim="VT60_driver_idle_close"
    HUDOverlayClass=class'ROVehicles.IS2DriverOverlay'
    HUDOverlayOffset=(X=-0.25,Y=0.0,Z=0.75)
    HUDOverlayFOV=90.0

    // Hull armor
    UFrontArmorFactor=3.0
    URightArmorFactor=1.3
    ULeftArmorFactor=1.3
    URearArmorFactor=1.3
    UFrontArmorSlope=15.0
    URearArmorSlope=10.0

    // Movement
    MaxCriticalSpeed=1057.0 // 63 kph // TODO: perhaps a little high?
    GearRatios(0)=-0.25
    GearRatios(1)=0.25
    GearRatios(2)=0.4
    GearRatios(3)=0.65
    GearRatios(4)=0.7
    TransRatio=0.13 // max speed is 38kph cross country

    // Damage
    Health=375
    HealthMax=375.0
    DisintegrationHealth=-1000
    VehHitpoints(0)=(PointRadius=30.0,PointOffset=(X=-60.0,Y=0.0,Z=-5.0)) // engine
    VehHitpoints(1)=(PointRadius=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=55.0,Y=30.0,Z=10.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=55.0,Y=-30.0,Z=10.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DriverDamageMult=1.0
    TreadHitMinAngle=1.9 // TODO: repl with min hit height
    HullFireChance=0.5
    DamagedEffectScale=0.8
    DamagedEffectOffset=(X=-100.0,Y=20.0,Z=26.0)
    FireAttachBone="Body"
    FireEffectOffset=(X=110.0,Y=35.0,Z=25.0) // TODO: set
    DestroyedVehicleMesh=StaticMesh'allies_ahz_vehicles_stc.BT7_destroyed'

    // Exit positions // TODO: need setting
    ExitPositions(0)=(X=100.0,Y=80.0,Z=100.0)   // driver
    ExitPositions(1)=(X=25.0,Y=-35.0,Z=250.0)   // commander
    ExitPositions(2)=(X=-60.0,Y=-100.0,Z=100.0) // riders
    ExitPositions(3)=(X=-100.0,Y=-100.0,Z=100.0)
    ExitPositions(4)=(X=-100.0,Y=100.0,Z=100.0)
    ExitPositions(5)=(X=-60.0,Y=100.0,Z=100.0)

    // Sounds
    SoundPitch=32 // half normal pitch = 1 octave lower
    MaxPitchSpeed=50.0
    IdleSound=SoundGroup'Vehicle_Engines.T34.t34_engine_loop'
    StartUpSound=sound'Vehicle_Engines.T34.t34_engine_start'
    ShutDownSound=sound'Vehicle_Engines.T34.t34_engine_stop'
    LeftTrackSoundBone="Track_l"
    RightTrackSoundBone="Track_r"
    LeftTreadSound=sound'Vehicle_Engines.track_squeak_L09'
    RightTreadSound=sound'Vehicle_Engines.track_squeak_R09'
    RumbleSoundBone="body"
    RumbleSound=sound'Vehicle_Engines.tank_inside_rumble01'

    // Visual effects
    TreadVelocityScale=400.0 // TODO: check
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-185.0,Y=23.0,Z=48.0),ExhaustRotation=(Pitch=34000,Yaw=0,Roll=0))
    ExhaustPipes(1)=(ExhaustPosition=(X=-185.0,Y=-23.0,Z=48.0),ExhaustRotation=(Pitch=34000,Yaw=0,Roll=0))
    SteerBoneName="steering_wheel"
    SteeringScaleFactor=4.0

    // HUD
    VehicleHudImage=texture 'InterfaceArt_ahz_tex.Tank_Hud.BT7_body'
    VehicleHudTurret=TexRotator'InterfaceArt_ahz_tex.Tank_Hud.BT7_turret_rot'
    VehicleHudTurretLook=TexRotator'InterfaceArt_ahz_tex.Tank_Hud.BT7_turret_look'
    VehicleHudEngineX=0.511
    VehicleHudEngineY=0.66
    VehicleHudTreadsPosX(0)=0.38
    VehicleHudTreadsPosX(1)=0.63
    VehicleHudTreadsPosY=0.52
    VehicleHudTreadsScale=0.55
    VehicleHudOccupantsX(0)=0.5
    VehicleHudOccupantsY(0)=0.26
    VehicleHudOccupantsX(1)=0.47
    VehicleHudOccupantsY(1)=0.5
    VehicleHudOccupantsX(2)=0.635
    VehicleHudOccupantsY(2)=0.65
    VehicleHudOccupantsX(3)=0.635
    VehicleHudOccupantsY(3)=0.75
    VehicleHudOccupantsX(4)=0.36
    VehicleHudOccupantsY(4)=0.75
    VehicleHudOccupantsX(5)=0.36
    VehicleHudOccupantsY(5)=0.65
//  SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.BT-7' // TODO: make one

    // Visible wheels
    WheelRotationScale=2000 // TODO: check
    LeftWheelBones(0)="Wheel_L_1"
    LeftWheelBones(1)="Wheel_L_2"
    LeftWheelBones(2)="Wheel_L_3"
    LeftWheelBones(3)="Wheel_L_4"
    LeftWheelBones(4)="Wheel_L_5"
    LeftWheelBones(5)="Wheel_L_6"
    RightWheelBones(0)="Wheel_R_1"
    RightWheelBones(1)="Wheel_R_2"
    RightWheelBones(2)="Wheel_R_3"
    RightWheelBones(3)="Wheel_R_4"
    RightWheelBones(4)="Wheel_R_5"
    RightWheelBones(5)="Wheel_R_6"

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        BoneOffset=(X=35.0,Y=-7.0,Z=5.0)
        SteerType=VST_Steered
        BoneName="Steer_Wheel_LF"
        BoneRollAxis=AXIS_Y
        WheelRadius=33.0
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_BT7Tank.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        BoneOffset=(X=35.0,Y=7.0,Z=5.0)
        SteerType=VST_Steered
        BoneName="Steer_Wheel_RF"
        BoneRollAxis=AXIS_Y
        WheelRadius=33.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_BT7Tank.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        BoneOffset=(X=-25.0,Y=-7.0,Z=5.0)
        SteerType=VST_Inverted
        BoneName="Steer_Wheel_LR"
        BoneRollAxis=AXIS_Y
        WheelRadius=33.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_BT7Tank.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        BoneOffset=(X=-25.0,Y=7.0,Z=5.0)
        SteerType=VST_Inverted
        BoneName="Steer_Wheel_RR"
        BoneRollAxis=AXIS_Y
        WheelRadius=33.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_BT7Tank.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneOffset=(X=5.0,Y=7.0,Z=5.0)
        BoneName="Drive_Wheel_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=33.0
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_BT7Tank.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneOffset=(X=5.0,Y=-7.0,Z=5.0)
        BoneName="Drive_Wheel_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=33.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_BT7Tank.Right_Drive_Wheel'

    // Karma
    VehicleMass=10.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=-0.0,Y=0.0,Z=-0.5)
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
        KMaxAngularSpeed=1.0
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_BT7Tank.KParams0'
}
