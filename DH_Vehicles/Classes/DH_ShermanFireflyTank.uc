//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ShermanFireflyTank extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_ShermanFirefly_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUK_tex.utx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex.utx

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Sherman Mk.VC"
    VehicleTeam=1
    VehicleMass=13.5

    // Hull mesh
    Mesh=SkeletalMesh'DH_ShermanFirefly_anm.ShermanFirefly_body_ext'
    Skins(0)=texture'DH_VehiclesUK_tex.ext_vehicles.FireFly_body_ext'
    Skins(1)=texture'DH_VehiclesUK_tex.ext_vehicles.FireFly_armor_ext'
    Skins(2)=texture'DH_VehiclesUS_tex.int_vehicles.Sherman_hatch_int'
    Skins(3)=texture'DH_VehiclesUS_tex.int_vehicles.Sherman_body_int'
    Skins(4)=texture'DH_VehiclesUK_tex.Treads.FireFly_treads'
    Skins(5)=texture'DH_VehiclesUK_tex.Treads.FireFly_treads'

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ShermanFireFlyCannonPawn',WeaponBone="Turret_placement")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-120.0,Y=-70.0,Z=35.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-155.0,Y=-25.0,Z=35.0),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-155.0,Y=25.0,Z=35.0),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(3)=(AttachBone="body",DrivePos=(X=-110.0,Y=70.0,Z=35.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider5_idle")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_ShermanFirefly_anm.ShermanFirefly_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,ViewFOV=90.0,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_ShermanFirefly_anm.ShermanFirefly_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,ViewFOV=90.0)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_ShermanFirefly_anm.ShermanFirefly_body_int',TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true,ViewFOV=90.0)
    DrivePos=(X=7.0,Y=0.0,Z=11.0)

    // Hull armor
    FrontArmor(0)=(Thickness=5.1,Slope=55.0)
    RightArmor(0)=(Thickness=3.8)
    LeftArmor(0)=(Thickness=3.8)
    RearArmor(0)=(Thickness=3.8,Slope=10.0)
