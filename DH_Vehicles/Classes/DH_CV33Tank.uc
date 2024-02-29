//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// CV33 Tank
//
// Code
// [~] Tweak vehicle handling & stats
// [ ] Tweak reloading of the MG to account for double MG
// [ ] Fix MG reload UI
//
// Audio
// [ ] New MG sound for double Fiat 14/35
//==============================================================================

class DH_CV33Tank extends DHArmoredVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Carro Armato L3/33"
    VehicleTeam=0
    bHasTreads=true
    bSpecialTankTurning=true
    VehicleMass=3.0
    ReinforcementCost=3
    MinRunOverSpeed=350 //Lighter vehicle so slightly higher min speed than other APCs
    PointValue=500
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_Vehicle'
    PrioritizeWeaponPawnEntryFromIndex=1
    UnbuttonedPositionIndex=2

    // Hull mesh
    Mesh=SkeletalMesh'DH_CV33_anm.cv33_body_ext'
    Skins(0)=Texture'DH_CV33_tex.cv33.cv33_body_ext'
    Skins(1)=Texture'DH_CV33_tex.cv33.cv33_treads'
    Skins(2)=Texture'DH_CV33_tex.cv33.cv33_treads'
    BeginningIdleAnim="driver_closed_idle"

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_CV33MGPawn',WeaponBone="turret_placement")

    // Driver
    InitialPositionIndex=1
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_CV33_anm.cv33_body_int',TransitionUpAnim="driver_vision_close",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=16384,ViewNegativeYawLimit=-16384)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_CV33_anm.cv33_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="driver_vision_open",DriverTransitionAnim="cv33_driver_close",ViewPitchUpLimit=8192,ViewPitchDownLimit=59000,ViewPositiveYawLimit=16384,ViewNegativeYawLimit=-16384,bExposed=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_CV33_anm.cv33_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="cv33_driver_open",ViewPitchUpLimit=14000,ViewPitchDownLimit=62500,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true)
    DriveAnim="cv33_driver_closed"
    PlayerCameraBone="camera_driver"
    DriverAttachmentBone="driver_attachment"
    DrivePos=(Z=58)
    DriveRot=(Yaw=16384)

    // Movement
    TransRatio=0.26
    TorqueCurve=(Points=((InVal=0.0,OutVal=10.0),(InVal=125.0,OutVal=5.0),(InVal=1500.0,OutVal=2.6),(InVal=2200.0,OutVal=0.0)))
    TurnDamping=50.0
    SteerSpeed=160.0
    MaxSteerAngleCurve=(Points=((InVal=0.0,OutVal=35.0),(InVal=1500.0,OutVal=20.0),(InVal=1000000000.0,OutVal=15.0)))
    ChassisTorqueScale=0.25

    // Physics wheels properties
    WheelPenScale=2.0
    WheelLongFrictionFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=100.0,OutVal=1.0),(InVal=200.0,OutVal=0.9),(InVal=10000000000.0,OutVal=0.9)))
    WheelLatSlipFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=30.0,OutVal=0.009),(InVal=10000000000.0,OutVal=0.0)))
    WheelLongFrictionScale=1.5
    WheelLatFrictionScale=3.0

    // Damage
    Health=250.0
    HealthMax=250.0
    DamagedEffectHealthFireFactor=0.1
    EngineHealth=150.0
    EngineDamageFromGrenadeModifier=0.05
    DirectHEImpactDamageMult=4.0
    ImpactWorldDamageMult=2.0

    VehHitpoints(0)=(PointRadius=24.0,PointBone="ENGINE",DamageMultiplier=1.0,HitPointType=HP_Engine)

    DamagedEffectScale=0.70
    DamagedEffectOffset=(X=-20,Y=-3.5,Z=18.0)
    DestroyedVehicleMesh=StaticMesh'DH_CV33_stc.destroyed.cv33_destroyed'
    DestructionEffectClass=class'ROEffects.ROVehicleDestroyedEmitter'
    DestructionEffectLowClass=class'ROEffects.ROVehicleDestroyedEmitter_simple'
    bEnableHatchFires=true
    FireEffectClass=class'DH_Effects.DHVehicleDamagedEffect' // driver's hatch fire
    FireAttachBone="driver_attachment"
    FireEffectOffset=(X=0,Y=0,Z=50.0) // position of driver's hatch fire - hull mg and turret fire positions are set in those pawn classes
    EngineToHullFireChance=0.5  // There is no firewall between the engine and the crew compartment, so the engine fire can spread to the crew compartment quite easily.
    AmmoIgnitionProbability=0.0 // 0 as ammo hitpoints are meant to represent fuel, not explosive ammo
    FireDetonationChance=0.05
    PlayerFireDamagePer2Secs=10.0 //kills a little more slowly than tanks since halftracks are open vehicles, also gives infantry a little more time to reach safety before bailing

    // Vehicle destruction
    ExplosionDamage=85.0
    ExplosionRadius=150.0
    ExplosionSoundRadius=200.0
    DestructionLinearMomentum=(Min=50.0,Max=100.0)
    DestructionAngularMomentum=(Min=10.0,Max=50.0)

    FrontRightAngle=26.0
    RearRightAngle=154.5
    RearLeftAngle=205.5
    FrontLeftAngle=334

    TreadHitMaxHeight=42.6371

    FrontArmor(0)=(Slope=-81.3,MaxRelativeHeight=16.4815,Thickness=1.2)
    FrontArmor(1)=(Slope=-52.0,MaxRelativeHeight=25.7771,Thickness=1.2)
    FrontArmor(2)=(Slope=-2.0,MaxRelativeHeight=38.1547,Thickness=1.2)
    FrontArmor(3)=(Slope=81.5,MaxRelativeHeight=45.2354,Thickness=1.2)
    FrontArmor(4)=(Slope=63.0,MaxRelativeHeight=57.6283,Thickness=1.2)
    FrontArmor(5)=(Slope=19.0,Thickness=1.2)

    LeftArmor(0)=(Slope=0.0,MaxRelativeHeight=57.6283,Thickness=1.2)
    LeftArmor(1)=(Slope=19.0,Thickness=1.2)

    RightArmor(0)=(Slope=0.0,MaxRelativeHeight=57.6283,Thickness=1.2)
    RightArmor(1)=(Slope=19.0,Thickness=1.2)

    RearArmor(0)=(Slope=0.0,MaxRelativeHeight=57.6283,Thickness=0.6)
    RearArmor(1)=(Slope=19.0,Thickness=0.6)

    // Exit
    ExitPositions(0)=(X=-10,Y=95,Z=55)  // driver
    ExitPositions(1)=(X=-10,Y=-95,Z=55) // gunner
    ExitPositions(2)=(X=-140,Y=25,Z=55) // back right
    ExitPositions(3)=(X=-140,Y=-25,Z=55) // back left

    // Sounds
    MaxPitchSpeed=125.0
    IdleSound=SoundGroup'Vehicle_EnginesTwo.UC.UC_engine_loop'
    StartUpSound=Sound'Vehicle_EnginesTwo.UC.UC_engine_start'
    ShutDownSound=Sound'Vehicle_EnginesTwo.UC.UC_engine_stop'
    LeftTrackSoundBone="TRACK_L"
    LeftTreadSound=Sound'Vehicle_EnginesTwo.UC.UC_tread_L'
    RightTrackSoundBone="TRACK_R"
    RightTreadSound=Sound'Vehicle_EnginesTwo.UC.UC_tread_R'
    RumbleSound=Sound'Vehicle_Engines.interior.tank_inside_rumble03'

    // Visual effects
    LeftTreadIndex=1
    RightTreadIndex=2
    LeftTreadPanDirection=(Pitch=0,Yaw=-16384,Roll=0)
    RightTreadPanDirection=(Pitch=0,Yaw=-16384,Roll=0)
    TreadVelocityScale=80.0
    WheelRotationScale=40000.0

    // Exhaust
    ExhaustPipes(0)=(ExhaustPosition=(X=-91.0,Y=34.0,Z=47.0),ExhaustRotation=(Pitch=32768))
    ExhaustPipes(1)=(ExhaustPosition=(X=-91.0,Y=-34.0,Z=47.0),ExhaustRotation=(Pitch=32768))

    // Levers
    LeftLeverBoneName="LEVER_L"
    RightLeverBoneName="LEVER_R"

    // HUD
    VehicleHudImage=Texture'DH_CV33_tex.interface.cv33_body'
    VehicleHudTurret=TexRotator'DH_CV33_tex.interface.cv33_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_CV33_tex.interface.cv33_turret_look'
    VehicleHudEngineY=0.75
    VehicleHudTreadsPosX(0)=0.345
    VehicleHudTreadsPosX(1)=0.655
    VehicleHudTreadsPosY=0.5
    VehicleHudTreadsScale=0.675
    VehicleHudOccupantsX(0)=0.57
    VehicleHudOccupantsY(0)=0.56
    VehicleHudOccupantsX(1)=0.43
    VehicleHudOccupantsY(1)=0.56
    SpawnOverlay(0)=Material'DH_CV33_tex.interface.cv33_icon'

    // Visible wheels
    LeftWheelBones(0)="WHEEL_1_L"
    LeftWheelBones(1)="WHEEL_2_L"
    LeftWheelBones(2)="WHEEL_3_L"
    LeftWheelBones(3)="WHEEL_4_L"
    LeftWheelBones(4)="WHEEL_5_L"
    LeftWheelBones(5)="WHEEL_6_L"
    LeftWheelBones(6)="WHEEL_7_L"
    LeftWheelBones(7)="WHEEL_8_L"
    LeftWheelBones(8)="WHEEL_9_L"
    
    RightWheelBones(0)="WHEEL_1_R"
    RightWheelBones(1)="WHEEL_2_R"
    RightWheelBones(2)="WHEEL_3_R"
    RightWheelBones(3)="WHEEL_4_R"
    RightWheelBones(4)="WHEEL_5_R"
    RightWheelBones(5)="WHEEL_6_R"
    RightWheelBones(6)="WHEEL_7_R"
    RightWheelBones(7)="WHEEL_8_R"
    RightWheelBones(8)="WHEEL_9_R"

    // Shadow
    ShadowZOffset=20.0

    // Collision Attachments
    CollisionAttachments(0)=(StaticMesh=StaticMesh'DH_CV33_stc.collision.cv33_body_hatch_collision',AttachBone="hatch")
    CollisionAttachments(1)=(StaticMesh=StaticMesh'DH_CV33_stc.collision.cv33_body_vision_port_collision',AttachBone="vision_port")

    // Destroyed Treads
    DamagedTrackStaticMeshLeft=StaticMesh'DH_CV33_stc.cv33_tread_dest_L'
    DamagedTrackStaticMeshRight=StaticMesh'DH_CV33_stc.cv33_tread_dest_R'

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="DRIVE_WHEEL_FL"
        BoneRollAxis=AXIS_Y
        WheelRadius=18.0
        bLeftTrack=true
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_CV33Tank.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="DRIVE_WHEEL_FR"
        BoneRollAxis=AXIS_Y
        WheelRadius=18.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_CV33Tank.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LB_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="DRIVE_WHEEL_BL"
        BoneRollAxis=AXIS_Y
        WheelRadius=18.0
        bLeftTrack=true
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_CV33Tank.LB_Steering'
    Begin Object Class=SVehicleWheel Name=RB_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="DRIVE_WHEEL_BR"
        BoneRollAxis=AXIS_Y
        WheelRadius=18.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_CV33Tank.RB_Steering'

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=0.0,Y=0.0,Z=0.2)
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=2.0 // default is 10 (full track tanks tend to have 0.9 or 1.0)
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_CV33Tank.KParams0'
}
