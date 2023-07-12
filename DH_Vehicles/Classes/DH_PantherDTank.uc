//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PantherDTank extends DHArmoredVehicle;

// Hack to stop panther camo variants without a matching schurzen texture from spawning schurzen
simulated function SpawnVehicleAttachments()
{
    if (RandomAttachment.Skins[0] == none)
    {
        RandomAttachOptions.Length = 0;
    }

    super.SpawnVehicleAttachments();
}

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Panzer V 'Panther' Ausf.D"
    VehicleMass=14.0
    ReinforcementCost=5

    // Hull mesh
    Mesh=SkeletalMesh'DH_Panther_anm.Panther_body_ext'
    Skins(0)=Texture'axis_vehicles_tex.ext_vehicles.pantherg_ext'
    Skins(1)=Texture'axis_vehicles_tex.Treads.PantherG_treads'
    Skins(2)=Texture'axis_vehicles_tex.Treads.PantherG_treads'
    Skins(3)=Texture'axis_vehicles_tex.int_vehicles.pantherg_int'
    HighDetailOverlay=Shader'axis_vehicles_tex.int_vehicles.pantherg_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PantherDCannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_PantherMountedMGPawn',WeaponBone="Mg_placement")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-96.0,Y=-76.5,Z=55.5),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider6_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-180.0,Y=-76.5,Z=55.5),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-150.0,Y=76.5,Z=55.5),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(3)=(AttachBone="body",DrivePos=(X=-96.0,Y=76.5,Z=55.5),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider1_idle")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Panther_anm.Panther_body_int',TransitionUpAnim="driver_hatch_open",DriverTransitionAnim="VPanther_driver_close",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Panther_anm.Panther_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VPanther_driver_open",ViewPitchUpLimit=8000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true)
    InitialPositionIndex=0
    UnbuttonedPositionIndex=1
    DriveAnim="VPanther_driver_idle_close"
    PeriscopeOverlay=Texture'DH_VehicleOptics_tex.General.PERISCOPE_overlay_German'

    // Hull armor
    FrontArmor(0)=(Thickness=6.5,Slope=-55.0,MaxRelativeHeight=-8.0,LocationName="lower")
    FrontArmor(1)=(Thickness=8.5,Slope=55.0,LocationName="upper")
    RightArmor(0)=(Thickness=4.5,MaxRelativeHeight=23.0,LocationName="lower")
    RightArmor(1)=(Thickness=4.0,Slope=30.0,LocationName="upper")
    LeftArmor(0)=(Thickness=4.5,MaxRelativeHeight=23.0,LocationName="lower")
    LeftArmor(1)=(Thickness=4.0,Slope=30.0,LocationName="upper")
    RearArmor(0)=(Thickness=4.0,Slope=-30.0)

    FrontLeftAngle=334.0
    FrontRightAngle=26.0
    RearRightAngle=154.0
    RearLeftAngle=206.0

    // Movement
    bTurnInPlace=true // don't think this affects panther's ability to turn, i.e. to neutral turn; think it's just a bot property
    GearRatios(4)=0.8
    TransRatio=0.11
    ChangeUpPoint=1990.0
    ChangeDownPoint=1000.0

    // Damage
    // pros: 5 men crew;
    // cons: petrol fuel; general unreliability of the panthers; this variant in particular is an early one which was even more unreliable
    Health=560
    HealthMax=560.0
    EngineHealth=200 //engine health is lowered for above reason
    EngineRestartFailChance=0.4 //unreliability

    EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
    DisintegrationHealth=-800.0 //petrol

    VehHitpoints(0)=(PointRadius=32.0,PointHeight=35.0,PointOffset=(X=-90.0,Z=6.0)) // engine
    VehHitpoints(1)=(PointRadius=15.0,PointHeight=30.0,PointScale=1.0,PointBone="body",PointOffset=(X=20.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=15.0,PointHeight=10.0,PointScale=1.0,PointBone="body",PointOffset=(X=-20.0,Y=-40.0,Z=40.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=15.0,PointHeight=10.0,PointScale=1.0,PointBone="body",PointOffset=(X=-20.0,Y=40.0,Z=40.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    TreadHitMaxHeight=0.0
    TreadDamageThreshold=0.85
    DamagedEffectOffset=(X=-100.0,Y=20.0,Z=26.0)
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherG_Destroyed0'

    // Exit
    ExitPositions(0)=(X=123.0,Y=-28.0,Z=105.0) // driver
    ExitPositions(1)=(X=-91.0,Y=20.0,Z=110.0)  // commander
    ExitPositions(2)=(X=128.0,Y=39.0,Z=105.0)  // hull MG
    ExitPositions(3)=(X=-95.0,Y=-160.0,Z=5.0)  // riders
    ExitPositions(4)=(X=-176.0,Y=-162.0,Z=5.0)
    ExitPositions(5)=(X=-176.0,Y=162.0,Z=5.0)
    ExitPositions(6)=(X=-95.0,Y=160.0,Z=5.0)

    // Sounds
    SoundPitch=32
    MaxPitchSpeed=100.0
    IdleSound=SoundGroup'Vehicle_Engines.Tiger.Tiger_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.Tiger.tiger_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.Tiger.tiger_engine_stop'
    LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L05'
    RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_R05'
    RumbleSound=Sound'Vehicle_Engines.interior.tank_inside_rumble02'
    RumbleSoundBone="driver_attachment"

    // Visual effects
    TreadVelocityScale=225.0
    WheelRotationScale=81250.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-230.0,Y=20.0,Z=65.0),ExhaustRotation=(Pitch=22000))
    ExhaustPipes(1)=(ExhaustPosition=(X=-230.0,Y=-20.0,Z=65.0),ExhaustRotation=(Pitch=22000))
    RandomAttachment=(AttachBone="body",Skins=(none)) // TODO: we don't have a schurzen skin for this camo variant, so add here if one gets made
    RandomAttachOptions(0)=(StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherSchurzen1',PercentChance=30) // undamaged schurzen
    RandomAttachOptions(1)=(StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherSchurzen2',PercentChance=15) // missing front panel on right & middle panel on left
    RandomAttachOptions(2)=(StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherSchurzen3',PercentChance=10) // with front panels missing on both sides
    RandomAttachOptions(3)=(StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherSchurzen4',PercentChance=15) // most badly damaged, with 3 panels missing

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.panther_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.panther_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.panther_turret_look'
    VehicleHudTreadsPosX(0)=0.38
    VehicleHudTreadsPosX(1)=0.63
    VehicleHudTreadsPosY=0.49
    VehicleHudTreadsScale=0.61
    VehicleHudOccupantsX(0)=0.45
    VehicleHudOccupantsY(0)=0.38
    VehicleHudOccupantsX(2)=0.55
    VehicleHudOccupantsY(2)=0.38
    VehicleHudOccupantsX(3)=0.4
    VehicleHudOccupantsY(3)=0.69
    VehicleHudOccupantsX(4)=0.4
    VehicleHudOccupantsY(4)=0.79
    VehicleHudOccupantsX(5)=0.605
    VehicleHudOccupantsY(5)=0.79
    VehicleHudOccupantsX(6)=0.605
    VehicleHudOccupantsY(6)=0.69
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.panther'

    // Visible wheels
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

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=32.0,Y=-15.0,Z=-1.0)
        WheelRadius=33.0
        bLeftTrack=true
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_PantherDTank.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=32.0,Y=15.0,Z=-1.0)
        WheelRadius=33.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_PantherDTank.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-14.0,Y=-15.0,Z=-1.0)
        WheelRadius=33.0
        bLeftTrack=true
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_PantherDTank.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-14.0,Y=15.0,Z=-1.0)
        WheelRadius=33.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_PantherDTank.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-15.0,Z=-1.0)
        WheelRadius=33.0
        bLeftTrack=true
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_PantherDTank.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=15.0,Z=-1.0)
        WheelRadius=33.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_PantherDTank.Right_Drive_Wheel'

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-0.6) // default is -0.5
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=1.0
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_PantherDTank.KParams0'
}
