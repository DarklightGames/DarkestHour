//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_StuartTank extends DHTreadCraft;

#exec OBJ LOAD FILE=..\Animations\DH_Stuart_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex.utx

defaultproperties
{
    LeftTreadIndex=3
    MaxCriticalSpeed=1057.0
    FireAttachBone="Player_Driver"
    HullFireChance=0.45
    UFrontArmorFactor=2.9
    URightArmorFactor=2.9
    ULeftArmorFactor=2.9
    URearArmorFactor=2.5
    UFrontArmorSlope=48.0
    URearArmorSlope=17.0
    PointValue=2.0
    MaxPitchSpeed=150.0
    TreadVelocityScale=215.0
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L03'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_R03'
    RumbleSound=sound'DH_AlliedVehicleSounds.stuart.stuart_inside_rumble'
    LeftTrackSoundBone="Track_L"
    RightTrackSoundBone="Track_R"
    RumbleSoundBone="placeholder_int"
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Stuart_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Stuart_turret_look'
    VehicleHudThreadsPosX(0)=0.37
    VehicleHudThreadsPosX(1)=0.63
    VehicleHudThreadsPosY=0.51
    VehicleHudThreadsScale=0.72
    LeftWheelBones(0)="Wheel_L_1"
    LeftWheelBones(1)="Wheel_L_2"
    LeftWheelBones(2)="Wheel_L_3"
    LeftWheelBones(3)="Wheel_L_4"
    LeftWheelBones(4)="Wheel_L_5"
    LeftWheelBones(5)="Wheel_L_6"
    LeftWheelBones(6)="Wheel_L_7"
    LeftWheelBones(7)="Wheel_L_8"
    LeftWheelBones(8)="Wheel_L_9"
    RightWheelBones(0)="Wheel_R_1"
    RightWheelBones(1)="Wheel_R_2"
    RightWheelBones(2)="Wheel_R_3"
    RightWheelBones(3)="Wheel_R_4"
    RightWheelBones(4)="Wheel_R_5"
    RightWheelBones(5)="Wheel_R_6"
    RightWheelBones(6)="Wheel_R_7"
    RightWheelBones(7)="Wheel_R_8"
    RightWheelBones(8)="Wheel_R_9"
    WheelRotationScale=700
    TreadHitMinAngle=1.15
    FrontLeftAngle=332.0
    RearLeftAngle=208.0
    GearRatios(3)=0.65
    GearRatios(4)=0.75
    TransRatio=0.13
    LeftLeverBoneName="lever_L"
    LeftLeverAxis=AXIS_Z
    RightLeverBoneName="lever_R"
    RightLeverAxis=AXIS_Z
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-100.0,Z=45.0),ExhaustRotation=(Pitch=31000,Yaw=-16384))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_StuartCannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_StuartMountedMGPawn',WeaponBone="Mg_placement")
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_StuartPassengerOne',WeaponBone="body")
    PassengerWeapons(3)=(WeaponPawnClass=class'DH_Vehicles.DH_StuartPassengerTwo',WeaponBone="body")
    PassengerWeapons(4)=(WeaponPawnClass=class'DH_Vehicles.DH_StuartPassengerThree',WeaponBone="body")
    IdleSound=SoundGroup'DH_AlliedVehicleSounds.stuart.stuart_engine_loop'
    StartUpSound=sound'Vehicle_Engines.T60.t60_engine_start'
    ShutDownSound=sound'Vehicle_Engines.T60.t60_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.M5_Stuart.M5_Stuart_dest1'
    DamagedEffectOffset=(X=-78.5,Y=20.0,Z=100.0)
    VehicleTeam=1
    SteeringScaleFactor=0.75
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,ViewFOV=90.0,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="VPanzer3_driver_idle_open",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000,ViewFOV=90.0)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VPanzer3_driver_idle_open",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true,ViewFOV=90.0)
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.stuart_body'
    VehicleHudOccupantsX(0)=0.43
    VehicleHudOccupantsX(3)=0.35
    VehicleHudOccupantsX(4)=0.5
    VehicleHudOccupantsX(5)=0.65
    VehicleHudOccupantsY(0)=0.35
    VehicleHudOccupantsY(2)=0.35
    VehicleHudOccupantsY(3)=0.72
    VehicleHudOccupantsY(4)=0.8
    VehicleHudOccupantsY(5)=0.72
    VehicleHudEngineX=0.51
    VehHitpoints(0)=(PointBone="Player_Driver",PointOffset=(Y=1.0,Z=3.0),bPenetrationPoint=false)
    VehHitpoints(1)=(PointOffset=(X=-73.0,Z=10.0),DamageMultiplier=1.0)
    VehHitpoints(2)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(Z=10.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=10.0,PointScale=1.0,PointBone="body",PointOffset=(Y=-45.0,Z=30.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(4)=(PointRadius=10.0,PointScale=1.0,PointBone="body",PointOffset=(Y=45.0,Z=30.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    EngineHealth=200
    DriverAttachmentBone="driver_attachment"
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=11.0)
        WheelRadius=33.0
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_StuartTank.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=11.0)
        WheelRadius=33.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_StuartTank.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-50.0,Z=11.0)
        WheelRadius=33.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_StuartTank.LR_Steering'
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-50.0,Z=11.0)
        WheelRadius=33.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_StuartTank.RR_Steering'
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_L"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-20.0,Z=11.0)
        WheelRadius=33.0
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_StuartTank.Left_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="drive_wheel_R"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-20.0,Z=11.0)
        WheelRadius=33.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_StuartTank.Right_Drive_Wheel'
    VehicleMass=7.0
    bFPNoZFromCameraPitch=true
    DrivePos=(X=0.0,Y=8.0,Z=0.0)
    DriveAnim="VPanzer3_driver_idle_close"
    ExitPositions(0)=(X=100.0,Y=-30.0,Z=175.0) // driver hatch
    ExitPositions(1)=(X=0.0,Y=0.0,Z=225.0)     // commander hatch
    ExitPositions(2)=(X=100.0,Y=30.0,Z=175.0)  // mg hatch
    ExitPositions(3)=(X=-75.0,Y=-125.0,Z=75.0) // left
    ExitPositions(4)=(X=-200.0,Y=2.24,Z=75.0)  // rear
    ExitPositions(5)=(X=-75.0,Y=125.0,Z=75.0)  // right
    ExitPositions(6)=(X=200.0,Y=0,Z=75.0)      // front
    EntryRadius=350.0
    FPCamPos=(X=0.0,Y=0.0,Z=0.0)
    TPCamDistance=600.0
    TPCamLookat=(X=-50.0)
    TPCamWorldOffset=(Z=250.0)
    DriverDamageMult=1.0
    VehicleNameString="M5 Stuart"
    MaxDesireability=1.9
    PitchUpLimit=5000
    PitchDownLimit=60000
    HealthMax=375.0
    Health=375
    Mesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_ext'
    Skins(0)=texture'DH_VehiclesUS_tex.ext_vehicles.M5_body_ext'
    Skins(1)=texture'DH_VehiclesUS_tex.int_vehicles.M5_body_int'
    Skins(2)=texture'DH_VehiclesUS_tex.Treads.M5_treads'
    Skins(3)=texture'DH_VehiclesUS_tex.Treads.M5_treads'
    SoundPitch=32
    SoundRadius=800.0
    TransientSoundRadius=1500.0
    CollisionRadius=175.0
    CollisionHeight=60.0
    LeftTreadPanDirection=(Pitch=0,Yaw=32768,Roll=16384)
    RightTreadPanDirection=(Pitch=0,Yaw=32768,Roll=16384)
}
