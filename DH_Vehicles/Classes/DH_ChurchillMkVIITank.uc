//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ChurchillMkVIITank extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\StaticMeshes\DH_Churchill_stc.usx
#exec OBJ LOAD FILE=..\Textures\DH_Churchill_tex.utx

exec function HideGuards() // TEMPDEBUG - exec to hide the track guards, so can see how the tank looks without them
{
    if (IsDebugModeAllowed())
    {
        if (Skins[6] == default.Skins[6]) Skins[6] = Texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha';
        else Skins[6] = default.Skins[6];
    }
}

exec function ToggleTreads() // TEMPDEBUG - exec to toggle between normal & destroyed tread skins
{
    if (IsDebugModeAllowed())
    {
        if (LeftTreadPanner.Material == Combiner'DH_Churchill_tex.Destroyed.churchill_treads_dest')
        {
            LeftTreadPanner.Material = Texture'DH_Churchill_tex.churchill.churchill_treads';
            RightTreadPanner.Material = Texture'DH_Churchill_tex.churchill.churchill_treads';
        }
        else
        {
            LeftTreadPanner.Material = Combiner'DH_Churchill_tex.Destroyed.churchill_treads_dest';
            RightTreadPanner.Material = Combiner'DH_Churchill_tex.Destroyed.churchill_treads_dest';
        }

        Skins[LeftTreadIndex] = LeftTreadPanner;
        Skins[RightTreadIndex] = RightTreadPanner;
    }
}

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Churchill Mk.VII"
    VehicleTeam=1
    VehicleMass=13.5
    ReinforcementCost=8

    // Hull mesh
    Mesh=SkeletalMesh'DH_Churchill_anm.ChurchillMkVII_body_ext'
    Skins(0)=Texture'DH_Churchill_tex.churchill.ChurchillMkVII_body_ext'
    Skins(1)=Texture'DH_Churchill_tex.churchill.ChurchillMkVIIl_turret'
