//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Cromwell6PdrTank extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_Cromwell_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUK_tex.utx

// Modified to adjust size/proportions of texture overlay to match driver's glass vision block
simulated function DrawPeriscopeOverlay(Canvas Canvas)
{
    local float ScreenRatio;

    ScreenRatio = float(Canvas.SizeY) / float(Canvas.SizeX);
    Canvas.SetPos(0.0, 0.0);
    Canvas.DrawTile(PeriscopeOverlay, Canvas.SizeX, Canvas.SizeY, 0.0, (1.0 - ScreenRatio) * float(PeriscopeOverlay.VSize) * 0.6,
        PeriscopeOverlay.USize, float(PeriscopeOverlay.VSize) * ScreenRatio * 0.85);
}

defaultproperties
{
    UnbuttonedPositionIndex=1
    LeftTreadIndex=3
    MaxCriticalSpeed=1165.0
    TreadDamageThreshold=0.75
    UFrontArmorFactor=6.3
    URightArmorFactor=3.2
    ULeftArmorFactor=3.2
    URearArmorFactor=3.2
    PointValue=3.0
    MaxPitchSpeed=150.0
    TreadVelocityScale=78.0
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L07'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L07'
    RumbleSound=sound'Vehicle_Engines.interior.tank_inside_rumble02'
    LeftTrackSoundBone="Track_L"
    RightTrackSoundBone="Track_R"
    RumbleSoundBone="body"
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Cromwell_Turret_6pdr_Rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Cromwell_Turret_6pdr_Look'
    VehicleHudThreadsPosX(0)=0.35
    VehicleHudThreadsPosX(1)=0.65
    VehicleHudThreadsPosY=0.57
    VehicleHudThreadsScale=1.0
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
    WheelRotationScale=250
    TreadHitMinAngle=1.16
    FrontRightAngle=27.0
    RearRightAngle=153.0
    GearRatios(3)=0.6
    GearRatios(4)=0.8
    TransRatio=0.14
    SteerBoneName="Steering"
    LeftLeverBoneName="lever_L"
    LeftLeverAxis=AXIS_Z
    RightLeverBoneName="lever_R"
    RightLeverAxis=AXIS_Z
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-175.0,Y=30.0,Z=10.0),ExhaustRotation=(Pitch=36000))
    ExhaustPipes(1)=(ExhaustPosition=(X=-175.0,Y=-30.0,Z=10.0),ExhaustRotation=(Pitch=36000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Cromwell6PdrCannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_CromwellMountedMGPawn',WeaponBone="Mg_attachment")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-82.0,Y=-65.0,Z=45.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-151.0,Y=-65.0,Z=45.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-151.0,Y=66.0,Z=45.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(3)=(AttachBone="body",DrivePos=(X=-82.0,Y=66.0,Z=45.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider6_idle")
    IdleSound=SoundGroup'Vehicle_Engines.T34.t34_engine_loop'
    StartUpSound=sound'Vehicle_Engines.T34.t34_engine_start'
    ShutDownSound=sound'Vehicle_Engines.T34.t34_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Cromwell.Crommy_wrecked'
    DamagedEffectScale=0.9
    DamagedEffectOffset=(X=-130.0,Y=0.0,Z=85.0)
    VehicleTeam=1
    SteeringScaleFactor=0.75
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Cromwell_anm.Cromwell_body_int',TransitionUpAnim="driver_hatch_open",ViewPitchDownLimit=65535,ViewFOV=90.0,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Cromwell_anm.Cromwell_body_int',TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=8000,ViewPitchDownLimit=58000,ViewPositiveYawLimit=19000,ViewNegativeYawLimit=-20000,bExposed=true,ViewFOV=90.0)
    InitialPositionIndex=0
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.cromwell_body'
    VehicleHudOccupantsX(0)=0.56
    VehicleHudOccupantsY(0)=0.38
    VehicleHudOccupantsX(1)=0.45
    VehicleHudOccupantsY(1)=0.56
    VehicleHudOccupantsX(2)=0.46
    VehicleHudOccupantsY(2)=0.38
    VehicleHudOccupantsX(3)=0.41
    VehicleHudOccupantsY(3)=0.73
    VehicleHudOccupantsX(4)=0.41
    VehicleHudOccupantsY(4)=0.83
    VehicleHudOccupantsX(5)=0.60
    VehicleHudOccupantsY(5)=0.83
    VehicleHudOccupantsX(6)=0.60
    VehicleHudOccupantsY(6)=0.73
    VehicleHudEngineX=0.505
    VehicleHudEngineY=0.76
    VehHitpoints(0)=(PointRadius=35.0,PointOffset=(X=-95.0,Z=2.0)) // engine
    VehHitpoints(1)=(PointRadius=25.0,PointScale=1.0,PointBone="body",PointOffset=(X=-20.0,Y=40.0,Z=3.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=25.0,PointScale=1.0,PointBone="body",PointOffset=(X=-20.0,Y=-40.0,Z=3.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=25.0,PointScale=1.0,PointBone="body",PointOffset=(X=40.0,Z=-8.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DriverAttachmentBone="driver_attachment"
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=35.0,Y=-10.0,Z=2.0)
        WheelRadius=33.0
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_Cromwell6PdrTank.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=35.0,Y=10.0,Z=2.0)
        WheelRadius=33.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_Cromwell6PdrTank.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-12.0,Y=-10.0,Z=2.0)
        WheelRadius=33.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_Cromwell6PdrTank.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-12.0,Y=10.0,Z=2.0)
        WheelRadius=33.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_Cromwell6PdrTank.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=10.0,Z=2.0)
        WheelRadius=33.0
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_Cromwell6PdrTank.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-10.0,Z=2.0)
        WheelRadius=33.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_Cromwell6PdrTank.Right_Drive_Wheel'
    VehicleMass=13.0
    bFPNoZFromCameraPitch=true
    DrivePos=(X=-2.0,Y=-5.0,Z=2.0)
    DriveAnim="VUC_driver_idle_close"
    ExitPositions(0)=(X=125.0,Y=35.0,Z=175.0)   //driver
    ExitPositions(1)=(X=25.0,Y=-35.0,Z=250.0)   //commander
    ExitPositions(2)=(X=125.0,Y=35.0,Z=175.0)   //hull gun
    ExitPositions(3)=(X=-77.0,Y=-160.0,Z=75.0)
    ExitPositions(4)=(X=-142.0,Y=-160.0,Z=75.0)
    ExitPositions(6)=(X=-142.0,Y=160.0,Z=75.0)
    ExitPositions(5)=(X=-77.0,Y=160.0,Z=75.0)
    EntryRadius=375.0
    DriverDamageMult=1.0
    VehicleNameString="Cromwell Mk.I"
    MaxDesireability=1.9
    FlagBone="Mg_placement"
    FlagRotation=(Yaw=32768)
    PitchUpLimit=5000
    PitchDownLimit=60000
    HealthMax=525.0
    Health=525
    Mesh=SkeletalMesh'DH_Cromwell_anm.cromwell6pdr_body_ext'
    Skins(0)=texture'DH_VehiclesUK_tex.ext_vehicles.Cromwell_body_ext'
    Skins(1)=texture'DH_VehiclesUK_tex.ext_vehicles.Cromwell_armor_ext'
    Skins(2)=texture'DH_VehiclesUK_tex.Treads.Cromwell_treads'
    Skins(3)=texture'DH_VehiclesUK_tex.Treads.Cromwell_treads'
    Skins(4)=texture'DH_VehiclesUK_tex.int_vehicles.Cromwell_body_int'
    Skins(5)=texture'DH_VehiclesUK_tex.int_vehicles.Cromwell_body_int2'
    CollisionRadius=175.0
    CollisionHeight=60.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-0.6)
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_Cromwell6PdrTank.KParams0'
    LeftTreadPanDirection=(Pitch=0,Yaw=0,Roll=0)
    RightTreadPanDirection=(Pitch=0,Yaw=0,Roll=0)
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.cromwell_6pdr'
}
