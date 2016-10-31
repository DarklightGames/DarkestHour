//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_IS2Tank extends DHArmoredVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_IS2_anm.ukx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_Soviet_vehicles_stc.ukx
#exec OBJ LOAD FILE=..\Textures\allies_vehicles_tex.utx

defaultproperties
{
    // Vehicle properties
    VehicleNameString="IS2"
    VehicleTeam=1
    MaxDesireability=1.9
    CollisionRadius=175.0
    CollisionHeight=60.0

    // Hull mesh
    Mesh=SkeletalMesh'DH_IS2_anm.IS2-body_ext'
    Skins(0)=texture'allies_vehicles_tex.ext_vehicles.IS2_ext'
    Skins(1)=texture'allies_vehicles_tex.Treads.IS2_treads'
    Skins(2)=texture'allies_vehicles_tex.Treads.IS2_treads'
    Skins(3)=texture'allies_vehicles_tex.int_vehicles.IS2_int'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3
    HighDetailOverlay=shader'allies_vehicles_tex.int_vehicles.IS2_int_s'
    BeginningIdleAnim="driver_hatch_idle_close"

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_IS2CannonPawn',WeaponBone="Turret_Placement")

    // TODO: set up riders, incl ExitPositions & VehicleHudOccupantsX/Y
    PassengerPawns(0)=(AttachBone="Body",DrivePos=(X=-110.0,Y=-66.0,Z=45.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-70.0,Y=-30.0,Z=95.0),DriveRot=(Yaw=-4096),DriveAnim="crouch_idle_binoc")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-70.0,Y=30.0,Z=95.0),DriveRot=(Yaw=4096),DriveAnim="crouch_idle_binoc")
    PassengerPawns(3)=(AttachBone="Body",DrivePos=(X=-110.0,Y=66.0,Z=45.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider6_idle")

    // Driver
    DriverPositions(0)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_IS2_anm.IS2-body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=0,ViewNegativeYawLimit=0,bDrawOverlays=true)
    DriverPositions(1)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_IS2_anm.IS2-body_int',DriverTransitionAnim="VIS2_driver_close",TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_in",ViewPitchUpLimit=2730,ViewPitchDownLimit=61900,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500)
    DriverPositions(2)=(ViewFOV=90.0,PositionMesh=SkeletalMesh'DH_IS2_anm.IS2-body_int',DriverTransitionAnim="VIS2_driver_open",TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=5500,ViewPitchDownLimit=65000,ViewPositiveYawLimit=12000,ViewNegativeYawLimit=-12000,bExposed=true)
    DriverAttachmentBone="driver_attachment"
    DriveAnim="VIS2_driver_idle_close"
    HUDOverlayClass=class'ROVehicles.IS2DriverOverlay'
    HUDOverlayFOV=90.0

    // Hull armor
    UFrontArmorFactor=12.0 // model 1943 upper glacis plate, as the part of the upper front hull most exposed (angle also)
    URightArmorFactor=9.0
    ULeftArmorFactor=9.0
    URearArmorFactor=6.0
    UFrontArmorSlope=30.0
    URightArmorSlope=15.0
    ULeftArmorSlope=15.0
    URearArmorSlope=49.0
    FrontLeftAngle=337.0 // angles adjusted from original
    FrontRightAngle=23.0
    RearRightAngle=157.0
    RearLeftAngle=203.0

    // Movement
    GearRatios(4)=0.72
    TransRatio=0.09

    // Damage
    Health=650 // was 800 but adjusted to more in line with similar DH vehicles
    HealthMax=650.0
    DisintegrationHealth=-900.0
    VehHitpoints(0)=(PointRadius=40.0,PointOffset=(X=-100.0,Y=0.0,Z=0.0)) // engine
    VehHitpoints(1)=(PointRadius=25.0,PointScale=1.0,PointBone="body",PointOffset=(X=16.0,Y=-25.0,Z=-5.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=25.0,PointScale=1.0,PointBone="body",PointOffset=(X=16.0,Y=25.0,Z=-5.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    DriverDamageMult=1.0
    TreadHitMaxHeight=8.0
    TreadDamageThreshold=0.75
    DamagedEffectOffset=(X=-135.0,Y=0.0,Z=35.0) // repositioned to engine deck grille
    HullFireChance=0.55
    FireAttachBone="Body"
    FireEffectOffset=(X=170.0,Y=0.0,Z=25.0)
    DestroyedVehicleMesh=StaticMesh'allies_vehicles_stc.Is2_destroyed'
    DestroyedMeshSkins(0)=combiner'DH_VehiclesSOV_tex.Destroyed.IS2_ext_dest'

    // Exit positions
    ExitPositions(0)=(X=250.0,Y=0.0,Z=50.0)    // driver
    ExitPositions(1)=(X=20.0,Y=-20.0,Z=200.0)  // commander
    ExitPositions(2)=(X=-110.00,Y=-147.00,Z=50.00)  // riders
    ExitPositions(3)=(X=-284.00,Y=-35.00,Z=50.00)
    ExitPositions(4)=(X=-284.00,Y=35.00,Z=50.00)
    ExitPositions(5)=(X=-110.00,Y=147.00,Z=50.00)

    // Sounds
    MaxPitchSpeed=450
    IdleSound=sound'Vehicle_Engines.IS2.IS2_engine_loop'
    StartUpSound=sound'Vehicle_Engines.IS2.IS2_engine_start'
    ShutDownSound=sound'Vehicle_Engines.IS2.IS2_engine_stop'
    LeftTrackSoundBone="Track_L"
    RightTrackSoundBone="Track_R"
    LeftTreadSound=sound'Vehicle_Engines.track_squeak_L03'
    RightTreadSound=sound'Vehicle_Engines.track_squeak_R03'
    RumbleSoundBone="Body"
    RumbleSound=sound'Vehicle_Engines.tank_inside_rumble02'

    // Visual effects
    TreadVelocityScale=125.0
    ExhaustEffectClass=class'ROEffects.ExhaustDieselEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustDieselEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-150.0,Y=60.0,Z=40.0),ExhaustRotation=(Pitch=34000,Yaw=0,Roll=-10000))
    ExhaustPipes(1)=(ExhaustPosition=(X=-150.0,Y=-60.0,Z=40.0),ExhaustRotation=(Pitch=34000,Yaw=0,Roll=10000))
    LeftLeverBoneName="Lever_L"
    LeftLeverAxis=AXIS_Z
    RightLeverBoneName="Lever_R"
    RightLeverAxis=AXIS_Z
    SteeringScaleFactor=0.75

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.is2_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.is2_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.is2_turret_look'
    VehicleHudTreadsPosX(0)=0.365 // some positions adjusted from original
    VehicleHudTreadsScale=0.8

    VehicleHudOccupantsX(0)=0.5
    VehicleHudOccupantsY(0)=0.2
    VehicleHudOccupantsY(1)=0.45
    VehicleHudOccupantsX(2)=0.4
    VehicleHudOccupantsY(2)=0.75
    VehicleHudOccupantsX(3)=0.45
    VehicleHudOccupantsY(3)=0.65
    VehicleHudOccupantsX(4)=0.55
    VehicleHudOccupantsY(4)=0.65
    VehicleHudOccupantsX(5)=0.6
    VehicleHudOccupantsY(5)=0.75

    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.IS2'

    // Visible wheels
    WheelRotationScale=1000 // was 600, but raised to more closely match tread speed
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
    LeftWheelBones(10)="Wheel_L_11"
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
    RightWheelBones(10)="Wheel_R_11"

    // Physics wheels
     Begin Object Class=SVehicleWheel Name=LF_Steering
         bPoweredWheel=True
         BoneOffset=(X=30.0,Y=-10.0,Z=6.0)
         SteerType=VST_Steered
         BoneName="Steer_Wheel_LF"
         BoneRollAxis=AXIS_Y
         WheelRadius=30.000000
     End Object
     Wheels(0)=SVehicleWheel'DH_Vehicles.DH_IS2Tank.LF_Steering'

     Begin Object Class=SVehicleWheel Name=RF_Steering
         bPoweredWheel=True
        BoneOffset=(X=30.0,Y=10.0,Z=6.0)
         SteerType=VST_Steered
         BoneName="Steer_Wheel_RF"
         BoneRollAxis=AXIS_Y
         WheelRadius=30.000000
     End Object
     Wheels(1)=SVehicleWheel'DH_Vehicles.DH_IS2Tank.RF_Steering'

     Begin Object Class=SVehicleWheel Name=LR_Steering
         bPoweredWheel=True
         BoneOffset=(X=-18.0,Y=-10.0,Z=6.0)
         SteerType=VST_Inverted
         BoneName="Steer_Wheel_LR"
         BoneRollAxis=AXIS_Y
         WheelRadius=30.000000
     End Object
     Wheels(2)=SVehicleWheel'DH_Vehicles.DH_IS2Tank.LR_Steering'
     Begin Object Class=SVehicleWheel Name=RR_Steering
         bPoweredWheel=True
         BoneOffset=(X=-18.0,Y=10.0,Z=6.0)
         SteerType=VST_Inverted
         BoneName="Steer_Wheel_RR"
         BoneRollAxis=AXIS_Y
         WheelRadius=30.000000
     End Object
     Wheels(3)=SVehicleWheel'DH_Vehicles.DH_IS2Tank.RR_Steering'
     Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
         bPoweredWheel=True
         BoneOffset=(X=0.0,Y=-10.0,Z=6.0)
         BoneName="Drive_Wheel_L"
         BoneRollAxis=AXIS_Y
         WheelRadius=30.000000
     End Object
     Wheels(4)=SVehicleWheel'DH_Vehicles.DH_IS2Tank.Left_Drive_Wheel'
     Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
         bPoweredWheel=True
         BoneOffset=(X=0.0,Y=10.0,Z=6.0)
         BoneName="Drive_Wheel_R"
         BoneRollAxis=AXIS_Y
         WheelRadius=30.000000
     End Object
     Wheels(5)=SVehicleWheel'DH_Vehicles.DH_IS2Tank.Right_Drive_Wheel'
}
