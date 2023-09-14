//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_T60Tank extends DHArmoredVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="T-60 Light Tank"
    VehicleTeam=1
    VehicleMass=6.5
    ReinforcementCost=4

    // Hull mesh
    Mesh=SkeletalMesh'DH_T60_anm.T60_body_ext'
    Skins(0)=Texture'allies_vehicles_tex.ext_vehicles.T60_ext'
    Skins(1)=Texture'allies_vehicles_tex.Treads.T60_treads'
    Skins(2)=Texture'allies_vehicles_tex.Treads.T60_treads'
    Skins(3)=Texture'allies_vehicles_tex.int_vehicles.T60_int'

    HighDetailOverlay=Material'allies_vehicles_tex.int_vehicles.T60_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3

    // Collision
    CollisionAttachments(0)=(StaticMesh=StaticMesh'DH_allies_vehicles_stc3.T60.T60_visor_Collision',AttachBone="hatch_driver") // collision attachment for driver's armoured visor

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_T60CannonPawn',WeaponBone="Turret_placement")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-80.0,Y=-55.0,Z=40.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-110.0,Y=-10.0,Z=43.0),DriveRot=(Pitch=3640,Yaw=32768),DriveAnim="VHalftrack_Rider2_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-80.0,Y=57.0,Z=40.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider3_idle")

    // Driver
    DriverPositions(0)=(PositionMesh=Mesh'DH_T60_anm.T60_body_int',DriverTransitionAnim=none,TransitionUpAnim=Overlay_Out,ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=0,ViewNegativeYawLimit=0,bExposed=false,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=Mesh'DH_T60_anm.T60_body_int',DriverTransitionAnim=VT60_driver_close,TransitionUpAnim=driver_hatch_open,TransitionDownAnim=Overlay_in,ViewPitchUpLimit=2730,ViewPitchDownLimit=61923,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bExposed=false)
    DriverPositions(2)=(PositionMesh=Mesh'DH_t60_anm.T60_body_int',DriverTransitionAnim=VT60_driver_open,TransitionDownAnim=driver_hatch_close,ViewPitchUpLimit=2730,ViewPitchDownLimit=60000,ViewPositiveYawLimit=9500,ViewNegativeYawLimit=-9500,bExposed=true)
    DrivePos=(X=0,Y=0,Z=0)
    DriveAnim=VT60_driver_idle_close

    // Driver overlay
    HUDOverlayClass=class'ROVehicles.T60DriverOverlay'
    HUDOverlayOffset=(X=2,Y=0,Z=0)
    HUDOverlayFOV=85

    // Hull armor
    FrontArmor(0)=(Thickness=3.5,Slope=-25.0,MaxRelativeHeight=48.5,LocationName="lower nose")
    FrontArmor(1)=(Thickness=1.5,Slope=72.0,MaxRelativeHeight=25.0,LocationName="glacis")
    FrontArmor(2)=(Thickness=3.5,Slope=21.0,LocationName="driver plate")
    RightArmor(0)=(Thickness=1.5) // no upper/lower split as is same
    LeftArmor(0)=(Thickness=1.5)  // no upper/lower split as is same
    RearArmor(0)=(Thickness=2.5,Slope=-27.0,MaxRelativeHeight=21.5,LocationName="lower")
    RearArmor(1)=(Thickness=1.0,Slope=71.0,LocationName="upper")

    FrontLeftAngle=332.0
    RearLeftAngle=208.0

    // Movement
    MaxCriticalSpeed=1057.0 // 63 kph
    GearRatios(3)=0.65
    GearRatios(4)=0.75
    TransRatio=0.13

    // Damage
    // pros: 20mm ammo is very unlikely to explode
    // cons: 2 men crew; petrol fuel
    Health=300
    HealthMax=300.0
    AmmoIgnitionProbability=0.2  // 0.75 default
    TurretDetonationThreshold=5000.0 // increased from 1750
    EngineHealth=300
    EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
    DisintegrationHealth=-800.0 //petrol
    VehHitpoints(0)=(PointRadius=40.0,PointHeight=0.0,PointScale=1.0,PointBone=body,PointOffset=(X=-90.0,Y=0.0,Z=0.0),bPenetrationPoint=false,DamageMultiplier=1.0,HitPointType=HP_Engine)
    VehHitpoints(1)=(PointRadius=25.0,PointHeight=0.0,PointScale=1.0,PointBone=body,PointOffset=(X=13.0,Y=-25.0,Z=-5.0),bPenetrationPoint=false,DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=25.0,PointHeight=0.0,PointScale=1.0,PointBone=body,PointOffset=(X=13.0,Y=25.0,Z=-5.0),bPenetrationPoint=false,DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    TreadHitMaxHeight=15.0
    TreadDamageThreshold=0.15
    DamagedEffectOffset=(X=-100,Y=20,Z=26)
    DamagedEffectScale=0.75
    FireAttachBone="Player_Driver"
    DestroyedVehicleMesh=StaticMesh'allies_vehicles_stc.T60_Destroyed'

    // Exit
    ExitPositions(0)=(X=100.0,Y=-30.0,Z=175.0) // driver hatch
    ExitPositions(1)=(X=0.0,Y=0.0,Z=225.0)     // commander hatch
    ExitPositions(2)=(X=100.0,Y=30.0,Z=175.0)  // hull MG hatch
    ExitPositions(3)=(X=-75.0,Y=-125.0,Z=75.0) // left
    ExitPositions(4)=(X=-200.0,Y=2.24,Z=75.0)  // rear
    ExitPositions(5)=(X=-75.0,Y=125.0,Z=75.0)  // right
    ExitPositions(6)=(X=200.0,Y=0.0,Z=75.0)    // front

    // Sounds
    SoundPitch=32 // half normal pitch = 1 octave lower
    IdleSound=SoundGroup'DH_AlliedVehicleSounds.stuart.stuart_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.T60.t60_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.T60.t60_engine_stop'
    LeftTreadSound=Sound'Vehicle_EnginesTwo.UC.UC_tread_L'
    RightTreadSound=Sound'Vehicle_EnginesTwo.UC.UC_tread_R'
    RumbleSoundBone="body"
    RumbleSound=Sound'Vehicle_Engines.tank_inside_rumble01'

    // Visual effects
    //LeftTreadIndex=3
    //LeftTreadPanDirection=(Pitch=0,Yaw=32768,Roll=16384)
    //RightTreadPanDirection=(Pitch=0,Yaw=32768,Roll=16384)
    TreadVelocityScale=215.0
    WheelRotationScale=45500.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-135,Y=70,Z=15),ExhaustRotation=(pitch=34000,yaw=-16384,roll=0))
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'

    //Steering
    LeftLeverBoneName="Lever_L"
    LeftLeverAxis=AXIS_Z
    RightLeverBoneName="Lever_R"
    RightLeverAxis=AXIS_Z
    SteeringScaleFactor=0.75

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.T60_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.T60_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.T60_turret_look'
    VehicleHudEngineX=0.51
    VehicleHudTreadsPosX(0)=0.35
    VehicleHudTreadsPosX(1)=0.66
    VehicleHudTreadsPosY=0.51
    VehicleHudTreadsScale=0.65
    VehicleHudOccupantsX(0)=0.5
    VehicleHudOccupantsY(0)=0.39
    VehicleHudOccupantsX(1)=0.465
    VehicleHudOccupantsY(1)=0.55
    VehicleHudOccupantsX(2)=0.35
    VehicleHudOccupantsY(2)=0.72
    VehicleHudOccupantsX(3)=0.5
    VehicleHudOccupantsY(3)=0.8
    VehicleHudOccupantsX(4)=0.65
    VehicleHudOccupantsY(4)=0.72
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.t60'

    // Visible wheels
    // Wheel bones for animation
    LeftWheelBones(0)="Wheel_L_1"
    LeftWheelBones(1)="Wheel_L_2"
    LeftWheelBones(2)="Wheel_L_3"
    LeftWheelBones(3)="Wheel_L_4"
    LeftWheelBones(4)="Wheel_L_5"
    LeftWheelBones(5)="Wheel_L_6"
    // Track return wheels
    LeftWheelBones(6)="Wheel_L_7"
    LeftWheelBones(7)="Wheel_L_8"
    LeftWheelBones(8)="Wheel_L_9"

    RightWheelBones(0)="Wheel_R_1"
    RightWheelBones(1)="Wheel_R_2"
    RightWheelBones(2)="Wheel_R_3"
    RightWheelBones(3)="Wheel_R_4"
    RightWheelBones(4)="Wheel_R_5"
    RightWheelBones(5)="Wheel_R_6"
    // Track return wheels
    RightWheelBones(6)="Wheel_R_7"
    RightWheelBones(7)="Wheel_R_8"
    RightWheelBones(8)="Wheel_R_9"

    // Physics wheels
    // Steering Wheels
     Begin Object Class=SVehicleWheel Name=LF_Steering
         bPoweredWheel=True
         BoneOffset=(X=25.0,Y=-3.0,Z=11.0)
         SteerType=VST_Steered
         BoneName="Steer_Wheel_LF"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.000000
     End Object
     Wheels(0)=SVehicleWheel'DH_Vehicles.DH_T60Tank.LF_Steering'

     Begin Object Class=SVehicleWheel Name=RF_Steering
         bPoweredWheel=True
        BoneOffset=(X=25.0,Y=3.0,Z=11.0)
         SteerType=VST_Steered
         BoneName="Steer_Wheel_RF"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.000000
     End Object
     Wheels(1)=SVehicleWheel'DH_Vehicles.DH_T60Tank.RF_Steering'

     Begin Object Class=SVehicleWheel Name=LR_Steering
         bPoweredWheel=True
         BoneOffset=(X=-7.0,Y=-3.0,Z=11.0)
         SteerType=VST_Inverted
         BoneName="Steer_Wheel_RL"//"Steer_Wheel_LR"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.000000
     End Object
     Wheels(2)=SVehicleWheel'DH_Vehicles.DH_T60Tank.LR_Steering'

     Begin Object Class=SVehicleWheel Name=RR_Steering
         bPoweredWheel=True
         BoneOffset=(X=-7.0,Y=3.0,Z=11.0)
         SteerType=VST_Inverted
         BoneName="Steer_Wheel_RR"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.000000
     End Object
     Wheels(3)=SVehicleWheel'DH_Vehicles.DH_T60Tank.RR_Steering'
     // End Steering Wheels

     // Center Drive Wheels
     Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
         bPoweredWheel=True
         BoneOffset=(X=0.0,Y=-3.0,Z=11.0)
         BoneName="Drive_Wheel_L"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.000000
     End Object
     Wheels(4)=SVehicleWheel'DH_Vehicles.DH_T60Tank.Left_Drive_Wheel'

     Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
         bPoweredWheel=True
         BoneOffset=(X=0.0,Y=-3.0,Z=11.0)
         BoneName="Drive_Wheel_R"
         BoneRollAxis=AXIS_Y
         WheelRadius=33.000000
     End Object
     Wheels(5)=SVehicleWheel'DH_Vehicles.DH_T60Tank.Right_Drive_Wheel'
}