/*
    FrontArmor(0)=(Thickness=x.0,Slope=-x.0,MaxRelativeHeight=x.0,LocationName="lower")
    FrontArmor(1)=(Thickness=x.0,Slope=x.0,LocationName="upper")
    RightArmor(0)=(Thickness=x.0,MaxRelativeHeight=x.0,LocationName="lower")
    RightArmor(1)=(Thickness=x.0,Slope=x.0,LocationName="upper")
    LeftArmor(0)=(Thickness=x.0,MaxRelativeHeight=x.0,LocationName="lower")
    LeftArmor(1)=(Thickness=x.0,Slope=x.0,LocationName="upper")
    RearArmor(0)=(Thickness=x.0,Slope=-x.0,MaxRelativeHeight=x.0,LocationName="lower")
    RearArmor(1)=(Thickness=x.0,Slope=x.0,LocationName="upper")

    UFrontArmorFactor=5.1
    URightArmorFactor=3.8
    ULeftArmorFactor=3.8
    URearArmorFactor=3.8
    UFrontArmorSlope=55.0
    URearArmorSlope=10.0
*/
    FrontLeftAngle=335.0
    FrontRightAngle=25.0
    RearRightAngle=155.0
    RearLeftAngle=205.0

    // Movement
    MaxCriticalSpeed=693.0 // 41 kph
    GearRatios(3)=0.62
    GearRatios(4)=0.76
    TransRatio=0.09

    // Damage
    VehHitpoints(0)=(PointRadius=30.0,PointOffset=(X=-90.0,Z=6.0)) // engine
    VehHitpoints(1)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=75.0,Y=22.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=50.0,Y=-55.0,Z=30.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=50.0,Y=55.0,Z=30.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(4)=(PointRadius=30.0,PointScale=1.0,PointBone="body",PointOffset=(X=-15.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    TreadHitMaxHeight=64.0
    DamagedEffectScale=0.9
    DamagedEffectOffset=(X=-113.0,Y=20.0,Z=79.0)
    HullFireChance=0.45
    FireAttachBone="Player_Driver"
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Sherman.Firefly_Dest'

    // Exit
    ExitPositions(0)=(X=125.0,Y=-25.0,Z=200.0)  // driver's hatch
    ExitPositions(1)=(X=0.0,Y=-25.0,Z=225.0)    // commander's hatch
    ExitPositions(2)=(X=-100.0,Y=-150.0,Z=75.0) // passenger (l)
    ExitPositions(3)=(X=-250.0,Y=-35.0,Z=75.0)  // passenger (bl)
    ExitPositions(4)=(X=-250.0,Y=35.0,Z=75.0)   // passenger (br)
    ExitPositions(5)=(X=-100.0,Y=150.0,Z=75.0)  // passenger (r)
    ExitPositions(6)=(X=250.0,Y=0.0,Z=75.0)     // front

    // Sounds
    IdleSound=SoundGroup'DH_AlliedVehicleSounds.Sherman.ShermanEngineLoop'
    StartUpSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanStart'
    ShutDownSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanStop'
    LeftTreadSound=sound'Vehicle_EnginesTwo.UC.UC_tread_L'
    RightTreadSound=sound'Vehicle_EnginesTwo.UC.UC_tread_R'
    RumbleSoundBone="Turret_placement"
    RumbleSound=sound'DH_AlliedVehicleSounds.Sherman.inside_rumble01'

    // Visual effects
    LeftTreadIndex=5
    RightTreadIndex=4
    TreadVelocityScale=250.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-116.0,Z=35.0),ExhaustRotation=(Pitch=31000,Yaw=-16384))
    LeftLeverBoneName="lever_L"
    RightLeverBoneName="lever_R"

    // HUD
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.firefly_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.FireFly_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.FireFly_turret_look'
    VehicleHudEngineX=0.51
    VehicleHudTreadsPosX(0)=0.34
    VehicleHudTreadsPosX(1)=0.64
    VehicleHudTreadsPosY=0.51
    VehicleHudTreadsScale=0.72
    VehicleHudOccupantsX(0)=0.43
    VehicleHudOccupantsX(1)=0.5
    VehicleHudOccupantsY(1)=0.5
    VehicleHudOccupantsX(2)=0.375
    VehicleHudOccupantsY(2)=0.75
    VehicleHudOccupantsX(3)=0.45
    VehicleHudOccupantsY(3)=0.8
    VehicleHudOccupantsX(4)=0.55
    VehicleHudOccupantsY(4)=0.8
    VehicleHudOccupantsX(5)=0.625
    VehicleHudOccupantsY(5)=0.75
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.sherman_firefly'

    // Visible wheels
    LeftWheelBones(0)="Wheel_R_1" // the left & right wheel bones are muddled up in the skeletal mesh !
    LeftWheelBones(1)="Wheel_R_2"
    LeftWheelBones(2)="Wheel_R_3"
    LeftWheelBones(3)="Wheel_R_4"
    LeftWheelBones(4)="Wheel_R_5"
    LeftWheelBones(5)="Wheel_R_6"
    LeftWheelBones(6)="Wheel_R_7"
    LeftWheelBones(7)="Wheel_R_8"
    LeftWheelBones(8)="Wheel_R_9"
    LeftWheelBones(9)="Wheel_R_10"
    LeftWheelBones(10)="Wheel_R_11"
    RightWheelBones(0)="Wheel_L_1"
    RightWheelBones(1)="Wheel_L_2"
    RightWheelBones(2)="Wheel_L_3"
    RightWheelBones(3)="Wheel_L_4"
    RightWheelBones(4)="Wheel_L_5"
    RightWheelBones(5)="Wheel_L_6"
    RightWheelBones(6)="Wheel_L_7"
    RightWheelBones(7)="Wheel_L_8"
    RightWheelBones(8)="Wheel_L_9"
    RightWheelBones(9)="Wheel_L_10"
    RightWheelBones(10)="Wheel_L_11"

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=20.0,Z=17.0)
        WheelRadius=36.0
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_ShermanFireflyTank.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=20.0,Z=17.0)
        WheelRadius=36.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_ShermanFireflyTank.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-30.0,Z=17.0)
        WheelRadius=36.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_ShermanFireflyTank.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-30.0,Z=17.0)
        WheelRadius=36.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_ShermanFireflyTank.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=17.0)
        WheelRadius=36.0
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_ShermanFireflyTank.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=17.0)
        WheelRadius=36.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_ShermanFireflyTank.Right_Drive_Wheel'

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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_ShermanFireflyTank.KParams0'
}
