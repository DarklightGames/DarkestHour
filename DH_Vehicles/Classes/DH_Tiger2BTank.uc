//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Tiger2BTank extends DHArmoredVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Panzer VI 'King Tiger' Ausf.B"
    VehicleMass=16.0
    ReinforcementCost=9

    // Hull mesh
    Mesh=SkeletalMesh'DH_Tiger2B_anm.tiger2B_body_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.tiger2B_body_normandy'
    Skins(1)=Texture'DH_VehiclesGE_tex2.Treads.tiger2B_treads'
    Skins(2)=Texture'DH_VehiclesGE_tex2.Treads.tiger2B_treads'
    Skins(3)=Texture'DH_VehiclesGE_tex2.int_vehicles.tiger2B_body_int'
    Skins(4)=Texture'DH_VehiclesGE_tex2.ext_vehicles.JagdTiger_skirtdetails'

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Tiger2BCannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_Tiger2BMountedMGPawn',WeaponBone="Mg_placement")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-140.0,Y=-85.0,Z=25.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider6_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-190.0,Y=-55.0,Z=25.0),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-190.0,Y=55.0,Z=25.0),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(3)=(AttachBone="body",DrivePos=(X=-140.0,Y=85.0,Z=25.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider1_idle")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Tiger2B_anm.tiger2B_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Tiger2B_anm.tiger2B_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",ViewPitchUpLimit=8000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=7000,ViewNegativeYawLimit=-7000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Tiger2B_anm.tiger2B_body_int',TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=15000,ViewPitchDownLimit=64500,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true)
    DrivePos=(X=3.0,Y=3.0,Z=-21.0)
    DriveAnim="VPanzer3_driver_idle_open"
    PeriscopeOverlay=Texture'DH_VehicleOptics_tex.General.PERISCOPE_overlay_German'

    // Hull armor
    FrontArmor(0)=(Thickness=10.0,Slope=-50.0,MaxRelativeHeight=-35.0,LocationName="lower")
    FrontArmor(1)=(Thickness=15.0,Slope=50.0,LocationName="upper")
    RightArmor(0)=(Thickness=8.0,MaxRelativeHeight=-15.0,LocationName="lower")
    RightArmor(1)=(Thickness=8.0,Slope=25.0,LocationName="upper")
    LeftArmor(0)=(Thickness=8.0,MaxRelativeHeight=-15.0,LocationName="lower")
    LeftArmor(1)=(Thickness=8.0,Slope=25.0,LocationName="upper")
    RearArmor(0)=(Thickness=8.0,Slope=-30.0)

    FrontLeftAngle=332.0
    RearLeftAngle=208.0

    // Movement
    MaxCriticalSpeed=693.0 // 41 kph
    GearRatios(3)=0.45
    GearRatios(4)=0.7
    TransRatio=0.07
    SteerSpeed=50.0

    EngineRestartFailChance=0.5 //unreliability

    // Damage
	// Compared to Tiger1: even more reliability problems due to extreme weight
    Health=570
    HealthMax=570.0
    EngineHealth=170  // reduced from 300
    AmmoIgnitionProbability=0.8 // 0.75 default
    EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
    DisintegrationHealth=-800.0 //petrol
    VehHitpoints(0)=(PointRadius=40.0,PointOffset=(X=-115.0,Z=-22.0)) // engine
    VehHitpoints(1)=(PointRadius=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=-55.0,Y=-65.0,Z=4.0),DamageMultiplier=3.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=-55.0,Y=65.0,Z=4.0),DamageMultiplier=3.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=15.0,PointScale=1.0,PointBone="body",PointOffset=(Y=-65.0,Z=4.0),DamageMultiplier=3.0,HitPointType=HP_AmmoStore)
    VehHitpoints(4)=(PointRadius=15.0,PointScale=1.0,PointBone="body",PointOffset=(Y=65.0,Z=4.0),DamageMultiplier=3.0,HitPointType=HP_AmmoStore)
    TreadHitMaxHeight=-38.3
    TreadDamageThreshold=1.0
    DamagedEffectScale=1.25
    DamagedEffectOffset=(X=-135.0,Y=20.0,Z=20.0)
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Tiger2B.Tiger2B_dest'

    // Exit
    ExitPositions(0)=(X=165.0,Y=-30.0,Z=80.0)    // driver's hatch
    ExitPositions(1)=(X=-35.0,Y=-30.0,Z=145.0)   // commander's hatch
    ExitPositions(2)=(X=165.0,Y=40.0,Z=80.0)     // hull MG hatch
    ExitPositions(3)=(X=-135.0,Y=-175.0,Z=-40.0) // riders
    ExitPositions(4)=(X=-280.0,Y=-55.0,Z=-40.0)
    ExitPositions(5)=(X=-280.0,Y=55.0,Z=-40.0)
    ExitPositions(6)=(X=-135.0,Y=175.0,Z=-40.0)

    // Sounds
    SoundPitch=32
    MaxPitchSpeed=50.0
    IdleSound=SoundGroup'Vehicle_Engines.Tiger.Tiger_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.Tiger.tiger_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.Tiger.tiger_engine_stop'
    LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L04'
    RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_R04'
    LeftTrackSoundBone="Tread_L"
    RightTrackSoundBone="Tread_R"
    RumbleSound=Sound'Vehicle_Engines.interior.tank_inside_rumble02'
    RumbleSoundBone="driver_attachment"

    // Visual effects
    TreadVelocityScale=200.0
    WheelRotationScale=58500.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-232.0,Y=23.0,Z=27.0),ExhaustRotation=(Pitch=22000))
    ExhaustPipes(1)=(ExhaustPosition=(X=-232.0,Y=-27.0,Z=27.0),ExhaustRotation=(Pitch=22000))
    SteerBoneName="Steering"
    SteeringScaleFactor=2.0

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.tiger2B_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.tiger2B_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.tiger2B_turret_look'
    VehicleHudTreadsPosX(1)=0.67
    VehicleHudTreadsPosY=0.54
    VehicleHudTreadsScale=0.72
    VehicleHudOccupantsX(0)=0.44
    VehicleHudOccupantsX(2)=0.57
    VehicleHudOccupantsY(0)=0.35
    VehicleHudOccupantsY(2)=0.35
    VehicleHudOccupantsX(3)=0.375
    VehicleHudOccupantsY(3)=0.75
    VehicleHudOccupantsX(4)=0.45
    VehicleHudOccupantsY(4)=0.8
    VehicleHudOccupantsX(5)=0.55
    VehicleHudOccupantsY(5)=0.8
    VehicleHudOccupantsX(6)=0.625
    VehicleHudOccupantsY(6)=0.75
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.tiger_2b'

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
        BoneOffset=(X=25.0,Y=-10.0,Z=1.0)
        WheelRadius=38.0
        bLeftTrack=true
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_Tiger2BTank.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=25.0,Y=10.0,Z=1.0)
        WheelRadius=38.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_Tiger2BTank.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-7.0,Y=-10.0,Z=1.0)
        WheelRadius=38.0
        bLeftTrack=true
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_Tiger2BTank.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-7.0,Y=10.0,Z=1.0)
        WheelRadius=38.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_Tiger2BTank.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-10.0,Z=1.0)
        WheelRadius=38.0
        bLeftTrack=true
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_Tiger2BTank.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-10.0,Z=1.0)
        WheelRadius=38.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_Tiger2BTank.Right_Drive_Wheel'

    // Karma
    Begin Object class=KarmaParamsRBFull Name=KParams0
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_Tiger2BTank.KParams0'
}
