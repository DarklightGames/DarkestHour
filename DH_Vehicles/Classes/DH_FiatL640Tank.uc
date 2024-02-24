//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// TODO:
// [ ] Fix periscope position on the turret
// [ ] Where is the gunsight?
// [ ] 8mm Breda coaxial MG stats/projectiles etc.
// [ ] Exterior commander animations
// [ ] Exterior driver animations
// [ ] Fix the yaw of driver periscope position (it didn't rotate)
// [ ] Projectile collision mesh
// [ ] UI elements
// [ ] Passengers
// [ ] Collsion meshes for hatch attachments
// [ ] Exit positions
// [ ] Fire/damaged effects
//
// Red:
// [ ] Interior meshes
// [ ] Destroyed mesh
// [ ] Destroyed treads
// 
// References:
// - https://comandosupremo.com/fiat-l6-40/
// - https://en.wikipedia.org/wiki/L6/40_tank
// - https://tanks-encyclopedia.com/ww2/italy/carro_armato_l6_40.php
//==============================================================================

class DH_FiatL640Tank extends DHArmoredVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Carro Armato L6/40"
    VehicleTeam=0
    VehicleMass=6.8
    ReinforcementCost=2

    Skins(0)=Texture'DH_FiatL640_tex.fiatl640_body_ext'
    Skins(1)=Texture'DH_FiatL640_tex.fiatl640_treads'
    Skins(2)=Texture'DH_FiatL640_tex.fiatl640_treads'

    // Hull mesh
    Mesh=SkeletalMesh'DH_FiatL640_anm.fiatl640_body_ext'

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_FiatL640CannonPawn',WeaponBone="TURRET_PLACEMENT")
    PassengerPawns(0)=(AttachBone="body",DrivePos=(X=-80.0,Y=-55.0,Z=50.0),DriveRot=(Yaw=-16384),DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(1)=(AttachBone="body",DrivePos=(X=-108.0,Y=0.0,Z=57.0),DriveRot=(Pitch=3640,Yaw=32768),DriveAnim="VHalftrack_Rider2_idle")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_FiatL640_anm.fiatl640_body_ext',TransitionUpAnim="overlay_out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewPositiveYawLimit=5500,ViewNegativeYawLimit=-5500,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_FiatL640_anm.fiatl640_body_ext',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="overlay_in",ViewPitchUpLimit=3000,ViewPitchDownLimit=61922,ViewPositiveYawLimit=8000,ViewNegativeYawLimit=-8000)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_FiatL640_anm.fiatl640_body_ext',TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=10000,ViewPitchDownLimit=62000,ViewPositiveYawLimit=16000,ViewNegativeYawLimit=-16000,bExposed=true)
    DrivePos=(X=0,Y=0,Z=0)
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

    // Hitpoints
    VehHitpoints(0)=(PointBone="BODY",PointRadius=27.1584,PointOffset=(X=-68.1716,Z=49.7671),HitPointType=HP_Engine)
    VehHitpoints(1)=(PointBone="BODY",PointRadius=16,PointOffset=(X=-19.1348,Y=-38.7964,Z=68.5152),DamageMultiplier=5.0,HitPointType=HP_AmmoStore)

    TreadHitMaxHeight=59.0
    TreadDamageThreshold=0.5
    DamagedEffectOffset=(X=-78.5,Y=20.0,Z=100.0)
    FireAttachBone="Player_Driver"
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.M5_Stuart.M5_Stuart_dest1'
    ShadowZOffset=20.0

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
    RumbleSoundBone="placeholder_int"   // fix this
    RumbleSound=Sound'DH_AlliedVehicleSounds.stuart.stuart_inside_rumble'

    // Visual effects
    LeftTreadIndex=1
    RightTreadIndex=2
    LeftTreadPanDirection=(Pitch=0,Yaw=0,Roll=0)
    RightTreadPanDirection=(Pitch=0,Yaw=0,Roll=0)
    TreadVelocityScale=100.0
    WheelRotationScale=45500.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-115.924,Y=48.0646,Z=60.461),ExhaustRotation=(Pitch=32768))
    LeftLeverBoneName="LEVER_L"
    RightLeverBoneName="LEVER_R"

    // HUD
    VehicleHudImage=Texture'DH_FiatL640_tex.interface.fiatl640_body'
    VehicleHudTurret=TexRotator'DH_FiatL640_tex.interface.fiatl640_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_FiatL640_tex.interface.fiatl640_turret_look'

    VehicleHudEngineX=0.50

    VehicleHudTreadsPosX(0)=0.35
    VehicleHudTreadsPosX(1)=0.65
    VehicleHudTreadsPosY=0.50
    VehicleHudTreadsScale=0.7

    VehicleHudOccupantsX(0)=0.55
    VehicleHudOccupantsY(0)=0.2 // TODO: fix this

    VehicleHudOccupantsX(1)=0.45
    VehicleHudOccupantsY(1)=0.475

    // TODO: add 2 passengers, fix these
    VehicleHudOccupantsY(2)=0.35
    VehicleHudOccupantsX(3)=0.35
    VehicleHudOccupantsY(3)=0.72
    VehicleHudOccupantsX(4)=0.5
    VehicleHudOccupantsY(4)=0.8
    VehicleHudOccupantsX(5)=0.65
    VehicleHudOccupantsY(5)=0.72

    SpawnOverlay(0)=Material'DH_FiatL640_tex.interace.fiatl640_icon'

    // Visible wheels
    LeftWheelBones(0)="WHEEL_01_L"
    LeftWheelBones(1)="WHEEL_02_L"
    LeftWheelBones(2)="WHEEL_03_L"
    LeftWheelBones(3)="WHEEL_04_L"
    LeftWheelBones(4)="WHEEL_05_L"
    LeftWheelBones(5)="WHEEL_06_L"
    LeftWheelBones(6)="WHEEL_07_L"
    LeftWheelBones(7)="WHEEL_08_L"
    LeftWheelBones(8)="WHEEL_09_L"

    RightWheelBones(0)="WHEEL_01_R"
    RightWheelBones(1)="WHEEL_02_R"
    RightWheelBones(2)="WHEEL_03_R"
    RightWheelBones(3)="WHEEL_04_R"
    RightWheelBones(4)="WHEEL_05_R"
    RightWheelBones(5)="WHEEL_06_R"
    RightWheelBones(6)="WHEEL_07_R"
    RightWheelBones(7)="WHEEL_08_R"
    RightWheelBones(8)="WHEEL_09_R"

    LeftTrackSoundBone="DRIVE_WHEEL_L"
    RightTrackSoundBone="DRIVE_WHEEL_R"

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="STEER_WHEEL_F_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
        bLeftTrack=true
    End Object
    Wheels(0)=LF_Steering
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="STEER_WHEEL_F_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
    End Object
    Wheels(1)=RF_Steering
    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="STEER_WHEEL_B_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
        bLeftTrack=true
    End Object
    Wheels(2)=LR_Steering
    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="STEER_WHEEL_B_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
    End Object
    Wheels(3)=RR_Steering
    Begin Object Class=SVehicleWheel Name=Left_Drive_Wheel
        bPoweredWheel=true
        BoneName="DRIVE_WHEEL_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
        bLeftTrack=true
    End Object
    Wheels(4)=Left_Drive_Wheel
    Begin Object Class=SVehicleWheel Name=Right_Drive_Wheel
        bPoweredWheel=true
        BoneName="DRIVE_WHEEL_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
    End Object
    Wheels(5)=Right_Drive_Wheel
}
