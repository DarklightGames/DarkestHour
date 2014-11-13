//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_KubelwagenCar_WH extends DH_ROWheeledVehicle;


#exec OBJ LOAD FILE=..\Animations\DH_Kubelwagen_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex.utx
#exec OBJ LOAD FILE=..\StaticMeshes\DH_German_vehicles_stc2.usx
#exec OBJ LOAD FILE=..\Sounds\DH_GerVehicleSounds2.uax

//==============================================================================
// Hack in appropriate motion sounds
//==============================================================================

var()   float                 MaxPitchSpeed;

var()       sound               EngineSound;       //  Put Engine sound in right place!
var()       Sound               RumbleSound;       // Interior rumble sound
var         ROSoundAttachment   EngineSoundAttach;
var         ROSoundAttachment   InteriorRumbleSoundAttach;
var         float               MotionSoundVolume;
var()       name                RumbleSoundBone;
var()       name                EngineSoundBone;

//==============================================================================
// Functions
//==============================================================================

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
      velocity=vect(0,0,0);
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

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_body_grau');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_glass_FB');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_body_grau');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_glass_FB');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
     MaxPitchSpeed=250.000000
     EngineSound=Sound'DH_GerVehicleSounds2.Kubelwagen.kubelwagen_engine_loop01'
     RumbleSound=Sound'DH_GerVehicleSounds2.Kubelwagen.kubelwagen_engine_interior'
     RumbleSoundBone="body"
     EngineSoundBone="Engine"
     EngineHealthMax=25
     WheelSoftness=0.025000
     WheelPenScale=0.850000
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
     WheelSuspensionTravel=15.000000
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
     SteerSpeed=75.000000
     TurnDamping=100.000000
     StopThreshold=100.000000
     HandbrakeThresh=200.000000
     EngineInertia=0.100000
     IdleRPM=700.000000
     EngineRPMSoundRange=6000.000000
     SteerBoneName="Steer_Wheel"
     RevMeterScale=4000.000000
     ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
     ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
     ExhaustPipes(0)=(ExhaustPosition=(X=-140.000000,Y=45.000000),ExhaustRotation=(Pitch=34000,Roll=-5000))
     ExhaustPipes(1)=(ExhaustPosition=(X=-140.000000,Y=-45.000000),ExhaustRotation=(Pitch=34000,Roll=5000))
     PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_KubelwagenPassengerOne',WeaponBone="body")
     PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_KubelwagenPassengerTwo',WeaponBone="body")
     PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_KubelwagenPassengerThree',WeaponBone="body")
     IdleSound=Sound'DH_GerVehicleSounds2.Kubelwagen.kubelwagen_engine_loop01'
     StartUpSound=Sound'DH_GerVehicleSounds2.Kubelwagen.kubelwagen_engine_start'
     ShutDownSound=Sound'DH_GerVehicleSounds2.Kubelwagen.kubelwagen_engine_stop'
     DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Kubelwagen.Kubelwagen_wh_dest'
     DisintegrationHealth=-10000.000000
     DestructionLinearMomentum=(Min=50.000000,Max=175.000000)
     DestructionAngularMomentum=(Min=5.000000,Max=15.000000)
     DamagedEffectScale=0.700000
     DamagedEffectOffset=(X=-100.000000,Z=15.000000)
     SteeringScaleFactor=4.000000
     BeginningIdleAnim="driver_hatch_idle_close"
     DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Kubelwagen_anm.kubelwagen_body_int',ViewPitchUpLimit=8000,ViewPitchDownLimit=63000,ViewPositiveYawLimit=26000,ViewNegativeYawLimit=-24000,bExposed=true,ViewFOV=90.000000)
     InitialPositionIndex=0
     VehicleHudImage=Texture'DH_InterfaceArt_tex.Tank_Hud.kubelwagen_body'
     VehicleHudOccupantsX(0)=0.460000
     VehicleHudOccupantsX(1)=0.540000
     VehicleHudOccupantsX(2)=0.450000
     VehicleHudOccupantsX(3)=0.550000
     VehicleHudOccupantsY(0)=0.490000
     VehicleHudOccupantsY(1)=0.490000
     VehicleHudOccupantsY(2)=0.600000
     VehicleHudOccupantsY(3)=0.600000
     VehicleHudEngineY=0.690000
     VehHitpoints(0)=(PointRadius=7.000000,PointBone="body",PointOffset=(X=22.000000,Y=-26.000000,Z=70.000000),bPenetrationPoint=false)
     VehHitpoints(1)=(PointBone="Engine",DamageMultiplier=1.000000)
     VehHitpoints(2)=(PointRadius=15.000000,PointScale=1.000000,PointBone="body",PointOffset=(X=100.000000,Y=25.000000,Z=35.000000),DamageMultiplier=25.000000,HitPointType=HP_AmmoStore)
     VehHitpoints(3)=(PointRadius=8.000000,PointScale=1.000000,PointBone="LeftFrontWheel",DamageMultiplier=5.000000,HitPointType=HP_Engine)
     VehHitpoints(4)=(PointRadius=8.000000,PointScale=1.000000,PointBone="RightFrontWheel",DamageMultiplier=5.000000,HitPointType=HP_Engine)
     VehHitpoints(5)=(PointRadius=8.000000,PointScale=1.000000,PointBone="LeftRearWheel",DamageMultiplier=5.000000,HitPointType=HP_Engine)
     VehHitpoints(6)=(PointRadius=8.000000,PointScale=1.000000,PointBone="RightRearWheel",DamageMultiplier=5.000000,HitPointType=HP_Engine)
     EngineHealth=25
     bMultiPosition=false
     DriverAttachmentBone="driver_attachment"
     Begin Object Class=SVehicleWheel Name=LFWheel
         SteerType=VST_Steered
         BoneName="LeftFrontWheel"
         BoneRollAxis=AXIS_Y
         WheelRadius=23.000000
         SupportBoneName="LeftFrontSusp00"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(0)=SVehicleWheel'DH_Vehicles.DH_KubelwagenCar_WH.LFWheel'

     Begin Object Class=SVehicleWheel Name=RFWheel
         SteerType=VST_Steered
         BoneName="RightFrontWheel"
         BoneRollAxis=AXIS_Y
         WheelRadius=23.000000
         SupportBoneName="RightFrontSusp00"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(1)=SVehicleWheel'DH_Vehicles.DH_KubelwagenCar_WH.RFWheel'

     Begin Object Class=SVehicleWheel Name=LRWheel
         bPoweredWheel=true
         BoneName="LeftRearWheel"
         BoneRollAxis=AXIS_Y
         WheelRadius=23.000000
         SupportBoneName="LeftRearAxle"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(2)=SVehicleWheel'DH_Vehicles.DH_KubelwagenCar_WH.LRWheel'

     Begin Object Class=SVehicleWheel Name=RRWheel
         bPoweredWheel=true
         BoneName="RightRearWheel"
         BoneRollAxis=AXIS_Y
         WheelRadius=23.000000
         SupportBoneName="RightRearAxle"
         SupportBoneAxis=AXIS_X
     End Object
     Wheels(3)=SVehicleWheel'DH_Vehicles.DH_KubelwagenCar_WH.RRWheel'

     VehicleMass=2.000000
     bHasHandbrake=true
     bFPNoZFromCameraPitch=true
     DrivePos=(X=-1.000000,Y=3.000000,Z=-12.000000)
     DriveAnim="Vhalftrack_driver_idle"
     ExitPositions(0)=(Y=-100.000000,Z=60.000000)
     ExitPositions(1)=(Y=100.000000,Z=60.000000)
     EntryRadius=160.000000
     FPCamViewOffset=(Z=2.000000)
     TPCamDistance=300.000000
     CenterSpringForce="SpringONSSRV"
     TPCamLookat=(X=0.000000,Z=0.000000)
     TPCamWorldOffset=(Z=250.000000)
     DriverDamageMult=1.000000
     VehiclePositionString="in a Volkswagen Type 82"
     VehicleNameString="Volkswagen Type 82"
     MaxDesireability=1.900000
     HUDOverlayOffset=(X=2.000000)
     HUDOverlayFOV=90.000000
     GroundSpeed=325.000000
     PitchUpLimit=500
     PitchDownLimit=58000
     HealthMax=125.000000
     Health=125
     Mesh=SkeletalMesh'DH_Kubelwagen_anm.kubelwagen_body_ext'
     Skins(0)=FinalBlend'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_glass_FB'
     Skins(1)=Texture'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_body_grau'
     CollisionRadius=175.000000
     CollisionHeight=40.000000
     Begin Object Class=KarmaParamsRBFull Name=KParams0
         KInertiaTensor(0)=1.300000
         KInertiaTensor(3)=3.000000
         KInertiaTensor(5)=3.000000
         KCOMOffset=(X=0.300000,Z=-0.200000)
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
     KParams=KarmaParamsRBFull'DH_Vehicles.DH_KubelwagenCar_WH.KParams0'

     HighDetailOverlay=Texture'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_body_grau'
     bUseHighDetailOverlayIndex=true
     HighDetailOverlayIndex=1
}
