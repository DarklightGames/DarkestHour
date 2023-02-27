//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Sdkfz251Transport extends DHArmoredVehicle;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Sd.Kfz.251 Halftrack"
    bIsApc=true
    bHasTreads=true
    VehicleMass=8.5
    ReinforcementCost=3
    MaxDesireability=1.2
    MinRunOverSpeed=300
    PointValue=500
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_Vehicle'
    PrioritizeWeaponPawnEntryFromIndex=1
    bMustBeTankCommander=false
    UnbuttonedPositionIndex=0

    // Hull mesh
    Mesh=SkeletalMesh'DH_Sdkfz251Halftrack_anm.halftrack_body_ext'
    Skins(0)=Texture'axis_vehicles_tex.ext_vehicles.halftrack_ext'
    Skins(1)=Texture'axis_vehicles_tex.Treads.Halftrack_treads'
    Skins(2)=Texture'axis_vehicles_tex.Treads.Halftrack_treads'
    Skins(3)=Texture'axis_vehicles_tex.int_vehicles.halftrack_int'
    HighDetailOverlay=Shader'axis_vehicles_tex.int_vehicles.halftrack_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3
    CollisionAttachments(0)=(StaticMesh=StaticMesh'DH_German_vehicles_stc.Halftrack.Halftrack_visor_Coll',AttachBone="driver_hatch") // collision attachment for driver's armoured visor
    BeginningIdleAnim="driver_hatch_idle_close"
    bUsesCodedDestroyedSkins=false

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Sdkfz251MGPawn',WeaponBone="mg_base")
    PassengerPawns(0)=(AttachBone="passenger_l_1",DriveAnim="VHalftrack_Rider1_idle")
    PassengerPawns(1)=(AttachBone="passenger_l_2",DriveAnim="VHalftrack_Rider2_idle")
    PassengerPawns(2)=(AttachBone="passenger_l_3",DriveAnim="VHalftrack_Rider3_idle")
    PassengerPawns(3)=(AttachBone="passenger_r_1",DriveAnim="VHalftrack_Rider4_idle")
    PassengerPawns(4)=(AttachBone="passenger_r_2",DriveAnim="VHalftrack_Rider5_idle")
    PassengerPawns(5)=(AttachBone="passenger_r_3",DriveAnim="VHalftrack_Rider6_idle")

    // Driver
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Sdkfz251Halftrack_anm.halftrack_body_int',TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,bExposed=true,bDrawOverlays=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Sdkfz251Halftrack_anm.halftrack_body_int',TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",ViewPitchUpLimit=500,ViewPitchDownLimit=49000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Sdkfz251Halftrack_anm.halftrack_body_int',TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=500,ViewPitchDownLimit=49000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true)
    DriverAttachmentBone="driver_player"
    DrivePos=(X=2.0,Y=2.0,Z=3.5)
    DriveAnim="Vhalftrack_driver_idle"
    HUDOverlayClass=class'ROVehicles.Sdkfz251DriverOverlay'
    HUDOverlayOffset=(X=0.0,Y=0.0,Z=0.8)
    HUDOverlayFOV=100.0

    // Movement & physics wheels properties
    MaxCriticalSpeed=838.22 // 50 kph
    GearRatios(0)=-0.3
    GearRatios(1)=0.3
    GearRatios(2)=0.5
    GearRatios(3)=0.7
    GearRatios(4)=0.9
    TorqueCurve=(Points=((InVal=0.0,OutVal=16.0),(InVal=200.0,OutVal=8.0),(InVal=600.0,OutVal=5.0),(InVal=1200.0,OutVal=2.0),(InVal=2000.0,OutVal=0.5)))
    SteerSpeed=85.0
    MaxSteerAngleCurve=(Points=((InVal=0.0,OutVal=64.0),(InVal=200.0,OutVal=32.0),(InVal=600.0,OutVal=5.0),(InVal=1000000000.0,OutVal=0.0)))
    ChangeUpPoint=2000.0
    ChangeDownPoint=1000.0
    ChassisTorqueScale=0.4
    bSpecialTankTurning=false
    TurnDamping=35.0

    // Physics wheels properties
    WheelLongFrictionScale=1.25
    WheelLongFrictionFunc=(Points=(,(InVal=100.0,OutVal=1.0),(InVal=200.0,OutVal=0.9),(InVal=10000000000.0,OutVal=0.9)))
    WheelLatSlipFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=30.0,OutVal=0.009),(InVal=45.0,OutVal=0.0),(InVal=10000000000.0,OutVal=0.0)))
    WheelLatFrictionScale=1.5

    // Damage
    Health=500.0
    HealthMax=500.0
    DamagedEffectHealthFireFactor=0.2
    EngineHealth=150.0
    VehHitpoints(0)=(PointRadius=50.0,PointOffset=(X=120.0)) // engine
    VehHitpoints(1)=(PointRadius=22.0,PointScale=1.0,PointBone="Wheel_F_R",DamageMultiplier=1.0,HitPointType=HP_Driver) // wheel
    VehHitpoints(2)=(PointRadius=22.0,PointScale=1.0,PointBone="Wheel_F_L",DamageMultiplier=1.0,HitPointType=HP_Driver) // wheel
    EngineDamageFromGrenadeModifier=0.05
    DamagedWheelSpeedFactor=0.4
    DirectHEImpactDamageMult=8.0
    ImpactWorldDamageMult=2.0
    TreadHitMaxHeight=-5.0
    DamagedEffectScale=0.75
    DamagedEffectOffset=(X=120.0,Y=00.0,Z=20.0)
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc.Halftrack.Halftrack0_Destroyed'
    DestructionEffectClass=class'ROEffects.ROVehicleDestroyedEmitter'
    DestructionEffectLowClass=class'ROEffects.ROVehicleDestroyedEmitter_simple'
    bEnableHatchFires=false

    // Vehicle destruction
    ExplosionDamage=85.0
    ExplosionRadius=150.0
    ExplosionSoundRadius=200.0
    DestructionLinearMomentum=(Min=50.0,Max=100.0)
    DestructionAngularMomentum=(Min=10.0,Max=50.0)

    FrontRightAngle=30.0 // angles set specifically for tread hits
    RearRightAngle=160.5
    RearLeftAngle=199.5
    FrontLeftAngle=330.0

    // Exit
    ExitPositions(0)=(X=-240.0,Y=-30.0,Z=5.0)   // back 1 - driver
    ExitPositions(1)=(X=-240.0,Y=30.0,Z=5.0)    // back 2 - MG
    ExitPositions(2)=(X=-285.0,Y=0.0,Z=5.0)     // back 3 - passenger 1
    ExitPositions(3)=(X=-240.0,Y=-30.0,Z=5.0)   // back 1 - passenger 2
    ExitPositions(4)=(X=-240.0,Y=30.0,Z=5.0)    // back 2 - passenger 3
    ExitPositions(5)=(X=-285.0,Y=0.0,Z=5.0)     // back 3 - passenger 4
    ExitPositions(6)=(X=-240.0,Y=-30.0,Z=5.0)   // back 1 - passenger 5
    ExitPositions(7)=(X=-240.0,Y=30.0,Z=5.0)    // back 2 - passenger 6
    ExitPositions(8)=(X=-35.0,Y=-125.0,Z=5.0)   // left side - extra
    ExitPositions(9)=(X=-35.0,Y=117.0,Z=5.0)    // right side - extra
    ExitPositions(10)=(X=-111.0,Y=36.0,Z=112.0) // top - extra

    // Sounds
    MaxPitchSpeed=350.0
    IdleSound=SoundGroup'Vehicle_Engines.sdkfz251.sdkfz251_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_stop'
    LeftTrackSoundBone="steer_wheel_LF"
    LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L02'
    RightTrackSoundBone="steer_wheel_RF"
    RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_R02'
    RumbleSound=Sound'Vehicle_Engines.interior.tank_inside_rumble03'

    // Visual effects
    LeftTreadIndex=1
    RightTreadIndex=2
    LeftTreadPanDirection=(Pitch=0,Yaw=0,Roll=16384)
    RightTreadPanDirection=(Pitch=0,Yaw=0,Roll=16384)
    TreadVelocityScale=80.0
    WheelRotationScale=32500.0
    ExhaustPipes(0)=(ExhaustPosition=(X=105.0,Y=-70.0,Z=-15.0),ExhaustRotation=(Pitch=36000,Yaw=5000))
    SteerBoneName="Steering"

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.sdkfz251_body'
    VehicleHudEngineY=0.3
    VehicleHudTreadsPosX(0)=0.4
    VehicleHudTreadsPosX(1)=0.6
    VehicleHudTreadsPosY=0.55
    VehicleHudTreadsScale=0.48
    VehicleHudOccupantsX(0)=0.45
    VehicleHudOccupantsY(0)=0.4
    VehicleHudOccupantsX(2)=0.45
    VehicleHudOccupantsY(2)=0.6
    VehicleHudOccupantsX(3)=0.45
    VehicleHudOccupantsY(3)=0.7
    VehicleHudOccupantsX(4)=0.45
    VehicleHudOccupantsY(4)=0.8
    VehicleHudOccupantsX(5)=0.55
    VehicleHudOccupantsY(5)=0.6
    VehicleHudOccupantsX(6)=0.55
    VehicleHudOccupantsY(6)=0.7
    VehicleHudOccupantsX(7)=0.55
    VehicleHudOccupantsY(7)=0.8
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.hanomag'

    // Visible wheels
    LeftWheelBones(0)="Wheel_T_L_1"
    LeftWheelBones(1)="Wheel_T_L_2"
    LeftWheelBones(2)="Wheel_T_L_3"
    LeftWheelBones(3)="Wheel_T_L_4"
    LeftWheelBones(4)="Wheel_T_L_5"
    LeftWheelBones(5)="Wheel_T_L_6"
    LeftWheelBones(6)="Wheel_T_L_7"
    LeftWheelBones(7)="Wheel_T_L_8"
    RightWheelBones(0)="Wheel_T_R_1"
    RightWheelBones(1)="Wheel_T_R_2"
    RightWheelBones(2)="Wheel_T_R_3"
    RightWheelBones(3)="Wheel_T_R_4"
    RightWheelBones(4)="Wheel_T_R_5"
    RightWheelBones(5)="Wheel_T_R_6"
    RightWheelBones(6)="Wheel_T_R_7"
    RightWheelBones(7)="Wheel_T_R_8"

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=RFWheel
        SteerType=VST_Steered
        BoneName="Wheel_F_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=27.5
        SupportBoneName="Axle_LF"
        SupportBoneAxis=AXIS_X
        bLeftTrack=true
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_Sdkfz251Transport.RFWheel'
    Begin Object Class=SVehicleWheel Name=LFWheel
        SteerType=VST_Steered
        BoneName="Wheel_F_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=27.5
        SupportBoneName="Axle_RF"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_Sdkfz251Transport.LFWheel'
    Begin Object Class=SVehicleWheel Name=FLeft_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=7.0)
        WheelRadius=30.0
        bLeftTrack=true
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_Sdkfz251Transport.FLeft_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=FRight_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=7.0)
        WheelRadius=30.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_Sdkfz251Transport.FRight_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=RLeft_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=-2.0)
        WheelRadius=30.0
        bLeftTrack=true
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_Sdkfz251Transport.RLeft_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=RRight_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=-2.0)
        WheelRadius=30.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_Sdkfz251Transport.RRight_Drive_Wheel'

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=0.0,Y=0.0,Z=-0.7) // default is zero (RO halftrack is zero, different to DH version)
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_Sdkfz251Transport.KParams0'
}
