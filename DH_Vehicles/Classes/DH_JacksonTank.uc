//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JacksonTank extends DHArmoredVehicle; // later version with HVAP instead of AP shot & with muzzle brake

defaultproperties
{
    // Vehicle properties
    VehicleNameString="M36 Jackson"
    VehicleTeam=1
    VehicleMass=13.0
    ReinforcementCost=7

    // Hull mesh
    Mesh=SkeletalMesh'DH_Jackson_anm.Jackson_body_ext'
    Skins(0)=Texture'DH_VehiclesUS_tex3.ext_vehicles.M36_Body'
    Skins(1)=Texture'DH_VehiclesUS_tex3.ext_vehicles.M36_turret_ext'
    Skins(2)=Texture'DH_VehiclesUS_tex.int_vehicles.M10_body_int'
    Skins(3)=Texture'DH_VehiclesUS_tex.int_vehicles.M10_body_int2'
    Skins(4)=Texture'DH_VehiclesUS_tex.Treads.M10_treads'
    Skins(5)=Texture'DH_VehiclesUS_tex.Treads.M10_treads'

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_JacksonCannonPawn',WeaponBone="Turret_placement")
    PassengerPawns(0)=(AttachBone="Jackson_body_ext",DrivePos=(X=-125.0,Y=-65.0,Z=115.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(1)=(AttachBone="Jackson_body_ext",DrivePos=(X=-185.0,Y=-35.0,Z=115.0),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(2)=(AttachBone="Jackson_body_ext",DrivePos=(X=-185.0,Y=35.0,Z=115.0),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(3)=(AttachBone="Jackson_body_ext",DrivePos=(X=-125.0,Y=75.0,Z=115.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider3_idle")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Jackson_anm.Jackson_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Jackson_anm.Jackson_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Jackson_anm.Jackson_body_int',TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true)
    DrivePos=(X=-3.0,Y=0.0,Z=-3.0)
    DriveAnim="VPanzer3_driver_idle_open"

    // Hull armor
    FrontArmor(0)=(Thickness=5.08,Slope=-45.0,MaxRelativeHeight=42.0,LocationName="lower nose")
    FrontArmor(1)=(Thickness=5.08,MaxRelativeHeight=56.0,LocationName="mid nose") // represents flattest, front facing part of rounded nose plate
    FrontArmor(2)=(Thickness=5.08,Slope=56.0,MaxRelativeHeight=78.6,LocationName="upper nose")
    FrontArmor(3)=(Thickness=3.81,Slope=55.0,LocationName="upper")
    RightArmor(0)=(Thickness=2.54,MaxRelativeHeight=64.0,LocationName="lower")
    RightArmor(1)=(Thickness=1.91,Slope=-26.0,MaxRelativeHeight=78.6,LocationName="upper")
    RightArmor(2)=(Thickness=1.91,Slope=38.0,LocationName="upper")
    LeftArmor(0)=(Thickness=2.54,MaxRelativeHeight=64.0,LocationName="lower")
    LeftArmor(1)=(Thickness=1.91,Slope=-26.0,MaxRelativeHeight=78.6,LocationName="upper")
    LeftArmor(2)=(Thickness=1.91,Slope=38.0,LocationName="upper")
    RearArmor(0)=(Thickness=1.91,Slope=-45.0,MaxRelativeHeight=38.5,LocationName="lowest")
    RearArmor(1)=(Thickness=1.91,MaxRelativeHeight=64.0,LocationName="lower")
    RearArmor(2)=(Thickness=1.91,Slope=-26.0,MaxRelativeHeight=78.6,LocationName="upper")
    RearArmor(3)=(Thickness=1.91,Slope=38.0,LocationName="upper")

    FrontLeftAngle=332.0
    RearLeftAngle=208.0

    // Movement
    MaxCriticalSpeed=766.0 // 46 kph
    GearRatios(4)=0.75
    TransRatio=0.1

    // Damage
	// pros: diesel fuel, 5 men crew
    Health=525
    HealthMax=525.0
	EngineHealth=300
	AmmoIgnitionProbability=0.8  // 0.75 default
    PlayerFireDamagePer2Secs=12.0 // reduced from 15 for all diesels
    FireDetonationChance=0.045  //reduced from 0.07 for all diesels
    DisintegrationHealth=-1200.0 //diesel
    VehHitpoints(0)=(PointRadius=35.0,PointBone="Jackson_body_ext",PointOffset=(X=-90.0,Z=-35.0)) // engine
    VehHitpoints(1)=(PointRadius=15.0,PointScale=1.0,PointBone="Jackson_body_ext",PointOffset=(X=20.0,Y=55.0,Z=-8.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=15.0,PointScale=1.0,PointBone="Jackson_body_ext",PointOffset=(X=20.0,Y=-55.0,Z=-8.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=25.0,PointScale=1.0,PointBone="Jackson_body_ext",PointOffset=(X=-20.0,Z=-20.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    TreadHitMaxHeight=65.0
    DamagedEffectOffset=(X=-126.0,Y=20.0,Z=105.0)
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc2.Jackson.Jackson_Dest'

    // Exit
    ExitPositions(0)=(X=150.0,Y=-35.0,Z=175.0)  // driver
    ExitPositions(1)=(X=20.0,Y=40.0,Z=250.0)    // commander
    ExitPositions(2)=(X=-125.0,Y=-150.0,Z=75.0) // passenger (l)
    ExitPositions(3)=(X=-250.0,Y=-35.0,Z=75.0)  // passenger (bl)
    ExitPositions(4)=(X=-250.0,Y=35.0,Z=75.0)   // passenger (br)
    ExitPositions(5)=(X=-125.0,Y=150.0,Z=75.0)  // passenger (r)

    // Sounds
    IdleSound=SoundGroup'DH_AlliedVehicleSounds.Sherman.ShermanEngineLoop'
    StartUpSound=Sound'DH_AlliedVehicleSounds.Sherman.ShermanStart'
    ShutDownSound=Sound'DH_AlliedVehicleSounds.Sherman.ShermanStop'
    LeftTreadSound=Sound'Vehicle_EnginesTwo.UC.UC_tread_L'
    RightTreadSound=Sound'Vehicle_EnginesTwo.UC.UC_tread_R'
    RumbleSoundBone="Turret_placement"
    RumbleSound=Sound'DH_AlliedVehicleSounds.Sherman.inside_rumble01'

    // Visual effects
    LeftTreadIndex=5
    RightTreadIndex=4
    LeftTreadPanDirection=(Pitch=0,Yaw=32768,Roll=16384)
    RightTreadPanDirection=(Pitch=32768,Yaw=0,Roll=16384)
    TreadVelocityScale=233.0
    WheelRotationScale=143000.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-180.0,Y=40.0,Z=63.0),ExhaustRotation=(Pitch=63000,Yaw=26000))
    ExhaustPipes(1)=(ExhaustPosition=(X=-180.0,Y=-40.0,Z=63.0),ExhaustRotation=(Pitch=63000,Yaw=39536))
    LeftLeverBoneName="lever_L"
    RightLeverBoneName="lever_R"

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.M36_Body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.M36_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.M36_turret_look'
    VehicleHudEngineX=0.50
    VehicleHudEngineY=0.675
    VehicleHudTreadsPosX(0)=0.37
    VehicleHudTreadsPosX(1)=0.66
    VehicleHudTreadsPosY=0.51
    VehicleHudTreadsScale=0.63
    VehicleHudOccupantsX(0)=0.43
    VehicleHudOccupantsY(0)=0.35
    VehicleHudOccupantsX(2)=0.375
    VehicleHudOccupantsY(2)=0.725
    VehicleHudOccupantsX(3)=0.45
    VehicleHudOccupantsY(3)=0.8
    VehicleHudOccupantsX(4)=0.55
    VehicleHudOccupantsY(4)=0.8
    VehicleHudOccupantsX(5)=0.6
    VehicleHudOccupantsY(5)=0.725
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.m36_jackson'

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
        bLeftTrack=true
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_JacksonTank.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=10.0,Z=10.0)
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_JacksonTank.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-30.0,Z=10.0)
        bLeftTrack=true
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_JacksonTank.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-30.0,Z=10.0)
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_JacksonTank.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.0)
        bLeftTrack=true
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_JacksonTank.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.0)
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_JacksonTank.Right_Drive_Wheel'

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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_JacksonTank.KParams0'
}
