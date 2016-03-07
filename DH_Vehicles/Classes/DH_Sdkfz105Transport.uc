//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Sdkfz105Transport extends DHApcVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_SdKfz10_5_anm.ukx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_German_vehicles_stc4.usx

var     DHVehicleDecoAttachment     WindscreenAttachment;

// Modified to spawn an attachment for the windscreen, which allows this to be omitted in the 'armored' subclass that has armour shielding to the front
simulated function PostBeginPlay()
{
    local int i;

    super.PostBeginPlay();

    WindscreenAttachment = Spawn(class'DHVehicleDecoAttachment');

    if (WindscreenAttachment != none)
    {
        WindscreenAttachment.bHardAttach = true;
        AttachToBone(WindscreenAttachment, 'Body');
        WindscreenAttachment.SetRelativeLocation(vect(0.0, 0.0, -45.0) >> Rotation); // TEMP // TODO: Peter to adjust static meshes to lower by 45 units in Z axis, then remove this line
        WindscreenAttachment.SetStaticMesh(StaticMesh'DH_German_vehicles_stc4.Sdkfz10_5.SdKfz10_5_windscreen');
        WindscreenAttachment.Skins[0] = Skins[1]; // match camo to vehicle's 'cabin' texture
    }
}

// Modified to include WindscreenAttachment
simulated function DestroyAttachments()
{
    super.DestroyAttachments();

    if (WindscreenAttachment != none)
    {
        WindscreenAttachment.Destroy();
    }
}

