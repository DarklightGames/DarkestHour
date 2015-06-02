//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_JagdpanzerIVL48Destroyer extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_Jagdpanzer4_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex4.utx
#exec OBJ LOAD FILE=..\Textures\axis_vehicles_tex.utx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_German_vehicles_stc4.usx

defaultproperties
{
    NewVehHitpoints(0)=(PointRadius=5.0,PointScale=1.0,PointBone="body",PointOffset=(X=40.0,Y=10.5,Z=65.0),NewHitPointType=NHP_GunOptics)
    NewVehHitpoints(1)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=100.0,Y=10.0,Z=35.0),NewHitPointType=NHP_Traverse)
    NewVehHitpoints(2)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=100.0,Y=10.0,Z=35.0),NewHitPointType=NHP_GunPitch)
    bAllowRiders=true
    LeftTreadIndex=4
    RightTreadIndex=3
    MaxCriticalSpeed=730.0
    TreadDamageThreshold=0.75
    PeriscopeOverlay=texture'DH_VehicleOptics_tex.German.PERISCOPE_overlay_German'
    UFrontArmorFactor=8.0
    URightArmorFactor=4.0
    ULeftArmorFactor=4.0
    URearArmorFactor=2.0
    UFrontArmorSlope=50.0
    URightArmorSlope=30.0
    ULeftArmorSlope=30.0
    URearArmorSlope=9.0
    PointValue=3.0
    MaxPitchSpeed=150.0
    TreadVelocityScale=100.0
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L08'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_R08'
    RumbleSound=sound'Vehicle_Engines.interior.tank_inside_rumble02'
    LeftTrackSoundBone="Track_L"
    RightTrackSoundBone="Track_R"
    RumbleSoundBone="driver_attachment"
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.JPIVL48_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.JPIVL48_turret_look'
    VehicleHudThreadsPosX(0)=0.36
    VehicleHudThreadsPosX(1)=0.64
    VehicleHudThreadsPosY=0.51
    VehicleHudThreadsScale=0.66
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
    LeftWheelBones(11)="Wheel_L_12"
    LeftWheelBones(12)="Wheel_L_13"
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
    RightWheelBones(11)="Wheel_R_12"
    RightWheelBones(12)="Wheel_R_13"
    WheelRotationScale=2000
    TreadHitMinAngle=1.7
    FrontLeftAngle=332.0
    RearLeftAngle=208.0
    LeftLeverBoneName="lever_L"
    LeftLeverAxis=AXIS_Z
    RightLeverBoneName="lever_R"
    RightLeverAxis=AXIS_Z
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-170.0,Y=16.0,Z=30.0),ExhaustRotation=(Pitch=22000,Yaw=9000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdpanzerIVL48CannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdpanzerIVMountedMGPawn',WeaponBone="Mg_placement")
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdpanzerIVPassengerOne',WeaponBone="body")
    PassengerWeapons(3)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdpanzerIVPassengerTwo',WeaponBone="body")
    IdleSound=SoundGroup'Vehicle_Engines.PanzerIV.PanzerIV_engine_loop'
    StartUpSound=sound'Vehicle_Engines.PanzerIV.PanzerIV_engine_start'
    ShutDownSound=sound'Vehicle_Engines.PanzerIV.PanzerIV_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc4.Jagdpanzer4.Jagdpanzer4_dest48'
    DamagedEffectScale=0.9
    DamagedEffectOffset=(X=-100.0,Y=20.0,Z=26.0)
    SteeringScaleFactor=0.75
    BeginningIdleAnim="Overlay_Idle"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L48_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=5000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=1,ViewNegativeYawLimit=-1,ViewFOV=90.0,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L48_body_int',TransitionDownAnim="Overlay_In",ViewPitchUpLimit=5000,ViewPitchDownLimit=63500,ViewPositiveYawLimit=5000,ViewNegativeYawLimit=-5500,ViewFOV=90.0)
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.JPIV_body'
    VehicleHudOccupantsX(0)=0.43
    VehicleHudOccupantsX(1)=0.46
    VehicleHudOccupantsX(2)=0.6
    VehicleHudOccupantsX(3)=0.5
    VehicleHudOccupantsX(4)=0.6
    VehicleHudOccupantsY(0)=0.42
    VehicleHudOccupantsY(1)=0.56
    VehicleHudOccupantsY(2)=0.42
    VehicleHudOccupantsY(3)=0.7
    VehicleHudOccupantsY(4)=0.7
    VehHitpoints(0)=(PointRadius=2.0,PointOffset=(X=-15.0,Z=-22.0),bPenetrationPoint=false)
    VehHitpoints(1)=(PointRadius=35.0,PointOffset=(X=-100.0,Z=10.0),DamageMultiplier=1.0)
    VehHitpoints(2)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(Y=50.0,Z=40.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(Y=-50.0,Z=40.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(4)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(X=-20.0,Y=-40.0,Z=20.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DriverAttachmentBone="driver_attachment"
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=35.0,Y=-5.0,Z=6.0)
        WheelRadius=29.0
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_JagdpanzerIVL48Destroyer.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=35.0,Y=5.0,Z=6.0)
        WheelRadius=29.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_JagdpanzerIVL48Destroyer.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-7.0,Y=-5.0,Z=6.0)
        WheelRadius=29.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_JagdpanzerIVL48Destroyer.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-7.0,Y=5.0,Z=6.0)
        WheelRadius=29.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_JagdpanzerIVL48Destroyer.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=6.0)
        WheelRadius=29.0
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_JagdpanzerIVL48Destroyer.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=6.0)
        WheelRadius=29.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_JagdpanzerIVL48Destroyer.Right_Drive_Wheel'
    VehicleMass=12.0
    bDrawDriverInTP=false
    bFPNoZFromCameraPitch=true
    ExitPositions(0)=(X=-26.0,Y=-25.0,Z=135.0)
    ExitPositions(1)=(X=-26.0,Y=-25.0,Z=135.0)
    ExitPositions(2)=(X=-26.0,Y=-25.0,Z=135.0)
    ExitPositions(3)=(X=-251.0,Y=-7.0,Z=5.0)
    ExitPositions(4)=(X=-252.0,Y=39.0,Z=5.0)
    EntryRadius=375.0
    DriverDamageMult=1.0
    VehicleNameString="Jagdpanzer IV/48"
    MaxDesireability=1.9
    FlagBone="Mg_placement"
    FlagRotation=(Yaw=32768)
    PitchUpLimit=5000
    PitchDownLimit=60000
    HealthMax=525.0
    Health=525
    Mesh=SkeletalMesh'DH_Jagdpanzer4_anm.jagdpanzer4L48_body_ext'
    Skins(0)=texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_body_camo1'
    Skins(1)=texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_armor_camo1'
    Skins(2)=texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_wheels_camo1'
    Skins(3)=texture'axis_vehicles_tex.Treads.panzer4F2_treads'
    Skins(4)=texture'axis_vehicles_tex.Treads.panzer4F2_treads'
    Skins(5)=texture'DH_VehiclesGE_tex4.int_vehicles.jagdpanzeriv_body_int'
    SoundRadius=800.0
    TransientSoundRadius=1500.0
    CollisionRadius=175.0
    CollisionHeight=60.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-1.5)
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_JagdpanzerIVL48Destroyer.KParams0'
    HighDetailOverlayIndex=5
}
