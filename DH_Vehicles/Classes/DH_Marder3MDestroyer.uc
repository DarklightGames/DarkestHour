//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Marder3MDestroyer extends DHArmoredVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Marder III Ausf.M"
    VehicleMass=11.0
    ReinforcementCost=4

    // Hull mesh
    Mesh=SkeletalMesh'DH_Marder3M_anm.marder3_body_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex7.ext_vehicles.marder_turret_ext'
    Skins(1)=Texture'DH_VehiclesGE_tex7.ext_vehicles.marder_body_ext'
    Skins(2)=Texture'DH_VehiclesGE_tex7.Treads.marder_treads'
    Skins(3)=Texture'DH_VehiclesGE_tex7.Treads.marder_treads'
    Skins(4)=Texture'DH_VehiclesGE_tex7.int_vehicles.marder3m_body_int'

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Marder3MCannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_Marder3MMountedMGPawn',WeaponBone="Mg34_placment")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=7.5,Y=30.0,Z=41.0),DriveAnim="VUC_rider1_idle")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Marder3M_anm.marder3_body_int',TransitionUpAnim="driver_slit_close",ViewPitchUpLimit=2000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Marder3M_anm.marder3_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="driver_slit_open",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Marder3M_anm.marder3_body_int',TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true)
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
    VehHitpoints(0)=(PointRadius=30.0,PointOffset=(Z=-5.0)) // engine
    VehHitpoints(1)=(PointRadius=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=-50.0,Y=-20.0,Z=-15.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=-90.0,Y=-40.0,Z=40.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=-90.0,Y=40.0,Z=40.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    TreadHitMaxHeight=-5.0
    TreadDamageThreshold=0.5
    DamagedEffectOffset=(X=30.0,Y=0.0,Z=20.0)
    FireEffectOffset=(X=10.0,Y=0.0,Z=-20.0)
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc3.Marder3.Marder3M_dest'

    // Exit
    ExitPositions(0)=(X=78.0,Y=96.0,Z=5.0)      // driver's hatch
    ExitPositions(1)=(X=-133.0,Y=-27.0,Z=120.0) // commander's position
    ExitPositions(2)=(X=-135.0,Y=24.0,Z=120.0)  // MG position
    ExitPositions(3)=(X=25.0,Y=106.0,Z=5.0)     // rider

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
    ExhaustPipes(0)=(ExhaustPosition=(X=-142.0,Y=-28.0,Z=18.0),ExhaustRotation=(Pitch=40050))
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

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=10.0)
        WheelRadius=30.0
        bLeftTrack=true
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_Marder3MDestroyer.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=10.0)
        WheelRadius=30.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_Marder3MDestroyer.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-30.0)
        WheelRadius=30.0
        bLeftTrack=true
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_Marder3MDestroyer.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-30.0)
        WheelRadius=30.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_Marder3MDestroyer.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
        bLeftTrack=true
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_Marder3MDestroyer.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_Marder3MDestroyer.Right_Drive_Wheel'

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-1.0) // default is -0.5
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_Marder3MDestroyer.KParams0'
    LeftTreadPanDirection=(Pitch=0,Yaw=32768,Roll=16384)
    RightTreadPanDirection=(Pitch=32768,Yaw=0,Roll=16384)
}
