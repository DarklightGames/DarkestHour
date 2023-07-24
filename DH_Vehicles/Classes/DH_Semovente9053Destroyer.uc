//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Semovente9053Destroyer extends DHArmoredVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Semovente da 90/53"
    VehicleMass=11.0 // 
    ReinforcementCost=4 // ?

    ShadowZOffset=60.0

    // Hull mesh
    Mesh=SkeletalMesh'DH_Semovente9053_anm.semovente9053_body_ext'
    Skins(0)=Texture'DH_Semovente9053_tex.semovente9053.semovente9053_body_tex'
    Skins(1)=Texture'DH_Semovente9053_tex.semovente9053.semovente9053_turret_tex'
    Skins(2)=Texture'DH_Semovente9053_tex.semovente9053.semovente9053_treads_tex'
    Skins(3)=Texture'DH_Semovente9053_tex.semovente9053.semovente9053_treads_tex'

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Semovente9053CannonPawn',WeaponBone="Turret_placement")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=7.5,Y=30.0,Z=41.0),DriveAnim="VUC_rider1_idle")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Semovente9053_anm.semovente9053_body_ext',TransitionUpAnim="driver_slit_close",ViewPitchUpLimit=2000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Semovente9053_anm.semovente9053_body_ext',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="driver_slit_open",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Semovente9053_anm.semovente9053_body_ext',TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true)
    DrivePos=(X=-5.0,Y=0.0,Z=2.0)
    DriveAnim="VPanzer3_driver_idle_open"

    // Hull armor
    FrontArmor(0)=(Thickness=1.5,Slope=-72.0,MaxRelativeHeight=-25.5,LocationName="lower nose") // measured most of the slopes in the hull mesh
    FrontArmor(1)=(Thickness=5.0,Slope=-16.0,MaxRelativeHeight=-2.0,LocationName="nose")
    FrontArmor(2)=(Thickness=1.5,Slope=68.0,MaxRelativeHeight=29.0,LocationName="glacis")
    FrontArmor(3)=(Thickness=1.0,Slope=30.0,LocationName="superstructure")
    RightArmor(0)=(Thickness=1.5,MaxRelativeHeight=5.0,LocationName="lower")
    RightArmor(1)=(Thickness=1.0,MaxRelativeHeight=29.0,LocationName="lower super")
    RightArmor(2)=(Thickness=1.0,Slope=15.0,LocationName="superstructure")
    LeftArmor(0)=(Thickness=1.5,MaxRelativeHeight=5.0,LocationName="lower")
    LeftArmor(1)=(Thickness=1.0,MaxRelativeHeight=29.0,LocationName="lower super")
    LeftArmor(2)=(Thickness=1.0,Slope=15.0,LocationName="superstructure")
    RearArmor(0)=(Thickness=1.5,Slope=-37.0,MaxRelativeHeight=4.8,LocationName="lower")
    RearArmor(1)=(Thickness=1.0,Slope=8.0,MaxRelativeHeight=29.0,LocationName="lower super")
    RearArmor(2)=(Thickness=1.0,Slope=17.0,LocationName="superstructure")

    FrontLeftAngle=330.0
    FrontRightAngle=30.0
    RearRightAngle=150.0
    RearLeftAngle=210.0

    // Movement
    MaxCriticalSpeed=729.0 // 43 kph
    GearRatios(4)=0.72
    TransRatio=0.1

    // Damage
	// cons: petrol fuel
	// note: 4 men crew
    Health=525
    HealthMax=525.0
	EngineHealth=300

    EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
    DisintegrationHealth=-800.0 //petrol

    VehHitpoints(0)=(PointRadius=30.0,PointBone="BODY",PointOffset=(X=-8,Z=51)) // engine
    VehHitpoints(1)=(PointRadius=22.0,PointBone="BODY",PointOffset=(X=-93,Y=22,Z=41),HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=22.0,PointBone="BODY",PointOffset=(X=-93,Y=-22.0,Z=41),HitPointType=HP_AmmoStore)
    NewVehHitpoints(0)=(PointRadius=20.0,PointBone="GUN_YAW",NewHitPointType=NHP_Traverse)
    NewVehHitpoints(1)=(PointRadius=20.0,PointBone="GUN_YAW",PointOffset=(X=-37.0887,Y=18.57,Z=19.6947),NewHitPointType=NHP_GunPitch)
    NewVehHitpoints(2)=(PointRadius=15.0,PointBone="GUN_YAW",PointOffset=(X=-15.5125,Y=-26.1281,Z=53.7762),NewHitPointType=NHP_GunOptics)

    TreadHitMaxHeight=-5.0
    TreadDamageThreshold=0.5
    DamagedEffectOffset=(X=30.0,Y=0.0,Z=20.0)
    FireEffectOffset=(X=10.0,Y=0.0,Z=-20.0)
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc3.Marder3.Marder3M_dest'

    // Exit Positions
    ExitPositions(0)=(X=51.73,Y=-29.58,Z=139.28) // EXIT_POSITION.001
    ExitPositions(1)=(X=-186.73,Y=-31.24,Z=59.66) // EXIT_POSITION.005
    ExitPositions(2)=(X=51.73,Y=-102.06,Z=59.66) // EXIT_POSITION.002
    ExitPositions(3)=(X=51.73,Y=31.24,Z=139.28) // EXIT_POSITION.003
    ExitPositions(4)=(X=51.73,Y=102.06,Z=59.66) // EXIT_POSITION.004
    ExitPositions(5)=(X=-186.73,Y=31.24,Z=59.66) // EXIT_POSITION.006

    // Sounds
    MaxPitchSpeed=450.0

    IdleSound=SoundGroup'Vehicle_Engines.Kv1s.KV1s_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.Kv1s.KV1s_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.Kv1s.KV1s_engine_stop'
    LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L03'
    RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_R03'
    RumbleSound=Sound'DH_AlliedVehicleSounds.Sherman.inside_rumble01'

    // Visual effects
    LeftTreadIndex=3
    TreadVelocityScale=300.0
    WheelRotationScale=110500.0

    ExhaustPipes(0)=(ExhaustPosition=(X=-110.64,Y=-68.79,Z=58.76),ExhaustRotation=(Roll=0,Pitch=1011,Yaw=-23232))
    ExhaustPipes(1)=(ExhaustPosition=(X=-110.64,Y=68.79,Z=58.76),ExhaustRotation=(Roll=0,Pitch=1011,Yaw=23596))

    LeftLeverBoneName="lever_L"
    RightLeverBoneName="lever_R"

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.MarderIII_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.MarderIII_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.MarderIII_turret_look'
    VehicleHudEngineX=0.51
    VehicleHudEngineY=0.47
    VehicleHudTreadsPosX(0)=0.36
    VehicleHudTreadsPosX(1)=0.64
    VehicleHudTreadsPosY=0.51
    VehicleHudTreadsScale=0.72
    VehicleHudOccupantsX(0)=0.55
    VehicleHudOccupantsY(0)=0.33
    VehicleHudOccupantsX(1)=0.45
    VehicleHudOccupantsY(1)=0.71
    VehicleHudOccupantsX(2)=0.55
    VehicleHudOccupantsY(2)=0.71
    VehicleHudOccupantsX(3)=0.575
    VehicleHudOccupantsY(3)=0.5
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.marder3'

    // Visible wheels
    LeftWheelBones(0)="WHEEL_B_01_L"
    LeftWheelBones(1)="WHEEL_B_02_L"
    LeftWheelBones(2)="WHEEL_B_03_L"
    LeftWheelBones(3)="WHEEL_B_04_L"
    LeftWheelBones(4)="WHEEL_B_05_L"
    LeftWheelBones(5)="WHEEL_B_06_L"
    LeftWheelBones(6)="WHEEL_B_07_L"
    LeftWheelBones(7)="WHEEL_B_08_L"
    LeftWheelBones(8)="WHEEL_T_01_L"
    LeftWheelBones(9)="WHEEL_T_02_L"
    LeftWheelBones(10)="WHEEL_T_03_L"
    LeftWheelBones(11)="WHEEL_F_L"
    LeftWheelBones(12)="WHEEL_R_L"
    RightWheelBones(0)="WHEEL_B_01_R"
    RightWheelBones(1)="WHEEL_B_02_R"
    RightWheelBones(2)="WHEEL_B_03_R"
    RightWheelBones(3)="WHEEL_B_04_R"
    RightWheelBones(4)="WHEEL_B_05_R"
    RightWheelBones(5)="WHEEL_B_06_R"
    RightWheelBones(6)="WHEEL_B_07_R"
    RightWheelBones(7)="WHEEL_B_08_R"
    RightWheelBones(8)="WHEEL_T_01_R"
    RightWheelBones(9)="WHEEL_T_02_R"
    RightWheelBones(10)="WHEEL_T_03_R"
    RightWheelBones(11)="WHEEL_F_R"
    RightWheelBones(12)="WHEEL_R_R"

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        WheelRadius=28.0
        bLeftTrack=true
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_Semovente9053Destroyer.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        WheelRadius=28.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_Semovente9053Destroyer.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        WheelRadius=28.0
        bLeftTrack=true
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_Semovente9053Destroyer.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        WheelRadius=28.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_Semovente9053Destroyer.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=28.0
        bLeftTrack=true
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_Semovente9053Destroyer.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=28.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_Semovente9053Destroyer.Right_Drive_Wheel'

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=-0.25,Z=1.25)
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_Semovente9053Destroyer.KParams0'
    LeftTreadPanDirection=(Pitch=0,Yaw=32768,Roll=16384)
    RightTreadPanDirection=(Pitch=32768,Yaw=0,Roll=16384)

    LeftTrackSoundBone="DRIVE_WHEEL_L"
    RightTrackSoundBone="DRIVE_WHEEL_R"

    CollisionAttachments(0)=(StaticMesh=StaticMesh'DH_Semovente9053_stc.semovente9053_hatch_collision',AttachBone="driver_hatch")

    // Shell attachments
    VehicleAttachments(0)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_Semovente9053_stc.deco.semovente9053_shell',Offset=(X=-116.391,Y=-31.8017,Z=46.0125))
    VehicleAttachments(1)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_Semovente9053_stc.deco.semovente9053_shell',Offset=(X=-116.391,Y=-21.5638,Z=46.0125))
    VehicleAttachments(2)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_Semovente9053_stc.deco.semovente9053_shell',Offset=(X=-116.391,Y=-26.7217,Z=37.901))
    VehicleAttachments(3)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_Semovente9053_stc.deco.semovente9053_shell',Offset=(X=-116.391,Y=-16.4839,Z=37.901))
    VehicleAttachments(4)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_Semovente9053_stc.deco.semovente9053_shell',Offset=(X=-116.391,Y=21.542,Z=46.0125))
    VehicleAttachments(5)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_Semovente9053_stc.deco.semovente9053_shell',Offset=(X=-116.391,Y=31.7799,Z=46.0125))
    VehicleAttachments(6)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_Semovente9053_stc.deco.semovente9053_shell',Offset=(X=-116.391,Y=16.4621,Z=37.901))
    VehicleAttachments(7)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_Semovente9053_stc.deco.semovente9053_shell',Offset=(X=-116.391,Y=26.7,Z=37.901))
}