//  Skins(2)=Texture'DH_Churchill_tex.churchill.churchill_treads' // TODO: tread texture doesn't have wrap continuity from top edge to bottom edge, which needs fixing
//  Skins(3)=Texture'DH_Churchill_tex.churchill.churchill_treads'
    Skins(2)=Combiner'DH_Churchill_tex.Destroyed.churchill_treads_dest' // TODO: temporary use of destroyed treads as the darkened, messed up overlay actually makes these treads look better
    Skins(3)=Combiner'DH_Churchill_tex.Destroyed.churchill_treads_dest'
    Skins(4)=Texture'DH_Churchill_tex.churchill.churchill_interior'
    Skins(5)=Texture'DH_VehiclesUK_tex.int_vehicles.Cromwell_body_int'
    Skins(6)=Texture'DH_Churchill_tex.churchill.ChurchillMkVII_body_ext' // track guards separate so can easily be split later (random bits missing, similar to panther schurzen)

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ChurchillMkVIICannonPawn',WeaponBone="turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_ChurchillMountedMGPawn',WeaponBone="mg_placement")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-85,Y=-101.0,Z=104.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-152.0,Y=-82.0,Z=109.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-152.0,Y=82.0,Z=109.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(3)=(AttachBone="body",DrivePos=(X=-85.0,Y=101.0,Z=104.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider6_idle")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Churchill_anm.ChurchillMkVII_body_int',TransitionUpAnim="driver_visionport_close",ViewPitchUpLimit=3000,ViewPitchDownLimit=60500,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Churchill_anm.ChurchillMkVII_body_int',TransitionUpAnim="driver_periscope_out",TransitionDownAnim="driver_visionport_open",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bDrawOverlays=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Churchill_anm.ChurchillMkVII_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="driver_periscope_in",DriverTransitionAnim="VUC_driver_close",ViewPitchUpLimit=3000,ViewPitchDownLimit=60500,ViewPositiveYawLimit=2500,ViewNegativeYawLimit=-1500)
    DriverPositions(3)=(PositionMesh=SkeletalMesh'DH_Churchill_anm.ChurchillMkVII_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VUC_driver_open",ViewPitchUpLimit=5000,ViewPitchDownLimit=64700,ViewPositiveYawLimit=15000,ViewNegativeYawLimit=-15000,bExposed=true)
    InitialPositionIndex=2
    UnbuttonedPositionIndex=3
    DriveAnim="VUC_driver_idle_close"
    OverlayFPCamPos=(X=10.0,Y=-1.0,Z=11.5)

    // Hull armor
    FrontArmor(0)=(Thickness=13.97,Slope=-20.0,MaxRelativeHeight=53.0,LocationName="nose")
    FrontArmor(1)=(Thickness=5.72,Slope=70.0,MaxRelativeHeight=71.0,LocationName="glacis")
    FrontArmor(2)=(Thickness=15.24,LocationName="upper")
    LeftArmor(0)=(Thickness=9.53) // small plate of side armour above protruding main sides was bit thinner (approx 83mm), but was behind tracks & so not a weaker spot, so have disregarded
    RightArmor(0)=(Thickness=9.53)
    RearArmor(0)=(Thickness=2.54,Slope=-62.0,MaxRelativeHeight=49.0,LocationName="lower")
    RearArmor(1)=(Thickness=5.08,LocationName="upper")

    FrontLeftAngle=337.5
    FrontRightAngle=22.5
    RearRightAngle=157.0
    RearLeftAngle=203.0

    // Movement
    MaxCriticalSpeed=587.0 // 35 kph
    TransRatio=0.078 // gives top speed on the flat of 15 mph (approx 24 kph) // TODO: may need to reduce this slightly for the Mk.VII as think it was a little slower

    // Damage
	// pros: 5 men crew, who are separated by a relatively large space
	// cons: petrol fuel
    Health=570
    HealthMax=570.0
	EngineHealth=270

    EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
    DisintegrationHealth=-800.0 //petrol
    VehHitpoints(0)=(PointRadius=35.0,PointOffset=(X=-100.0,Y=0.0,Z=65.0))
    VehHitpoints(1)=(PointRadius=20.0,PointScale=1.0,PointBone="Turret",PointOffset=(X=20.0,Y=20.0,Z=-30.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore) // turret ready rack
    VehHitpoints(2)=(PointRadius=25.0,PointScale=1.0,PointBone="Body",PointOffset=(X=20.0,Y=-65.0,Z=65.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)   // left pannier
    VehHitpoints(3)=(PointRadius=25.0,PointScale=1.0,PointBone="Body",PointOffset=(X=20.0,Y=65.0,Z=65.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)    // right pannier
    NewVehHitpoints(0)=(PointRadius=15.0,PointBone="Turret",PointOffset=(X=48.0,Y=0.0,Z=19.0),NewHitPointType=NHP_GunPitch)
    TreadHitMaxHeight=37.0
    DamagedTrackStaticMeshLeft=StaticMesh'DH_Churchill_stc.Churchill_DamagedTrack_left'
    DamagedTrackStaticMeshRight=StaticMesh'DH_Churchill_stc.Churchill_DamagedTrack_right'
    DamagedEffectScale=0.9
    DamagedEffectOffset=(X=-110.0,Y=0.0,Z=70.0)
    FireAttachBone="body"
    FireEffectOffset=(X=95.0,Y=25.0,Z=75.0)
    DestroyedVehicleMesh=StaticMesh'DH_Churchill_stc.ChurchillMkVII_dest' // TODO: get a proper destroyed SM made - this is just a placeholder

    // Exit
    ExitPositions(0)=(X=95.0,Y=25.0,Z=150.0)   // driver
    ExitPositions(1)=(X=-18.0,Y=-21.0,Z=175.0) // commander
    ExitPositions(2)=(X=95.0,Y=-25.0,Z=150.0)  // hull MG
    ExitPositions(3)=(X=-85.0,Y=-140.0,Z=75.0) // riders
    ExitPositions(4)=(X=-152.0,Y=-135.0,Z=75.0)
    ExitPositions(5)=(X=-152.0,Y=135.0,Z=75.0)
    ExitPositions(6)=(X=-85.0,Y=140.0,Z=75.0)

    // Sounds
    IdleSound=SoundGroup'Vehicle_Engines.Kv1s.KV1s_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.Kv1s.KV1s_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.Kv1s.KV1s_engine_stop'
    LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L07'
    RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L07'
    RumbleSound=Sound'Vehicle_Engines.interior.tank_inside_rumble03'

    // Visual effects
    LeftTreadIndex=2
    RightTreadIndex=3
    LeftTreadPanDirection=(Pitch=0,Yaw=-16384,Roll=0)
    RightTreadPanDirection=(Pitch=0,Yaw=-16384,Roll=0)
    LeftTrackSoundBone="drive_wheel_L"
    RightTrackSoundBone="drive_wheel_R"
    TreadVelocityScale=104.0
    WheelRotationScale=65000.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-164.0,Y=0.0,Z=104.0),ExhaustRotation=(Pitch=29000))
    ShadowZOffset=55.0

    // HUD
    VehicleHudImage=Texture'DH_Churchill_tex.hud.churchill_body'
    VehicleHudTurret=TexRotator'DH_Churchill_tex.hud.churchill_mkvii_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Churchill_tex.hud.churchill_mkvii_turret_look'
    VehicleHudEngineX=0.505
    VehicleHudEngineY=0.76
    VehicleHudTreadsPosX(0)=0.36
    VehicleHudTreadsPosY=0.51
    VehicleHudTreadsScale=0.82
    VehicleHudOccupantsX(0)=0.545
    VehicleHudOccupantsY(0)=0.345
    VehicleHudOccupantsX(2)=0.455
    VehicleHudOccupantsY(2)=0.345
    VehicleHudOccupantsX(3)=0.31
    VehicleHudOccupantsY(3)=0.67
    VehicleHudOccupantsX(4)=0.35
    VehicleHudOccupantsY(4)=0.82
    VehicleHudOccupantsX(5)=0.65
    VehicleHudOccupantsY(5)=0.82
    VehicleHudOccupantsX(6)=0.69
    VehicleHudOccupantsY(6)=0.67
    SpawnOverlay(0)=Material'DH_Churchill_tex.HUD.churchill_mkvii'

    // Visible wheels
    LeftWheelBones(0)="wheel_L_1"
    LeftWheelBones(1)="wheel_L_2"
    LeftWheelBones(2)="wheel_L_3"
    LeftWheelBones(3)="wheel_L_4"
    LeftWheelBones(4)="wheel_L_5"
    LeftWheelBones(5)="wheel_L_6"
    LeftWheelBones(6)="wheel_L_7"
    LeftWheelBones(7)="wheel_L_8"
    LeftWheelBones(8)="wheel_L_9"
    LeftWheelBones(9)="wheel_L_10"
    LeftWheelBones(10)="wheel_L_11"
    LeftWheelBones(11)="wheel_L_12"
    LeftWheelBones(12)="wheel_L_13"
    RightWheelBones(0)="wheel_R_1"
    RightWheelBones(1)="wheel_R_2"
    RightWheelBones(2)="wheel_R_3"
    RightWheelBones(3)="wheel_R_4"
    RightWheelBones(4)="wheel_R_5"
    RightWheelBones(5)="wheel_R_6"
    RightWheelBones(6)="wheel_R_7"
    RightWheelBones(7)="wheel_R_8"
    RightWheelBones(8)="wheel_R_9"
    RightWheelBones(9)="wheel_R_10"
    RightWheelBones(10)="wheel_R_11"
    RightWheelBones(11)="wheel_R_12"
    RightWheelBones(12)="wheel_R_13"

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        WheelRadius=40.0
        bLeftTrack=true
    End Object
    Wheels(0)=LF_Steering
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        WheelRadius=40.0
    End Object
    Wheels(1)=RF_Steering
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        WheelRadius=40.0
        bLeftTrack=true
    End Object
    Wheels(2)=LR_Steering
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        WheelRadius=40.0
    End Object
    Wheels(3)=RR_Steering
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=40.0
        bLeftTrack=true
    End Object
    Wheels(4)=Left_Drive_Wheel
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=40.0
    End Object
    Wheels(5)=Right_Drive_Wheel

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=-0.15,Y=0.0,Z=0.0) // default is Z=-0.5; X adjustment balances karma contacts between front & rear
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=0.4 // default is 1.0 (lower value for slower, 'heavier' turns)
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KParams0
}
