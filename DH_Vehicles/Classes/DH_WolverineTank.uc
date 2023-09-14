//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WolverineTank extends DHArmoredVehicle; // later version with HVAP instead of smoke rounds

defaultproperties
{
    // Vehicle properties
    VehicleNameString="M10 Wolverine"
    VehicleTeam=1
    VehicleMass=13.0
    ReinforcementCost=5

    // Hull mesh
    Mesh=SkeletalMesh'DH_Wolverine_anm.M10_body_ext'
    Skins(0)=Texture'DH_VehiclesUS_tex.ext_vehicles.M10_body_ext'
    Skins(1)=Texture'DH_VehiclesUS_tex.ext_vehicles.M10_turret_ext'
    Skins(2)=Texture'DH_VehiclesUS_tex.Treads.M10_treads'
    Skins(3)=Texture'DH_VehiclesUS_tex.Treads.M10_treads'
    Skins(4)=Texture'DH_VehiclesUS_tex.int_vehicles.M10_body_int'
    Skins(5)=Texture'DH_VehiclesUS_tex.int_vehicles.M10_body_int2'

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_WolverineCannonPawn',WeaponBone="Turret_placement")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-125.0,Y=-65.0,Z=12.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-165.0,Y=-35.0,Z=12.0),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-165.0,Y=35.0,Z=12.0),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(3)=(AttachBone="body",DrivePos=(X=-125.0,Y=65.0,Z=12.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider3_idle")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Wolverine_anm.M10_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Wolverine_anm.M10_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Wolverine_anm.M10_body_int',TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true)
    DrivePos=(X=-3.0,Y=0.0,Z=4.0)
    DriveAnim="VPanzer3_driver_idle_open"

    // Hull armor
    FrontArmor(0)=(Thickness=5.08,Slope=-45.0,MaxRelativeHeight=39.0,LocationName="lower nose")
    FrontArmor(1)=(Thickness=5.08,MaxRelativeHeight=53.0,LocationName="mid nose") // represents flattest, front facing part of rounded nose plate
    FrontArmor(2)=(Thickness=5.08,Slope=56.0,MaxRelativeHeight=75.5,LocationName="upper nose")
    FrontArmor(3)=(Thickness=3.81,Slope=55.0,LocationName="upper")
    RightArmor(0)=(Thickness=2.54,MaxRelativeHeight=61.5,LocationName="lower")
    RightArmor(1)=(Thickness=1.91,Slope=-26.0,MaxRelativeHeight=75.5,LocationName="upper")
    RightArmor(2)=(Thickness=1.91,Slope=38.0,LocationName="upper")
    LeftArmor(0)=(Thickness=2.54,MaxRelativeHeight=61.5,LocationName="lower")
    LeftArmor(1)=(Thickness=1.91,Slope=-26.0,MaxRelativeHeight=75.5,LocationName="upper")
    LeftArmor(2)=(Thickness=1.91,Slope=38.0,LocationName="upper")
    RearArmor(0)=(Thickness=2.54,MaxRelativeHeight=63.0,LocationName="lower")
    RearArmor(1)=(Thickness=2.54,Slope=-26.0,MaxRelativeHeight=75.5,LocationName="upper")
    RearArmor(2)=(Thickness=1.91,Slope=38.0,LocationName="upper")

    FrontLeftAngle=332.0
    RearLeftAngle=208.0

    // Movement
    MaxCriticalSpeed=766.0 // 46 kph
    GearRatios(4)=0.75
    TransRatio=0.1

    // Damage
	// Compared to M4A2 (soviet) Sherman: No wet storage?
    Health=565
    HealthMax=565.0
	EngineHealth=300

    PlayerFireDamagePer2Secs=12.0 // reduced from 15 for all diesels
    FireDetonationChance=0.045  //reduced from 0.07 for all diesels
    DisintegrationHealth=-1200.0 //diesel
    VehHitpoints(0)=(PointRadius=35.0,PointOffset=(X=-90.0,Z=-35.0)) // engine
    VehHitpoints(1)=(PointRadius=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=20.0,Y=55.0,Z=-8.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=20.0,Y=-55.0,Z=-8.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=15.0,PointScale=1.0,PointBone="body",PointOffset=(Z=-8.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    TreadHitMaxHeight=62.0
    DamagedEffectOffset=(X=-100.0,Y=0.0,Z=95.0)
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.M10.M10_Dest'

    // Exit
    ExitPositions(0)=(X=150.0,Y=-35.0,Z=175.0)  // driver
    ExitPositions(1)=(X=40.0,Y=-15.0,Z=250.0)   // commander
    ExitPositions(2)=(X=-125.0,Y=-150.0,Z=75.0) // passenger (l)
    ExitPositions(3)=(X=-250.0,Y=-35.0,Z=75.0)  // passenger (bl)
    ExitPositions(4)=(X=-250.0,Y=35.0,Z=75.0)   // passenger (br)
    ExitPositions(5)=(X=-125.0,Y=150.0,Z=75.0)  // passenger (r)

    // Sounds
    IdleSound=SoundGroup'Vehicle_Engines.SU76.SU76_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.SU76.SU76_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.SU76.SU76_engine_stop'
    LeftTreadSound=Sound'Vehicle_EnginesTwo.UC.UC_tread_L'
    RightTreadSound=Sound'Vehicle_EnginesTwo.UC.UC_tread_R'
    RumbleSoundBone="placeholder_int"
    RumbleSound=Sound'DH_AlliedVehicleSounds.Sherman.inside_rumble01'

    // Visual effects
    LeftTreadIndex=3
    LeftTreadPanDirection=(Pitch=0,Yaw=32768,Roll=16384)
    RightTreadPanDirection=(Pitch=0,Yaw=32768,Roll=16384)
    TreadVelocityScale=228.0
    WheelRotationScale=71500.0
    ExhaustEffectClass=class'ROEffects.ExhaustDieselEffect' // based on Sherman M4A2 chassis, which was the version with a diesel engine
    ExhaustEffectLowClass=class'ROEffects.ExhaustDieselEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-168.0,Y=0.0,Z=57.0),ExhaustRotation=(Pitch=63500,Yaw=32768))
    LeftLeverBoneName="lever_L"
    RightLeverBoneName="lever_R"

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.wolverine_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Wolverine_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Wolverine_turret_look'
    VehicleHudEngineX=0.51
    VehicleHudTreadsPosX(0)=0.36
    VehicleHudTreadsPosX(1)=0.64
    VehicleHudTreadsPosY=0.51
    VehicleHudTreadsScale=0.72
    VehicleHudOccupantsX(0)=0.43
    VehicleHudOccupantsY(0)=0.32
    VehicleHudOccupantsX(2)=0.4
    VehicleHudOccupantsY(2)=0.74
    VehicleHudOccupantsX(3)=0.45
    VehicleHudOccupantsY(3)=0.8
    VehicleHudOccupantsX(4)=0.55
    VehicleHudOccupantsY(4)=0.8
    VehicleHudOccupantsX(5)=0.6
    VehicleHudOccupantsY(5)=0.74
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.m10_wolverine'

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
        BoneOffset=(X=10.0,Z=10.0)
        WheelRadius=33.0
        bLeftTrack=true
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_WolverineTank.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=10.0,Z=10.0)
        WheelRadius=33.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_WolverineTank.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-30.0,Z=10.0)
        WheelRadius=33.0
        bLeftTrack=true
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_WolverineTank.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-30.0,Z=10.0)
        WheelRadius=33.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_WolverineTank.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.0)
        WheelRadius=33.0
        bLeftTrack=true
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_WolverineTank.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.0)
        WheelRadius=33.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_WolverineTank.Right_Drive_Wheel'

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=0.0) // default is -0.5
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_WolverineTank.KParams0'
}
