//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M22LocustTank extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_M22Locust_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_M22Locust_tex.utx // TODO: move this into one of the DH_VehiclesUS_tex files

simulated state ViewTransition // TEMP until anims are made
{
    simulated function HandleTransition()
    {
        super(DHVehicle).HandleTransition();

        if (Level.NetMode != NM_DedicatedServer && IsHumanControlled() && !PlayerController(Controller).bBehindView)
        {
             if (DriverPositionIndex == 0)
                 FPCamPos = vect(30.0, 0.0, 10.0);
             else if (DriverPositionIndex == 1)
                 FPCamPos = vect(0.0, 0.0, 0.0);
             else if (DriverPositionIndex == 2)
                 FPCamPos = vect(20.0, 0.0, 100.0);
        }
    }
}

defaultproperties
{
    // Vehicle properties
    VehicleNameString="M22 Locust (rough WIP)"
    VehicleTeam=1
    MaxDesireability=1.9
    PointValue=2.0
    CollisionRadius=175.0
    CollisionHeight=60.0

    // Hull mesh
    Mesh=SkeletalMesh'DH_M22Locust_anm.M22Locust_body'
    Skins(0)=texture'DH_M22Locust_tex.ext_vehicles.M22Locust_body_ext'
    Skins(1)=texture'DH_M22Locust_tex.Treads.M22Locust_treads'
    Skins(2)=texture'DH_M22Locust_tex.ext_vehicles.M22Locust_turret_ext'
    Skins(3)=texture'DH_M22Locust_tex.int_vehicles.M22Locust_int'
    Skins(4)=texture'DH_M22Locust_tex.ext_vehicles.M22Locust_wheels'
    Skins(5)=texture'DH_M22Locust_tex.Treads.M22Locust_treads'
    BeginningIdleAnim="driver_hatch_idle_close"

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_M22LocustCannonPawn',WeaponBone="Turret_placement")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-80.0,Y=-40.0,Z=83.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-113.0,Y=0.0,Z=81.0),DriveRot=(Yaw=32768),DriveAnim="VHalftrack_Rider2_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-80.0,Y=46.0,Z=83.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider3_idle")

    // Driver
    DriverPositions(0)=(TransitionUpAnim="Overlay_out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,ViewFOV=90.0,bDrawOverlays=true)
    DriverPositions(1)=(TransitionUpAnim="Driver_hatch_open",TransitionDownAnim="Overlay_in",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,ViewFOV=90.0)
    DriverPositions(2)=(TransitionDownAnim="Driver_hatch_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true,ViewFOV=90.0)
    DriverAttachmentBone="driver_player" // should be Driver_attachment
    DrivePos=(X=15.0,Y=5.0,Z=-10.0) // SET // TODO: reposition attachment bone to remove need for this offset, then delete this line
    DriveAnim="VPanzer3_driver_idle_open"

    // Hull armor
    UFrontArmorFactor=1.27   // 1/2 inch
    URightArmorFactor=0.9525 // 3/8 inch
    ULeftArmorFactor=0.9525
    URearArmorFactor=1.27
    UFrontArmorSlope=65.0
    URightArmorSlope=45.0
    ULeftArmorSlope=45.0
    URearArmorSlope=9.0
    FrontRightAngle=30.0
    RearRightAngle=153.0
    RearLeftAngle=207.0
    FrontLeftAngle=330.0

    // Movement
    MaxCriticalSpeed=1057.0
    GearRatios(3)=0.65
    GearRatios(4)=0.75
    TransRatio=0.14
    MaxPitchSpeed=150.0

    // Damage
    Health=200
    HealthMax=200.0
    EngineHealth=100
    VehHitpoints(0)=(PointRadius=20.0,PointOffset=(X=-80.0,Y=0.0,Z=45.0)) // engine
    VehHitpoints(1)=(PointRadius=9.0,PointScale=1.0,PointBone="body",PointOffset=(X=-15.0,Y=0.0,Z=55.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DriverDamageMult=1.0
    TreadHitMaxHeight=49.0
    DamagedEffectScale=0.8
    DamagedEffectOffset=(X=-60.0,Y=0.0,Z=70.0)
    HullFireChance=0.45
    FireAttachBone="body"
    FireEffectOffset=(X=60.0,Y=-30.0,Z=90.0)
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.M5_Stuart.M5_Stuart_dest1' // 'DH_allies_vehicles_stc3.Locust.Locust_dest' // TODO: get this made

    // Entry & exit
    ExitPositions(0)=(X=60.0,Y=-95.0,Z=75.0)   // driver
    ExitPositions(1)=(X=-20.0,Y=-12.0,Z=200.0) // commander
    ExitPositions(2)=(X=-75.0,Y=-110.0,Z=75.0) // riders
    ExitPositions(3)=(X=-170.0,Y=2.24,Z=75.0)
    ExitPositions(4)=(X=-75.0,Y=110.0,Z=75.0)

    // Sounds
    IdleSound=SoundGroup'DH_AlliedVehicleSounds.stuart.stuart_engine_loop'
    StartUpSound=sound'Vehicle_Engines.T60.t60_engine_start'
    ShutDownSound=sound'Vehicle_Engines.T60.t60_engine_stop'
    //LeftTrackSoundBone="Track_L"
    //RightTrackSoundBone="Track_R"
    LeftTreadSound=sound'Vehicle_EnginesTwo.UC.UC_tread_L'
    RightTreadSound=sound'Vehicle_EnginesTwo.UC.UC_tread_R'
    //RumbleSoundBone="placeholder_int"
    RumbleSound=sound'DH_AlliedVehicleSounds.stuart.stuart_inside_rumble'
    SoundPitch=32

    // Visual effects
    TreadVelocityScale=120.0
    LeftTreadIndex=5 // TODO: re-order material groups
    RightTreadIndex=1
    LeftTreadPanDirection=(Pitch=0,Yaw=16384,Roll=16384)
    RightTreadPanDirection=(Pitch=0,Yaw=16384,Roll=16384)
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-53.0,Y=68.0,Z=69.0),ExhaustRotation=(Yaw=16384))
//  LeftLeverBoneName="lever_L" // TODO: add steering lever bones
//  LeftLeverAxis=AXIS_Z
//  RightLeverBoneName="lever_R"
//  RightLeverAxis=AXIS_Z
//  SteeringScaleFactor=0.75

    // HUD // TODO: get 4 named HUD icons made
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.stuart_body' // locust_body
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Stuart_turret_rot' // Locust_turret_rot
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Stuart_turret_look' // Locust_turret_look
    VehicleHudTreadsPosX(0)=0.37
    VehicleHudTreadsPosX(1)=0.63
    VehicleHudTreadsPosY=0.51
    VehicleHudTreadsScale=0.61
    VehicleHudOccupantsX(0)=0.43
    VehicleHudOccupantsX(2)=0.4
    VehicleHudOccupantsX(3)=0.5
    VehicleHudOccupantsX(4)=0.6
    VehicleHudOccupantsY(0)=0.35
    VehicleHudOccupantsY(2)=0.72
    VehicleHudOccupantsY(3)=0.78
    VehicleHudOccupantsY(4)=0.72
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.m5_stuart' // M22_Locust

    // Visible wheels
    WheelRotationScale=700
    LeftWheelBones(0)="Wheel_L_1"
    LeftWheelBones(1)="Wheel_L_2"
    LeftWheelBones(2)="Wheel_L_3"
    LeftWheelBones(3)="Wheel_L_4"
    LeftWheelBones(4)="Wheel_L_5"
    LeftWheelBones(5)="Wheel_L_6"
    LeftWheelBones(6)="Wheel_L_7"
    LeftWheelBones(7)="Wheel_L_8"
    RightWheelBones(0)="Wheel_R_1"
    RightWheelBones(1)="Wheel_R_2"
    RightWheelBones(2)="Wheel_R_3"
    RightWheelBones(3)="Wheel_R_4"
    RightWheelBones(4)="Wheel_R_5"
    RightWheelBones(5)="Wheel_R_6"
    RightWheelBones(6)="Wheel_R_7"
    RightWheelBones(7)="Wheel_R_8"

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-24.0,Y=5.9,Z=-12.5) // TODO: reposition physics wheel bones & then remove all BoneOffset
        WheelRadius=26.0
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_M22LocustTank.LF_Steering'

    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-24.0,Y=-2.9,Z=-12.5)
        WheelRadius=26.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_M22LocustTank.RF_Steering'

    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=2.0,Y=10.5,Z=-12.5)
        WheelRadius=26.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_M22LocustTank.LR_Steering'

    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=2.0,Y=-7.5,Z=-12.5)
        WheelRadius=26.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_M22LocustTank.RR_Steering'

    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_LM" // TODO: rename bone to 'drive_wheel_L' (similar with right wheel)
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-16.0,Y=10.5,Z=-12.5)
        WheelRadius=26.0
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_M22LocustTank.Left_Drive_Wheel'

    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_RM"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-16.0,Y=-7.5,Z=-12.5)
        WheelRadius=26.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_M22LocustTank.Right_Drive_Wheel'

    // Karma
    VehicleMass=5.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=-0.1,Y=0.0,Z=1.0) // default is Z=-0.5
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_M22LocustTank.KParams0'
}
