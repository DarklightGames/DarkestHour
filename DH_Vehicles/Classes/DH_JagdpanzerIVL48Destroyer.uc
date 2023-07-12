//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JagdpanzerIVL48Destroyer extends DHArmoredVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Jagdpanzer IV/48"
    VehicleMass=12.0
    ReinforcementCost=7

    // Hull mesh
    Mesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L48_body_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_body_camo1'
    Skins(1)=Texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_armor_camo1'
    Skins(2)=Texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_wheels_camo1'
    Skins(3)=Texture'axis_vehicles_tex.Treads.panzer4F2_treads'
    Skins(4)=Texture'axis_vehicles_tex.Treads.panzer4F2_treads'
    Skins(5)=FinalBlend'DH_VehiclesGE_tex4.int_vehicles.jagdpanzeriv_body_intFB'
    BeginningIdleAnim="Overlay_Idle"
    FireEffectOffset=(X=55.0,Y=0.0,Z=-25.0)

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdpanzerIVL48CannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdpanzerIVMountedMGPawn',WeaponBone="Mg_placement")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-100.0,Y=0.0,Z=110.0),DriveAnim="prone_idle_nade")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-100.0,Y=40.0,Z=110.0),DriveRot=(Yaw=2048),DriveAnim="prone_idle_satchel")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L48_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=5000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=1,ViewNegativeYawLimit=-1,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L48_body_int',TransitionDownAnim="Overlay_In",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5000,ViewNegativeYawLimit=-5500)
    bDrawDriverInTP=false
    PeriscopeOverlay=Texture'DH_VehicleOptics_tex.General.PERISCOPE_overlay_German'

    // Hull armor
    FrontArmor(0)=(Thickness=5.0,Slope=-57.0,MaxRelativeHeight=-12.2,LocationName="lower nose")
    FrontArmor(1)=(Thickness=8.0,Slope=45.0,MaxRelativeHeight=13.5,LocationName="upper nose") // later model with this armor plate increased from 60mm to 80mm
    FrontArmor(2)=(Thickness=8.0,Slope=50.0,LocationName="superstructure")
    RightArmor(0)=(Thickness=3.0,MaxRelativeHeight=18.7,LocationName="lower")
    RightArmor(1)=(Thickness=4.0,Slope=30.0,LocationName="superstructure") // TODO: Bird & Livingston says this plate was reduced to 30mm in this later model?
    LeftArmor(0)=(Thickness=3.0,MaxRelativeHeight=18.7,LocationName="lower")
    LeftArmor(1)=(Thickness=4.0,Slope=30.0,LocationName="superstructure")
    RearArmor(0)=(Thickness=2.0,Slope=-10.0,MaxRelativeHeight=22.5,LocationName="lower")
    RearArmor(1)=(Thickness=2.0,Slope=12.0,MaxRelativeHeight=50.5,LocationName="upper")
    RearArmor(2)=(Thickness=3.0,Slope=33.0,LocationName="superstructure")

    FrontLeftAngle=332.0
    RearLeftAngle=208.0

    // Movement
    MaxCriticalSpeed=730.0 // 44 kph

    // Damage
	// note: 4 men crew
	// cons: petrol fuel
    Health=525
    HealthMax=525.0
	EngineHealth=300

    EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
    DisintegrationHealth=-800.0 //petrol
    VehHitpoints(0)=(PointRadius=35.0,PointOffset=(X=-100.0,Z=10.0)) // engine
    VehHitpoints(1)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(Y=50.0,Z=40.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(Y=-50.0,Z=40.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=-20.0,Y=-40.0,Z=20.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    NewVehHitpoints(0)=(PointRadius=5.0,PointBone="body",PointOffset=(X=40.0,Y=10.5,Z=65.0),NewHitPointType=NHP_GunOptics)
    NewVehHitpoints(1)=(PointRadius=20.0,PointBone="body",PointOffset=(X=100.0,Y=10.0,Z=35.0),NewHitPointType=NHP_Traverse)
    NewVehHitpoints(2)=(PointRadius=20.0,PointBone="body",PointOffset=(X=100.0,Y=10.0,Z=35.0),NewHitPointType=NHP_GunPitch)
    GunOpticsHitPointIndex=0
    TreadHitMaxHeight=13.0
    DamagedEffectScale=0.9
    DamagedEffectOffset=(X=-100.0,Y=20.0,Z=26.0)
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc4.Jagdpanzer4.Jagdpanzer4_dest48'

    // Exit
    ExitPositions(0)=(X=-26.0,Y=-25.0,Z=135.0)
    ExitPositions(1)=(X=-26.0,Y=-25.0,Z=135.0)
    ExitPositions(2)=(X=-26.0,Y=-25.0,Z=135.0)
    ExitPositions(3)=(X=-251.0,Y=-7.0,Z=5.0)
    ExitPositions(4)=(X=-252.0,Y=39.0,Z=5.0)

    // Sounds
    IdleSound=SoundGroup'Vehicle_Engines.PanzerIV.PanzerIV_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.PanzerIV.PanzerIV_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.PanzerIV.PanzerIV_engine_stop'
    LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L08'
    RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_R08'
    RumbleSoundBone="driver_attachment"
    RumbleSound=Sound'Vehicle_Engines.interior.tank_inside_rumble02'

    // Visual effects
    LeftTreadIndex=4
    RightTreadIndex=3
    TreadVelocityScale=100.0
    WheelRotationScale=49920.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-170.0,Y=16.0,Z=30.0),ExhaustRotation=(Pitch=22000,Yaw=9000))
    LeftLeverBoneName="lever_L"
    RightLeverBoneName="lever_R"

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.JPIV_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.JPIVL48_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.JPIVL48_turret_look'
    VehicleHudTreadsPosX(0)=0.36
    VehicleHudTreadsPosX(1)=0.645
    VehicleHudTreadsPosY=0.51
    VehicleHudTreadsScale=0.66
    VehicleHudOccupantsX(0)=0.43
    VehicleHudOccupantsY(0)=0.42
    VehicleHudOccupantsX(1)=0.46
    VehicleHudOccupantsY(1)=0.56
    VehicleHudOccupantsX(2)=0.6
    VehicleHudOccupantsY(2)=0.42
    VehicleHudOccupantsX(3)=0.5
    VehicleHudOccupantsY(3)=0.7
    VehicleHudOccupantsX(4)=0.6
    VehicleHudOccupantsY(4)=0.7
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.jagdpanzer_l48'

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
    LeftWheelBones(10)="Wheel_L_11"
    LeftWheelBones(11)="Wheel_L_12"
    LeftWheelBones(12)="Wheel_L_13"
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
    RightWheelBones(11)="Wheel_R_12"
    RightWheelBones(12)="Wheel_R_13"

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=35.0,Y=-5.0,Z=6.0)
        WheelRadius=29.0
        bLeftTrack=true
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_JagdpanzerIVL48Destroyer.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=35.0,Y=5.0,Z=6.0)
        WheelRadius=29.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_JagdpanzerIVL48Destroyer.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-7.0,Y=-5.0,Z=6.0)
        WheelRadius=29.0
        bLeftTrack=true
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_JagdpanzerIVL48Destroyer.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-7.0,Y=5.0,Z=6.0)
        WheelRadius=29.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_JagdpanzerIVL48Destroyer.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=6.0)
        WheelRadius=29.0
        bLeftTrack=true
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_JagdpanzerIVL48Destroyer.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=6.0)
        WheelRadius=29.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_JagdpanzerIVL48Destroyer.Right_Drive_Wheel'

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-1.5) // default is -0.5
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_JagdpanzerIVL48Destroyer.KParams0'
}
