//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ShermanTank_M4A3E2 extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_ShermanM4A3_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex.utx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex3.utx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_allies_vehicles_stc3.usx

defaultproperties
{
    LeftTreadIndex=5
    RightTreadIndex=4
    TreadHitMaxHeight=65.0
    DamagedTrackStaticMeshLeft=StaticMesh'DH_allies_vehicles_stc3.ShermanM4A3.M4A3E2_DamagedTrack_left'
    DamagedTrackStaticMeshRight=StaticMesh'DH_allies_vehicles_stc3.ShermanM4A3.M4A3E2_DamagedTrack_right'
    DamagedTrackAttachBone="body"
    MaxCriticalSpeed=638.0
    AmmoIgnitionProbability=0.5
    TreadDamageThreshold=0.75
    FireAttachBone="Player_Driver"
    UFrontArmorFactor=8.7
    URightArmorFactor=5.8
    ULeftArmorFactor=5.8
    URearArmorFactor=3.8
    UFrontArmorSlope=47.0
    URearArmorSlope=10.0
    PointValue=4.0
    MaxPitchSpeed=150.0
    TreadVelocityScale=110.0
    LeftTreadSound=sound'Vehicle_EnginesTwo.UC.UC_tread_L'
    RightTreadSound=sound'Vehicle_EnginesTwo.UC.UC_tread_R'
    RumbleSound=sound'DH_AlliedVehicleSounds.Sherman.inside_rumble01'
    LeftTrackSoundBone="Track_L"
    RightTrackSoundBone="Track_R"
    RumbleSoundBone="Turret_placement"
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.ShermanJumbo75_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.ShermanJumbo75_turret_look'
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
    WheelRotationScale=700
    FrontLeftAngle=335.0
    FrontRightAngle=25.0
    RearRightAngle=155.0
    RearLeftAngle=205.0
    GearRatios(4)=0.67
    TransRatio=0.07
    SteerSpeed=75.0
    SteerBoneName="Steering"
    LeftLeverBoneName="lever_L"
    LeftLeverAxis=AXIS_Z
    RightLeverBoneName="lever_R"
    RightLeverAxis=AXIS_Z
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-116.0,Z=35.0),ExhaustRotation=(Pitch=31000,Yaw=-16384))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ShermanCannonPawn_M4A3E2',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_ShermanMountedMGPawn',WeaponBone="Mg_placement")
    PassengerPawns(0)=(AttachBone="Passenger_1",DrivePos=(X=0.0,Y=-10.0,Z=5.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(1)=(AttachBone="passenger_2",DrivePos=(X=-10.0,Y=0.0,Z=5.0),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(2)=(AttachBone="passenger_3",DrivePos=(X=0.0,Y=0.0,Z=5.0),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(3)=(AttachBone="passenger_4",DrivePos=(X=0.0,Y=10.0,Z=3.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider5_idle")
    IdleSound=SoundGroup'DH_AlliedVehicleSounds.Sherman.ShermanEngineLoop'
    StartUpSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanStart'
    ShutDownSound=sound'DH_AlliedVehicleSounds.Sherman.ShermanStop'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc3.ShermanM4A3.M4A3E2_dest'
    DamagedEffectScale=0.9
    DamagedEffectOffset=(X=-113.0,Y=20.0,Z=79.0)
    VehicleTeam=1
    SteeringScaleFactor=0.75
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_ShermanM4A3_anm.ShermanM4A3E2_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,ViewFOV=90.0,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_ShermanM4A3_anm.ShermanM4A3E2_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,ViewFOV=90.0)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_ShermanM4A3_anm.ShermanM4A3E2_body_int',TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=5000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true,ViewFOV=90.0)
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.shermanm4a3e2_body'
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
    VehicleHudEngineX=0.51
    VehHitpoints(0)=(PointRadius=30.0,PointOffset=(X=-90.0,Z=6.0)) // engine
    VehHitpoints(1)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=-15.0,Y=25.0,Z=20.0),DamageMultiplier=3.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=-15.0,Y=-25.0,Z=20.0),DamageMultiplier=3.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=25.0,PointScale=1.0,PointBone="body",PointOffset=(Z=15.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DriverAttachmentBone="driver_attachment"
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=20.0,Z=17.0)
        WheelRadius=36.0
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_ShermanTank_M4A3E2.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=20.0,Z=17.0)
        WheelRadius=36.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_ShermanTank_M4A3E2.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-30.0,Z=17.0)
        WheelRadius=37.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_ShermanTank_M4A3E2.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-30.0,Z=17.0)
        WheelRadius=37.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_ShermanTank_M4A3E2.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=17.0)
        WheelRadius=36.0
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_ShermanTank_M4A3E2.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=17.0)
        WheelRadius=36.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_ShermanTank_M4A3E2.Right_Drive_Wheel'
    VehicleMass=14.0
    bFPNoZFromCameraPitch=true
    DrivePos=(X=3.0,Y=0.0,Z=7.0)
    ExitPositions(0)=(X=125.0,Y=-25.0,Z=200.0)      //driver's hatch
    ExitPositions(1)=(X=0.0,Y=-25.0,Z=225.0)        //commander's hatch
    ExitPositions(2)=(X=125.0,Y=25.0,Z=200.0)       //mg's hatch
    ExitPositions(3)=(X=-100.0,Y=-150.0,Z=75.0)     //passenger (l)
    ExitPositions(4)=(X=-250.0,Y=-35.0,Z=75.0)    //passenger (rl)
    ExitPositions(5)=(X=-250.0,Y=35.0,Z=75.0)     //passenger (rr)
    ExitPositions(6)=(X=-100.0,Y=150.0,Z=75.0)      //passenger (r)
    ExitPositions(7)=(X=250.0,Y=0.0,Z=75.0)         //front
    DriverDamageMult=1.0
    VehicleNameString="M4A3E2(75)W Sherman"
    MaxDesireability=1.9
    FlagBone="Mg_placement"
    FlagRotation=(Yaw=32768)
    PitchUpLimit=5000
    PitchDownLimit=60000
    HealthMax=575.0
    Health=575
    Mesh=SkeletalMesh'DH_ShermanM4A3_anm.ShermanM4A3E2_body_ext'
    Skins(0)=texture'DH_VehiclesUS_tex3.ext_vehicles.ShermanM4A3E2_ext'
    Skins(1)=texture'DH_VehiclesUS_tex3.ext_vehicles.ShermanM4A3E2_wheels'
    Skins(2)=texture'DH_VehiclesUS_tex.int_vehicles.Sherman_hatch_int'
    Skins(3)=texture'DH_VehiclesUS_tex.int_vehicles.Sherman_body_int'
    Skins(4)=texture'DH_VehiclesUS_tex.Treads.Sherman_treads'
    Skins(5)=texture'DH_VehiclesUS_tex.Treads.Sherman_treads'
    CollisionRadius=175.0
    CollisionHeight=60.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_ShermanTank_M4A3E2.KParams0'
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.sherman_m4a3e2'
}
