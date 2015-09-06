//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_JagdpantherTank extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_Jagdpanther_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex2.utx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex3.utx

defaultproperties
{
    SchurzenTexture=texture'DH_VehiclesGE_tex.ext_vehicles.PantherG_armor_camo2' // ideally get better matching texture made, but for now this is passable match
    SchurzenTypes(0)=(SchurzenStaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherSchurzen1',PercentChance=30) // undamaged schurzen
    SchurzenTypes(1)=(SchurzenStaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherSchurzen2',PercentChance=15) // missing front panel on right & middle panel on left
    SchurzenTypes(2)=(SchurzenStaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherSchurzen3',PercentChance=10) // with front panels missing on both sides
    SchurzenTypes(3)=(SchurzenStaticMesh=StaticMesh'DH_German_vehicles_stc.PantherG.PantherSchurzen4',PercentChance=15) // most badly damaged, with 3 panels missing
    SchurzenOffset=(X=-18.0,Y=-1.65,Z=-14.0)
    SchurzenIndex=255 // invalid starting value just so if schurzen no. zero is selected, it gets actively set & so flagged for replication
    NewVehHitpoints(0)=(PointRadius=8.0,PointScale=1.0,PointBone="body",PointOffset=(X=55.0,Y=-40.0,Z=77.0),NewHitPointType=NHP_GunOptics)
    NewVehHitpoints(1)=(PointRadius=15.0,PointScale=1.0,PointBone="Turret_placement",PointOffset=(X=72.0,Z=45.0),NewHitPointType=NHP_Traverse)
    NewVehHitpoints(2)=(PointRadius=15.0,PointScale=1.0,PointBone="Turret_placement",PointOffset=(X=72.0,Z=45.0),NewHitPointType=NHP_GunPitch)
    LeftTreadIndex=2
    RightTreadIndex=1
    MaxCriticalSpeed=1002.0
    TreadDamageThreshold=0.85
    FireEffectOffset=(X=-15.0)
    PeriscopeOverlay=texture'DH_VehicleOptics_tex.German.PERISCOPE_overlay_German'
    UFrontArmorFactor=8.2
    URightArmorFactor=5.0
    ULeftArmorFactor=5.0
    URearArmorFactor=4.0
    UFrontArmorSlope=55.0
    URightArmorSlope=30.0
    ULeftArmorSlope=30.0
    URearArmorSlope=25.0
    PointValue=4.0
    MaxPitchSpeed=80.0
    TreadVelocityScale=172.0
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L05'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_R05'
    RumbleSound=sound'Vehicle_Engines.interior.tank_inside_rumble02'
    LeftTrackSoundBone="Wheel_L_1"
    RightTrackSoundBone="Wheel_R_1"
    RumbleSoundBone="body"
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.jagdpanther_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.jagdpanther_turret_look'
    VehicleHudThreadsPosX(0)=0.38
    VehicleHudThreadsPosX(1)=0.63
    VehicleHudThreadsPosY=0.54
    VehicleHudThreadsScale=0.61
    bVehicleHudUsesLargeTexture=true
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
    WheelRotationScale=750
    TreadHitMinAngle=1.5
    FrontRightAngle=27.0
    RearRightAngle=153.0
    GearRatios(4)=0.8
    TransRatio=0.1
    ChangeUpPoint=1990.0
    ChangeDownPoint=1000.0
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-230.0,Y=20.0,Z=109.592003),ExhaustRotation=(Pitch=22000))
    ExhaustPipes(1)=(ExhaustPosition=(X=-230.0,Y=-20.0,Z=109.592003),ExhaustRotation=(Pitch=22000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdpantherCannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdpantherMountedMGPawn',WeaponBone="Mg_attachment")
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdpantherPassengerOne',WeaponBone="body")
    PassengerWeapons(3)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdpantherPassengerTwo',WeaponBone="body")
    PassengerWeapons(4)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdpantherPassengerThree',WeaponBone="body")
    PassengerWeapons(5)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdpantherPassengerFour',WeaponBone="body")
    IdleSound=SoundGroup'Vehicle_Engines.Tiger.Tiger_engine_loop'
    StartUpSound=sound'Vehicle_Engines.Tiger.tiger_engine_start'
    ShutDownSound=sound'Vehicle_Engines.Tiger.tiger_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Jagdpanther.Jagdpanther_dest'
    DamagedEffectScale=1.1
    DamagedEffectOffset=(X=-135.0,Y=20.0,Z=108.0)
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=5000,ViewPitchDownLimit=64000,ViewPositiveYawLimit=1,ViewNegativeYawLimit=-1,ViewFOV=90.0,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_body_int',TransitionDownAnim="Overlay_In",ViewPitchUpLimit=2300,ViewPitchDownLimit=64000,ViewPositiveYawLimit=7000,ViewNegativeYawLimit=-7000,ViewFOV=90.0)
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.jagdpanther_body'
    VehicleHudOccupantsX(0)=0.43
    VehicleHudOccupantsX(1)=0.55
    VehicleHudOccupantsX(2)=0.59
    VehicleHudOccupantsY(0)=0.38
    VehicleHudOccupantsY(1)=0.51
    VehicleHudOccupantsY(2)=0.38
    VehicleHudOccupantsX(3)=0.4
    VehicleHudOccupantsY(3)=0.69
    VehicleHudOccupantsX(4)=0.4
    VehicleHudOccupantsY(4)=0.79
    VehicleHudOccupantsX(5)=0.605
    VehicleHudOccupantsY(5)=0.79
    VehicleHudOccupantsX(6)=0.605
    VehicleHudOccupantsY(6)=0.69
    VehicleHudEngineX=0.51
    VehHitpoints(0)=(PointBone="body",PointOffset=(X=100.0,Y=-40.0,Z=30.0))
    VehHitpoints(1)=(PointRadius=32.0,PointHeight=35.0,PointOffset=(X=-122.0,Z=-6.0))
    VehHitpoints(2)=(PointRadius=15.0,PointHeight=10.0,PointScale=1.0,PointBone="body",PointOffset=(Y=-45.0,Z=50.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=15.0,PointHeight=10.0,PointScale=1.0,PointBone="body",PointOffset=(X=35.0,Y=-45.0,Z=50.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(4)=(PointRadius=15.0,PointHeight=10.0,PointScale=1.0,PointBone="body",PointOffset=(Y=45.0,Z=50.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(5)=(PointRadius=15.0,PointHeight=10.0,PointScale=1.0,PointBone="body",PointOffset=(X=35.0,Y=45.0,Z=50.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DriverAttachmentBone="driver_attachment"
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=32.0,Y=-15.0,Z=-1.0)
        WheelRadius=33.0
    End Object
    Wheels(0)=SVehicleWheel'ROVehicles.PantherTank.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=32.0,Y=15.0,Z=-1.0)
        WheelRadius=33.0
    End Object
    Wheels(1)=SVehicleWheel'ROVehicles.PantherTank.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-14.0,Y=-15.0,Z=-1.0)
        WheelRadius=33.0
    End Object
    Wheels(2)=SVehicleWheel'ROVehicles.PantherTank.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-14.0,Y=15.0,Z=-1.0)
        WheelRadius=33.0
    End Object
    Wheels(3)=SVehicleWheel'ROVehicles.PantherTank.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-15.0,Z=-1.0)
        WheelRadius=33.0
    End Object
    Wheels(4)=SVehicleWheel'ROVehicles.PantherTank.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=15.0,Z=-1.0)
        WheelRadius=33.0
    End Object
    Wheels(5)=SVehicleWheel'ROVehicles.PantherTank.Right_Drive_Wheel'
    VehicleMass=14.0
    bDrawDriverInTP=false
    bFPNoZFromCameraPitch=true
    ExitPositions(0)=(X=-33.0,Y=36.0,Z=210.0)
    ExitPositions(1)=(X=-33.0,Y=36.0,Z=210.0)
    ExitPositions(2)=(X=-33.0,Y=36.0,Z=210.0)
    ExitPositions(3)=(X=-109.0,Y=-170.0,Z=60.0)
    ExitPositions(4)=(X=-159.0,Y=-170.0,Z=60.0)
    ExitPositions(5)=(X=-159.0,Y=170.0,Z=60.0)
    ExitPositions(6)=(X=-109.0,Y=170.0,Z=60.0)
    EntryRadius=375.0
    DriverDamageMult=1.0
    VehicleNameString="Jagdpanzer V 'Jagdpanther'"
    MaxDesireability=1.9
    FlagBone="Mg_placement"
    FlagRotation=(Yaw=32768)
    PitchUpLimit=5000
    PitchDownLimit=60000
    HealthMax=600.0
    Health=600
    Mesh=SkeletalMesh'DH_Jagdpanther_anm.Jagdpanther_body_ext'
    Skins(0)=texture'DH_VehiclesGE_tex2.ext_vehicles.Jagdpanther_body_goodwood'
    Skins(1)=texture'DH_VehiclesGE_tex2.Treads.Jagdpanther_treads'
    Skins(2)=texture'DH_VehiclesGE_tex2.Treads.Jagdpanther_treads'
    Skins(3)=texture'DH_VehiclesGE_tex2.int_vehicles.Jagdpanther_walls_int'
    Skins(4)=texture'DH_VehiclesGE_tex2.int_vehicles.Jagdpanther_body_int'
    SoundPitch=32
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
        KMaxAngularSpeed=0.85
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_JagdpantherTank.KParams0'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.jagdpanther'
}
