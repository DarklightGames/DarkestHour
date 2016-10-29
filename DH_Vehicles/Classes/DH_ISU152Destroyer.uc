//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

//============================================================================
// Original ISU-152 for Red Orchestra:
// Skins, models & animation by Paul Pepera (c) 2007-2008
// Sounds by Eric Parris (c) 2007-2008
//============================================================================

class DH_ISU152Destroyer extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_ISU152_anm.ukx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_Soviet_vehicles_stc.ukx // TODO: edit collision mesh to create a 'hole' allowing driver to be shot, as he is enveloped inside the hull collision
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesSOV_tex.utx

defaultproperties
{
    // Vehicle properties
    VehicleNameString="ISU-152"
    VehicleTeam=1
    MaxDesireability=1.9
    CollisionRadius=175.0
    CollisionHeight=60.0

    // Hull mesh
    Mesh=SkeletalMesh'DH_ISU152_anm.ISU152-body_ext'
    Skins(0)=texture'DH_VehiclesSOV_tex.ext_vehicles.isu152_body_ext'
    Skins(1)=texture'DH_VehiclesSOV_tex.Treads.isu152_treads'
    Skins(2)=texture'DH_VehiclesSOV_tex.Treads.isu152_treads'
    Skins(3)=texture'DH_VehiclesSOV_tex.int_vehicles.isu152_body_int'
    BeginningIdleAnim="driver_hatch_idle_close"

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ISU152CannonPawn',WeaponBone="Turret_Placement")

    // TODO: set up riders, incl ExitPositions & VehicleHudOccupantsX/Y
//    PassengerPawns(0)=(AttachBone="Body",DrivePos=(X=-59.0,Y=-50.0,Z=53.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider1_idle")
//    PassengerPawns(1)=(AttachBone="Body",DrivePos=(X=-151.0,Y=-65.0,Z=45.0),DriveAnim="VHalftrack_Rider3_idle")
//    PassengerPawns(2)=(AttachBone="Body",DrivePos=(X=-135.0,Y=35.0,Z=51.0),DriveRot=(Yaw=-32768),DriveAnim="VHalftrack_Rider5_idle")
//    PassengerPawns(3)=(AttachBone="Body",DrivePos=(X=-59.0,Y=50.0,Z=54.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider6_idle")

    // Driver
    DriverPositions(0)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'allies_isu152_anm.isu152_body_int',TransitionUpAnim="Overlay_Out",ViewPitchDownLimit=65535,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'allies_isu152_anm.isu152_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="VSU76_driver_close",ViewPitchUpLimit=1000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=2000,ViewNegativeYawLimit=-2000)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'allies_isu152_anm.isu152_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VSU76_driver_open",ViewPitchUpLimit=14500,ViewPitchDownLimit=57000,ViewPositiveYawLimit=10000,ViewNegativeYawLimit=-12000,bExposed=true)
    DriverAttachmentBone="driver_attachment"
    DrivePos=(X=10.0,Y=0.0,Z=-41.0) // adjusted from original
    DriveAnim="VIS2_driver_idle_close"
    HUDOverlayClass=class'ROVehicles.KV1DriverOverlay'
    HUDOverlayFOV=90.0

    // Hull armor
    UFrontArmorFactor=9.0
    URightArmorFactor=7.5
    ULeftArmorFactor=7.5
    URearArmorFactor=6.0
    UFrontArmorSlope=30.0
    URightArmorSlope=15.0
    ULeftArmorSlope=15.0
    URearArmorSlope=49.0
    FrontLeftAngle=322.0 // angles adjusted from original
    FrontRightAngle=38.0
    RearRightAngle=163.0
    RearLeftAngle=197.0

    // Movement
    GearRatios(4)=0.72
    TransRatio=0.09

    // Damage
    Health=650 // was 800 but adjusted to more in line with similar DH vehicles
    HealthMax=650.0
    DisintegrationHealth=-900.0
    VehHitpoints(0)=(PointRadius=35.0,PointBone="Engine",PointOffset=(X=-25.0,Y=0.0,Z=-5.0)) // engine
    VehHitpoints(1)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=-70.0,Y=50.0,Z=40.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=-20.0,Y=50.0,Z=40.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=-20.0,Y=10.0,Z=-20.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DriverDamageMult=1.0
    TreadHitMaxHeight=-5.0
    TreadDamageThreshold=0.75
    DamagedEffectOffset=(X=-210.0,Y=0.0,Z=40.0) // adjusted from original
    HullFireChance=0.55
    FireAttachBone="Body"
    FireEffectOffset=(X=90.0,Y=-28.0,Z=15.0)
    DestroyedVehicleMesh=StaticMesh'DH_Soviet_vehicles_stc.ISU152.ISU152_dest'

    // Exit positions
    ExitPositions(0)=(X=165.0,Y=-25.0,Z=50.0)  // driver
    ExitPositions(1)=(X=10.0,Y=50.0,Z=200.0)   // commander
//    ExitPositions(2)=(X=-43.0,Y=-125.0,Z=75.0) // riders
//    ExitPositions(3)=(X=-210.0,Y=-35.0,Z=75.0)
//    ExitPositions(4)=(X=-210.0,Y=37.0,Z=75.0)
//    ExitPositions(5)=(X=-43.0,Y=125.0,Z=75.0)

    // Sounds
    MaxPitchSpeed=100
    IdleSound=sound'Vehicle_Engines.IS2.IS2_engine_loop' // was SU76 engine sound but vehicle is built off IS2 chassis & engine
    StartUpSound=sound'Vehicle_Engines.IS2.IS2_engine_start'
    ShutDownSound=sound'Vehicle_Engines.IS2.IS2_engine_stop'
    LeftTrackSoundBone="Tread_L"
    RightTrackSoundBone="Tread_R"
    LeftTreadSound=sound'Vehicle_Engines.track_squeak_L03'
    RightTreadSound=sound'Vehicle_Engines.track_squeak_R03'
    RumbleSoundBone="Body"
    RumbleSound=sound'Vehicle_Engines.tank_inside_rumble02' // was custom 'ISU152_engine_loop', but using same as IS2 as same chassis & engine

    // Visual effects
    TreadVelocityScale=125.0
    ExhaustEffectClass=class'ROEffects.ExhaustDieselEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustDieselEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-220.0,Y=60.0,Z=30.0),ExhaustRotation=(Pitch=34000,Roll=-10000)) // positions adjusted from original
    ExhaustPipes(1)=(ExhaustPosition=(X=-220.0,Y=-60.0,Z=30.0),ExhaustRotation=(Pitch=34000,Roll=10000))
    LeftLeverBoneName="lever_L"
    LeftLeverAxis=AXIS_Z
    RightLeverBoneName="lever_R"
    RightLeverAxis=AXIS_Z
    SteeringScaleFactor=0.75

    // HUD
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.isu152_body'           // TODO: remove clockface & resize to 256x256 to match DH
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.isu152_turret_rot' // TODO: resize TexRotators to 256x256 to match DH
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.isu152_turret_look'
    VehicleHudTreadsPosX(0)=0.38 // some positions adjusted from original
    VehicleHudTreadsPosX(1)=0.64
    VehicleHudTreadsScale=0.7
    VehicleHudOccupantsX(0)=0.46
    VehicleHudOccupantsX(1)=0.592
    VehicleHudOccupantsX(2)=0.0 // 0.55
//    VehicleHudOccupantsX(3)=0.635
//    VehicleHudOccupantsX(4)=0.36
//    VehicleHudOccupantsX(5)=0.36
    VehicleHudOccupantsY(0)=0.26
    VehicleHudOccupantsY(1)=0.36
    VehicleHudOccupantsY(2)=0.0 // 0.65
//    VehicleHudOccupantsY(3)=0.75
//    VehicleHudOccupantsY(4)=0.75
//    VehicleHudOccupantsY(5)=0.65
//  SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.ISU152' // TODO: make one

    // Visible wheels
    WheelRotationScale=1000 // was 2500, but lowered to more closely match tread speed
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

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=30.0,Y=-10.0)
        WheelRadius=27.0
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_ISU152Destroyer.LF_Steering'

    Begin Object Class=SVehicleWheel Name=RF_Steering
    bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=30.0,Y=10.0)
        WheelRadius=27.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_ISU152Destroyer.RF_Steering'

    Begin Object Class=SVehicleWheel Name=LR_Steering
    bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-18.0,Y=-10.0)
        WheelRadius=26.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_ISU152Destroyer.LR_Steering'

    Begin Object Class=SVehicleWheel Name=RR_Steering
    bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-18.0,Y=10.0)
        WheelRadius=26.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_ISU152Destroyer.RR_Steering'

    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-10.0)
        WheelRadius=28.0
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_ISU152Destroyer.Left_Drive_Wheel'

    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=10.0)
        WheelRadius=28.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_ISU152Destroyer.Right_Drive_Wheel'

    // Karma
    VehicleMass=13.5
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-0.55) // default is -0.5
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=0.75 // default is 1.0
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_ISU152Destroyer.KParams0'
}
