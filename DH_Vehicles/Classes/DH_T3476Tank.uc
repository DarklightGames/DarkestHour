//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_T3476Tank extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_T34_anm.ukx
#exec OBJ LOAD FILE=..\Textures\allies_vehicles_tex.utx

defaultproperties
{
    // Vehicle properties
    VehicleNameString="T34/76"
    VehicleTeam=1
    MaxDesireability=1.9
    CollisionRadius=175.0
    CollisionHeight=60.0

    // Hull mesh
    Mesh=SkeletalMesh'DH_T34_anm.T34_body_ext'
    Skins(0)=texture'allies_vehicles_tex.ext_vehicles.T3476_ext'
    Skins(1)=texture'allies_vehicles_tex.Treads.T3476_treads'
    Skins(2)=texture'allies_vehicles_tex.Treads.T3476_treads'
    Skins(3)=texture'allies_vehicles_tex.int_vehicles.T3476_int'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3
    HighDetailOverlay=material'allies_vehicles_tex.int_vehicles.t3476_int_s'
    BeginningIdleAnim="driver_hatch_idle_close"

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_T3476CannonPawn',WeaponBone="Turret_Placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_T34MountedMGPawn',WeaponBone="MG_Placement")
    PassengerPawns(0)=(AttachBone="Body",DrivePos=(X=-59.0,Y=-50.0,Z=53.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-100.0,Y=-25.0,Z=105.5),DriveAnim="crouch_idle_binoc") // kneeling, as can't sit in usual position due to fuel drum
    PassengerPawns(2)=(AttachBone="Body",DrivePos=(X=-135.0,Y=35.0,Z=51.0),DriveRot=(Yaw=-32768),DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(3)=(AttachBone="Body",DrivePos=(X=-59.0,Y=50.0,Z=54.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider6_idle")

    // Driver
    InitialPositionIndex=0
    UnbuttonedPositionIndex=1
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_T34_anm.T34_body_int',TransitionUpAnim="driver_hatch_open",DriverTransitionAnim="Vt3485_driver_close",ViewPitchUpLimit=0,ViewPitchDownLimit=65535,ViewPositiveYawLimit=0,ViewNegativeYawLimit=0,ViewFOV=90.0,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_T34_anm.T34_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="Vt3485_driver_open",ViewPitchUpLimit=5500,ViewPitchDownLimit=63500,ViewPositiveYawLimit=11000,ViewNegativeYawLimit=-12500,bExposed=true,ViewFOV=90.0)
    DriverAttachmentBone="driver_attachment"
    DriveAnim="VT3476_driver_idle_close"
    HUDOverlayClass=class'ROVehicles.T3476DriverOverlay'
    HUDOverlayFOV=90.0

    // Hull armor
    UFrontArmorFactor=4.5
    URightArmorFactor=4.5
    ULeftArmorFactor=4.5
    URearArmorFactor=4.5
    UFrontArmorSlope=60.0
    URightArmorSlope=40.0
    ULeftArmorSlope=40.0
    URearArmorSlope=45.0
    FrontLeftAngle=330.0
    FrontRightAngle=30.0
    RearRightAngle=155.0
    RearLeftAngle=205.0

    // Movement
    MaxCriticalSpeed=948.0
    GearRatios(3)=0.65
    GearRatios(4)=0.75
    TransRatio=0.13

    // Damage
    Health=525 // was 800 but adjusted to match similar DH vehicles, i.e. Sherman
    HealthMax=525.0
    VehHitpoints(0)=(PointRadius=40.0,PointOffset=(X=-90.0,Y=0.0,Z=0.0)) // engine
    VehHitpoints(1)=(PointRadius=25.0,PointScale=1.0,PointBone="Body",PointOffset=(X=13.0,Y=-25.0,Z=-5.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=25.0,PointScale=1.0,PointBone="Body",PointOffset=(X=13.0,Y=25.0,Z=-5.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DriverDamageMult=1.0
    TreadHitMaxHeight=5.0
    TreadDamageThreshold=0.75
    DamagedEffectScale=0.9
    DamagedEffectOffset=(X=-105.0,Y=0.0,Z=40.0) // adjusted from original
    HullFireChance=0.55
    FireAttachBone="Body"
    FireEffectOffset=(X=127.0,Y=-18.0,Z=25.0)
    DestroyedVehicleMesh=StaticMesh'allies_vehicles_stc.T3476_Destroyed'

    // Exit positions
    ExitPositions(0)=(X=215.0,Y=-14.0,Z=50.0)  // driver
    ExitPositions(1)=(X=25.0,Y=-5.0,Z=200.0)   // commander
    ExitPositions(2)=(X=215.0,Y=41.0,Z=50.0)   // hull MG
    ExitPositions(3)=(X=-43.0,Y=-125.0,Z=75.0) // riders
    ExitPositions(4)=(X=-210.0,Y=-35.0,Z=75.0)
    ExitPositions(5)=(X=-210.0,Y=37.0,Z=75.0)
    ExitPositions(6)=(X=-43.0,Y=125.0,Z=75.0)

    // Sounds
    SoundPitch=32 // half normal pitch = 1 octave lower
    MaxPitchSpeed=50
    IdleSound=SoundGroup'Vehicle_Engines.T34.t34_engine_loop'
    StartUpSound=sound'Vehicle_Engines.T34.t34_engine_start'
    ShutDownSound=sound'Vehicle_Engines.T34.t34_engine_stop'
    LeftTrackSoundBone="Track_L"
    RightTrackSoundBone="Track_R"
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L07'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L07'
    RumbleSoundBone="Body"
    RumbleSound=sound'Vehicle_Engines.interior.tank_inside_rumble02'

    // Visual effects
    TreadVelocityScale=110.0
    ExhaustEffectClass=class'ROEffects.ExhaustDieselEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustDieselEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-175,Y=30,Z=10),ExhaustRotation=(Pitch=36000,Yaw=0,Roll=0))
    ExhaustPipes(1)=(ExhaustPosition=(X=-175,Y=-30,Z=10),ExhaustRotation=(Pitch=36000,Yaw=0,Roll=0))

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.t34_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.t34_76_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.t34_76_turret_look'
    VehicleHudTreadsPosX(0)=0.36 // some positions adjusted from original
    VehicleHudTreadsScale=0.73
    VehicleHudOccupantsX(0)=0.465
    VehicleHudOccupantsX(2)=0.565
    VehicleHudOccupantsX(3)=0.55
    VehicleHudOccupantsX(4)=0.635
    VehicleHudOccupantsX(5)=0.36
    VehicleHudOccupantsX(6)=0.36
    VehicleHudOccupantsY(0)=0.27
    VehicleHudOccupantsY(1)=0.47
    VehicleHudOccupantsY(3)=0.65
    VehicleHudOccupantsY(4)=0.75
    VehicleHudOccupantsY(5)=0.75
    VehicleHudOccupantsY(6)=0.65
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.T34_76'

    // Visible wheels
    WheelRotationScale=450
    LeftWheelBones(0)="Wheel_L_1"
    LeftWheelBones(1)="Wheel_L_2"
    LeftWheelBones(2)="Wheel_L_3"
    LeftWheelBones(3)="Wheel_L_4"
    LeftWheelBones(4)="Wheel_L_5"
    LeftWheelBones(5)="Wheel_L_6"
    LeftWheelBones(6)="Wheel_L_7"
    RightWheelBones(0)="Wheel_R_1"
    RightWheelBones(1)="Wheel_R_2"
    RightWheelBones(2)="Wheel_R_3"
    RightWheelBones(3)="Wheel_R_4"
    RightWheelBones(4)="Wheel_R_5"
    RightWheelBones(5)="Wheel_R_6"
    RightWheelBones(6)="Wheel_R_7"

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
         bPoweredWheel=True
         BoneOffset=(X=35.0,Y=-10.0,Z=2.0)
         SteerType=VST_Steered
         BoneName="Steer_Wheel_LF"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.0
     End Object
     Wheels(0)=SVehicleWheel'DH_Vehicles.DH_T3476Tank.LF_Steering'
     Begin Object Class=SVehicleWheel Name=RF_Steering
         bPoweredWheel=True
        BoneOffset=(X=35.0,Y=10.0,Z=2.0)
         SteerType=VST_Steered
         BoneName="Steer_Wheel_RF"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.0
     End Object
     Wheels(1)=SVehicleWheel'DH_Vehicles.DH_T3476Tank.RF_Steering'
     Begin Object Class=SVehicleWheel Name=LR_Steering
         bPoweredWheel=True
         BoneOffset=(X=-12.0,Y=-10.0,Z=2.0)
         SteerType=VST_Inverted
         BoneName="Steer_Wheel_LR"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.0
     End Object
     Wheels(2)=SVehicleWheel'DH_Vehicles.DH_T3476Tank.LR_Steering'
     Begin Object Class=SVehicleWheel Name=RR_Steering
         bPoweredWheel=True
         BoneOffset=(X=-12.0,Y=10.0,Z=2.0)
         SteerType=VST_Inverted
         BoneName="Steer_Wheel_RR"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.0
     End Object
     Wheels(3)=SVehicleWheel'DH_Vehicles.DH_T3476Tank.RR_Steering'
     Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
         bPoweredWheel=True
         BoneOffset=(X=0.0,Y=10.0,Z=2.0)
         BoneName="Drive_Wheel_L"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.0
     End Object
     Wheels(4)=SVehicleWheel'DH_Vehicles.DH_T3476Tank.Left_Drive_Wheel'
     Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
         bPoweredWheel=True
         BoneOffset=(X=0.0,Y=-10.0,Z=2.0)
         BoneName="Drive_Wheel_R"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.0
     End Object
     Wheels(5)=SVehicleWheel'DH_Vehicles.DH_T3476Tank.Right_Drive_Wheel'
}
