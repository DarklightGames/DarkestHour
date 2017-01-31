//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M7Priest extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_M7Priest_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_M7Priest_tex.utx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_allies_vehicles_stc.usx

defaultproperties
{
    LeftTreadIndex=3
    RightTreadIndex=4
    MaxCriticalSpeed=638.0
    TreadDamageThreshold=0.75
    HullFireChance=0.45
    UFrontArmorFactor=5.1
    URightArmorFactor=3.8
    ULeftArmorFactor=3.8
    URearArmorFactor=3.8
    UFrontArmorSlope=55.0
    MaxPitchSpeed=150.0
    TreadVelocityScale=130.0
    LeftTreadSound=sound'Vehicle_EnginesTwo.UC.UC_tread_L'
    RightTreadSound=sound'Vehicle_EnginesTwo.UC.UC_tread_R'
    RumbleSound=sound'DH_AlliedVehicleSounds.Sherman.inside_rumble01'
    LeftTrackSoundBone="Track_L"
    RightTrackSoundBone="Track_R"
    RumbleSoundBone="Camera_driver"
    VehicleHudTurret=TexRotator'DH_M7Priest_tex.interface.priest_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_M7Priest_tex.interface.priest_turret_look'
    VehicleHudTreadsPosY=0.51
    VehicleHudTreadsScale=0.72
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
    WheelRotationScale=600
    TreadHitMaxHeight=-30
    FrontLeftAngle=335.0
    FrontRightAngle=25.0
    RearRightAngle=155.0
    RearLeftAngle=205.0
    GearRatios(4)=0.72
    TransRatio=0.1
    LeftLeverBoneName="lever_L"
    LeftLeverAxis=AXIS_X
    RightLeverBoneName="lever_R"
    RightLeverAxis=AXIS_X
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-150.0,Y=-40,Z=30.0),ExhaustRotation=(Pitch=0,Yaw=32768))
    ExhaustPipes(1)=(ExhaustPosition=(X=-150.0,Y=40,Z=30.0),ExhaustRotation=(Pitch=0,Yaw=32768))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_M7PriestCannonPawn',WeaponBone="turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_M7PriestMGPawn',WeaponBone="mg_placement")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=40.0,Y=-65.0,Z=10.0),DriveRot=(Yaw=24576),DriveAnim="VHalftrack_Rider6_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-45.0,Y=60.0,Z=10.0),DriveRot=(Yaw=-8192),DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-120.0,Y=-75.0,Z=40.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider2_idle")
    PassengerPawns(3)=(AttachBone="body",DrivePos=(X=-170,Y=0,Z=25),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(4)=(AttachBone="body",DrivePos=(X=-120.0,Y=75.0,Z=40.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider3_idle")
    IdleSound=SoundGroup'DH_AlliedVehicleSounds.Sherman.ShermanEngineLoop'
    StartUpSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanStart'
    ShutDownSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanStop'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Sherman.Sherman_Dest'    // TODO: get a proper one
    DamagedEffectScale=0.9
    DamagedEffectOffset=(X=-110.0,Y=0.0,Z=95.0)
    VehicleTeam=1
    SteeringScaleFactor=0.75
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=0,ViewNegativeYawLimit=-1,ViewFOV=90.0,bDrawOverlays=true)
    DriverPositions(1)=(TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=32768,ViewNegativeYawLimit=-32768,ViewFOV=90.0)
    DriverPositions(2)=(TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=32768,ViewNegativeYawLimit=-32768,bExposed=true,ViewFOV=90.0)
    VehicleHudImage=texture'DH_M7Priest_tex.interface.priest_body'
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
    VehicleHudEngineX=0.51
    // TODO: set these up
    VehHitpoints(0)=(PointRadius=30.0,PointOffset=(X=-90.0,Z=60.0)) // engine
    VehHitpoints(1)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=-15.0,Y=40.0,Z=87.0),DamageMultiplier=4.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=-15.0,Y=-40.0,Z=87.0),DamageMultiplier=4.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=25.0,PointScale=1.0,PointBone="body",PointOffset=(Z=55.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DriverAttachmentBone="driver_attachment"    // TODO: put this in the exterior mesh
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        WheelRadius=23.0
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_M7Priest.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        WheelRadius=25.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_M7Priest.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        WheelRadius=25.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_M7Priest.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        WheelRadius=25.00
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_M7Priest.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=25.0
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_M7Priest.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=25.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_M7Priest.Right_Drive_Wheel'
    VehicleMass=13.5
    bFPNoZFromCameraPitch=true
    DrivePos=(X=5.0,Y=0.0,Z=3.0)

    ExitPositions(0)=(X=50.00,Y=-140.00,Z=-10.00)
    ExitPositions(1)=(X=-50.00,Y=-140.00,Z=-10.00)
    ExitPositions(2)=(X=0.00,Y=140.00,Z=-10.00)
    ExitPositions(3)=(X=15.00,Y=-140.00,Z=-10.00)
    ExitPositions(4)=(X=-52.00,Y=140.00,Z=-10.00)
    ExitPositions(5)=(X=-120.00,Y=-140.00,Z=-10.00)
    ExitPositions(6)=(X=-255.00,Y=0.00,Z=-10.00)
    ExitPositions(7)=(X=-120.00,Y=140.00,Z=-10.00)

    DriverDamageMult=1.0
    VehicleNameString="M7 Priest"
    // TODO: flag?
    FlagBone="Mg_placement"
    FlagRotation=(Yaw=32768)
    PitchUpLimit=5000
    PitchDownLimit=60000
    HealthMax=525.0
    Health=525
    Mesh=SkeletalMesh'DH_M7Priest_anm.ext_body'
    Skins(0)=texture'DH_M7Priest_tex.ext_vehicles.M7Priest'
    Skins(1)=texture'DH_M7Priest_tex.ext_vehicles.M7Priest2'
    Skins(2)=texture'DH_M7Priest_tex.ext_vehicles.M7Priest_tracks'
    Skins(3)=texture'DH_M7Priest_tex.ext_vehicles.M7Priest_tracks'
    Skins(4)=texture'DH_M7Priest_tex.ext_vehicles.M7Priest_tracks'
    // TODO: figure this one out
    CollisionRadius=175.0
    CollisionHeight=60.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-1.2) // default is -0.5
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
    LeftTreadPanDirection=(Pitch=0,Yaw=16384,Roll=0)
    RightTreadPanDirection=(Pitch=0,Yaw=16384,Roll=0)
    SpawnOverlay(0)=material'DH_M7Priest_tex.interface.priest'
    UnbuttonedPositionIndex=0
}

