//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_JacksonTank extends DHTreadCraft;

#exec OBJ LOAD FILE=..\Animations\DH_Jackson_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex4.utx

defaultproperties
{
    bAllowRiders=true
    LeftTreadIndex=5
    RightTreadIndex=4
    MaxCriticalSpeed=766.0
    TreadDamageThreshold=0.75
    UFrontArmorFactor=3.8
    URightArmorFactor=1.9
    ULeftArmorFactor=1.9
    URearArmorFactor=1.9
    UFrontArmorSlope=55.0
    URightArmorSlope=38.0
    ULeftArmorSlope=38.0
    PointValue=3.0
    MaxPitchSpeed=150.0
    TreadVelocityScale=233.0
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L03'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_R03'
    RumbleSound=sound'DH_AlliedVehicleSounds.Sherman.inside_rumble01'
    LeftTrackSoundBone="Track_L"
    RightTrackSoundBone="Track_R"
    RumbleSoundBone="driver_attachment"
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.M36_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.M36_turret_look'
    VehicleHudThreadsPosX(0)=0.37
    VehicleHudThreadsPosX(1)=0.66
    VehicleHudThreadsPosY=0.51
    VehicleHudThreadsScale=0.63
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
    WheelRotationScale=2200
    TreadHitMinAngle=1.8
    FrontLeftAngle=332.0
    RearLeftAngle=208.0
    GearRatios(4)=0.75
    TransRatio=0.1
    SteerBoneName="Steering"
    LeftLeverBoneName="lever_L"
    LeftLeverAxis=AXIS_Z
    RightLeverBoneName="lever_R"
    RightLeverAxis=AXIS_Z
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-100.0,Z=40.0),ExhaustRotation=(Pitch=31000,Yaw=-16384))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_JacksonCannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_JacksonPassengerOne',WeaponBone="Jackson_body_ext")
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_JacksonPassengerTwo',WeaponBone="Jackson_body_ext")
    PassengerWeapons(3)=(WeaponPawnClass=class'DH_Vehicles.DH_JacksonPassengerThree',WeaponBone="Jackson_body_ext")
    PassengerWeapons(4)=(WeaponPawnClass=class'DH_Vehicles.DH_JacksonPassengerFour',WeaponBone="Jackson_body_ext")
    IdleSound=SoundGroup'Vehicle_Engines.SU76.SU76_engine_loop'
    StartUpSound=sound'Vehicle_Engines.SU76.SU76_engine_start'
    ShutDownSound=sound'Vehicle_Engines.SU76.SU76_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc2.Jackson.Jackson_Dest'
    DamagedEffectOffset=(X=-126.0,Y=20.0,Z=105.0)
    VehicleTeam=1
    SteeringScaleFactor=0.75
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Jackson_anm.Jackson_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,ViewFOV=90.0,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Jackson_anm.Jackson_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="VPanzer3_driver_idle_open",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,ViewFOV=90.0)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Jackson_anm.Jackson_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VPanzer3_driver_idle_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true,ViewFOV=90.0)
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.M36_Body'
    VehicleHudOccupantsX(0)=0.43
    VehicleHudOccupantsY(0)=0.32
    VehicleHudOccupantsX(1)=0.5
    VehicleHudOccupantsY(1)=0.5
    VehicleHudOccupantsX(2)=0.4
    VehicleHudOccupantsY(2)=0.65
    VehicleHudOccupantsX(3)=0.45
    VehicleHudOccupantsY(3)=0.725
    VehicleHudOccupantsX(4)=0.55
    VehicleHudOccupantsY(4)=0.725
    VehicleHudOccupantsX(5)=0.6
    VehicleHudOccupantsY(5)=0.65
    VehicleHudEngineX=0.51
    VehHitpoints(0)=(PointOffset=(Y=2.0,Z=-2.0),bPenetrationPoint=false)
    VehHitpoints(1)=(PointRadius=35.0,PointBone="Jackson_body_ext",PointOffset=(X=-90.0,Z=-35.0),DamageMultiplier=1.0)
    VehHitpoints(2)=(PointRadius=15.0,PointScale=1.0,PointBone="Jackson_body_ext",PointOffset=(X=20.0,Y=55.0,Z=-8.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=15.0,PointScale=1.0,PointBone="Jackson_body_ext",PointOffset=(X=20.0,Y=-55.0,Z=-8.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(4)=(PointRadius=25.0,PointScale=1.0,PointBone="Jackson_body_ext",PointOffset=(X=-20.0,Z=-20.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DriverAttachmentBone="driver_attachment"
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=10.0,Z=10.0)
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
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_JacksonTank.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=10.0)
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_JacksonTank.Right_Drive_Wheel'
    VehicleMass=13.0
    bFPNoZFromCameraPitch=true
    DrivePos=(X=-3.0,Y=0.0,Z=-3.0)
    DriveAnim="VPanzer3_driver_idle_close"
    ExitPositions(0)=(X=150.0,Y=-35.0,Z=175.0)  //driver
    ExitPositions(1)=(X=-20.0,Y=0.0,Z=250.0)    //commander
    ExitPositions(2)=(X=-125.0,Y=-150.0,Z=75.0) //passenger (l)
    ExitPositions(3)=(X=-250.0,Y=-35.0,Z=75.0)  //passenger (rl)
    ExitPositions(4)=(X=-250.0,Y=35.0,Z=75.0)   //passenger (rr)
    ExitPositions(5)=(X=-125.0,Y=150.0,Z=75.0)  //passenger (r)
    EntryRadius=375.0
    FPCamPos=(X=120.0,Y=-21.0,Z=17.0)
    DriverDamageMult=1.0
    VehicleNameString="M36 Jackson"
    MaxDesireability=1.9
    FlagBone="Mg_placement"
    FlagRotation=(Yaw=32768)
    PitchUpLimit=5000
    PitchDownLimit=60000
    HealthMax=500.0
    Health=500
    Mesh=SkeletalMesh'DH_Jackson_anm.Jackson_body_ext'
    Skins(0)=texture'DH_VehiclesUS_tex3.ext_vehicles.M36_Body'
    Skins(1)=texture'DH_VehiclesUS_tex3.ext_vehicles.M36_turret_ext'
    Skins(2)=texture'DH_VehiclesUS_tex.int_vehicles.M10_body_int'
    Skins(3)=texture'DH_VehiclesUS_tex.int_vehicles.M10_body_int2'
    Skins(4)=texture'DH_VehiclesUS_tex.Treads.M10_treads'
    Skins(5)=texture'DH_VehiclesUS_tex.Treads.M10_treads'
    SoundRadius=800.0
    TransientSoundRadius=1500.0
    CollisionRadius=175.0
    CollisionHeight=60.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-0.7)
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_JacksonTank.KParams0'
    LeftTreadPanDirection=(Pitch=0,Yaw=32768,Roll=16384)
    RightTreadPanDirection=(Pitch=32768,Yaw=0,Roll=16384)
    FirstRiderPositionIndex=1
}
