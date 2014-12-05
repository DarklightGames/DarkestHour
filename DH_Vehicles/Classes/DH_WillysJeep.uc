//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WillysJeep extends DH_ROWheeledVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_WillysJeep_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex2.utx
#exec OBJ LOAD FILE=..\Sounds\DH_AlliedVehicleSounds.uax
#exec OBJ LOAD FILE=..\Sounds\DH_GerVehicleSounds2.uax

var()   float                 MaxPitchSpeed;

var()       sound               EngineSound;       //  Put Engine sound in right place!
var()       Sound               RumbleSound;       // Interior rumble sound
var         ROSoundAttachment   EngineSoundAttach;
var         ROSoundAttachment   InteriorRumbleSoundAttach;
var         float               MotionSoundVolume;
var()       name                RumbleSoundBone;
var()       name                EngineSoundBone;

//The following functions are empty functions
simulated function NextWeapon();   //no need to switch views, there is only one for the driver.
simulated function PrevWeapon();   //no need to switch views, there is only one for the driver.

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
    {

        //add this back in if we add engine sound attachment points
        if (EngineSoundAttach == none)
        {
             EngineSoundAttach = Spawn(class 'ROSoundAttachment');
             EngineSoundAttach.AmbientSound = EngineSound;
             //EngineSoundAttach.SoundVolume = default.SoundVolume;
             AttachToBone(EngineSoundAttach, EngineSoundBone);
        }

        if (InteriorRumbleSoundAttach == none)
        {
             InteriorRumbleSoundAttach = Spawn(class 'ROSoundAttachment');
             InteriorRumbleSoundAttach.AmbientSound = RumbleSound;
             //InteriorRumbleSoundAttach.SoundVolume = default.SoundVolume;
             AttachToBone(InteriorRumbleSoundAttach, RumbleSoundBone);
        }
    }
}

function DriverLeft()
{
    if (EngineSoundAttach != none)
    EngineSoundAttach.SoundVolume = 0;

    MotionSoundVolume=0.0;
    UpdateMovementSound();

    super.DriverLeft();
}

simulated function UpdateMovementSound()
{

    if (EngineSoundAttach != none)
    {
       EngineSoundAttach.SoundVolume= MotionSoundVolume * 0.75;
    }

    if (InteriorRumbleSoundAttach != none)
    {
      InteriorRumbleSoundAttach.SoundVolume= MotionSoundVolume*2.50;
    }
}

simulated function Destroyed()
{

    if (EngineSoundAttach != none)
        EngineSoundAttach.Destroy();
    if (InteriorRumbleSoundAttach != none)
        InteriorRumbleSoundAttach.Destroy();

    super.Destroyed();
}

