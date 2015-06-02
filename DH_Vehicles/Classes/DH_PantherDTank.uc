//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PantherDTank extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\Animations\axis_pantherg_anm.ukx

defaultproperties
{
    SchurzenTexture=none // we don't have a schurzen skin for this camo variant, so add here if one gets made
    SchurzenTypes(0)=(SchurzenClass=class'DH_Vehicles.DH_PantherDeco_SchurzenOne',PercentChance=30)   // undamaged schurzen
    SchurzenTypes(1)=(SchurzenClass=class'DH_Vehicles.DH_PantherDeco_SchurzenTwo',PercentChance=15)   // missing front panel on right & middle panel on left
    SchurzenTypes(2)=(SchurzenClass=class'DH_Vehicles.DH_PantherDeco_SchurzenThree',PercentChance=10) // with front panels missing on both sides
    SchurzenTypes(3)=(SchurzenClass=class'DH_Vehicles.DH_PantherDeco_SchurzenFour',PercentChance=15)  // most badly damaged, with 3 panels missing
    SchurzenOffset=(X=45.5,Y=7.45,Z=-1.0)
    SchurzenIndex=255 // invalid starting value just so if schurzen no. zero is selected, it gets actively set & so flagged for replication
    UnbuttonedPositionIndex=1
    MaxCriticalSpeed=932.0
    TreadDamageThreshold=0.85
    PeriscopeOverlay=texture'DH_VehicleOptics_tex.German.PERISCOPE_overlay_German'
    UFrontArmorFactor=8.5
    URightArmorFactor=4.0
    ULeftArmorFactor=4.0
    URearArmorFactor=4.0
    UFrontArmorSlope=55.0
    URightArmorSlope=40.0
    ULeftArmorSlope=40.0
    URearArmorSlope=30.0
    PointValue=4.0
    MaxPitchSpeed=100.0
    TreadVelocityScale=225.0
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L05'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_R05'
    RumbleSound=sound'Vehicle_Engines.interior.tank_inside_rumble02'
    LeftTrackSoundBone="Track_L"
    RightTrackSoundBone="Track_R"
    RumbleSoundBone="driver_attachment"
    VehicleHudTurret=TexRotator'InterfaceArt_tex.Tank_Hud.panther_turret_rot'
    VehicleHudTurretLook=TexRotator'InterfaceArt_tex.Tank_Hud.panther_turret_look'
    VehicleHudThreadsPosX(0)=0.38
    VehicleHudThreadsPosX(1)=0.63
    VehicleHudThreadsPosY=0.49
    VehicleHudThreadsScale=0.61
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
    WheelRotationScale=2500
    TreadHitMinAngle=1.7
    FrontLeftAngle=334.0
    FrontRightAngle=26.0
    RearRightAngle=154.0
    RearLeftAngle=206.0
    GearRatios(4)=0.8
    TransRatio=0.11
    ChangeUpPoint=1990.0
    ChangeDownPoint=1000.0
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-230.0,Y=20.0,Z=65.0),ExhaustRotation=(Pitch=22000))
    ExhaustPipes(1)=(ExhaustPosition=(X=-230.0,Y=-20.0,Z=65.0),ExhaustRotation=(Pitch=22000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PantherDCannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_PantherMountedMGPawn',WeaponBone="Mg_placement")
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_PantherPassengerOne',WeaponBone="body")
    PassengerWeapons(3)=(WeaponPawnClass=class'DH_Vehicles.DH_PantherPassengerTwo',WeaponBone="body")
    PassengerWeapons(4)=(WeaponPawnClass=class'DH_Vehicles.DH_PantherPassengerThree',WeaponBone="body")
    PassengerWeapons(5)=(WeaponPawnClass=class'DH_Vehicles.DH_PantherPassengerFour',WeaponBone="body")
    IdleSound=SoundGroup'Vehicle_Engines.Tiger.Tiger_engine_loop'
    StartUpSound=sound'Vehicle_Engines.Tiger.tiger_engine_start'
    ShutDownSound=sound'Vehicle_Engines.Tiger.tiger_engine_stop'
    DestroyedVehicleMesh=StaticMesh'axis_vehicles_stc.PantherG.PantherG_Destoyed'
    DamagedEffectOffset=(X=-100.0,Y=20.0,Z=26.0)
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'axis_pantherg_anm.PantherG_body_int',TransitionUpAnim="driver_hatch_open",DriverTransitionAnim="VPanther_driver_close",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=6000,ViewNegativeYawLimit=-6000,ViewFOV=90.0,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'axis_pantherg_anm.PantherG_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VPanther_driver_open",ViewPitchUpLimit=8000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true,ViewFOV=90.0)
    InitialPositionIndex=0
    VehicleHudImage=texture'InterfaceArt_tex.Tank_Hud.panther_body'
    VehicleHudOccupantsX(0)=0.45
    VehicleHudOccupantsY(0)=0.38
    VehicleHudOccupantsX(2)=0.55
    VehicleHudOccupantsY(2)=0.38
    VehicleHudOccupantsX(3)=0.4
    VehicleHudOccupantsY(3)=0.69
    VehicleHudOccupantsX(4)=0.4
    VehicleHudOccupantsY(4)=0.79
    VehicleHudOccupantsX(5)=0.605
    VehicleHudOccupantsY(5)=0.79
    VehicleHudOccupantsX(6)=0.605
    VehicleHudOccupantsY(6)=0.69
    VehHitpoints(0)=(PointRadius=10.0,PointBone="body",PointOffset=(X=100.0,Y=-30.0,Z=61.0),bPenetrationPoint=false)
    VehHitpoints(1)=(PointRadius=32.0,PointHeight=35.0,PointOffset=(X=-90.0,Z=6.0),DamageMultiplier=1.0)
    VehHitpoints(2)=(PointRadius=15.0,PointHeight=30.0,PointScale=1.0,PointBone="body",PointOffset=(X=20.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=15.0,PointHeight=10.0,PointScale=1.0,PointBone="body",PointOffset=(X=-20.0,Y=-40.0,Z=40.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(4)=(PointRadius=15.0,PointHeight=10.0,PointScale=1.0,PointBone="body",PointOffset=(X=-20.0,Y=40.0,Z=40.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DriverAttachmentBone="driver_attachment"
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=32.0,Y=-15.0,Z=-1.0)
        WheelRadius=33.0
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_PantherDTank.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=32.0,Y=15.0,Z=-1.0)
        WheelRadius=33.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_PantherDTank.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-14.0,Y=-15.0,Z=-1.0)
        WheelRadius=33.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_PantherDTank.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-14.0,Y=15.0,Z=-1.0)
        WheelRadius=33.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_PantherDTank.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-15.0,Z=-1.0)
        WheelRadius=33.0
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_PantherDTank.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=15.0,Z=-1.0)
        WheelRadius=33.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_PantherDTank.Right_Drive_Wheel'
    VehicleMass=14.0
    bTurnInPlace=true
    bFPNoZFromCameraPitch=true
    DrivePos=(X=0.0,Y=0.0,Z=0.0)
    DriveAnim="VPanther_driver_idle_close"
    ExitPositions(0)=(X=123.0,Y=-28.0,Z=105.0)
    ExitPositions(1)=(X=-91.0,Y=20.0,Z=110.0)
    ExitPositions(2)=(X=128.0,Y=39.0,Z=105.0)
    ExitPositions(3)=(X=-95.0,Y=-160.0,Z=5.0)
    ExitPositions(4)=(X=-176.0,Y=-162.0,Z=5.0)
    ExitPositions(5)=(X=-176.0,Y=162.0,Z=5.0)
    ExitPositions(6)=(X=-95.0,Y=160.0,Z=5.0)
    EntryRadius=375.0
    DriverDamageMult=1.0
    VehicleNameString="Panzer V Ausf.D"
    MaxDesireability=2.1
    FlagBone="Mg_placement"
    FlagRotation=(Yaw=32768)
    PitchUpLimit=5000
    PitchDownLimit=60000
    HealthMax=600.0
    Health=600
    Mesh=SkeletalMesh'axis_pantherg_anm.PantherG_body_ext'
    Skins(0)=texture'axis_vehicles_tex.ext_vehicles.pantherg_ext'
    Skins(1)=texture'axis_vehicles_tex.Treads.PantherG_treads'
    Skins(2)=texture'axis_vehicles_tex.Treads.PantherG_treads'
    Skins(3)=texture'axis_vehicles_tex.int_vehicles.pantherg_int'
    SoundPitch=32
    SoundRadius=2500.0
    TransientSoundRadius=5000.0
    CollisionRadius=175.0
    CollisionHeight=60.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-0.6)
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=1.0
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_PantherDTank.KParams0'
    HighDetailOverlay=Shader'axis_vehicles_tex.int_vehicles.pantherg_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3
}
