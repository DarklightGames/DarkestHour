//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Sdkfz105Transport extends DHApcVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_Sdkfz105_anm.ukx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_German_vehicles_stc.usx

var DHVehicleDecoAttachment ArmorAttachment;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    ArmorAttachment = Spawn(class'DHVehicleDecoAttachment');

    if (ArmorAttachment != none)
    {
        ArmorAttachment.SetDrawScale3D(vect(-1, 1, 1)); //TODO: until piotr fixes the mesh orientation, this is what's happening
        ArmorAttachment.SetStaticMesh(StaticMesh'DH_German_vehicles_stc4.Sdkfz10_5.SdKfz10_5_armor');
        ArmorAttachment.SetCollision(true, true); // bCollideActors & bBlockActors both true, so ducts block players walking through & stop projectiles
        ArmorAttachment.bWorldGeometry = true;    // means we get appropriate bullet impact effects, as if we'd hit a normal static mesh actor
        ArmorAttachment.bHardAttach = true;
        ArmorAttachment.SetBase(self);
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
    LeftTrackSoundBone="steer_wheel_LF"
    RightTrackSoundBone="steer_wheel_RF"
    RumbleSoundBone="body"
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
    WheelSuspensionTravel=15.0
    WheelSuspensionMaxRenderTravel=15.0
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
    SteerBoneName="Steering"
    RevMeterScale=4000.0
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=105.0,Y=-70.0,Z=-15.0),ExhaustRotation=(Pitch=36000,Yaw=5000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Sdkfz105Flak38CannonPawn',WeaponBone="turret_placement")
    PassengerPawns(0)=(AttachBone="driver_player2",DriveAnim="VHalftrack_Rider1_idle")
    IdleSound=SoundGroup'Vehicle_Engines.sdkfz251.sdkfz251_engine_loop'
    StartUpSound=sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_start'
    ShutDownSound=sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_stop'
    DestroyedVehicleMesh=StaticMesh'axis_vehicles_stc.Halftrack.Halftrack_Destoyed'
    DisintegrationHealth=-10000.0
    DestructionLinearMomentum=(Min=100.0,Max=350.0)
    DestructionAngularMomentum=(Max=150.0)
    DamagedEffectScale=0.75
    DamagedEffectOffset=(X=-40.0,Y=10.0,Z=10.0)
    SteeringScaleFactor=4.0
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(TransitionUpAnim="Overlay_Out",ViewPitchUpLimit=1,ViewPitchDownLimit=65535,ViewFOV=90.0,bExposed=true,bDrawOverlays=true)
    DriverPositions(1)=(TransitionUpAnim="driver_hatch_open",TransitionDownAnim="Overlay_In",ViewPitchUpLimit=500,ViewPitchDownLimit=49000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true,ViewFOV=90.0)
    DriverPositions(2)=(TransitionDownAnim="driver_hatch_close",ViewPitchUpLimit=500,ViewPitchDownLimit=49000,ViewPositiveYawLimit=27000,ViewNegativeYawLimit=-27000,bExposed=true,ViewFOV=90.0)
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.sdkfz105_body'
    VehicleHudOccupantsX(0)=0.45
    VehicleHudOccupantsY(0)=0.42
    VehicleHudOccupantsX(1)=0.5
    VehicleHudOccupantsY(1)=0.6
    VehicleHudOccupantsX(2)=0.55
    VehicleHudOccupantsY(2)=0.42
    VehicleHudEngineY=0.3
    VehHitpoints(0)=(PointRadius=30.0,PointBone="engine") // engine
    EngineHealth=150
    DriverAttachmentBone="driver_player1"
    Begin Object Class=SVehicleWheel Name=RFWheel
        SteerType=VST_Steered
        BoneName="Wheel_F_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
        SupportBoneName="Axle_LF"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_Sdkfz105Transport.RFWheel'
    Begin Object Class=SVehicleWheel Name=LFWheel
        SteerType=VST_Steered
        BoneName="Wheel_F_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=30.0
        SupportBoneName="Axle_RF"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_Sdkfz105Transport.LFWheel'
    Begin Object Class=SVehicleWheel Name=FLeft_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_LF"
        BoneRollAxis=AXIS_Y
        WheelRadius=27.5
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_Sdkfz105Transport.FLeft_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=FRight_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_RF"
        BoneRollAxis=AXIS_Y
        WheelRadius=27.5
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_Sdkfz105Transport.FRight_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=RLeft_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_LR"
        BoneRollAxis=AXIS_Y
        WheelRadius=27.5
    End Object
    Wheels(4)=SVehicleWheel'DH_Vehicles.DH_Sdkfz105Transport.RLeft_Drive_Wheel'
    Begin Object Class=SVehicleWheel Name=RRight_Drive_Wheel
        bPoweredWheel=true
        BoneName="steer_wheel_RR"
        BoneRollAxis=AXIS_Y
        WheelRadius=27.5
    End Object
    Wheels(5)=SVehicleWheel'DH_Vehicles.DH_Sdkfz105Transport.RRight_Drive_Wheel'
    VehicleMass=6.5
    DrivePos=(X=2.0,Y=2.0,Z=3.5)
    DriveAnim="Vhalftrack_driver_idle"

    ExitPositions(0)=(X=30.00,Y=-110.00,Z=55.00)
    ExitPositions(1)=(X=-235.00,Y=0.0,Z=55.00)
    ExitPositions(2)=(X=30.00,Y=110.00,Z=55.00)

    EntryRadius=375.0
    CenterSpringForce="SpringONSSRV"
    DriverDamageMult=1.0
    VehicleNameString="Sd.Kfz. 10/5"
    MaxDesireability=1.2
    HUDOverlayClass=class'ROVehicles.Sdkfz251DriverOverlay'
    HUDOverlayOffset=(Z=0.8)
    HUDOverlayFOV=100.0
    GroundSpeed=325.0
    PitchUpLimit=500
    PitchDownLimit=49000
    HealthMax=325.0
    Health=325
    Mesh=SkeletalMesh'DH_SdKfz10_5_anm.SdKfz10_5'
    Skins(0)=Texture'DH_VehiclesGE_tex7.ext_vehicles.SdKfz10_5_base'
    Skins(1)=Texture'DH_VehiclesGE_tex7.ext_vehicles.SdKfz10_5_track'
    Skins(2)=Texture'DH_VehiclesGE_tex7.ext_vehicles.SdKfz10_5_cabine'
    Skins(3)=Texture'DH_Artillery_tex.Flak38.Flak38_gun'
    Skins(4)=Texture'DH_VehiclesGE_tex7.ext_vehicles.SdKfz10_5_wire'
    Skins(5)=Texture'DH_VehiclesGE_tex7.ext_vehicles.SdKfz10_5_track'
    Skins(6)=Texture'DH_VehiclesGE_tex7.ext_vehicles.SdKfz10_5_wheels'
//    VisorColStaticMesh=StaticMesh'DH_German_vehicles_stc.Halftrack.Halftrack_visor_Coll'
//    VisorColAttachBone="driver_hatch"
    CollisionRadius=175.0
    CollisionHeight=40.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(Z=-0.7) // default is -0.5 (RO halftrack has 0.0)
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
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_Sdkfz105Transport.KParams0'
    HighDetailOverlay=Shader'axis_vehicles_tex.int_vehicles.halftrack_int_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3
    LeftTreadPanDirection=(Pitch=0,Yaw=16384,Roll=0)
    RightTreadPanDirection=(Pitch=0,Yaw=16384,Roll=0)
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.hanomag'

    LeftTreadIndex=1
    RightTreadIndex=5

    PlayerCameraBone="Camera_driver1"

//    VehicleHudTurret=TexRotator'DH_InterfaceArt_tex.Tank_H.sdkfz105_turret_rot'
//    VehicleHudTurretLook=TexRotator'DH_InterfaceArt_tex.Tank_Hud.sdkfz105_turret_look'
}
