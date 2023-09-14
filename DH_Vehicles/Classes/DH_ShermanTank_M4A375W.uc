//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanTank_M4A375W extends DHArmoredVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="M4A3(75)W Sherman"
    VehicleTeam=1
    VehicleMass=13.5
    ReinforcementCost=4

    // Hull mesh
    Mesh=SkeletalMesh'DH_ShermanM4A3_anm.M4A3_body_ext'
    Skins(0)=Texture'DH_VehiclesUS_tex3.ext_vehicles.ShermanM4A3_body_ext'
    Skins(1)=Texture'DH_VehiclesUS_tex3.ext_vehicles.ShermanM4A3E2_wheels'
    Skins(2)=Texture'DH_VehiclesUS_tex.int_vehicles.Sherman_hatch_int'
    Skins(3)=Texture'DH_VehiclesUS_tex.int_vehicles.Sherman_body_int'
    Skins(4)=Texture'DH_VehiclesUS_tex.Treads.Sherman_treads'
    Skins(5)=Texture'DH_VehiclesUS_tex.Treads.Sherman_treads'

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ShermanCannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_ShermanMountedMGPawn_M4A3W',WeaponBone="Mg_placement")
    PassengerPawns(0)=(AttachBone="Passenger_1",DrivePos=(X=0.0,Y=-10.0,Z=5.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(1)=(AttachBone="passenger_2",DrivePos=(X=-10.0,Y=0.0,Z=5.0),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(2)=(AttachBone="passenger_3",DrivePos=(X=0.0,Y=0.0,Z=5.0),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(3)=(AttachBone="passenger_4",DrivePos=(X=0.0,Y=10.0,Z=3.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider5_idle")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_ShermanM4A3_anm.M4A3_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_ShermanM4A3_anm.M4A3_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_ShermanM4A3_anm.M4A3_body_int',TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true)
    DrivePos=(X=3.0,Y=0.0,Z=7.0)

    // Hull armor
    FrontArmor(0)=(Thickness=5.08,Slope=-45.0,MaxRelativeHeight=41.0,LocationName="lower nose")
    FrontArmor(1)=(Thickness=5.08,MaxRelativeHeight=55.0,LocationName="mid nose") // represents flattest, front facing part of rounded nose plate
    FrontArmor(2)=(Thickness=5.08,Slope=56.0,MaxRelativeHeight=73.0,LocationName="upper nose")
    FrontArmor(3)=(Thickness=6.35,Slope=47.0,LocationName="upper")
    RightArmor(0)=(Thickness=3.81)
    LeftArmor(0)=(Thickness=3.81)
    RearArmor(0)=(Thickness=3.81,Slope=-10.0,MaxRelativeHeight=61.0,LocationName="lower")
    RearArmor(1)=(Thickness=3.81,Slope=22.0,LocationName="upper")

    FrontLeftAngle=335.0
    FrontRightAngle=25.0
    RearRightAngle=155.0
    RearLeftAngle=205.0

    // Movement
    MaxCriticalSpeed=638.0 // 38 kph
    GearRatios(4)=0.71
    TransRatio=0.1
    SteerSpeed=75.0

    // Damage
	// pros: 5 men crew; wet stowage
	// cons: petrol
    Health=565
    HealthMax=565.0
	EngineHealth=300
    EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
    DisintegrationHealth=-1000.0 //petrol and wet stowage
    VehHitpoints(0)=(PointRadius=30.0,PointOffset=(X=-90.0,Z=6.0)) // engine
    VehHitpoints(1)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=-15.0,Y=25.0,Z=20.0),DamageMultiplier=3.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=-15.0,Y=-25.0,Z=20.0),DamageMultiplier=3.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=25.0,PointScale=1.0,PointBone="body",PointOffset=(Z=15.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    TreadHitMaxHeight=65.0
    DamagedTrackStaticMeshLeft=StaticMesh'DH_allies_vehicles_stc3.ShermanM4A3.M4A3_DamagedTrack_left'
    DamagedTrackStaticMeshRight=StaticMesh'DH_allies_vehicles_stc3.ShermanM4A3.M4A3_DamagedTrack_right'
    DamagedEffectScale=0.9
    DamagedEffectOffset=(X=-113.0,Y=20.0,Z=79.0)
    FireAttachBone="Player_Driver"
    AmmoIgnitionProbability=0.35 // wet stowage means reduced chance of a hit on an ammo storage location detonating the ammo
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc3.ShermanM4A3.M4A3_75dest'

    // Exit
    ExitPositions(0)=(X=125.0,Y=-25.0,Z=200.0)  // driver's hatch
    ExitPositions(1)=(X=0.0,Y=-25.0,Z=225.0)    // commander's hatch
    ExitPositions(2)=(X=125.0,Y=25.0,Z=200.0)   // hull MG hatch
    ExitPositions(3)=(X=-100.0,Y=-150.0,Z=75.0) // passenger (l)
    ExitPositions(4)=(X=-250.0,Y=-35.0,Z=75.0)  // passenger (bl)
    ExitPositions(5)=(X=-250.0,Y=35.0,Z=75.0)   // passenger (br)
    ExitPositions(6)=(X=-100.0,Y=150.0,Z=75.0)  // passenger (r)
    ExitPositions(7)=(X=250.0,Y=0.0,Z=75.0)     // front

    // Sounds
    IdleSound=SoundGroup'DH_AlliedVehicleSounds.Sherman.ShermanEngineLoop' // TODO: M4A3 used a different gasoline engine to M4/M4A1, so ideally add different engine sounds
    StartUpSound=Sound'DH_AlliedVehicleSounds.Sherman.ShermanStart'
    ShutDownSound=Sound'DH_AlliedVehicleSounds.Sherman.ShermanStop'
    LeftTreadSound=Sound'Vehicle_EnginesTwo.UC.UC_tread_L'
    RightTreadSound=Sound'Vehicle_EnginesTwo.UC.UC_tread_R'
    RumbleSoundBone="Turret_placement"
    RumbleSound=Sound'DH_AlliedVehicleSounds.Sherman.inside_rumble01'

    // Visual effects
    LeftTreadIndex=5
    RightTreadIndex=4
    LeftTreadPanDirection=(Pitch=20480,Yaw=0,Roll=0)
    RightTreadPanDirection=(Pitch=20480,Yaw=0,Roll=0)
    TreadVelocityScale=110.0
    WheelRotationScale=45500.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-160.0,Y=-31.0,Z=51.0),ExhaustRotation=(Pitch=63000,Yaw=-32768))
    ExhaustPipes(1)=(ExhaustPosition=(X=-160.0,Y=31.0,Z=51.0),ExhaustRotation=(Pitch=63000,Yaw=-32768))
    LeftLeverBoneName="lever_L"
    RightLeverBoneName="lever_R"

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.Shermanm4a3_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Sherman_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Sherman_turret_look'
    VehicleHudEngineX=0.51
    VehicleHudTreadsPosY=0.51
    VehicleHudTreadsScale=0.72
    VehicleHudOccupantsX(0)=0.43
    VehicleHudOccupantsX(2)=0.56
    VehicleHudOccupantsX(3)=0.375
    VehicleHudOccupantsY(3)=0.75
    VehicleHudOccupantsX(4)=0.45
    VehicleHudOccupantsY(4)=0.8
    VehicleHudOccupantsX(5)=0.55
    VehicleHudOccupantsY(5)=0.8
    VehicleHudOccupantsX(6)=0.625
    VehicleHudOccupantsY(6)=0.75
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.sherman_m4a3_75w'

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
        BoneOffset=(X=20.0,Z=17.0)
        WheelRadius=36.0
        bLeftTrack=true
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_ShermanTank_M4A375W.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=20.0,Z=17.0)
        WheelRadius=36.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_ShermanTank_M4A375W.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-30.0,Z=17.0)
        WheelRadius=37.0
        bLeftTrack=true
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_ShermanTank_M4A375W.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-30.0,Z=17.0)
        WheelRadius=37.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_ShermanTank_M4A375W.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=17.0)
        WheelRadius=36.0
        bLeftTrack=true
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_ShermanTank_M4A375W.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=17.0)
        WheelRadius=36.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_ShermanTank_M4A375W.Right_Drive_Wheel'

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
//      KCOMOffset=(Z=-0.5) // omits this default
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_ShermanTank_M4A375W.KParams0'
}
