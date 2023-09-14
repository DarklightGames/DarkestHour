//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanFireflyTank extends DHArmoredVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Sherman Mk.VC 'Firefly'"
    VehicleTeam=1
    VehicleMass=13.5
    ReinforcementCost=8

    // Hull mesh
    Mesh=SkeletalMesh'DH_ShermanFirefly_anm.ShermanFirefly_body_ext'
    Skins(0)=Texture'DH_VehiclesUK_tex.ext_vehicles.FireFly_body_ext'
    Skins(1)=Texture'DH_VehiclesUK_tex.ext_vehicles.FireFly_armor_ext'
    Skins(2)=Texture'DH_VehiclesUS_tex.int_vehicles.Sherman_hatch_int'
    Skins(3)=Texture'DH_VehiclesUS_tex.int_vehicles.Sherman_body_int'
    Skins(4)=Texture'DH_VehiclesUK_tex.Treads.FireFly_treads'
    Skins(5)=Texture'DH_VehiclesUK_tex.Treads.FireFly_treads'

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ShermanFireFlyCannonPawn',WeaponBone="Turret_placement")
    PassengerPawns(0)=(AttachBone="Body",DrivePos=(X=-144.0,Y=-68.0,Z=43.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(1)=(AttachBone="Body",DrivePos=(X=-186.0,Y=-29.0,Z=45.0),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(2)=(AttachBone="Body",DrivePos=(X=-186.0,Y=29.0,Z=45.0),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(3)=(AttachBone="Body",DrivePos=(X=-119.0,Y=68.0,Z=46.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider5_idle")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_ShermanFirefly_anm.ShermanFirefly_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_ShermanFirefly_anm.ShermanFirefly_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_ShermanFirefly_anm.ShermanFirefly_body_int',TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true)
    OverlayFPCamPos=(X=10.5,Y=0.0,Z=10.8)

    // Hull armor
    FrontArmor(0)=(Thickness=5.08,Slope=-45.0,MaxRelativeHeight=36.0,LocationName="lower nose")
    FrontArmor(1)=(Thickness=5.08,MaxRelativeHeight=50.0,LocationName="mid nose") // represents flattest, front facing part of rounded nose plate
    FrontArmor(2)=(Thickness=5.08,Slope=56.0,LocationName="upper")
    RightArmor(0)=(Thickness=3.81)
    LeftArmor(0)=(Thickness=3.81)
    RearArmor(0)=(Thickness=3.81,Slope=-10.0,MaxRelativeHeight=64.5,LocationName="lower")
    RearArmor(1)=(Thickness=3.81,Slope=20.0,LocationName="upper")

    FrontLeftAngle=330.0
    FrontRightAngle=30.0
    RearRightAngle=157.0
    RearLeftAngle=203.0

    // Movement
    MaxCriticalSpeed=693.0 // 41 kph
    GearRatios(1)=0.19
    GearRatios(3)=0.62
    GearRatios(4)=0.76
    TransRatio=0.091

    // Damage
    Health=565
    HealthMax=565.0
	EngineHealth=300
    EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
    DisintegrationHealth=-800.0 //petrol
    VehHitpoints(0)=(PointRadius=32.0,PointOffset=(X=-120.0,Y=0.0,Z=5.0)) // engine
    VehHitpoints(1)=(PointRadius=20.0,PointScale=1.0,PointBone="Body",PointOffset=(X=75.0,Y=22.0,Z=0.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=20.0,PointScale=1.0,PointBone="Body",PointOffset=(X=67.0,Y=-55.0,Z=31.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=20.0,PointScale=1.0,PointBone="Body",PointOffset=(X=67.0,Y=55.0,Z=31.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(4)=(PointRadius=30.0,PointScale=1.0,PointBone="Body",PointOffset=(X=-15.0,Y=0.0,Z=0.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    TreadHitMaxHeight=70.15
    DamagedTrackStaticMeshLeft=StaticMesh'DH_allies_vehicles_stc.Sherman.Firefly_DamagedTrack_left'
    DamagedTrackStaticMeshRight=StaticMesh'DH_allies_vehicles_stc.Sherman.Firefly_DamagedTrack_right'
    DamagedEffectScale=0.9
    DamagedEffectOffset=(X=-80.0,Y=0.0,Z=75.0)
    FireAttachBone="Body"
    FireEffectOffset=(X=80.0,Y=-35.0,Z=60.0)
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Sherman.Firefly_Dest'

    // Exit
    ExitPositions(0)=(X=80.0,Y=-115.0,Z=125.0)   // driver's hatch (exit to side)
    ExitPositions(1)=(X=-12.0,Y=25.0,Z=235.0)    // commander's hatch
    ExitPositions(2)=(X=-144.0,Y=-115.0,Z=105.0) // passenger (l)
    ExitPositions(3)=(X=-235.0,Y=-29.0,Z=105.0)  // passenger (bl)
    ExitPositions(4)=(X=-235.0,Y=29.0,Z=105.0)   // passenger (br)
    ExitPositions(5)=(X=-119.0,Y=115.0,Z=105.0)  // passenger (r)
    ExitPositions(6)=(X=80.0,Y=115.0,Z=125.0)    // co-driver's hatch (a fallback)

    // Sounds
    IdleSound=SoundGroup'DH_AlliedVehicleSounds.Sherman.ShermanEngineLoop' // TODO: Sherman Mk.V (M4A4) used a different gasoline multi-engine to M4/M4A1, so ideally add different engine sounds
    StartUpSound=Sound'DH_AlliedVehicleSounds.Sherman.ShermanStart'
    ShutDownSound=Sound'DH_AlliedVehicleSounds.Sherman.ShermanStop'
    LeftTreadSound=Sound'Vehicle_EnginesTwo.UC.UC_tread_L'
    RightTreadSound=Sound'Vehicle_EnginesTwo.UC.UC_tread_R'
    RumbleSound=Sound'DH_AlliedVehicleSounds.Sherman.inside_rumble01'

    // Visual effects
    LeftTreadIndex=5
    RightTreadIndex=4
    TreadVelocityScale=250.0
    WheelRotationScale=91000.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-170.0,Y=-30.0,Z=80.0),ExhaustRotation=(Pitch=53000,Yaw=32768))
    ExhaustPipes(1)=(ExhaustPosition=(X=-170.0,Y=30.0,Z=80.0),ExhaustRotation=(Pitch=53000,Yaw=32768))
    LeftLeverBoneName="lever_L"
    RightLeverBoneName="lever_R"

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.firefly_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.FireFly_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.FireFly_turret_look'
    VehicleHudTreadsPosX(0)=0.38
    VehicleHudTreadsPosX(1)=0.62
    VehicleHudTreadsPosY=0.495
    VehicleHudTreadsScale=0.67
    VehicleHudOccupantsX(0)=0.435
    VehicleHudOccupantsY(0)=0.34
    VehicleHudOccupantsX(2)=0.375
    VehicleHudOccupantsY(2)=0.75
    VehicleHudOccupantsX(3)=0.45
    VehicleHudOccupantsY(3)=0.82
    VehicleHudOccupantsX(4)=0.55
    VehicleHudOccupantsY(4)=0.82
    VehicleHudOccupantsX(5)=0.625
    VehicleHudOccupantsY(5)=0.72
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.sherman_firefly'

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
        WheelRadius=35.0
        bLeftTrack=true
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_ShermanFireflyTank.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        WheelRadius=35.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_ShermanFireflyTank.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        WheelRadius=35.0
        bLeftTrack=true
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_ShermanFireflyTank.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        WheelRadius=35.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_ShermanFireflyTank.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=35.0
        bLeftTrack=true
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_ShermanFireflyTank.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=35.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_ShermanFireflyTank.Right_Drive_Wheel'

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=-0.1,Y=0.0,Z=0.0) // default is X=0.0, Z=-0.5
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_ShermanFireflyTank.KParams0'
}
