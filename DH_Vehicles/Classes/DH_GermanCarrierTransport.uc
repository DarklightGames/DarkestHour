//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_GermanCarrierTransport extends DHVehicle;  //to do: destroyed texture

simulated event DestroyAppearance()
{
    local Combiner DestroyedSkin;

    DestroyedSkin = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
    DestroyedSkin.Material1 = Skins[0];
    DestroyedSkin.Material2 = Texture'DH_FX_Tex.Overlays.DestroyedVehicleOverlay2';
    DestroyedSkin.FallbackMaterial = Skins[0];
    DestroyedSkin.CombineOperation = CO_Multiply;
    DestroyedMeshSkins[0] = DestroyedSkin;

    super.DestroyAppearance();
}

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Bren 731(e)"
    VehicleTeam=0
    bIsApc=true
    bHasTreads=true
    bSpecialTankTurning=true // because Bren Carrier is fully tracked
    VehicleMass=5.0
    ReinforcementCost=3
    MaxDesireability=1.2
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_Vehicle'
    PrioritizeWeaponPawnEntryFromIndex=1

    // Hull mesh
    Mesh=SkeletalMesh'DH_BrenCarrier_anm.BrenCarrier_body_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.german_carrier'
    Skins(1)=Texture'allies_vehicles_tex.Treads.T60_treads'
    Skins(2)=Texture'allies_vehicles_tex.Treads.T60_treads'
    Skins(3)=Texture'allies_vehicles_tex2.int_vehicles.Universal_Carrier_Int'
    HighDetailOverlay=Shader'allies_vehicles_tex2.int_vehicles.Universal_Carrier_Int_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3
    BeginningIdleAnim="driver_hatch_idle_close"

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_GermanCarrierMGPawn',WeaponBone="mg_base")
    PassengerPawns(0)=(AttachBone="passenger_l_1",DriveAnim="VUC_rider1_idle")
    PassengerPawns(1)=(AttachBone="passenger_l_2",DriveAnim="VUC_rider1_idle")
    PassengerPawns(2)=(AttachBone="passenger_r_1",DriveAnim="VUC_rider1_idle")
    PassengerPawns(3)=(AttachBone="passenger_r_2",DriveAnim="VUC_rider1_idle")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_BrenCarrier_anm.BrenCarrier_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,bExposed=true,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_BrenCarrier_anm.BrenCarrier_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",DriverTransitionAnim="VUC_driver_close",ViewPitchUpLimit=14000,ViewPitchDownLimit=58000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_BrenCarrier_anm.BrenCarrier_body_int',TransitionDownAnim="driver_hatch_close",DriverTransitionAnim="VUC_driver_open",ViewPitchUpLimit=14000,ViewPitchDownLimit=62500,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true)
    DriverAttachmentBone="driver_player"
    DriveAnim="VUC_driver_idle_close"
    HUDOverlayClass=class'ROVehicles.UniCarrierDriverOverlay'
    HUDOverlayOffset=(X=0.0,Y=-0.8,Z=1.99)
    HUDOverlayFOV=81.0

    // Movement
    MaxCriticalSpeed=875.0 // 52 kph
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
    Health=1500
    HealthMax=1500.0
    DamagedEffectHealthFireFactor=0.9
    EngineHealth=50
    VehHitpoints(0)=(PointRadius=20.0,PointOffset=(X=-15.0,Y=0.0,Z=0.0)) // engine
    VehHitpoints(1)=(PointRadius=20.0,PointScale=1.0,PointBone="Engine",PointOffset=(X=22.0,Y=0.0,Z=0.0),DamageMultiplier=1.0,HitPointType=HP_Engine)
    VehHitpoints(2)=(PointRadius=15.0,PointScale=1.0,PointBone="Engine",PointOffset=(X=0.0,Y=0.0,Z=30.0),DamageMultiplier=1.0,HitPointType=HP_Engine)
    VehHitpoints(3)=(PointRadius=15.0,PointScale=1.0,PointBone="Engine",PointOffset=(X=27.0,Y=0.0,Z=30.0),DamageMultiplier=1.0,HitPointType=HP_Engine)
    VehHitpoints(4)=(PointRadius=15.0,PointHeight=15.0,PointScale=1.0,PointBone="body",PointOffset=(X=-83.0,Y=0.0,Z=30.0),DamageMultiplier=2.0,HitPointType=HP_AmmoStore)
    DirectHEImpactDamageMult=8.0
    TreadHitMaxHeight=7.0
    DamagedEffectScale=0.75
    DamagedEffectOffset=(X=-40.0,Y=10.0,Z=10.0)
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Carrier.Carrier_destroyed'
    DestructionEffectClass=class'ROEffects.ROVehicleDestroyedEmitter'
    DestructionEffectLowClass=class'ROEffects.ROVehicleDestroyedEmitter_simple'

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
    ExitPositions(0)=(X=50.0,Y=100.0,Z=50.0)   // driver
    ExitPositions(1)=(X=50.0,Y=-100.0,Z=50.0)  // MG
    ExitPositions(2)=(X=5.0,Y=-100.0,Z=50.0)  // left front passenger
    ExitPositions(3)=(X=-55.0,Y=-100.0,Z=50.0) // left rear passenger
    ExitPositions(4)=(X=5.0,Y=100.0,Z=50.0)    // right front passenger
    ExitPositions(5)=(X=-55.0,Y=100.0,Z=50.0)  // right rear passenger

    // Sounds
    MaxPitchSpeed=125.0
    IdleSound=SoundGroup'Vehicle_EnginesTwo.UC.UC_engine_loop'
    StartUpSound=Sound'Vehicle_EnginesTwo.UC.UC_engine_start'
    ShutDownSound=Sound'Vehicle_EnginesTwo.UC.UC_engine_stop'
    LeftTrackSoundBone="Wheel_T_L_3"
    LeftTreadSound=Sound'Vehicle_EnginesTwo.UC.UC_tread_L'
    RightTrackSoundBone="Wheel_T_R_3"
    RightTreadSound=Sound'Vehicle_EnginesTwo.UC.UC_tread_R'
    RumbleSound=Sound'Vehicle_Engines.interior.tank_inside_rumble03'

    // Visual effects
    LeftTreadIndex=1
    RightTreadIndex=2
    LeftTreadPanDirection=(Pitch=0,Yaw=0,Roll=16384)
    RightTreadPanDirection=(Pitch=0,Yaw=0,Roll=16384)
    TreadVelocityScale=80.0
    WheelRotationScale=40000.0
    ExhaustPipes(0)=(ExhaustPosition=(X=-105.0,Y=33.0,Z=13.0),ExhaustRotation=(Pitch=36000))
    ExhaustPipes(1)=(ExhaustPosition=(X=-105.0,Y=-33.0,Z=13.0),ExhaustRotation=(Pitch=36000))
    SteerBoneName="Steering"

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.unicarrier_body'
    VehicleHudEngineY=0.75
    VehicleHudTreadsPosX(0)=0.37
    VehicleHudTreadsPosX(1)=0.66
    VehicleHudTreadsPosY=0.47
    VehicleHudTreadsScale=0.65
    VehicleHudOccupantsX(0)=0.58
    VehicleHudOccupantsX(1)=0.46
    VehicleHudOccupantsX(2)=0.39
    VehicleHudOccupantsX(3)=0.39
    VehicleHudOccupantsX(4)=0.62
    VehicleHudOccupantsX(5)=0.62
    VehicleHudOccupantsY(0)=0.35
    VehicleHudOccupantsY(1)=0.3
    VehicleHudOccupantsY(2)=0.5
    VehicleHudOccupantsY(3)=0.65
    VehicleHudOccupantsY(4)=0.5
    VehicleHudOccupantsY(5)=0.65
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.BrenCarrier'

    // Visible wheels
    LeftWheelBones(0)="Wheel_T_L_1"
    LeftWheelBones(1)="Wheel_T_L_2"
    LeftWheelBones(2)="Wheel_T_L_3"
    LeftWheelBones(3)="Wheel_T_L_4"
    LeftWheelBones(4)="Wheel_T_L_5"
    RightWheelBones(0)="Wheel_T_R_1"
    RightWheelBones(1)="Wheel_T_R_2"
    RightWheelBones(2)="Wheel_T_R_3"
    RightWheelBones(3)="Wheel_T_R_4"
    RightWheelBones(4)="Wheel_T_R_5"

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=LF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-34.5,Y=0.0,Z=3.5)
        WheelRadius=28.0
        bLeftTrack=true
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_GermanCarrierTransport.LF_Steering'

    Begin Object Class=SVehicleWheel Name=RF_Steering
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=-34.5,Y=0.0,Z=3.5)
        WheelRadius=28.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_GermanCarrierTransport.RF_Steering'

    Begin Object Class=SVehicleWheel Name=LR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=23.5,Y=0.0,Z=3.5)
        WheelRadius=28.0
        bLeftTrack=true
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_GermanCarrierTransport.LR_Steering'

    Begin Object Class=SVehicleWheel Name=RR_Steering
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(X=23.5,Y=0.0,Z=3.5)
        WheelRadius=28.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_GermanCarrierTransport.RR_Steering'

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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_GermanCarrierTransport.KParams0'
}