defaultproperties
{
    FriendlyResetDistance=6000.0
    IdleTimeBeforeReset=300.0
    MaxPitchSpeed=350.0
    TreadVelocityScale=40.0
    WheelRotationScale=150
    LeftTreadSound=sound'Vehicle_Engines.tracks.track_squeak_L02'
    RightTreadSound=sound'Vehicle_Engines.tracks.track_squeak_R02'
    RumbleSound=sound'Vehicle_Engines.interior.tank_inside_rumble03'
    LeftTrackSoundBone="Tread_drive_wheel_F_L"
    RightTrackSoundBone="Tread_drive_wheel_F_R"
    RumbleSoundBone="Body"
    MaxCriticalSpeed=674.0
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
    WheelSoftness=0.025
    WheelPenScale=1.2
    WheelPenOffset=0.01
    WheelRestitution=0.1
    WheelInertia=0.1
    WheelLongFrictionFunc=(Points=(,(InVal=100.0,OutVal=1.0),(InVal=200.0,OutVal=0.9),(InVal=10000000000.0,OutVal=0.9)))
    WheelLongSlip=0.001
    WheelLatSlipFunc=(Points=(,(InVal=30.0,OutVal=0.009),(InVal=45.0),(InVal=10000000000.0)))
    WheelLongFrictionScale=1.1
    WheelLatFrictionScale=2.0
    WheelHandbrakeSlip=0.01
    WheelHandbrakeFriction=0.1
    WheelSuspensionTravel=8.0
    WheelSuspensionMaxRenderTravel=8.0
    FTScale=0.03
    ChassisTorqueScale=0.4
    MinBrakeFriction=4.0
    MaxSteerAngleCurve=(Points=((OutVal=35.0),(InVal=1500.0,OutVal=30.0),(InVal=1000000000.0,OutVal=15.0)))
    TorqueCurve=(Points=((OutVal=10.0),(InVal=200.0,OutVal=1.0),(InVal=1500.0,OutVal=2.5),(InVal=2200.0)))
    GearRatios(0)=-0.25
    GearRatios(1)=0.2
    GearRatios(2)=0.35
    GearRatios(3)=0.5
    GearRatios(4)=0.72
    TransRatio=0.12
    ChangeUpPoint=2000.0
    ChangeDownPoint=1000.0
    LSDFactor=1.0
    EngineBrakeFactor=0.0001
    EngineBrakeRPMScale=0.1
    MaxBrakeTorque=20.0
    SteerSpeed=50.0
    TurnDamping=35.0
    StopThreshold=100.0
    HandbrakeThresh=200.0
    EngineInertia=0.1
    IdleRPM=500.0
    EngineRPMSoundRange=5000.0
    SteerBoneName="Steering_wheel"
    RevMeterScale=4000.0
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=70.0,Y=-65.0,Z=-5.0),ExhaustRotation=(Pitch=-7000,Yaw=-16364))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Sdkfz105PassengerPawn',WeaponBone="Body")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_Sdkfz105CannonPawn',WeaponBone="Turret_placement")
    IdleSound=SoundGroup'Vehicle_Engines.sdkfz251.sdkfz251_engine_loop'
    StartUpSound=sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_start'
    ShutDownSound=sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc4.SdKfz10_5.sdkfz10_5_dest'
    DisintegrationHealth=-10000.0
    DestructionLinearMomentum=(Min=100.0,Max=350.0)
    DestructionAngularMomentum=(Max=150.0)
    DamagedEffectScale=0.75
    DamagedEffectOffset=(X=90.0,Y=0.0,Z=15.0)
    SteeringScaleFactor=4.0
    BeginningIdleAnim="Driver_idle_out"
    DriverPositions(0)=(ViewPitchUpLimit=10000,ViewPitchDownLimit=50000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true,ViewFOV=90.0)
    DriverPositions(1)=(ViewPitchUpLimit=10000,ViewPitchDownLimit=50000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true,ViewFOV=90.0)
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.sdkfz105_body'
    VehicleHudOccupantsX(0)=0.45
    VehicleHudOccupantsY(0)=0.42
    VehicleHudOccupantsX(1)=0.5
    VehicleHudOccupantsY(1)=0.6
    VehicleHudOccupantsX(2)=0.55
    VehicleHudOccupantsY(2)=0.42
    VehicleHudEngineY=0.2
    VehHitpoints(0)=(PointRadius=20.0,PointBone="Body",PointOffset=(X=93.0,Y=0.0,Z=9.0)) // engine
    EngineHealth=150
    DriverAttachmentBone="Driver_player"
    Begin Object Class=SVehicleWheel Name=Wheel_F_L
        SteerType=VST_Steered
        BoneName="Wheel_F_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=25.0
        SupportBoneName="Axle_F_L"
        SupportBoneAxis=AXIS_X
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
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_Sdkfz105Transport.Tread_drive_wheel_R_L'
    Begin Object Class=SVehicleWheel Name=Tread_drive_wheel_R_R
        bPoweredWheel=true
        BoneName="Tread_drive_wheel_R_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=25.0
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_Sdkfz105Transport.Tread_drive_wheel_R_R'
    VehicleMass=6.5
    DriveAnim="Vhalftrack_driver_idle"

    ExitPositions(0)=(X=25.00,Y=-100.00,Z=20.00)  // driver
    ExitPositions(1)=(X=25.00,Y=100.00,Z=20.00)   // passenger
    ExitPositions(2)=(X=-230.00,Y=0.0,Z=20.00)    // gunner
    ExitPositions(3)=(X=-100.00,Y=-125.0,Z=20.00) // alternative exit on left side of rear flat bed
    ExitPositions(4)=(X=-100.00,Y=125.0,Z=20.00)  // alternative exit on right side

    EntryRadius=375.0
    CenterSpringForce="SpringONSSRV"
    DriverDamageMult=1.0
    VehicleNameString="Sd.Kfz. 10/5"
    MaxDesireability=1.2
    GroundSpeed=325.0
    PitchUpLimit=10000
    PitchDownLimit=50000
    HealthMax=325.0
    Health=275
    Mesh=SkeletalMesh'DH_SdKfz10_5_anm.SdKfz10_5_body_ext'
    Skins(0)=texture'DH_VehiclesGE_tex7.ext_vehicles.sdkfz10_5_body_ext'
    Skins(1)=texture'DH_VehiclesGE_tex7.ext_vehicles.SdKfz10_5_cabin'
    Skins(2)=texture'DH_Artillery_tex.Flak38.Flak38_gun'
    Skins(3)=texture'DH_VehiclesGE_tex7.ext_vehicles.SdKfz10_5_meshpanels'
    Skins(4)=texture'DH_VehiclesGE_tex7.ext_vehicles.SdKfz10_5_wheels'
    Skins(5)=texture'DH_VehiclesGE_tex7.Treads.SdKfz10_5_treads'
    Skins(6)=texture'DH_VehiclesGE_tex7.Treads.SdKfz10_5_treads'
    CollisionRadius=175.0
    CollisionHeight=40.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=0.25,Y=0.0,Z=-0.8) // default is zero
        KLinearDamping=0.05
        KAngularDamping=0.05
        KStartEnabled=true
        bKNonSphericalInertia=true
        KMaxAngularSpeed=0.5 // default is 1
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=700.0
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_Sdkfz105Transport.KParams0'
    LeftTreadPanDirection=(Pitch=0,Yaw=16384,Roll=0)
    RightTreadPanDirection=(Pitch=0,Yaw=16384,Roll=0)
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.sdkfz_105'
    LeftTreadIndex=5
    RightTreadIndex=6
    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_Hud.sdkfz105_turet_rot'
    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.sdkfz105_turet_look'
}
