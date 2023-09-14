//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Sdkfz105Transport extends DHVehicle;

// Modified to set cannon pawn class, as can't be done in default properties, since as DH_Guns code package isn't compiled until after this package
simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    PassengerWeapons[1].WeaponPawnClass = class<VehicleWeaponPawn>(DynamicLoadObject("DH_Guns.DH_Sdkfz105CannonPawn", class'Class'));
}

// Modified to match the windscreen camo to vehicle's 'cabin' texture
simulated function SpawnVehicleAttachments()
{
    VehicleAttachments[0].Skins[0] = Skins[1];

    super.SpawnVehicleAttachments();
}

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Sd.Kfz. 10/5"
    bHasTreads=true
    VehicleMass=6.5
    ReinforcementCost=2
    MaxDesireability=1.2
    PointValue=500
    MapIconAttachmentClass=class'DH_Engine.DHMapIconAttachment_Vehicle'

    // Hull mesh
    Mesh=SkeletalMesh'DH_SdKfz10_5_anm.SdKfz10_5_body_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex7.ext_vehicles.sdkfz10_5_body_ext'
    Skins(1)=Texture'DH_VehiclesGE_tex7.ext_vehicles.SdKfz10_5_cabin'
    Skins(2)=Texture'DH_Artillery_tex.Flak38.Flak38_gun'
    Skins(3)=Texture'DH_VehiclesGE_tex7.ext_vehicles.SdKfz10_5_meshpanels'
    Skins(4)=Texture'DH_VehiclesGE_tex7.ext_vehicles.SdKfz10_5_wheels'
    Skins(5)=Texture'DH_VehiclesGE_tex7.Treads.SdKfz10_5_treads'
    Skins(6)=Texture'DH_VehiclesGE_tex7.Treads.SdKfz10_5_treads'
    VehicleAttachments(0)=(StaticMesh=StaticMesh'DH_German_vehicles_stc4.Sdkfz10_5.SdKfz10_5_windscreen',AttachBone="Body") // windscreen on non-armoured version
    BeginningIdleAnim="Driver_idle_out"

    // Vehicle weapons & passengers
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Sdkfz105PassengerPawn',WeaponBone="Body")
    PassengerWeapons(1)=(WeaponBone="Turret_placement") // cannon pawn class has to be set in PostBeginPlay() due to build order
    FirstRiderPositionIndex=0 // non-standard as passenger position comes before vehicle weapon position

    // Driver
    DriverPositions(0)=(ViewPitchUpLimit=10000,ViewPitchDownLimit=50000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true)
    DriverPositions(1)=(ViewPitchUpLimit=10000,ViewPitchDownLimit=50000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true)
    DriverAttachmentBone="Driver_player"
    DriveAnim="Vhalftrack_driver_idle"

    // Movement
    MaxCriticalSpeed=674.0 // 40 kph
    GearRatios(0)=-0.3
    GearRatios(1)=0.3
    GearRatios(2)=0.5
    GearRatios(3)=0.7
    GearRatios(4)=0.9
    TorqueCurve=(Points=((InVal=0.0,OutVal=10.0),(InVal=200.0,OutVal=1.0),(InVal=1500.0,OutVal=2.5),(InVal=2200.0,OutVal=0.0)))
    MaxSteerAngleCurve=(Points=((InVal=0.0,OutVal=35.0),(InVal=1500.0,OutVal=30.0),(InVal=1000000000.0,OutVal=15.0)))

    // Physics wheels properties
    WheelLongFrictionScale=1.25
    WheelLongFrictionFunc=(Points=(,(InVal=100.0,OutVal=1.0),(InVal=200.0,OutVal=0.9),(InVal=10000000000.0,OutVal=0.9)))
    WheelLatSlipFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=30.0,OutVal=0.009),(InVal=45.0,OutVal=0.0),(InVal=10000000000.0,OutVal=0.0)))
    WheelSuspensionTravel=8.0
    WheelSuspensionMaxRenderTravel=8.0

    // Damage
    Health=1500
    HealthMax=1500.0
    //AmmoIgnitionProbability=0.2  // 0.75 default; 20mm ammo is unlikely to explode
    //TurretDetonationThreshold=5000.0 // increased from 1750
    //above properties dont compile
    DamagedEffectHealthFireFactor=0.9
    EngineHealth=50
    VehHitpoints(0)=(PointRadius=20.0,PointBone="Body",PointOffset=(X=93.0,Y=0.0,Z=9.0)) // engine
    VehHitpoints(1)=(PointRadius=22.0,PointScale=1.0,PointBone="Wheel_F_R",DamageMultiplier=1.0,HitPointType=HP_Driver) // wheel
    VehHitpoints(2)=(PointRadius=22.0,PointScale=1.0,PointBone="Wheel_F_L",DamageMultiplier=1.0,HitPointType=HP_Driver) // wheel
    EngineDamageFromGrenadeModifier=0.125
    DamagedWheelSpeedFactor=0.4
    DirectHEImpactDamageMult=8.0
    TreadHitMaxHeight=-5.0
    DamagedEffectScale=0.75
    DamagedEffectOffset=(X=90.0,Y=0.0,Z=15.0)
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc4.SdKfz10_5.sdkfz10_5_dest'

    // Vehicle destruction
    ExplosionDamage=85.0
    ExplosionRadius=150.0
    ExplosionSoundRadius=200.0
    DestructionLinearMomentum=(Min=50.0,Max=100.0)
    DestructionAngularMomentum=(Min=10.0,Max=50.0)

    FrontRightAngle=39.0 // angles set specifically for tread hits
    RearRightAngle=161.0
    RearLeftAngle=199.0
    FrontLeftAngle=321.0

    // Exit
    ExitPositions(0)=(X=25.00,Y=-100.00,Z=20.00)  // driver
    ExitPositions(1)=(X=25.00,Y=100.00,Z=20.00)   // passenger
    ExitPositions(2)=(X=-230.00,Y=0.0,Z=20.00)    // gunner
    ExitPositions(3)=(X=-100.00,Y=-125.0,Z=20.00) // alternative exit on left side of rear flat bed
    ExitPositions(4)=(X=-100.00,Y=125.0,Z=20.00)  // alternative exit on right side

    // Sounds
    MaxPitchSpeed=350.0
    IdleSound=SoundGroup'Vehicle_Engines.sdkfz251.sdkfz251_engine_loop'
    StartUpSound=Sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_stop'
    LeftTrackSoundBone="Tread_drive_wheel_F_L"
    LeftTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_L02'
    RightTrackSoundBone="Tread_drive_wheel_F_R"
    RightTreadSound=Sound'Vehicle_Engines.tracks.track_squeak_R02'
    RumbleSound=Sound'Vehicle_Engines.interior.tank_inside_rumble03'

    // Visual effects
    LeftTreadIndex=5
    RightTreadIndex=6
    LeftTreadPanDirection=(Pitch=0,Yaw=16384,Roll=0)
    RightTreadPanDirection=(Pitch=0,Yaw=16384,Roll=0)
    TreadVelocityScale=40.0
    WheelRotationScale=9750.0
    ExhaustPipes(0)=(ExhaustPosition=(X=70.0,Y=-65.0,Z=-5.0),ExhaustRotation=(Pitch=-7000,Yaw=-16364))
    SteerBoneName="Steering_wheel"

    // HUD
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.sdkfz105_body'
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.sdkfz105_turet_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.sdkfz105_turet_look'
    VehicleHudEngineY=0.2
    VehicleHudTreadsPosX(0)=0.38
    VehicleHudTreadsPosX(1)=0.62
    VehicleHudTreadsPosY=0.57
    VehicleHudTreadsScale=0.51
    VehicleHudOccupantsX(0)=0.45
    VehicleHudOccupantsY(0)=0.42
    VehicleHudOccupantsX(1)=0.55
    VehicleHudOccupantsY(1)=0.42
    VehicleHudOccupantsX(2)=0.5
    VehicleHudOccupantsY(2)=0.6
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.sdkfz_105'

    // Visible wheels
    LeftWheelBones(0)="Wheel_T_L_1"
    LeftWheelBones(1)="Wheel_T_L_2"
    LeftWheelBones(2)="Wheel_T_L_3"
    LeftWheelBones(3)="Wheel_T_L_4"
    LeftWheelBones(4)="Wheel_T_L_5"
    LeftWheelBones(5)="Wheel_T_L_6"
    LeftWheelBones(6)="Wheel_T_L_7"
    RightWheelBones(0)="Wheel_T_R_1"
    RightWheelBones(1)="Wheel_T_R_2"
    RightWheelBones(2)="Wheel_T_R_3"
    RightWheelBones(3)="Wheel_T_R_4"
    RightWheelBones(4)="Wheel_T_R_5"
    RightWheelBones(5)="Wheel_T_R_6"
    RightWheelBones(6)="Wheel_T_R_7"

    // Physics wheels
    Begin Object Class=SVehicleWheel Name=Wheel_F_L
        SteerType=VST_Steered
        BoneName="Wheel_F_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=25.0
        SupportBoneName="Axle_F_L"
        SupportBoneAxis=AXIS_X
        bLeftTrack=true
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_Sdkfz105Transport.Wheel_F_L'
    Begin Object Class=SVehicleWheel Name=Wheel_F_R
        SteerType=VST_Steered
        BoneName="Wheel_F_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=25.0
        SupportBoneName="Axle_F_R"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_Sdkfz105Transport.Wheel_F_R'
    Begin Object Class=SVehicleWheel Name=Tread_drive_wheel_F_L
        bPoweredWheel=true
        BoneName="Tread_drive_wheel_F_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=25.0
        bLeftTrack=true
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_Sdkfz105Transport.Tread_drive_wheel_F_L'
    Begin Object Class=SVehicleWheel Name=Tread_drive_wheel_F_R
        bPoweredWheel=true
        BoneName="Tread_drive_wheel_F_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=25.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_Sdkfz105Transport.Tread_drive_wheel_F_R'
    Begin Object Class=SVehicleWheel Name=Tread_drive_wheel_R_L
        bPoweredWheel=true
        BoneName="Tread_drive_wheel_R_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=25.0
        bLeftTrack=true
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_Sdkfz105Transport.Tread_drive_wheel_R_L'
    Begin Object Class=SVehicleWheel Name=Tread_drive_wheel_R_R
        bPoweredWheel=true
        BoneName="Tread_drive_wheel_R_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=25.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_Sdkfz105Transport.Tread_drive_wheel_R_R'

    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=0.25,Y=0.0,Z=-0.8) // default is zero
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=0.5 // default is 10 (this change makes the vehicle turn more slowly & feel more like a halftrack should)
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_Sdkfz105Transport.KParams0'
}
