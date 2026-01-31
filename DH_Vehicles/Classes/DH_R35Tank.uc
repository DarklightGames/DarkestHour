//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// [1] https://tank-afv.com/ww2/france/Renault_R-35.php
// [2] https://forum.axishistory.com/viewtopic.php?t=118800
//==============================================================================
// TODO
//==============================================================================
// [ ] Riders
// [ ] Nation & Camo Variants
// [ ] Factory Classes
// [ ] Destroyed Treads
// [ ] Destroyed static
// [ ] Clock Icon
// [ ] Spawn Icon
// [ ] Pan magazine icon for coax
// [ ] Set up shell types and ammo counts
// [ ] New coax MG sound effects
// [ ] Third person driver and gunner anims
// [ ] Reduce karma kick when firing (very very light gun)
// [ ] Gunsight (pinned in Discord)
// [ ] Hitpoints for turret parts
//==============================================================================

class DH_R35Tank extends DHArmoredVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Renault R35"
    VehicleTeam=0
    VehicleMass=10.6
    ReinforcementCost=2

    // Periscope
    PeriscopePositionIndex=0
    PeriscopeCameraBone="DRIVER_CAMERA" // TODO: do we even have a periscope?

    PlayerCameraBone="DRIVER_CAMERA"

    // Skins(0)=Texture'DH_FiatL640_tex.fiatl640_body_ext'
    // Skins(1)=Texture'DH_FiatL640_tex.fiatl640_treads'
    // Skins(2)=Texture'DH_FiatL640_tex.fiatl640_treads'

    // Hull mesh
    Mesh=SkeletalMesh'DH_R35_anm.R35_BODY_EXT'

    // Vehicle weapons & passengers
    BeginningIdleAnim="closed"
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_R35CannonPawn',WeaponBone="TURRET_ATTACHMENT")
    // PassengerPawns(0)=(AttachBone="body",DrivePos=(X=0,Y=0,Z=58),DriveRot=(Yaw=16384),DriveAnim="fiatl640_passenger_02",InitialViewRotationOffset=(Yaw=-16384))
    // PassengerPawns(1)=(AttachBone="body",DrivePos=(X=0,Y=0,Z=58),DriveRot=(Yaw=16384),DriveAnim="fiatl640_passenger_01",InitialViewRotationOffset=(Yaw=-16384))

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_R35_anm.R35_BODY_EXT',TransitionUpAnim="overlay_out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=0,ViewNegativeYawLimit=-1,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_R35_anm.R35_BODY_EXT',DriverTransitionAnim="R35_driver_out",TransitionUpAnim="open",TransitionDownAnim="overlay_in",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_R35_anm.R35_BODY_EXT',DriverTransitionAnim="R35_driver_in",TransitionDownAnim="close",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,bExposed=true)
    DrivePos=(X=0,Y=0,Z=58)
    DriveRot=(Yaw=16384)
    DriveAnim="r35_driver_closed"
    DriverAttachmentBone="driver_attachment"
    UnbuttonedPositionIndex=3
    bLockCameraDuringTransition=false

    // Hull armor
    // https://tanks-encyclopedia.com/ww2/romania/vanatorul-de-care-r35/
    FrontArmor(0)=(Thickness=4.0,Slope=-45,MaxRelativeHeight=30,LocationName="lower slope")
    FrontArmor(1)=(Thickness=4.0,Slope=0,MaxRelativeHeight=49.5499,LocationName="nose")
    FrontArmor(2)=(Thickness=4.0,Slope=75,MaxRelativeHeight=63.828,LocationName="upper slope")
    FrontArmor(3)=(Thickness=4.0,Slope=15,LocationName="upper")
    RightArmor(0)=(Thickness=4.0,Slope=0.0,LocationName="side")
    LeftArmor(0)=(Thickness=4.0,Slope=0.0,LocationName="side")
    RearArmor(0)=(Thickness=4.0,Slope=-38,MaxRelativeHeight=38.5723,LocationName="lower")
    RearArmor(1)=(Thickness=4.0,Slope=11,LocationName="upper")

    FrontLeftAngle=337
    FrontRightAngle=23
    RearLeftAngle=208
    RearRightAngle=152

    // Damage
    Health=400
    HealthMax=400
    EngineHealth=250
    AmmoIgnitionProbability=0.5  // 0.75 default
    TurretDetonationThreshold=4000.0 // increased from 1750
    EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
    DisintegrationHealth=-800.0 //petrol

    // Hitpoints
    VehHitpoints(0)=(PointBone="BODY",PointRadius=28,PointOffset=(X=-63,Z=51),HitPointType=HP_Engine)
    VehHitpoints(1)=(PointBone="BODY",PointRadius=20,PointOffset=(X=36,Y=27,Z=44),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)

    TreadHitMaxHeight=55.0
    TreadDamageThreshold=0.5
    DamagedEffectOffset=(X=-70,Y=0,Z=80)
    DamagedEffectScale=1.0
    FireAttachBone="body"
    DestroyedVehicleMesh=StaticMesh'DH_FiatL640_stc.fiatl640_destroyed'
    // DestroyedVehicleMesh=StaticMesh'DH_R35_stc.R35_destroyed'
    ShadowZOffset=20.0

    DamagedTrackStaticMeshLeft=StaticMesh'DH_FiatL640_stc.fiatl640_tracks_dest_L'
    DamagedTrackStaticMeshRight=StaticMesh'DH_FiatL640_stc.fiatl640_tracks_dest_R'
    // DamagedTrackStaticMeshLeft=StaticMesh'DH_R35_stc.R35_tracks_dest_L'
    // DamagedTrackStaticMeshRight=StaticMesh'DH_R35_stc.R35_tracks_dest_R'

    FireEffectOffset=(X=40,Y=15,Z=60)

    // Exit
    ExitPositions(0)=(X=45,Y=-98,Z=59)  // Left of the driver
    ExitPositions(1)=(X=-96,Y=0,Z=142)  // Behind the turret
    ExitPositions(4)=(X=-76,Y=-98,Z=59) // Left passenger
    ExitPositions(5)=(X=-76,Y=98,Z=59)  // Right passenger
    ExitPositions(2)=(X=189,Y=0,Z=62)   // Very front of the vehicle
    ExitPositions(3)=(X=45,Y=98,Z=59)   // Right of the driver
    ExitPositions(6)=(X=-218,Y=0,Z=55)  // Far behind the vehicle

    // TODO: choose some other vehicle sounds

    // Sounds
    SoundPitch=48
    IdleSound=SoundGroup'DH_AlliedVehicleSounds.stuart_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.t60_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.t60_engine_stop'
    LeftTreadSound=Sound'Vehicle_EnginesTwo.UC_tread_L'
    RightTreadSound=Sound'Vehicle_EnginesTwo.UC_tread_R'
    RumbleSoundBone="body"
    RumbleSound=Sound'DH_AlliedVehicleSounds.stuart_inside_rumble'

    // Visual effects
    LeftTreadIndex=1
    RightTreadIndex=2
    LeftTreadPanDirection=(Pitch=0,Yaw=0,Roll=0)
    RightTreadPanDirection=(Pitch=0,Yaw=0,Roll=0)
    TreadVelocityScale=100.0
    WheelRotationScale=45500.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-90,Y=-49,Z=69),ExhaustRotation=(Pitch=32768))
    LeftLeverBoneName="LEVER_L"
    RightLeverBoneName="LEVER_R"

    // TODO: replace, obviously
    // HUD
    VehicleHudImage=Texture'DH_FiatL640_tex.fiatl640_body'
    VehicleHudTurret=TexRotator'DH_FiatL640_tex.fiatl640_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_FiatL640_tex.fiatl640_turret_look'

    VehicleHudEngineX=0.50

    VehicleHudTreadsPosX(0)=0.35
    VehicleHudTreadsPosX(1)=0.65
    VehicleHudTreadsPosY=0.50
    VehicleHudTreadsScale=0.7

    VehicleHudOccupantsX(0)=0.545
    VehicleHudOccupantsY(0)=0.4
    VehicleHudOccupantsX(1)=0.45
    VehicleHudOccupantsY(1)=0.475
    VehicleHudOccupantsX(2)=0.35
    VehicleHudOccupantsY(2)=0.65
    VehicleHudOccupantsX(3)=0.65
    VehicleHudOccupantsY(3)=0.65

    SpawnOverlay(0)=Material'DH_FiatL640_tex.fiatl640_icon'

    // Visible wheels
    LeftWheelBones(0)="WHEEL_01_L"
    LeftWheelBones(1)="WHEEL_02_L"
    LeftWheelBones(2)="WHEEL_03_L"
    LeftWheelBones(3)="WHEEL_04_L"
    LeftWheelBones(4)="WHEEL_05_L"
    LeftWheelBones(5)="WHEEL_06_L"
    LeftWheelBones(6)="WHEEL_07_L"
    LeftWheelBones(7)="WHEEL_08_L"
    LeftWheelBones(8)="WHEEL_09_L"
    LeftWheelBones(9)="WHEEL_10_L"

    RightWheelBones(0)="WHEEL_01_R"
    RightWheelBones(1)="WHEEL_02_R"
    RightWheelBones(2)="WHEEL_03_R"
    RightWheelBones(3)="WHEEL_04_R"
    RightWheelBones(4)="WHEEL_05_R"
    RightWheelBones(5)="WHEEL_06_R"
    RightWheelBones(6)="WHEEL_07_R"
    RightWheelBones(7)="WHEEL_08_R"
    RightWheelBones(8)="WHEEL_09_R"
    RightWheelBones(9)="WHEEL_10_R"

    LeftTrackSoundBone="DRIVE_WHEEL_L"
    RightTrackSoundBone="DRIVE_WHEEL_R"

    // TODO: attach these to the right bones
    CollisionAttachments(0)=(StaticMesh=StaticMesh'DH_R35_stc.R35_BODY_HATCH_COLLISION',AttachBone="BODY")
    CollisionAttachments(1)=(StaticMesh=StaticMesh'DH_R35_stc.R35_BODY_VISION_PORT_COLLISION',AttachBone="BODY")

    // RandomAttachmentGroups(0)=(Options=((Probability=1.0,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_R35_stc.R35_ATTACHMENT_SPARE_WHEEL'))))
    bDoRandomAttachments=true
    RandomAttachmentGroups(0)=(Options=((Probability=1.0,Attachment=(AttachBone="BODY",StaticMesh=StaticMesh'DH_R35_stc.R35_ATTACHMENT_TRENCH_SKID'))))

    // Movement
    GearRatios(3)=0.65
    GearRatios(4)=0.75
    TransRatio=0.13
    WheelLatFrictionScale=2.0
    HandbrakeThresh=1000.000000
    MaxBrakeTorque=10.0

    // Karma properties
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=0.0,Y=0.0,Z=0.4)
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
        KMaxAngularSpeed=1.0
    End Object
    KParams=KParams0

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="STEER_WHEEL_F_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=28
        bLeftTrack=true
    End Object
    Wheels(0)=LF_Steering
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="STEER_WHEEL_F_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=28
    End Object
    Wheels(1)=RF_Steering
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="STEER_WHEEL_B_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=28
        bLeftTrack=true
    End Object
    Wheels(2)=LR_Steering
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="STEER_WHEEL_B_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=28
    End Object
    Wheels(3)=RR_Steering
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="DRIVE_WHEEL_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=28
        bLeftTrack=true
    End Object
    Wheels(4)=Left_Drive_Wheel
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="DRIVE_WHEEL_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=28
    End Object
    Wheels(5)=Right_Drive_Wheel
}
