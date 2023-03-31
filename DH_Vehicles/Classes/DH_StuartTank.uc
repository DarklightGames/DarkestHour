//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_StuartTank extends DHArmoredVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="M5 Stuart"
    VehicleTeam=1
    VehicleMass=7.0
    ReinforcementCost=4

    // Hull mesh
    Mesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_ext'
    Skins(0)=Texture'DH_VehiclesUS_tex.ext_vehicles.M5_body_ext'
    Skins(1)=Texture'DH_VehiclesUS_tex.int_vehicles.M5_body_int'
    Skins(2)=Texture'DH_VehiclesUS_tex.Treads.M5_treads'
    Skins(3)=Texture'DH_VehiclesUS_tex.Treads.M5_treads'

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_StuartCannonPawn',WeaponBone="Turret_placement")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_StuartMountedMGPawn',WeaponBone="Mg_placement")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-80.0,Y=-55.0,Z=50.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-108.0,Y=0.0,Z=57.0),DriveRot=(Pitch=3640,Yaw=32768),DriveAnim="VHalftrack_Rider2_idle")
    PassengerPawns(2)=(AttachBone="body",DrivePos=(X=-80.0,Y=57.0,Z=50.0),DriveRot=(Yaw=16384),DriveAnim="VHalftrack_Rider3_idle")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_int',TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true)
    DrivePos=(X=1.0,Y=7.0,Z=-10.0)
    DriveAnim="VPanzer3_driver_idle_open"

    // Hull armor
    FrontArmor(0)=(Thickness=4.45,Slope=-23.0,MaxRelativeHeight=48.5,LocationName="lower")
    FrontArmor(1)=(Thickness=2.86,Slope=48.0,LocationName="upper")
    RightArmor(0)=(Thickness=2.7) // side armor was 1.125 inches front half & 1" back half, so split the difference (no upper/lower split as is same)
    LeftArmor(0)=(Thickness=2.7)
    RearArmor(0)=(Thickness=2.54,Slope=-17.0,MaxRelativeHeight=45.2,LocationName="lowest")
    RearArmor(1)=(Thickness=2.54,MaxRelativeHeight=81.3) // this is the main lower and upper hull combined, as both are 1 inch & vertical
    RearArmor(2)=(Thickness=2.54,Slope=49.0,LocationName="upper slope")

    FrontLeftAngle=332.0
    RearLeftAngle=208.0

    // Movement
    MaxCriticalSpeed=1057.0 // 63 kph
    GearRatios(3)=0.65
    GearRatios(4)=0.75
    TransRatio=0.13

    // Damage
    // pros: 37mm ammo is less likely to explode;
    // cons: tightly placed 4 men crew; petrol fuel;
    Health=420
    HealthMax=420.0
    EngineHealth=300
    AmmoIgnitionProbability=0.27  // 0.75 default
    TurretDetonationThreshold=4000.0 // increased from 1750
    EngineToHullFireChance=0.1  //increased from 0.05 for all petrol engines
    DisintegrationHealth=-800.0 //petrol
    VehHitpoints(0)=(PointOffset=(X=-73.0,Z=10.0)) // engine
    VehHitpoints(1)=(PointRadius=20.0,PointScale=1.0,PointBone="body",PointOffset=(Z=10.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(2)=(PointRadius=10.0,PointScale=1.0,PointBone="body",PointOffset=(Y=-45.0,Z=30.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    VehHitpoints(3)=(PointRadius=10.0,PointScale=1.0,PointBone="body",PointOffset=(Y=45.0,Z=30.0),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)
    TreadHitMaxHeight=59.0
    TreadDamageThreshold=0.5
    DamagedEffectOffset=(X=-78.5,Y=20.0,Z=100.0)
    FireAttachBone="Player_Driver"
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.M5_Stuart.M5_Stuart_dest1'

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
    RumbleSoundBone="placeholder_int"
    RumbleSound=Sound'DH_AlliedVehicleSounds.stuart.stuart_inside_rumble'

    // Visual effects
    LeftTreadIndex=3
    LeftTreadPanDirection=(Pitch=0,Yaw=32768,Roll=16384)
    RightTreadPanDirection=(Pitch=0,Yaw=32768,Roll=16384)
    TreadVelocityScale=215.0
    WheelRotationScale=45500.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-110.0,Y=-5.0,Z=40.0),ExhaustRotation=(Pitch=63000,Yaw=32768))
    ExhaustPipes(1)=(ExhaustPosition=(X=-110.0,Y=37.0,Z=40.0),ExhaustRotation=(Pitch=63000,Yaw=32768))
    LeftLeverBoneName="lever_L"
    RightLeverBoneName="lever_R"

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.stuart_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Stuart_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.Stuart_turret_look'
    VehicleHudEngineX=0.51
    VehicleHudTreadsPosX(0)=0.37
    VehicleHudTreadsPosX(1)=0.63
    VehicleHudTreadsPosY=0.51
    VehicleHudTreadsScale=0.72
    VehicleHudOccupantsX(0)=0.43
    VehicleHudOccupantsY(0)=0.35
    VehicleHudOccupantsY(2)=0.35
    VehicleHudOccupantsX(3)=0.35
    VehicleHudOccupantsY(3)=0.72
    VehicleHudOccupantsX(4)=0.5
    VehicleHudOccupantsY(4)=0.8
    VehicleHudOccupantsX(5)=0.65
    VehicleHudOccupantsY(5)=0.72
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.m5_stuart'

    // Visible wheels
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

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=11.0)
        WheelRadius=33.0
        bLeftTrack=true
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
        bLeftTrack=true
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
        bLeftTrack=true
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
}
