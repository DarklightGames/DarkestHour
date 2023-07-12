//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JagdpantherTank extends DHArmoredVehicle;

// Hack to stop jagdpanther camo variants without a matching schurzen texture from spawning schurzen
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
    VehicleNameString="Jagdpanzer V 'Jagdpanther'"
    VehicleMass=14.0
    ReinforcementCost=8

    // Hull mesh
    Mesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_body_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Jagdpanther_body_goodwood'
    Skins(1)=Texture'DH_VehiclesGE_tex2.Treads.Jagdpanther_treads'
    Skins(2)=Texture'DH_VehiclesGE_tex2.Treads.Jagdpanther_treads'
    Skins(3)=Texture'DH_VehiclesGE_tex2.int_vehicles.Jagdpanther_walls_int'
    Skins(4)=Texture'DH_VehiclesGE_tex2.int_vehicles.Jagdpanther_body_int'

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdpantherCannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdpantherMountedMGPawn',WeaponBone="Mg_attachment")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-109.0,Y=-79.5,Z=41.5),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider6_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-168.0,Y=-79.5,Z=41.5),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-168.0,Y=77.0,Z=41.5),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(3)=(AttachBone="body",DrivePos=(X=-109.0,Y=77.0,Z=41.5),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider1_idle")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=5000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=1,ViewNegativeYawLimit=-1,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_body_int',TransitionDownAnim="Overlay_In",ViewPitchUpLimit=2300,ViewPitchDownLimit=64000,ViewPositiveYawLimit=7000,ViewNegativeYawLimit=-7000)
    bDrawDriverInTP=false
    PeriscopeOverlay=Texture'DH_VehicleOptics_tex.General.PERISCOPE_overlay_German'

    // Hull armor
    FrontArmor(0)=(Thickness=6.5,Slope=-55.0,MaxRelativeHeight=56.8,LocationName="lower")
    FrontArmor(1)=(Thickness=8.2,Slope=55.0,LocationName="superstructure")
    RightArmor(0)=(Thickness=4.3,MaxRelativeHeight=84.0,LocationName="lower") //add a little for road wheels/schurzen
    RightArmor(1)=(Thickness=5.0,Slope=30.0,LocationName="superstructure")
    LeftArmor(0)=(Thickness=4.0,MaxRelativeHeight=84.0,LocationName="lower")
    LeftArmor(1)=(Thickness=5.0,Slope=30.0,LocationName="superstructure")
    RearArmor(0)=(Thickness=4.0,Slope=-30.0,MaxRelativeHeight=109.8,LocationName="lower")
    RearArmor(1)=(Thickness=4.0,Slope=33.0,LocationName="superstructure")

    FrontRightAngle=27.0
    RearRightAngle=153.0

    // Movement
    GearRatios(4)=0.8
    TransRatio=0.1
    ChangeUpPoint=1990.0
    ChangeDownPoint=1000.0
    MaxCriticalSpeed=1002.0 // 60 kph

    // Damage
    // pros: 5 men crew
    // cons: petrol fuel
    Health=565
    HealthMax=565.0
    EngineHealth=300
    AmmoIgnitionProbability=0.8  // 0.75 default
    EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
    DisintegrationHealth=-800.0 //petrol
    VehHitpoints(0)=(PointRadius=32.0,PointHeight=35.0,PointOffset=(X=-122.0,Z=-6.0)) // engine
    VehHitpoints(1)=(PointRadius=15.0,PointHeight=10.0,PointScale=1.0,PointBone="body",PointOffset=(Y=-45.0,Z=50.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=15.0,PointHeight=10.0,PointScale=1.0,PointBone="body",PointOffset=(X=35.0,Y=-45.0,Z=50.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=15.0,PointHeight=10.0,PointScale=1.0,PointBone="body",PointOffset=(Y=45.0,Z=50.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(4)=(PointRadius=15.0,PointHeight=10.0,PointScale=1.0,PointBone="body",PointOffset=(X=35.0,Y=45.0,Z=50.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    NewVehHitpoints(0)=(PointRadius=8.0,PointBone="body",PointOffset=(X=55.0,Y=-40.0,Z=77.0),NewHitPointType=NHP_GunOptics)
    NewVehHitpoints(1)=(PointRadius=15.0,PointBone="Turret_placement",PointOffset=(X=72.0,Z=45.0),NewHitPointType=NHP_Traverse)
    NewVehHitpoints(2)=(PointRadius=15.0,PointBone="Turret_placement",PointOffset=(X=72.0,Z=45.0),NewHitPointType=NHP_GunPitch)
    GunOpticsHitPointIndex=0
    TreadHitMaxHeight=60.0
    TreadDamageThreshold=0.85
    DamagedEffectScale=1.1
    DamagedEffectOffset=(X=-135.0,Y=20.0,Z=108.0)
    FireEffectOffset=(X=50.0,Y=0.0,Z=-20.0)
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Jagdpanther.Jagdpanther_dest'
    DestroyedMeshSkins(0)=Combiner'DH_VehiclesGE_tex3.Destroyed.Jagdpanther_body_goodwood_dest' // 'Jagdpanther_dest' SM has been set up with Ardennes camo skin, so this corrects it

    // Exit
    ExitPositions(0)=(X=-33.0,Y=36.0,Z=210.0)   // driver
    ExitPositions(1)=(X=-33.0,Y=36.0,Z=210.0)   // commander's hatch
    ExitPositions(2)=(X=-33.0,Y=36.0,Z=210.0)   // hull MG
    ExitPositions(3)=(X=-109.0,Y=-170.0,Z=60.0) // riders
    ExitPositions(4)=(X=-159.0,Y=-170.0,Z=60.0)
    ExitPositions(5)=(X=-159.0,Y=170.0,Z=60.0)
    ExitPositions(6)=(X=-109.0,Y=170.0,Z=60.0)

    // Sounds
    SoundPitch=32
    MaxPitchSpeed=80.0
    IdleSound=SoundGroup'Vehicle_Engines.Tiger.Tiger_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.Tiger.tiger_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.Tiger.tiger_engine_stop'
    LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L04'
    RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_R04'
    RumbleSound=Sound'Vehicle_Engines.interior.tank_inside_rumble02'
    LeftTrackSoundBone="Wheel_L_1"
    RightTrackSoundBone="Wheel_R_1"

    // Visual effects
    LeftTreadIndex=2
    RightTreadIndex=1
    TreadVelocityScale=172.0
    WheelRotationScale=48750.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-230.0,Y=20.0,Z=109.592003),ExhaustRotation=(Pitch=22000))
    ExhaustPipes(1)=(ExhaustPosition=(X=-230.0,Y=-20.0,Z=109.592003),ExhaustRotation=(Pitch=22000))
    // TODO: ideally get better matching schurzen texture made for this camo variant, but for now this is passable match:
    RandomAttachment=(AttachBone="body",Offset=(X=-18.0,Y=-1.65,Z=-14.0),Skins=(Texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_armor_camo2'))
    RandomAttachOptions(0)=(StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherSchurzen1',PercentChance=30) // undamaged schurzen
    RandomAttachOptions(1)=(StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherSchurzen2',PercentChance=15) // missing front panel on right & middle panel on left
    RandomAttachOptions(2)=(StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherSchurzen3',PercentChance=10) // with front panels missing on both sides
    RandomAttachOptions(3)=(StaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherSchurzen4',PercentChance=15) // most badly damaged, with 3 panels missing

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.jagdpanther_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.jagdpanther_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.jagdpanther_turret_look'
    VehicleHudEngineX=0.51
    VehicleHudTreadsPosX(0)=0.38
    VehicleHudTreadsPosX(1)=0.63
    VehicleHudTreadsPosY=0.54
    VehicleHudTreadsScale=0.61
    VehicleHudOccupantsX(0)=0.43
    VehicleHudOccupantsY(0)=0.38
    VehicleHudOccupantsX(1)=0.55
    VehicleHudOccupantsY(1)=0.51
    VehicleHudOccupantsX(2)=0.59
    VehicleHudOccupantsY(2)=0.38
    VehicleHudOccupantsX(3)=0.4
    VehicleHudOccupantsY(3)=0.69
    VehicleHudOccupantsX(4)=0.4
    VehicleHudOccupantsY(4)=0.79
    VehicleHudOccupantsX(5)=0.605
    VehicleHudOccupantsY(5)=0.79
    VehicleHudOccupantsX(6)=0.605
    VehicleHudOccupantsY(6)=0.69
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.jagdpanther'

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
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_JagdpantherTank.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=32.0,Y=15.0,Z=-1.0)
        WheelRadius=33.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_JagdpantherTank.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-14.0,Y=-15.0,Z=-1.0)
        WheelRadius=33.0
        bLeftTrack=true
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_JagdpantherTank.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-14.0,Y=15.0,Z=-1.0)
        WheelRadius=33.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_JagdpantherTank.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-15.0,Z=-1.0)
        WheelRadius=33.0
        bLeftTrack=true
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_JagdpantherTank.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=15.0,Z=-1.0)
        WheelRadius=33.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_JagdpantherTank.Right_Drive_Wheel'

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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_JagdpantherTank.KParams0'
}
