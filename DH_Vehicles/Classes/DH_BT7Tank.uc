//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_BT7Tank extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\textures\allies_ahz_vehicles_tex.utx
#exec OBJ LOAD FILE=..\Animations\allies_ahz_bt7_anm.ukx
#exec OBJ LOAD FILE=..\StaticMeshes\allies_ahz_vehicles_stc.usx

simulated function SetupTreads()
{
    LeftTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));

    if (LeftTreadPanner != none)
    {
        LeftTreadPanner.Material = Skins[LeftTreadIndex];
        LeftTreadPanner.PanDirection = rot(0, 0, 16384);
        LeftTreadPanner.PanRate = 0.0;
        Skins[LeftTreadIndex] = LeftTreadPanner;
    }

    RightTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));

    if (RightTreadPanner != none)
    {
        RightTreadPanner.Material = Skins[RightTreadIndex];
        RightTreadPanner.PanDirection = rot(0, 0, 16384);
        RightTreadPanner.PanRate = 0.0;
        Skins[RightTreadIndex] = RightTreadPanner;
    }
}

defaultproperties
{
    Mesh=Mesh'allies_ahz_bt7_anm.bt7_body_ext'
    DriveAnim=VT60_driver_idle_close
    BeginningIdleAnim=driver_hatch_idle_close

    Skins(0)=Texture'allies_ahz_vehicles_tex.ext_vehicles.BT7_ext'
    Skins(1)=Texture'allies_ahz_vehicles_tex.Treads.bt7_treads'
    Skins(2)=Texture'allies_ahz_vehicles_tex.Treads.bt7_treads'
    Skins(3)=Texture'allies_ahz_vehicles_tex.int_vehicles.BT7_int'

    HighDetailOverlay=Material'allies_ahz_vehicles_tex.int_vehicles.BT7_Int'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3

    // Hud stuff
    VehicleHudImage=Texture 'InterfaceArt_ahz_tex.Tank_Hud.BT7_body'
    VehicleHudTurret=TexRotator'InterfaceArt_ahz_tex.Tank_Hud.BT7_turret_rot'
    VehicleHudTurretLook=TexRotator'InterfaceArt_ahz_tex.Tank_Hud.BT7_turret_look'
    VehicleHudTreadsPosX(0)=0.38
    VehicleHudTreadsPosX(1)=0.63
    VehicleHudTreadsPosY=0.52
    VehicleHudTreadsScale=0.55
    VehicleHudEngineX=0.511
    VehicleHudEngineY=0.66
    VehicleHudOccupantsX(0)=0.50
    VehicleHudOccupantsY(0)=0.26
    VehicleHudOccupantsX(1)=0.47
    VehicleHudOccupantsY(1)=0.50
    VehicleHudOccupantsX(2)=0.635
    VehicleHudOccupantsY(2)=0.65
    VehicleHudOccupantsX(3)=0.635
    VehicleHudOccupantsY(3)=0.75
    VehicleHudOccupantsX(4)=0.36
    VehicleHudOccupantsY(4)=0.75
    VehicleHudOccupantsX(5)=0.36
    VehicleHudOccupantsY(5)=0.65

    // Vehicle Params
    VehicleMass=10.0
    VehicleTeam=1;
    Health=375
    HealthMax=375
    DisintegrationHealth=-1000
    CollisionHeight=+70.0
    CollisionRadius=150.0
    DriverDamageMult=1.0
    TreadVelocityScale=400
    WheelRotationScale=1000
    MaxDesireability=1.0

    GearRatios(0)=-0.250000
    GearRatios(1)=0.250000
    GearRatios(2)=0.400000
    GearRatios(3)=0.650000
    GearRatios(4)=0.700000
    TransRatio=0.13 //max speed is 38kph cross country

    // Weapon Attachments for turret and riders
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_BT7CannonPawn',WeaponBone=Turret_Placement)                //Turret

    PassengerPawns(0)=(AttachBone="passenger_01",DrivePos=(X=0.0,Y=0.0,Z=20.0),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(1)=(AttachBone="passenger_02",DrivePos=(X=0.0,Y=0.0,Z=20.0),DriveAnim="VHalftrack_Rider2_idle")
    PassengerPawns(2)=(AttachBone="passenger_03",DrivePos=(X=0.0,Y=0.0,Z=20.0),DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(3)=(AttachBone="passenger_04",DrivePos=(X=0.0,Y=0.0,Z=20.0),DriveAnim="VHalftrack_Rider4_idle")

    // Position Info
    DriverAttachmentBone=driver_attachment
    DriverPositions(0)=(PositionMesh=Mesh'allies_ahz_bt7_anm.BT7_body_int',DriverTransitionAnim=none,TransitionUpAnim=Overlay_Out,ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=0,ViewNegativeYawLimit=0,bExposed=false,bDrawOverlays=true,ViewFOV=80)
    DriverPositions(1)=(PositionMesh=Mesh'allies_ahz_bt7_anm.BT7_body_int',DriverTransitionAnim=VT60_driver_close,TransitionUpAnim=driver_hatch_open,TransitionDownAnim=Overlay_In,ViewPitchUpLimit=2730,ViewPitchDownLimit=61923,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bExposed=false,ViewFOV=80)
    DriverPositions(2)=(PositionMesh=Mesh'allies_ahz_bt7_anm.BT7_body_int',DriverTransitionAnim=VT60_driver_open,TransitionDownAnim=driver_hatch_close,ViewPitchUpLimit=2730,ViewPitchDownLimit=60000,ViewPositiveYawLimit=9500,ViewNegativeYawLimit=-9500,bExposed=true,ViewFOV=80)

    FPCamPos=(X=0,Y=0,Z=0)
    FPCamViewOffset=(X=0,Y=0,Z=0)
    bFPNoZFromCameraPitch=true
    TPCamLookat=(X=-50,Y=0,Z=0)
    TPCamWorldOffset=(X=0,Y=0,Z=250)
    TPCamDistance=600
    DrivePos=(X=35,Y=0,Z=-5)

    // Driver overlay
    HUDOverlayClass=class'DH_Vehicles.DH_BT7DriverOverlay'
    HUDOverlayOffset=(X=-.25,Y=0.0,Z=0.75)
    HUDOverlayFOV=85

    ExitPositions(0)=(X=0,Y=-200,Z=100)
    ExitPositions(1)=(X=0,Y=200,Z=100)
    EntryPosition=(X=0,Y=0,Z=0)
    EntryRadius=375.0

    VehicleNameString="BT-7"

    PitchUpLimit=5000
    PitchDownLimit=60000

    // Destruction
    DestroyedVehicleMesh=StaticMesh'allies_ahz_vehicles_stc.BT7_destroyed'
    DestructionLinearMomentum=(Min=100.000000,Max=350.000000)
    DestructionAngularMomentum=(Min=50.000000,Max=150.000000)
    DamagedEffectOffset=(X=-100,Y=20,Z=26)
    DamagedEffectScale=0.80

    // effects
    ExhaustPipes(0)=(ExhaustPosition=(X=-185,Y=23,Z=48),ExhaustRotation=(pitch=34000,yaw=0,roll=0))
    ExhaustPipes(1)=(ExhaustPosition=(X=-185,Y=-23,Z=48),ExhaustRotation=(pitch=34000,yaw=0,roll=0))
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'

    // sound
    IdleSound=sound'Vehicle_Engines.T34.t34_engine_loop'
    StartUpSound=sound'Vehicle_Engines.T34.t34_engine_start'
    ShutDownSound=sound'Vehicle_Engines.T34.t34_engine_stop'

    //Vehicle's ambient (idle) sound properties
    MaxPitchSpeed=50//450
    SoundPitch=32 //half normal pitch = 1 octave lower
    SoundRadius=2000 // 200
    TransientSoundRadius=5000 // 600
    bFullVolume=false // true

    // RO Vehicle sound vars
    LeftTreadSound=sound'Vehicle_Engines.track_squeak_L09'
    RightTreadSound=sound'Vehicle_Engines.track_squeak_R09'
    RumbleSound=sound'Vehicle_Engines.tank_inside_rumble01'
    LeftTrackSoundBone="Track_l"
    RightTrackSoundBone="Track_r"
    RumbleSoundBone="body"

    // Steering
    SteeringScaleFactor=4.0
    SteerBoneName="steering_wheel"
    SteerBoneAxis=AXIS_X

    // Wheels
    // Steering Wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=True
        BoneOffset=(X=35.0,Y=-7.0,Z=5.0)
        SteerType=VST_Steered
        BoneName="Steer_Wheel_LF"
        BoneRollAxis=AXIS_Y
        WheelRadius=33.000000
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_BT7Tank.LF_Steering'

    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=True
        BoneOffset=(X=35.0,Y=7.0,Z=5.0)
        SteerType=VST_Steered
        BoneName="Steer_Wheel_RF"
        BoneRollAxis=AXIS_Y
        WheelRadius=33.000000
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_BT7Tank.RF_Steering'

    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=True
        BoneOffset=(X=-25.0,Y=-7.0,Z=5.0)
        SteerType=VST_Inverted
        BoneName="Steer_Wheel_LR"
        BoneRollAxis=AXIS_Y
        WheelRadius=33.000000
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_BT7Tank.LR_Steering'

    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=True
        BoneOffset=(X=-25.0,Y=7.0,Z=5.0)
        SteerType=VST_Inverted
        BoneName="Steer_Wheel_RR"
        BoneRollAxis=AXIS_Y
        WheelRadius=33.000000
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_BT7Tank.RR_Steering'
     // End Steering Wheels
     //-------------------------------------------------------------------------
     // Center Drive Wheels
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=True
        BoneOffset=(X=5.0,Y=7.0,Z=5.0)
        BoneName="Drive_Wheel_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=33.000000
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_BT7Tank.Left_Drive_Wheel'

    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=True
        BoneOffset=(X=5.0,Y=-7.0,Z=5.0)
        BoneName="Drive_Wheel_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=33.000000
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_BT7Tank.Right_Drive_Wheel'

    // Wheel bones for animation
    LeftWheelBones(0)="Wheel_L_1"
    LeftWheelBones(1)="Wheel_L_2"
    LeftWheelBones(2)="Wheel_L_3"
    LeftWheelBones(3)="Wheel_L_4"
    LeftWheelBones(4)="Wheel_L_5"
    LeftWheelBones(5)="Wheel_L_6"

    RightWheelBones(0)="Wheel_R_1"
    RightWheelBones(1)="Wheel_R_2"
    RightWheelBones(2)="Wheel_R_3"
    RightWheelBones(3)="Wheel_R_4"
    RightWheelBones(4)="Wheel_R_5"
    RightWheelBones(5)="Wheel_R_6"

    // Karma params
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.000000
        KInertiaTensor(3)=3.000000
        KInertiaTensor(5)=3.000000
        KCOMOffset=(X=-0.0000,Z=-0.50000)
        KLinearDamping=0.050000
        KAngularDamping=0.050000
        KStartEnabled=True
        bKNonSphericalInertia=True
        bHighDetailOnly=False
        bClientOnly=False
        bKDoubleTickRate=True
        bDestroyOnWorldPenetrate=True
        bDoSafetime=True
        KFriction=0.500000
        KImpactThreshold=700.000000
        KMaxAngularSpeed=1.0
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_BT7Tank.KParams0'

     // Misc ONS
    FlagBone=MG_Placement// Probably not needed
    FlagRotation=(Yaw=32768)

    // Special hit points
    VehHitpoints(0)=(PointRadius=9.0,PointHeight=0.0,PointScale=1.0,PointBone=driver_player,PointOffset=(X=36.0,Y=-1.0,Z=-1.0),bPenetrationPoint=true,HitPointType=HP_Driver)
    VehHitpoints(1)=(PointRadius=30.0,PointHeight=0.0,PointScale=1.0,PointBone=body,PointOffset=(X=-60.0,Y=0.0,Z=-5.0),bPenetrationPoint=false,DamageMultiplier=1.0,HitPointType=HP_Engine)
    VehHitpoints(2)=(PointRadius=15.0,PointHeight=0.0,PointScale=1.0,PointBone=body,PointOffset=(X=55.0,Y=30.0,Z=10.0),bPenetrationPoint=false,DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=15.0,PointHeight=0.0,PointScale=1.0,PointBone=body,PointOffset=(X=55.0,Y=-30.0,Z=10.0),bPenetrationPoint=false,DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    HullFireChance=0.50
    UFrontArmorFactor=3.0
    URightArmorFactor=1.3
    ULeftArmorFactor=1.3
    URearArmorFactor=1.3
    UFrontArmorSlope=15.0
    URightArmorSlope=0.0
    ULeftArmorSlope=0.0
    URearArmorSlope=10.0
    PointValue=2.000000
    LeftTreadIndex=1
    RightTreadIndex=2
    TreadHitMinAngle= 1.9
    MaxCriticalSpeed=1057.000000
}
