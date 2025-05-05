//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// [ ] top MG shells not ejected the right direction & don't collide with top of tank (done with an emitter)
// [ ] you can destroy the thing by penetrating the MG
// [ ] late variant
// [ ] if we want to go FULL HOG, we could force the MG to a particular orientation
//     and do a reload sequence, at least in third person; would look SWEET
// [ ] TP and FP anims for all
// [ ] add passengers in right spot
// [ ] UI art (do against straight dunkelgelb)
// [ ] fix rear cmd hatch collision
// [ ] play a sound when the player tries to open the hatch when the MG is in the way
// [ ] exhaust position on late variant
// [ ] destroyed mesh
// [ ] destroyed textures (for statics)
// [ ] bushes
// [ ] hatch opening/closing sounds in animations
//==============================================================================

class DH_HetzerDestroyer extends DHArmoredVehicle;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Hetzer_anm.HETZER_BODY_EARLY_EXT'
    Skins(0)=Texture'DH_Hetzer_tex.HETZER_BODY_EXT'
    Skins(1)=Texture'DH_Hetzer_tex.HETZER_TREADS'
    Skins(2)=Texture'DH_Hetzer_tex.HETZER_TREADS'

    PeriscopeCameraBone="PERISCOPE_CAMERA"
    PeriscopePositionIndex=0
    PlayerCameraBone="PLAYER_CAMERA"
    PeriscopeOverlay=Texture'DH_VehicleOptics_tex.General.PERISCOPE_overlay_German'
    ReinforcementCost=4
    FrontArmor(0)=(Thickness=6.000000,Slope=-40.000000,MaxRelativeHeight=9.900000,LocationName="lower")
    FrontArmor(1)=(Thickness=6.000000,Slope=60.000000,LocationName="upper")
    RightArmor(0)=(Thickness=2.000000,Slope=-15.000000,MaxRelativeHeight=13.000000,LocationName="lower")
    RightArmor(1)=(Thickness=2.000000,Slope=40.000000,LocationName="upper")
    LeftArmor(0)=(Thickness=2.000000,Slope=-15.000000,MaxRelativeHeight=13.000000,LocationName="lower")
    LeftArmor(1)=(Thickness=2.000000,Slope=40.000000,LocationName="upper")
    RearArmor(0)=(Thickness=2.000000,Slope=15.000000,MaxRelativeHeight=20.299999,LocationName="lower")
    RearArmor(1)=(Thickness=0.800000,Slope=70.000000,LocationName="upper")
    NewVehHitpoints(0)=(PointRadius=2.000000,PointBone="body",PointOffset=(X=32.000000,Y=-9.800000,Z=64.699997),NewHitPointType=NHP_GunOptics)
    NewVehHitpoints(1)=(PointRadius=15.000000,PointBone="Turret",PointOffset=(X=-12.000000),NewHitPointType=NHP_Traverse)
    NewVehHitpoints(2)=(PointRadius=15.000000,PointBone="Turret",PointOffset=(X=-12.000000),NewHitPointType=NHP_GunPitch)
    GunOpticsHitPointIndex=0
    FireAttachBone="body"
    FireEffectOffset=(X=103.000000,Y=-35.000000,Z=30.000000)
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-70.000000,Y=-25.000000,Z=110.000000),DriveRot=(Pitch=3850),DriveAnim="crouch_idle_binoc")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-80.000000,Y=45.000000,Z=105.000000),DriveRot=(Pitch=4400,Yaw=-3100,Roll=-1700),DriveAnim="prone_idle_nade")
    FrontLeftAngle=340.000000
    FrontRightAngle=35.000000
    RearRightAngle=145.000000
    RearLeftAngle=201.000000
    MaxPitchSpeed=450.000000
    RumbleSound=Sound'DH_AlliedVehicleSounds.Sherman.inside_rumble01'
    WheelRotationScale=30000.000000
    TreadVelocityScale=125.000000
    LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L03'
    RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_R03'
    LeftWheelBones(0)="Wheel_1_L"
    LeftWheelBones(1)="Wheel_2_L"
    LeftWheelBones(2)="Wheel_3_L"
    LeftWheelBones(3)="Wheel_4_L"
    LeftWheelBones(4)="Wheel_5_L"
    LeftWheelBones(5)="Wheel_6_L"
    LeftWheelBones(6)="Wheel_7_L"
    RightWheelBones(0)="Wheel_1_R"
    RightWheelBones(1)="Wheel_2_R"
    RightWheelBones(2)="Wheel_3_R"
    RightWheelBones(3)="Wheel_4_R"
    RightWheelBones(4)="Wheel_5_R"
    RightWheelBones(5)="Wheel_6_R"
    RightWheelBones(6)="Wheel_7_R"
    TreadHitMaxHeight=8.000000
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.hetzer_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.hetzer_turret_look'
    VehicleHudTreadsPosX(0)=0.375000
    VehicleHudTreadsPosX(1)=0.625000
    VehicleHudTreadsPosY=0.54
    VehicleHudTreadsScale=0.575
    GearRatios(4)=0.720000
    TransRatio=0.100000
    LeftLeverBoneName="lever_L"
    LeftLeverAxis=AXIS_Y
    RightLeverBoneName="lever_R"
    RightLeverAxis=AXIS_Y
    ExhaustPipes(0)=(ExhaustPosition=(X=-150,Y=-39.3837,Z=78.3706),ExhaustRotation=(Yaw=34000))
    PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_HetzerCannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=Class'DH_Vehicles.DH_HetzerMountedMGPawn',WeaponBone="Mg_placement")
    IdleSound=SoundGroup'Vehicle_Engines.Kv1s.KV1s_engine_loop'  //KV sound for pz38(t)?? this definitely needs to be changed
    StartUpSound=Sound'Vehicle_Engines.Kv1s.KV1s_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.Kv1s.KV1s_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_Hetzer_stc.Destroyed.Hetzer_destroyed'
    DamagedEffectOffset=(X=-60.000000,Y=25.000000)
    BeginningIdleAnim="idle"
    DriverPositions(0)=(/*PositionMesh=SkeletalMesh'DH_Hetzer_anm.Hetzer_body_int',*/ViewFOV=80,TransitionUpAnim="overlay_out",ViewPitchUpLimit=3500,ViewPitchDownLimit=63000,ViewPositiveYawLimit=3500,ViewNegativeYawLimit=-3000,bDrawOverlays=True)
    DriverPositions(1)=(/*PositionMesh=SkeletalMesh'DH_Hetzer_anm.Hetzer_body_int',*/TransitionDownAnim="overlay_in",ViewPitchUpLimit=3500,ViewPitchDownLimit=63000,ViewPositiveYawLimit=3500,ViewNegativeYawLimit=-3000)
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.hetzer_body'
    VehicleHudOccupantsX(0)=0.440000
    VehicleHudOccupantsX(1)=0.540000
    VehicleHudOccupantsX(2)=0.440000
    VehicleHudOccupantsX(3)=0.450000
    VehicleHudOccupantsX(4)=0.560000
    VehicleHudOccupantsY(0)=0.330000
    VehicleHudOccupantsY(2)=0.500000
    VehicleHudOccupantsY(3)=0.610000
    VehicleHudOccupantsY(4)=0.610000
    VehicleHudEngineY=0.610000

    DamagedTrackStaticMeshLeft=StaticMesh'DH_Hetzer_stc.HETZER_TRACK_L'
    DamagedTrackStaticMeshRight=StaticMesh'DH_Hetzer_stc.HETZER_TRACK_R'

    ShadowZOffset=40

    VehHitpoints(0)=(PointRadius=30.000000,PointOffset=(X=-60.000000))
    VehHitpoints(1)=(PointRadius=18.000000,PointBone="body",PointOffset=(Y=-28.299999,Z=-5.500000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=14.000000,PointBone="body",PointOffset=(X=74.000000,Y=26.700001,Z=-9.400000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=14.000000,PointBone="body",PointOffset=(X=29.000000,Y=26.700001,Z=-9.400000),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
    VehHitpoints(4)=(PointRadius=14.000000,PointBone="body",PointOffset=(X=38.500000,Y=35.299999,Z=37.299999),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)
    VehHitpoints(5)=(PointRadius=14.000000,PointBone="body",PointOffset=(X=1.000000,Y=35.299999,Z=37.299999),DamageMultiplier=5.000000,HitPointType=HP_AmmoStore)

    RandomAttachmentGroups(0)=(Options=((Probability=0.9,Attachment=(StaticMesh=StaticMesh'DH_Hetzer_stc.HETZER_ATTACHMENT_SIDE_SKIRT_1',AttachBone="body"))))
    RandomAttachmentGroups(1)=(Options=((Probability=0.9,Attachment=(StaticMesh=StaticMesh'DH_Hetzer_stc.HETZER_ATTACHMENT_SIDE_SKIRT_2',AttachBone="body"))))
    RandomAttachmentGroups(2)=(Options=((Probability=0.9,Attachment=(StaticMesh=StaticMesh'DH_Hetzer_stc.HETZER_ATTACHMENT_SIDE_SKIRT_3',AttachBone="body"))))
    RandomAttachmentGroups(3)=(Options=((Probability=0.9,Attachment=(StaticMesh=StaticMesh'DH_Hetzer_stc.HETZER_ATTACHMENT_SIDE_SKIRT_4',AttachBone="body"))))
    RandomAttachmentGroups(4)=(Options=((Probability=0.9,Attachment=(StaticMesh=StaticMesh'DH_Hetzer_stc.HETZER_ATTACHMENT_SIDE_SKIRT_5',AttachBone="body"))))
    RandomAttachmentGroups(5)=(Options=((Probability=0.9,Attachment=(StaticMesh=StaticMesh'DH_Hetzer_stc.HETZER_ATTACHMENT_SIDE_SKIRT_6',AttachBone="body"))))

    LeftTrackSoundBone="WHEEL_4_L"
    RightTrackSoundBone="WHEEL_4_R"

    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=True
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        WheelRadius=32
    End Object
    Wheels(0)=LF_Steering

    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=True
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        WheelRadius=32
    End Object
    Wheels(1)=RF_Steering

    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=True
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        WheelRadius=32
    End Object
    Wheels(2)=LR_Steering

    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=True
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        WheelRadius=32
    End Object
    Wheels(3)=RR_Steering

    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=True
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=32
    End Object
    Wheels(4)=Left_Drive_Wheel

    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=True
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=32
    End Object
    Wheels(5)=Right_Drive_Wheel

    VehicleMass=11.000000
    bDrawDriverInTP=False
    ExitPositions(0)=(X=-78.00,Y=23.00,Z=174.00)
    ExitPositions(1)=(X=-46,Y=124,Z=60)     // COMMANDER
    ExitPositions(2)=(X=-46,Y=-124,Z=60)    // MACHINE GUNNER
    ExitPositions(3)=(X=-191,Y=29,Z=60)     // PASSENGER 1
    ExitPositions(4)=(X=-191,Y=-29,Z=60)    // PASSENGER 2
    ExitPositions(5)=(X=-78.00,Y=-23.00,Z=174.00)
    VehicleNameString="Jagdpanzer 38(t) 'Hetzer'"
    SpawnOverlay(0)=Texture'DH_InterfaceArt_tex.hetzer'

    //Health cons: petrol fuel
    //4 men crew
    Health=525
    HealthMax=525.0
    EngineHealth=260 //slightly overloaded

    EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
    DisintegrationHealth=-800.0 //petrol
    // reduced reliability due to increased weight

    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.000000
        KInertiaTensor(3)=3.000000
        KInertiaTensor(5)=3.000000
        KCOMOffset=(X=0.040000,Y=0.440000,Z=-1.000000)
        KLinearDamping=0.050000
        KAngularDamping=0.050000
        KStartEnabled=True
        bKNonSphericalInertia=True
        KMaxAngularSpeed=0.600000
        bHighDetailOnly=False
        bClientOnly=False
        bKDoubleTickRate=True
        bDestroyOnWorldPenetrate=True
        bDoSafetime=True
        KFriction=0.500000
        KImpactThreshold=700.000000
    End Object
    KParams=KParams0
}
