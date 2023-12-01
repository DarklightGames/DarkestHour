//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// [~] MG position animations
// [ ] turret collision meshes
// [ ] collision attachments for hatches
// [ ] Fix camera limits
// [ ] Gunsight overlay texture
// [ ] Destroyed mesh
// [ ] Figure out how to draw the high res interior mesh while in the MG position (wolf sent me a PR dirty was working on earlier)
// [ ] Tweak vehicle handling & stats
// [ ] Armor values (WOLFkraut)
// [ ] Destroyed tread mesh
// [ ] Finalize texture (Red)
// [ ] Add camo variants
// [ ] Driver & gunner player animations (waiting on finalized interior, especially for gunner)
// [ ] Fix bug where MG hatch stays open after swapping positions
// [ ] hatch opening/closing sounds in the animations
// [ ] Don't allow reloading of the MG if turned out
// [ ] UI elements (clock &  spawn menu icon)
// [ ] tweak reloading of the MG to account for double MG
// [ ] engine, track, MG sounds
//==============================================================================

class DH_CV33Tank extends DHArmoredVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Carro Armato L3/33"
    VehicleTeam=0
    bHasTreads=true
    bSpecialTankTurning=true
    VehicleMass=3.0
    ReinforcementCost=3
    MinRunOverSpeed=350 //Lighter vehicle so slightly higher min speed than other APCs
    PointValue=500
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_Vehicle'
    PrioritizeWeaponPawnEntryFromIndex=1
    UnbuttonedPositionIndex=2

    // Hull mesh
    Mesh=SkeletalMesh'DH_CV33_anm.cv33_body_ext'
    // Skins(0)=Texture'DH_VehiclesUK_tex.ext_vehicles.BrenCarrier_body_ext'
    // HighDetailOverlay=Shader'allies_vehicles_tex2.int_vehicles.Universal_Carrier_Int_S'
    // bUseHighDetailOverlayIndex=true
    // HighDetailOverlayIndex=3
    BeginningIdleAnim="driver_closed_idle"

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_CV33MGPawn',WeaponBone="turret_placement")

    // Driver
    InitialPositionIndex=1
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_CV33_anm.cv33_body_int',TransitionUpAnim="driver_vision_close",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,bExposed=false)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_CV33_anm.cv33_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="driver_vision_open",DriverTransitionAnim="VUC_driver_close",ViewPitchUpLimit=14000,ViewPitchDownLimit=58000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_CV33_anm.cv33_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VUC_driver_open",ViewPitchUpLimit=14000,ViewPitchDownLimit=62500,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true)
    DriveAnim="cv33_driver_closed_idle"
    PlayerCameraBone="camera_driver"

    // Movement
    TransRatio=0.145
    TorqueCurve=(Points=((InVal=0.0,OutVal=11.0),(InVal=200.0,OutVal=1.25),(InVal=1500.0,OutVal=2.5),(InVal=2200.0,OutVal=0.0)))
    TurnDamping=50.0
    SteerSpeed=160.0
    MaxSteerAngleCurve=(Points=((InVal=0.0,OutVal=35.0),(InVal=1500.0,OutVal=20.0),(InVal=1000000000.0,OutVal=15.0)))
    ChassisTorqueScale=0.25

    // Physics wheels properties
    WheelPenScale=2.0
    WheelLongFrictionFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=100.0,OutVal=1.0),(InVal=200.0,OutVal=0.9),(InVal=10000000000.0,OutVal=0.9)))
    WheelLatSlipFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=30.0,OutVal=0.009),(InVal=10000000000.0,OutVal=0.0)))
    WheelLongFrictionScale=1.5
    WheelLatFrictionScale=3.0

    // Damage
    Health=500.0
    HealthMax=500.0
    DamagedEffectHealthFireFactor=0.1
    EngineHealth=150.0
    EngineDamageFromGrenadeModifier=0.05
    DirectHEImpactDamageMult=4.0
    ImpactWorldDamageMult=2.0

    VehHitpoints(0)=(PointRadius=24.0,PointBone="ENGINE",DamageMultiplier=1.0,HitPointType=HP_Engine)

    TreadHitMaxHeight=7.0
    DamagedEffectScale=0.70
    DamagedEffectOffset=(X=-20,Y=-3.5,Z=18.0)
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Carrier.Carrier_destroyed'   // REPLACE
    DestructionEffectClass=class'ROEffects.ROVehicleDestroyedEmitter'
    DestructionEffectLowClass=class'ROEffects.ROVehicleDestroyedEmitter_simple'
    bEnableHatchFires=true
    FireEffectClass=class'DH_Effects.DHVehicleDamagedEffect' // driver's hatch fire
    FireAttachBone="passenger_l_2"
    FireEffectOffset=(X=5.0,Y=4.0,Z=10.0) // position of driver's hatch fire - hull mg and turret fire positions are set in those pawn classes
    EngineToHullFireChance=0.55 //engine of the Uni Carrier is in the middle of the hull/passenger compartment
    AmmoIgnitionProbability=0.0 // 0 as ammo hitpoints are meant to represent fuel, not explosive ammo
    FireDetonationChance=0.05
    PlayerFireDamagePer2Secs=10.0 //kills a little more slowly than tanks since halftracks are open vehicles, also gives infantry a little more time to reach safety before bailing

    // Vehicle destruction
    ExplosionDamage=85.0
    ExplosionRadius=150.0
    ExplosionSoundRadius=200.0
    DestructionLinearMomentum=(Min=50.0,Max=100.0)
    DestructionAngularMomentum=(Min=10.0,Max=50.0)

    FrontRightAngle=20.0 // angles set specifically for tread hits
    RearRightAngle=157.0
    RearLeftAngle=203.5
    FrontLeftAngle=339.5

    // Exit
    ExitPositions(0)=(X=-10,Y=95,Z=55)  // driver
    ExitPositions(1)=(X=-10,Y=-95,Z=55) // gunner
    ExitPositions(2)=(X=-140,Y=25,Z=55) // back right
    ExitPositions(3)=(X=-140,Y=-25,Z=55) // back left

    // Sounds
    MaxPitchSpeed=125.0
    IdleSound=SoundGroup'Vehicle_EnginesTwo.UC.UC_engine_loop'
    StartUpSound=Sound'Vehicle_EnginesTwo.UC.UC_engine_start'
    ShutDownSound=Sound'Vehicle_EnginesTwo.UC.UC_engine_stop'
    LeftTrackSoundBone="TRACK_L"
    LeftTreadSound=Sound'Vehicle_EnginesTwo.UC.UC_tread_L'
    RightTrackSoundBone="TRACK_R"
    RightTreadSound=Sound'Vehicle_EnginesTwo.UC.UC_tread_R'
    RumbleSound=Sound'Vehicle_Engines.interior.tank_inside_rumble03'

    // Visual effects
    LeftTreadIndex=1
    RightTreadIndex=2
    LeftTreadPanDirection=(Pitch=0,Yaw=0,Roll=16384)
    RightTreadPanDirection=(Pitch=0,Yaw=0,Roll=16384)
    TreadVelocityScale=80.0
    WheelRotationScale=40000.0

    // Exhaust
    ExhaustPipes(0)=(ExhaustPosition=(X=-91.0,Y=34.0,Z=47.0),ExhaustRotation=(Pitch=32768))
    ExhaustPipes(1)=(ExhaustPosition=(X=-91.0,Y=-34.0,Z=47.0),ExhaustRotation=(Pitch=32768))

    // Levers
    LeftLeverBoneName="LEVER_L"
    RightLeverBoneName="LEVER_R"

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.unicarrier_body'   // REPLACE
    VehicleHudEngineY=0.75
    VehicleHudTreadsPosX(0)=0.37
    VehicleHudTreadsPosX(1)=0.66
    VehicleHudTreadsPosY=0.47
    VehicleHudTreadsScale=0.65
    VehicleHudOccupantsX(0)=0.58
    VehicleHudOccupantsX(1)=0.
    VehicleHudOccupantsY(0)=0.35
    VehicleHudOccupantsY(1)=0.3
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.BrenCarrier'  // REPLACE

    // Visible wheels
    LeftWheelBones(0)="WHEEL_1_L"
    LeftWheelBones(1)="WHEEL_2_L"
    LeftWheelBones(2)="WHEEL_3_L"
    LeftWheelBones(3)="WHEEL_4_L"
    LeftWheelBones(4)="WHEEL_5_L"
    LeftWheelBones(5)="WHEEL_6_L"
    LeftWheelBones(6)="WHEEL_7_L"
    LeftWheelBones(7)="WHEEL_8_L"
    LeftWheelBones(8)="WHEEL_9_L"
    
    RightWheelBones(0)="WHEEL_1_R"
    RightWheelBones(1)="WHEEL_2_R"
    RightWheelBones(2)="WHEEL_3_R"
    RightWheelBones(3)="WHEEL_4_R"
    RightWheelBones(4)="WHEEL_5_R"
    RightWheelBones(5)="WHEEL_6_R"
    RightWheelBones(6)="WHEEL_7_R"
    RightWheelBones(7)="WHEEL_8_R"
    RightWheelBones(8)="WHEEL_9_R"

    // Shadow
    ShadowZOffset=20.0

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="DRIVE_WHEEL_FL"
        BoneRollAxis=AXIS_Y
        WheelRadius=18.0
        bLeftTrack=true
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_CV33Tank.LF_Steering'
    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="DRIVE_WHEEL_FR"
        BoneRollAxis=AXIS_Y
        WheelRadius=18.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_CV33Tank.RF_Steering'
    Begin Object Class=SVehicleWheel Name=LB_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="DRIVE_WHEEL_BL"
        BoneRollAxis=AXIS_Y
        WheelRadius=18.0
        bLeftTrack=true
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_CV33Tank.LB_Steering'
    Begin Object Class=SVehicleWheel Name=RB_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="DRIVE_WHEEL_BR"
        BoneRollAxis=AXIS_Y
        WheelRadius=18.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_CV33Tank.RB_Steering'

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=0.05,Y=0.0,Z=-0.85) // default is zero
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=2.0 // default is 10 (full track tanks tend to have 0.9 or 1.0)
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_CV33Tank.KParams0'
}