simulated function Tick(float DeltaTime)
{
    local float MotionSoundTemp;
    local float MySpeed;

    // Only need these effects client side
    if (Level.Netmode != NM_DedicatedServer)

        MySpeed = VSize(Velocity);

        // Setup sounds that are dependent on velocity
        MotionSoundTemp =  MySpeed/MaxPitchSpeed * 255;
        if (MySpeed > 0.1)
        {
            MotionSoundVolume =  FClamp(MotionSoundTemp, 0, 255);
        }
        else
        {
            MotionSoundVolume=0;
        }
        UpdateMovementSound();

    super.Tick(DeltaTime);

    if (bEngineDead || bEngineOff)
    {
      velocity=vect(0, 0, 0);
      Throttle=0;
      ThrottleAmount=0;
      bDisableThrottle=true;
      Steering=0;
    }

    if (Level.NetMode != NM_DedicatedServer)
        CheckEmitters();
}

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex2.ext_vehicles.WillysJeep');
    //L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex2.ext_vehicles.kubelwagen_glass_FB');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex2.ext_vehicles.WillysJeep');
    //Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_glass_FB');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    MaxPitchSpeed=250.000000
    RumbleSound=Sound'DH_GerVehicleSounds2.Kubelwagen.kubelwagen_engine_interior'
    RumbleSoundBone="body"
    EngineHealthMax=25
    WheelSoftness=0.025000
    WheelPenScale=1.200000
    WheelPenOffset=0.010000
    WheelRestitution=0.100000
    WheelInertia=0.100000
    WheelLongFrictionFunc=(Points=(,(InVal=100.000000,OutVal=1.000000),(InVal=200.000000,OutVal=0.900000),(InVal=10000000000.000000,OutVal=0.900000)))
    WheelLongSlip=0.001000
    WheelLatSlipFunc=(Points=(,(InVal=30.000000,OutVal=0.009000),(InVal=45.000000),(InVal=10000000000.000000)))
    WheelLongFrictionScale=1.100000
    WheelLatFrictionScale=1.550000
    WheelHandbrakeSlip=0.010000
    WheelHandbrakeFriction=0.100000
    WheelSuspensionTravel=10.000000
    WheelSuspensionMaxRenderTravel=5.000000
    FTScale=0.030000
    ChassisTorqueScale=0.095000
    MinBrakeFriction=4.000000
    MaxSteerAngleCurve=(Points=((OutVal=45.000000),(InVal=300.000000,OutVal=30.000000),(InVal=500.000000,OutVal=20.000000),(InVal=600.000000,OutVal=15.000000),(InVal=1000000000.000000,OutVal=10.000000)))
    TorqueCurve=(Points=((OutVal=10.000000),(InVal=200.000000,OutVal=0.750000),(InVal=1500.000000,OutVal=2.000000),(InVal=2200.000000)))
    GearRatios(0)=-0.200000
    GearRatios(1)=0.200000
    GearRatios(2)=0.350000
    GearRatios(3)=0.550000
    GearRatios(4)=0.800000
    TransRatio=0.170000
    ChangeUpPoint=2000.000000
    ChangeDownPoint=1000.000000
    LSDFactor=1.000000
    EngineBrakeFactor=0.000100
    EngineBrakeRPMScale=0.100000
    MaxBrakeTorque=20.000000
    SteerSpeed=160.000000
    TurnDamping=35.000000
    StopThreshold=100.000000
    HandbrakeThresh=200.000000
    EngineInertia=0.100000
    IdleRPM=500.000000
    EngineRPMSoundRange=6000.000000
    SteerBoneName="Steer_Wheel"
    RevMeterScale=4000.000000
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-120.000000,Y=30.000000,Z=-5.000000),ExhaustRotation=(Pitch=34000,Roll=-5000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_WillysJeepPassengerOne',WeaponBone="passenger2")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_WillysJeepPassengerTwo',WeaponBone="Passenger3")
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_WillysJeepPassengerThree',WeaponBone="Passenger4")
    IdleSound=SoundGroup'DH_AlliedVehicleSounds.Jeep.jeep_engine_loop03'
    StartUpSound=Sound'DH_AlliedVehicleSounds.Jeep.jeep_engine_start'
    ShutDownSound=Sound'DH_AlliedVehicleSounds.Jeep.jeep_engine_stop'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.Jeep.WillysJeep_dest1'
    DisintegrationHealth=-10000.000000
    DestructionLinearMomentum=(Min=50.000000,Max=175.000000)
    DestructionAngularMomentum=(Min=5.000000,Max=15.000000)
    DamagedEffectScale=0.800000
    DamagedEffectOffset=(X=75.000000,Y=5.000000,Z=45.000000)
    VehicleTeam=1
    SteeringScaleFactor=4.000000
    BeginningIdleAnim="driver_hatch_idle_close"
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_WillysJeep_anm.jeep_body_ext',ViewPitchUpLimit=8000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=26000,ViewNegativeYawLimit=-24000,bExposed=true,ViewFOV=90.000000)
    InitialPositionIndex=0
    VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.Willys_body'
    VehicleHudOccupantsX(0)=0.440000
    VehicleHudOccupantsX(1)=0.570000
    VehicleHudOccupantsX(2)=0.410000
    VehicleHudOccupantsX(3)=0.600000
    VehicleHudOccupantsY(0)=0.530000
    VehicleHudOccupantsY(1)=0.530000
    VehicleHudOccupantsY(2)=0.660000
    VehicleHudOccupantsY(3)=0.660000
    VehicleHudEngineY=0.280000
    VehHitpoints(0)=(PointBone="body",PointOffset=(X=-10.000000,Y=-25.000000,Z=55.000000),bPenetrationPoint=false)
    VehHitpoints(1)=(PointRadius=20.000000,PointOffset=(X=65.000000,Z=15.000000),DamageMultiplier=1.000000)
    VehHitpoints(2)=(PointRadius=18.000000,PointScale=1.000000,PointBone="LeftFrontWheel",DamageMultiplier=1.000000,HitPointType=HP_Engine)
    VehHitpoints(3)=(PointRadius=18.000000,PointScale=1.000000,PointBone="RightFrontWheel",DamageMultiplier=1.000000,HitPointType=HP_Engine)
    VehHitpoints(4)=(PointRadius=18.000000,PointScale=1.000000,PointBone="LeftRearWheel",DamageMultiplier=1.000000,HitPointType=HP_Engine)
    VehHitpoints(5)=(PointRadius=18.000000,PointScale=1.000000,PointBone="RightRearWheel",DamageMultiplier=1.000000,HitPointType=HP_Engine)
    EngineHealth=25
    bMultiPosition=false
    DriverAttachmentBone="driver_attachment"
    Begin Object Class=SVehicleWheel Name=LFWheel
        SteerType=VST_Steered
        BoneName="LeftFrontWheel"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=9.000000,Z=1.000000)
        WheelRadius=25.000000
        SupportBoneName="RightFrontSusp00"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_WillysJeep.LFWheel'
    Begin Object Class=SVehicleWheel Name=RFWheel
        SteerType=VST_Steered
        BoneName="RightFrontWheel"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-9.000000,Z=1.000000)
        WheelRadius=25.000000
        SupportBoneName="LeftFrontSusp00"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_WillysJeep.RFWheel'
    Begin Object Class=SVehicleWheel Name=LRWheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="LeftRearWheel"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=9.000000,Z=1.000000)
        WheelRadius=25.000000
        SupportBoneName="LeftRearAxle"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_WillysJeep.LRWheel'
    Begin Object Class=SVehicleWheel Name=RRWheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="RightRearWheel"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Y=-9.000000,Z=1.000000)
        WheelRadius=25.000000
        SupportBoneName="RightRearAxle"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_WillysJeep.RRWheel'
    VehicleMass=3.000000
    bHasHandbrake=true
    bFPNoZFromCameraPitch=true
    DrivePos=(X=5.000000,Z=8.000000)
    DriveAnim="Vhalftrack_driver_idle"
    ExitPositions(0)=(Y=-100.000000,Z=85.000000)
    ExitPositions(1)=(Y=100.000000,Z=85.000000)
    EntryRadius=225.000000
    FPCamPos=(Z=10.000000)
    FPCamViewOffset=(Z=-5.000000)
    TPCamDistance=300.000000
    CenterSpringForce="SpringONSSRV"
    TPCamLookat=(X=0.000000,Z=0.000000)
    TPCamWorldOffset=(Z=250.000000)
    DriverDamageMult=1.000000
    VehiclePositionString="in a Willys Jeep MB"
    VehicleNameString="Willys Jeep MB"
    HUDOverlayOffset=(X=2.000000)
    HUDOverlayFOV=90.000000
    GroundSpeed=325.000000
    PitchUpLimit=500
    PitchDownLimit=58000
    HealthMax=125.000000
    Health=125
    Mesh=SkeletalMesh'DH_WillysJeep_anm.jeep_body_ext'
    Skins(0)=Texture'DH_VehiclesUS_tex2.ext_vehicles.WillysJeep'
    CollisionRadius=175.000000
    CollisionHeight=40.000000
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.300000
        KInertiaTensor(3)=3.000000
        KInertiaTensor(5)=3.000000
        KCOMOffset=(Z=-0.200000)
        KLinearDamping=0.050000
        KAngularDamping=0.050000
        KStartEnabled=true
        bKNonSphericalInertia=true
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.500000
        KImpactThreshold=700.000000
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_WillysJeep.KParams0'
    HighDetailOverlay=Texture'DH_VehiclesUS_tex2.ext_vehicles.WillysJeep'
}
