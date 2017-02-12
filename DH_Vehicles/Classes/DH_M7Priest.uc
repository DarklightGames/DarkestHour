//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M7Priest extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_M7Priest_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_M7Priest_tex.utx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_allies_vehicles_stc3.usx

defaultproperties
{
    // Vehicle properties
    VehicleNameString="M7 Priest"
    VehicleTeam=1
    CollisionRadius=175.0
    CollisionHeight=60.0

    // Artillery
    bIsArtilleryVehicle=true

    // Hull mesh
    Mesh=SkeletalMesh'DH_M7Priest_anm.priest_body'
    Skins(0)=texture'DH_M7Priest_tex.ext_vehicles.M7Priest'
    Skins(1)=texture'DH_M7Priest_tex.ext_vehicles.M7Priest2'
    Skins(2)=texture'DH_M7Priest_tex.ext_vehicles.M7Priest_tracks'
    Skins(3)=texture'DH_M7Priest_tex.ext_vehicles.M7Priest_tracks'
    Skins(4)=texture'DH_M7Priest_tex.ext_vehicles.M7Priest_tracks'
    CollisionAttachments(0)=(StaticMesh=StaticMesh'DH_allies_vehicles_stc3.priest.priest_visor_coll',AttachBone="driver_hatch") // collision attachment for driver's armoured visor
    BeginningIdleAnim="driver_hatch_idle_close"

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_M7PriestCannonPawn',WeaponBone="turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_M7PriestMGPawn',WeaponBone="mg_placement")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=40.0,Y=-65.0,Z=10.0),DriveRot=(Yaw=24576),DriveAnim="VHalftrack_Rider6_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-45.0,Y=60.0,Z=10.0),DriveRot=(Yaw=-8192),DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-120.0,Y=-75.0,Z=40.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider2_idle")
    PassengerPawns(3)=(AttachBone="body",DrivePos=(X=-170,Y=0.0,Z=25.0),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(4)=(AttachBone="body",DrivePos=(X=-120.0,Y=75.0,Z=40.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider3_idle")

    // Driver
    UnbuttonedPositionIndex=0
    DriverPositions(0)=(TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=0,ViewNegativeYawLimit=-1,bExposed=true,bDrawOverlays=true,ViewFOV=90.0)
    DriverPositions(1)=(TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=32768,ViewNegativeYawLimit=-32768,bExposed=true,ViewFOV=90.0)
    DriverPositions(2)=(TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=32768,ViewNegativeYawLimit=-32768,bExposed=true,ViewFOV=90.0)
    DriverAttachmentBone="driver_attachment"
    DrivePos=(X=5.0,Y=0.0,Z=3.0)
    FPCamPos=(X=-10.0,Y=0.0,Z=0.0)
    OverlayFPCamPos=(X=4.0,Y=0.0,Z=0.0)

    // Hull armor
    UFrontArmorFactor=1.27
    URightArmorFactor=1.27 // TODO: query 0.5 inch to sides & rear?
    ULeftArmorFactor=1.27
    URearArmorFactor=1.27
    UFrontArmorSlope=55.0 // TODO: query 30 degrees? (upper front varies a lot, but most is 30)
    FrontLeftAngle=335.0
    FrontRightAngle=25.0
    RearRightAngle=155.0
    RearLeftAngle=205.0

    // Movement
    MaxCriticalSpeed=638.0 // 38 kph
    GearRatios(4)=0.72
    TransRatio=0.1 // TODO: may want to review ratios as a result of reduced VehicleMass & increased physics wheel size - currently max speed is 31kph on the flat
    MaxPitchSpeed=150.0

    // Damage
    Health=525
    HealthMax=525.0
    VehHitpoints(0)=(PointRadius=30.0,PointScale=1.0,PointBone="hp_engine")
    VehHitpoints(1)=(PointRadius=15.0,PointScale=1.0,PointBone="hp_ammo_l",DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=15.0,PointScale=1.0,PointBone="hp_ammo_r",DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DriverDamageMult=1.0
    TreadHitMaxHeight=-30
    TreadDamageThreshold=0.75
    DamagedEffectScale=0.9
    DamagedEffectOffset=(X=-85.0,Y=0.0,Z=40.0)
    HullFireChance=0.45
    FireAttachBone="Body"
    FireEffectOffset=(X=105.0,Y=-35.0,Z=50.0)
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc3.priest.priest_destro'

    // Entry & exit
    ExitPositions(0)=(X=50.0,Y=-140.0,Z=-10.0)
    ExitPositions(1)=(X=-50.0,Y=-140.0,Z=-10.0)
    ExitPositions(2)=(X=0.0,Y=140.0,Z=-10.0)
    ExitPositions(3)=(X=15.0,Y=-140.0,Z=-10.0)
    ExitPositions(4)=(X=-52.0,Y=140.0,Z=-10.0)
    ExitPositions(5)=(X=-120.0,Y=-140.0,Z=-10.0)
    ExitPositions(6)=(X=-255.0,Y=0.0,Z=-10.0)
    ExitPositions(7)=(X=-120.0,Y=140.0,Z=-10.0)

    // Sounds
    IdleSound=SoundGroup'DH_AlliedVehicleSounds.Sherman.ShermanEngineLoop'
    StartUpSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanStart'
    ShutDownSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanStop'
    LeftTrackSoundBone="Track_L"
    RightTrackSoundBone="Track_R"
    LeftTreadSound=sound'Vehicle_EnginesTwo.UC.UC_tread_L'
    RightTreadSound=sound'Vehicle_EnginesTwo.UC.UC_tread_R'
    RumbleSoundBone="Camera_driver"
    RumbleSound=sound'DH_AlliedVehicleSounds.Sherman.inside_rumble01'

    // Visual effects
    TreadVelocityScale=130.0
    LeftTreadIndex=3
    RightTreadIndex=4
    LeftTreadPanDirection=(Pitch=0,Yaw=16384,Roll=0)
    RightTreadPanDirection=(Pitch=0,Yaw=16384,Roll=0)
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-150.0,Y=-40.0,Z=30.0),ExhaustRotation=(Pitch=0,Yaw=32768))
    ExhaustPipes(1)=(ExhaustPosition=(X=-150.0,Y=40.0,Z=30.0),ExhaustRotation=(Pitch=0,Yaw=32768))
    LeftLeverBoneName="lever_L"
    LeftLeverAxis=AXIS_X
    RightLeverBoneName="lever_R"
    RightLeverAxis=AXIS_X
    SteeringScaleFactor=0.75

    // HUD
    VehicleHudImage=texture'DH_M7Priest_tex.interface.priest_body'
    VehicleHudTurret=TexRotator'DH_M7Priest_tex.interface.priest_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_M7Priest_tex.interface.priest_turret_look'
    VehicleHudTreadsPosY=0.51
    VehicleHudTreadsScale=0.72
    VehicleHudOccupantsX(0)=0.42
    VehicleHudOccupantsY(0)=0.37
    VehicleHudOccupantsX(1)=0.43
    VehicleHudOccupantsY(1)=0.5
    VehicleHudOccupantsX(2)=0.62
    VehicleHudOccupantsY(2)=0.40
    VehicleHudOccupantsX(3)=0.39
    VehicleHudOccupantsY(3)=0.44
    VehicleHudOccupantsX(4)=0.60
    VehicleHudOccupantsY(4)=0.56
    VehicleHudOccupantsX(5)=0.37
    VehicleHudOccupantsY(5)=0.74
    VehicleHudOccupantsX(6)=0.50
    VehicleHudOccupantsY(6)=0.8
    VehicleHudOccupantsX(7)=0.63
    VehicleHudOccupantsY(7)=0.74
    SpawnOverlay(0)=material'DH_M7Priest_tex.interface.priest'

    // Visible wheels
    WheelRotationScale=650
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
        BoneOffset=(X=0.0,Y=0.0,Z=9.0)
        WheelRadius=33.0
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_M7Priest.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=0.0,Y=0.0,Z=9.0)
        WheelRadius=33.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_M7Priest.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=0.0,Y=0.0,Z=9.0)
        WheelRadius=33.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_M7Priest.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=0.0,Y=0.0,Z=9.0)
        WheelRadius=33.00
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_M7Priest.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=0.0,Y=0.0,Z=9.0)
        WheelRadius=33.0
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_M7Priest.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=0.0,Y=0.0,Z=9.0)
        WheelRadius=33.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_M7Priest.Right_Drive_Wheel'

    // Karma
    VehicleMass=11.5
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-1.7) // default is -0.5
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_M7Priest.KParams0'
}
