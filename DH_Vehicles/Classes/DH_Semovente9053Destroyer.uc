//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// [ ] Add positional offset to turret angle calculations to fix hit detection
//     issues (probably not worth it since there's almost no armor anyways)
// [ ] UI textures for shells
//==============================================================================

class DH_Semovente9053Destroyer extends DHArmoredVehicle;

// The Semovente 90/53 has an ammo rack in the hull. We show and hide the shells in the hull
// based on the number of rounds remaining in the ammo rack.
//
// If we end up doing this on more vehicles, we can move this to the base class.
simulated function OnTotalRoundsRemainingChanged(int Count)
{
    local int i;

    for (i = 0; i < VehicleAttachments.Length; i++)
    {
        // We subtract 1 from the count because a loaded round is still counted.
        VehicleAttachments[i].Actor.bHidden = i >= Count - 1;
    }
}

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Semovente da 90/53"
    VehicleMass=11.0
    ReinforcementCost=4

    ShadowZOffset=60.0

    // Hull mesh
    Mesh=SkeletalMesh'DH_Semovente9053_anm.semovente9053_body_ext'
    Skins(0)=Texture'DH_Semovente9053_tex.semovente9053_body_ext'
    Skins(1)=Texture'DH_Semovente9053_tex.semovente9053_body_int'
    Skins(2)=Texture'DH_Semovente9053_tex.semovente9053_treads'
    Skins(3)=Texture'DH_Semovente9053_tex.semovente9053_treads'

    bUsesCodedDestroyedSkins=false

    BeginningIdleAnim="body_closed_idle"

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Semovente9053CannonPawn',WeaponBone="Turret_placement")

    // Driver
    InitialPositionIndex=0
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Semovente9053_anm.semovente9053_body_int',DriverTransitionAnim="semo9053_driver_close",TransitionUpAnim="body_open",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=7000,ViewNegativeYawLimit=-7000)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Semovente9053_anm.semovente9053_body_int',DriverTransitionAnim="semo9053_driver_open",TransitionDownAnim="body_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=9000,ViewNegativeYawLimit=-9000,bExposed=true)
    DrivePos=(X=0,Y=0.0,Z=59) // ??
    DriveRot=(Yaw=32768)
    DriveAnim="semo9053_driver_close_idle"

    // Hull armor
    FrontArmor(0)=(Thickness=3.0,Slope=-41.0,MaxRelativeHeight=40.5,LocationName="lower nose") // measured most of the slopes in the hull mesh
    FrontArmor(1)=(Thickness=3.0,Slope=13.0,MaxRelativeHeight=56,LocationName="nose")
    FrontArmor(2)=(Thickness=3.0,Slope=36.0,MaxRelativeHeight=62.9,LocationName="upper nose")
    FrontArmor(3)=(Thickness=2.5,Slope=80.0,MaxRelativeHeight=69.7,LocationName="transmision cover")
    FrontArmor(4)=(Thickness=3.0,Slope=68.0,MaxRelativeHeight=73.5,LocationName="driver plate lower")
    FrontArmor(5)=(Thickness=3.0,Slope=19.0,MaxRelativeHeight=80.9,LocationName="driver plate upper")
    FrontArmor(6)=(Thickness=1.5,Slope=81.0,LocationName="driver roof")
    RightArmor(0)=(Thickness=2.5,MaxRelativeHeight=81.0,LocationName="right side")
    RightArmor(1)=(Thickness=1.5,Slope=75.0,LocationName="right side upper")
    LeftArmor(0)=(Thickness=2.5,MaxRelativeHeight=81.0,LocationName="left side")
    LeftArmor(1)=(Thickness=1.5,Slope=75.0,LocationName="left side upper")
    RearArmor(0)=(Thickness=2.5,Slope=-16.0,LocationName="rear")

    FrontLeftAngle=335.0
    FrontRightAngle=25.0
    RearRightAngle=152.0
    RearLeftAngle=208.0

    // Movement
    GearRatios(4)=0.72
    TransRatio=0.1

    // Damage
	// cons: petrol fuel
	// note: 4 men crew
    Health=525
    HealthMax=525.0
	EngineHealth=300

    EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
    DisintegrationHealth=-800.0 //petrol

    VehHitpoints(0)=(PointRadius=30.0,PointBone="BODY",PointOffset=(X=-8,Z=51)) // engine
    VehHitpoints(1)=(PointRadius=22.0,PointBone="BODY",PointOffset=(X=-93,Y=22,Z=41),HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=22.0,PointBone="BODY",PointOffset=(X=-93,Y=-22.0,Z=41),HitPointType=HP_AmmoStore)
    NewVehHitpoints(0)=(PointRadius=20.0,PointBone="GUN_YAW",NewHitPointType=NHP_Traverse)
    NewVehHitpoints(1)=(PointRadius=20.0,PointBone="GUN_YAW",PointOffset=(X=-37.0887,Y=18.57,Z=19.6947),NewHitPointType=NHP_GunPitch)
    NewVehHitpoints(2)=(PointRadius=15.0,PointBone="GUN_YAW",PointOffset=(X=-15.5125,Y=-26.1281,Z=53.7762),NewHitPointType=NHP_GunOptics)

    TreadHitMaxHeight=50
    TreadDamageThreshold=0.5
    DamagedEffectOffset=(X=0.0,Y=0.0,Z=80.0)
    FireEffectOffset=(X=0.0,Y=0.0,Z=80.0)
    DestroyedVehicleMesh=StaticMesh'DH_Semovente9053_stc.semovente9053_destroyed'

    // Exit Positions
    ExitPositions(0)=(X=51.73,Y=-29.58,Z=139.28)
    ExitPositions(1)=(X=-186.73,Y=-31.24,Z=59.66)
    ExitPositions(2)=(X=51.73,Y=-102.06,Z=59.66)
    ExitPositions(3)=(X=51.73,Y=31.24,Z=139.28)
    ExitPositions(4)=(X=51.73,Y=102.06,Z=59.66)
    ExitPositions(5)=(X=-186.73,Y=31.24,Z=59.66)

    // Sounds
    MaxPitchSpeed=450.0

    IdleSound=SoundGroup'Vehicle_Engines.Kv1s.KV1s_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.Kv1s.KV1s_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.Kv1s.KV1s_engine_stop'
    LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L03'
    RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_R03'
    RumbleSound=Sound'DH_AlliedVehicleSounds.Sherman.inside_rumble01'

    // Visual effects
    LeftTreadIndex=2
    RightTreadIndex=3
    TreadVelocityScale=69.0
    WheelRotationScale=20000.0

    ExhaustPipes(0)=(ExhaustPosition=(X=-110.64,Y=-68.79,Z=58.76),ExhaustRotation=(Roll=0,Pitch=1011,Yaw=-23232))
    ExhaustPipes(1)=(ExhaustPosition=(X=-110.64,Y=68.79,Z=58.76),ExhaustRotation=(Roll=0,Pitch=1011,Yaw=23596))

    LeftLeverBoneName="LEVER_L"
    RightLeverBoneName="LEVER_R"

    // HUD
    VehicleHudImage=Texture'DH_Semovente9053_tex.Tank_Hud.semo9053_body'
    VehicleHudTurret=TexRotator'DH_Semovente9053_tex.Tank_Hud.semo9053_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Semovente9053_tex.Tank_Hud.semo9053_turret_look'
    VehicleHudEngineX=0.50
    VehicleHudEngineY=0.50
    VehicleHudTreadsPosY=0.5
    VehicleHudTreadsScale=0.6
    VehicleHudTreadsPosX(0)=0.35
    VehicleHudTreadsPosX(1)=0.65
    VehicleHudOccupantsX(0)=0.425
    VehicleHudOccupantsY(0)=0.38
    VehicleHudOccupantsX(1)=0.45
    VehicleHudOccupantsY(1)=0.75
    SpawnOverlay(0)=Material'DH_Semovente9053_tex.Interface.semovente9053_icon'

    // Visible wheels
    LeftWheelBones(0)="WHEEL_B_01_L"
    LeftWheelBones(1)="WHEEL_B_02_L"
    LeftWheelBones(2)="WHEEL_B_03_L"
    LeftWheelBones(3)="WHEEL_B_04_L"
    LeftWheelBones(4)="WHEEL_B_05_L"
    LeftWheelBones(5)="WHEEL_B_06_L"
    LeftWheelBones(6)="WHEEL_B_07_L"
    LeftWheelBones(7)="WHEEL_B_08_L"
    LeftWheelBones(8)="WHEEL_T_01_L"
    LeftWheelBones(9)="WHEEL_T_02_L"
    LeftWheelBones(10)="WHEEL_T_03_L"
    LeftWheelBones(11)="WHEEL_F_L"
    LeftWheelBones(12)="WHEEL_R_L"
    RightWheelBones(0)="WHEEL_B_01_R"
    RightWheelBones(1)="WHEEL_B_02_R"
    RightWheelBones(2)="WHEEL_B_03_R"
    RightWheelBones(3)="WHEEL_B_04_R"
    RightWheelBones(4)="WHEEL_B_05_R"
    RightWheelBones(5)="WHEEL_B_06_R"
    RightWheelBones(6)="WHEEL_B_07_R"
    RightWheelBones(7)="WHEEL_B_08_R"
    RightWheelBones(8)="WHEEL_T_01_R"
    RightWheelBones(9)="WHEEL_T_02_R"
    RightWheelBones(10)="WHEEL_T_03_R"
    RightWheelBones(11)="WHEEL_F_R"
    RightWheelBones(12)="WHEEL_R_R"

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        WheelRadius=28.0
        bLeftTrack=true
    End Object
    Wheels(0)=LF_Steering
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        WheelRadius=28.0
    End Object
    Wheels(1)=RF_Steering
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        WheelRadius=28.0
        bLeftTrack=true
    End Object
    Wheels(2)=LR_Steering
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        WheelRadius=28.0
    End Object
    Wheels(3)=RR_Steering
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=28.0
        bLeftTrack=true
    End Object
    Wheels(4)=Left_Drive_Wheel
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=28.0
    End Object
    Wheels(5)=Right_Drive_Wheel

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=0.25)
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
    KParams=KParams0
    LeftTreadPanDirection=(Pitch=0,Yaw=16384,Roll=0)
    RightTreadPanDirection=(Pitch=0,Yaw=16384,Roll=0)

    LeftTrackSoundBone="DRIVE_WHEEL_L"
    RightTrackSoundBone="DRIVE_WHEEL_R"
    DamagedTrackStaticMeshLeft=StaticMesh'DH_Semovente9053_stc.semovente9053_treads_destroyed_left'
    DamagedTrackStaticMeshRight=StaticMesh'DH_Semovente9053_stc.semovente9053_treads_destroyed_right'

    CollisionAttachments(0)=(StaticMesh=StaticMesh'DH_Semovente9053_stc.semovente9053_hatch_collision',AttachBone="driver_hatch")

    // Shell attachments
    VehicleAttachments(0)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_Semovente9053_stc.deco.semovente9053_shell',Offset=(X=-116.391,Y=-31.8017,Z=46.0125))
    VehicleAttachments(1)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_Semovente9053_stc.deco.semovente9053_shell',Offset=(X=-116.391,Y=-21.5638,Z=46.0125))
    VehicleAttachments(2)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_Semovente9053_stc.deco.semovente9053_shell',Offset=(X=-116.391,Y=-26.7217,Z=37.901))
    VehicleAttachments(3)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_Semovente9053_stc.deco.semovente9053_shell',Offset=(X=-116.391,Y=-16.4839,Z=37.901))
    VehicleAttachments(4)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_Semovente9053_stc.deco.semovente9053_shell',Offset=(X=-116.391,Y=21.542,Z=46.0125))
    VehicleAttachments(5)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_Semovente9053_stc.deco.semovente9053_shell',Offset=(X=-116.391,Y=31.7799,Z=46.0125))
    VehicleAttachments(6)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_Semovente9053_stc.deco.semovente9053_shell',Offset=(X=-116.391,Y=16.4621,Z=37.901))
    VehicleAttachments(7)=(AttachClass=class'DHDecoAttachment',AttachBone="body",StaticMesh=StaticMesh'DH_Semovente9053_stc.deco.semovente9053_shell',Offset=(X=-116.391,Y=26.7,Z=37.901))

    // Because the turret is completely disconnected from the hull, there should be no chance of
    // hull components being damaged when the turret is penetrated and vice versa.
    // Similarly, penetrating the turret should do significantly less points of damage to the vehicle.
    TurretPenetrationHullDamageChanceModifier=0.0
    HullPenetrationTurretDamageChanceModifier=0.0
    TurretPenetrationDamageModifier=0.25

    UnbuttonedPositionIndex=1
}
