//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// [ ] Fix engine fire position
// [ ] Fix passengers all facing wild directions by default [why did this happen?]
//==============================================================================
// Bonus Marks:
// [ ] Have a special emitter for the propeller and bow wash
// [ ] Have different driving characteristics when in water/on land
// [ ] Maybe make the propeller spin cause it'd be fun
// [ ] Add more wash sounds to the sides of the vehicle (IMMERSION, BABY!)
// [ ] Add bow water spray
// [ ] Wheels should appear to be stationary while in water
//==============================================================================

class DH_DUKW extends DHBoatVehicle
    abstract;

var name WaterIdleAnim;
var name GroundIdleAnim;

var Sound WaterEngineSound;
var Sound GroundEngineSound;

var Sound WaterStartUpSound;
var Sound WaterShutDownSound;
var Sound GroundStartUpSound;
var Sound GroundShutDownSound;

// State tracking whether the vehicle is in water or not.
var bool bIsInWater;

// A set of exit positions for use when the vehicle is in water.
var array<Vector> WaterExitPositions;

// Modified so that players will exit inside the vehicle when it's in water.
function array<Vector> GetExitPositions()
{
    // If we are in the water, return the positions of each passenger in the vehicle.
    if (bIsInWater)
    {
        return WaterExitPositions;
    }

    return super.GetExitPositions();
}

simulated event DestroyAppearance()
{
    // Avoid calling the DHBoatVehicle's DestroyAppearance function since it does
    // some weird shit we don't want to replicate.
    super(DHVehicle).DestroyAppearance();
}

simulated function name GetIdleAnim()
{
    if (PhysicsVolume.bWaterVolume)
    {
        return WaterIdleAnim;
    }
    else
    {
        return GroundIdleAnim;
    }
}

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    // Force update the water status and run the callbacks so that
    // we initialize into the correct state.
    UpdateInWaterStatus(true);
}

function RaiseSplashGuard()
{
    local int i;

    for (i = 0; i < VehicleComponentControllerActors.Length; ++i)
    {
        if (VehicleComponentControllerActors[i] != none)
        {
            VehicleComponentControllerActors[i].Raise();
        }
    }
}

function LowerSplashGuard()
{
    local int i;

    for (i = 0; i < VehicleComponentControllerActors.Length; ++i)
    {
        if (VehicleComponentControllerActors[i] != none)
        {
            VehicleComponentControllerActors[i].Lower();
        }
    }
}

simulated function OnWaterEntered()
{
    LoopAnim(WaterIdleAnim, 1.0, 1.0);
    
    if (Role == ROLE_Authority)
    {
        RaiseSplashGuard();
    }

    WheelRotationScale = 0;

    // Change the engine sound to the boat engine.
    AmbientSound = WaterEngineSound;

    SetWashSoundActive(true);
}

simulated function OnWaterLeft()
{
    WheelRotationScale = default.WheelRotationScale;

    if (Role == ROLE_Authority)
    {
        LowerSplashGuard();
    }

    LoopAnim(GroundIdleAnim, 1.0, 0.5);

    // Change the engine sound to the truck engine.
    AmbientSound = GroundEngineSound;

    SetWashSoundActive(false);
}

simulated function UpdateInWaterStatus(optional bool bForceUpdate)
{
    local bool bNewIsInWater;

    bNewIsInWater = PhysicsVolume != none && PhysicsVolume.bWaterVolume;

    if (bNewIsInWater && (bForceUpdate || !bIsInWater))
    {
        OnWaterEntered();
    }
    else if (!bNewIsInWater && (bForceUpdate || bIsInWater))
    {
        OnWaterLeft();
    }

    bIsInWater = bNewIsInWater;
}

simulated event PhysicsVolumeChange(PhysicsVolume NewPhysicsVolume)
{
    super.PhysicsVolumeChange(NewPhysicsVolume);

    // TODO: check if the current water status is different from the new one.
    if (NewPhysicsVolume.bWaterVolume && !bIsInWater)
    {
        OnWaterEntered();
    }
    else if (!NewPhysicsVolume.bWaterVolume && bIsInWater)
    {
        OnWaterLeft();
    }

    bIsInWater = NewPhysicsVolume.bWaterVolume;
}

simulated function Sound GetIdleSound()
{
    if (PhysicsVolume.bWaterVolume)
    {
        return WaterEngineSound;
    }
    else
    {
        return GroundEngineSound;
    }
}

simulated function Sound GetStartUpSound()
{
    if (PhysicsVolume.bWaterVolume)
    {
        return WaterStartUpSound;
    }
    else
    {
        return GroundStartUpSound;
    }
}

simulated function Sound GetShutDownSound()
{
    if (PhysicsVolume.bWaterVolume)
    {
        return WaterShutDownSound;
    }
    else
    {
        return GroundShutDownSound;
    }
}

defaultproperties
{
    bIsAmphibious=true

    WaterIdleAnim="idle_water"
    GroundIdleAnim="idle_ground"

    VehicleNameString="DUKW"
    VehicleTeam=1

    Mesh=SkeletalMesh'DH_DUKW_anm.dukw_ext'

    MapIconMaterial=Texture'DH_InterfaceArt2_tex.craft_amphibious_topdown'

    BeginningIdleAnim="idle_water"

    // Use a secondary animation channel to decouple the driver transition animations from the boat idle animations.
    DriverAnimationChannel=1
    DriverAnimationChannelBone="CAMERA_DRIVER"

    bMultiPosition=true
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_DUKW_anm.dukw_ext',DriverTransitionAnim=dukw_driver_transition_down,TransitionUpAnim=com_raise,ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=30000,ViewNegativeYawLimit=-30000,bExposed=true)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_DUKW_anm.dukw_ext',DriverTransitionAnim=dukw_driver_transition_up,TransitionDownAnim=com_lower,ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=30000,ViewNegativeYawLimit=-30000,bExposed=true)
    // TODO: add binocs position
    InitialPositionIndex=0
    DriverAttachmentBone="com_player"
    DrivePos=(X=0,Y=0,Z=57)
    DriveAnim="DUKW_driver_idle_closed"

    // Sounds
    EngineSoundBone="ENGINE"
    EngineSound=SoundGroup'DH_AlliedVehicleSounds.higgins.HigginsEngine_loop'
    WaterEngineSound=SoundGroup'DH_AlliedVehicleSounds.higgins.HigginsEngine_loop'
    GroundEngineSound=SoundGroup'DH_alliedvehiclesounds.gmc.gmctruck_engine_loop'
    WaterStartUpSound=Sound'DH_AlliedVehicleSounds.higgins.HigginsStart01'
    WaterShutDownSound=Sound'DH_AlliedVehicleSounds.higgins.HigginsStop01'
    GroundStartUpSound=Sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_start'
    GroundShutDownSound=Sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_stop'
    // TODO: startup sounds for both types of engine, automatically play when the vehicle changes volumes

    WashSound=Sound'DH_AlliedVehicleSounds.higgins.wash01'
    VehicleAttachments(0)=(AttachBone="WASH")

    // TODO: idle sound?

    //================copypaste from gmc

    // Engine/Transmission
    TorqueCurve=(Points=((InVal=0.0,OutVal=15.0),(InVal=200.0,OutVal=10.0),(InVal=600.0,OutVal=8.0),(InVal=1200.0,OutVal=3.0),(InVal=2000.0,OutVal=0.5)))
    GearRatios(0)=-0.3
    GearRatios(1)=0.4  //0.2
    GearRatios(2)=0.65   //0.350000
    GearRatios(3)=0.85    //0.6
    GearRatios(4)=1.1    //0.98
    TransRatio=0.18
    ChangeUpPoint=1990.0
    ChangeDownPoint=1000.0

    // Vehicle properties

    // Vehicle properties
    WheelSoftness=0.025000
    WheelPenScale=1.200000
    WheelPenOffset=0.010000
    WheelRestitution=0.100000
    WheelInertia=0.100000
    WheelLongFrictionFunc=(Points=(,(InVal=100.000000,OutVal=1.000000),(InVal=200.000000,OutVal=0.900000),(InVal=10000000000.000000,OutVal=0.900000)))
    WheelLongSlip=0.001000
    WheelLatSlipFunc=(Points=(,(InVal=30.000000,OutVal=0.009000),(InVal=45.000000),(InVal=10000000000.000000)))
    WheelLongFrictionScale=1.100000
    WheelLatFrictionScale=1.55
    WheelHandbrakeSlip=0.010000
    WheelHandbrakeFriction=0.1
    WheelSuspensionTravel=5.0
    WheelSuspensionMaxRenderTravel=5.0
    WheelSuspensionOffset=0.0
    FTScale=0.030000
    ChassisTorqueScale=1.0
    MinBrakeFriction=4.000000
    MaxSteerAngleCurve=(Points=((InVal=0.0,OutVal=11.5),(InVal=200.0,OutVal=10.0),(InVal=800.0,OutVal=5.0),(InVal=1000000000.0,OutVal=0.0)))
    SteerSpeed=70.0
    TurnDamping=25.0
    StopThreshold=100.000000
    HandbrakeThresh=100.0 //200.000000
    LSDFactor=1.000000
    CenterSpringForce="SpringONSSRV"

    //MaxSteerAngleCurve=(Points=((InVal=0.0,OutVal=45.0),(InVal=200.0,OutVal=35.0),(InVal=800.0,OutVal=6.0),(InVal=1000000000.0,OutVal=0.0)))
    MaxBrakeTorque=20.0 //10.0
    bHasHandbrake=true

    // Physics wheels properties
    //WheelLongFrictionFunc=(Points=((InVal=0.0,OutVal=0.1),(InVal=100.0,OutVal=1.0),(InVal=200.0,OutVal=0.3),(InVal=400.0,OutVal=0.1),(InVal=10000000000.0,OutVal=0.0)))
    //WheelLatSlipFunc=(Points=((InVal=0.0,OutVal=0.0),(InVal=30.0,OutVal=0.009),(InVal=45.0,OutVal=0.09),(InVal=10000000000.0,OutVal=0.9)))
    //WheelLatFrictionScale=1.0

    // Damage
    Health=1500
    HealthMax=1500.0
    DamagedEffectHealthFireFactor=0.9
    EngineHealth=20
    VehHitpoints(0)=(PointRadius=42.0,PointBone="ENGINE",bPenetrationPoint=false,DamageMultiplier=1.0,HitPointType=HP_Engine) // engine

    EngineDamageFromGrenadeModifier=0.15
    ImpactWorldDamageMult=1.0
    DirectHEImpactDamageMult=9.0
    DamagedEffectOffset=(X=130.0,Y=0.0,Z=80.0)
    DamagedEffectScale=1.0
    DestroyedVehicleMesh=StaticMesh'DH_DUKW_stc.DUKW_destroyed'

    // Vehicle destruction
    ExplosionDamage=50.0
    ExplosionRadius=100.0
    ExplosionSoundRadius=200.0
    DestructionLinearMomentum=(Min=50.0,Max=100.0)
    DestructionAngularMomentum=(Min=10.0,Max=50.0)

    // Exit
    ExitPositions(0)=(X=65.0,Y=-135.0,Z=60.0)       // Driver
    ExitPositions(1)=(X=65.0,Y=135.0,Z=60.0)        // Front passenger
    ExitPositions(2)=(X=-8.00,Y=135.00,Z=60.00)     // Right Passenger 01
    ExitPositions(3)=(X=-8.00,Y=-135.00,Z=60.00)    // Left Passenger 01

    WaterExitPositions(0)=(X=76.91966247558594,Y=-28.477802276611328,Z=153.4036407470703)
    WaterExitPositions(1)=(X=76.91966247558594,Y=22.614728927612305,Z=152.4199981689453)
    WaterExitPositions(2)=(X=0.4548492431640625,Y=34.716644287109375,Z=153.4036407470703)
    WaterExitPositions(3)=(X=0.4548492431640625,Y=-34.71664047241211,Z=153.4036407470703)
    WaterExitPositions(4)=(X=-59.236663818359375,Y=34.716644287109375,Z=153.4036407470703)
    WaterExitPositions(5)=(X=-59.236663818359375,Y=-34.71664047241211,Z=153.4036407470703)
    WaterExitPositions(6)=(X=-115.40373992919922,Y=34.716644287109375,Z=153.4036407470703)
    WaterExitPositions(7)=(X=-115.40373992919922,Y=-34.71664047241211,Z=153.4036407470703)
    WaterExitPositions(8)=(X=-170.43197631835938,Y=34.716644287109375,Z=153.4036407470703)
    WaterExitPositions(9)=(X=-170.43197631835938,Y=-34.71664047241211,Z=153.4036407470703)

    // Sounds
    SoundPitch=32.0
    MaxPitchSpeed=10.0 //150.0
    IdleSound=none
    StartUpSound=Sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_start'
    ShutDownSound=Sound'Vehicle_Engines.sdkfz251.sdkfz251_engine_stop'
    RumbleSound=Sound'Vehicle_Engines.tank_inside_rumble01'
    RumbleSoundBone="body"

    SteerBoneName="steering_wheel"
    SteerBoneAxis=AXIS_Z

    // HUD
    VehicleHudImage=Texture'DH_DUKW_tex.interface.DUKW_body_icon'
    VehicleHudEngineY=0.25
    VehicleHudOccupantsX(0)=0.45
    VehicleHudOccupantsY(0)=0.4
    VehicleHudOccupantsX(1)=0.55
    VehicleHudOccupantsY(1)=0.4

    VehicleHudOccupantsX(2)=0.56
    VehicleHudOccupantsY(2)=0.5125
    VehicleHudOccupantsX(3)=0.44
    VehicleHudOccupantsY(3)=0.5125

    VehicleHudOccupantsX(4)=0.56
    VehicleHudOccupantsY(4)=0.6
    VehicleHudOccupantsX(5)=0.44
    VehicleHudOccupantsY(5)=0.6

    VehicleHudOccupantsX(6)=0.56
    VehicleHudOccupantsY(6)=0.6875
    VehicleHudOccupantsX(7)=0.44
    VehicleHudOccupantsY(7)=0.6875

    VehicleHudOccupantsX(8)=0.56
    VehicleHudOccupantsY(8)=0.775
    VehicleHudOccupantsX(9)=0.44
    VehicleHudOccupantsY(9)=0.775

    SpawnOverlay(0)=Material'DH_DUKW_tex.interface.DUKW_icon'

    // Splashguard 
    CollisionAttachments(0)=(StaticMesh=StaticMesh'DH_DUKW_stc.DUKW_splash_collision',AttachBone="SPLASH_GUARD")

    VehicleComponentControllers(0)=(Channel=2,BoneName="SPLASH_GUARD",RaisingAnim="splash_guard_up",LoweringAnim="splash_guard_down")

    //================copypaste from gmc

    // Shadow
    ShadowZOffset=60.0

    // Wheels
    Begin Object Class=SVehicleWheel Name=FRWheel
        SteerType=VST_Steered
        BoneName="WHEEL_F_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=28
        SupportBoneName="SUSP_F_R"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(0)=FRWheel

    Begin Object Class=SVehicleWheel Name=FLWheel
        SteerType=VST_Steered
        BoneName="WHEEL_F_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=28
        SupportBoneName="SUSP_F_L"
        SupportBoneAxis=AXIS_X
        bLeftTrack=true
    End Object
    Wheels(1)=FLWheel

    Begin Object Class=SVehicleWheel Name=B1RWheel
        bPoweredWheel=true
        BoneName="WHEEL_B1_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=28
        SupportBoneName="SUSP_B1_R"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(2)=B1RWheel

    Begin Object Class=SVehicleWheel Name=B1LWheel
        bPoweredWheel=true
        BoneName="WHEEL_B1_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=28
        SupportBoneName="SUSP_B1_L"
        SupportBoneAxis=AXIS_X
        bLeftTrack=true
    End Object
    Wheels(3)=B1LWheel

    Begin Object Class=SVehicleWheel Name=B2RWheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="WHEEL_B2_R"
        BoneRollAxis=AXIS_Y
        WheelRadius=28
        SupportBoneName="SUSP_B2_R"
        SupportBoneAxis=AXIS_X
    End Object
    Wheels(4)=B2RWheel

    Begin Object Class=SVehicleWheel Name=B2LWheel
        bPoweredWheel=true
        bHandbrakeWheel=true
        BoneName="WHEEL_B2_L"
        BoneRollAxis=AXIS_Y
        WheelRadius=28
        SupportBoneName="SUSP_B2_L"
        SupportBoneAxis=AXIS_X
        bLeftTrack=true
    End Object
    Wheels(5)=B2LWheel

    // todo: figure this out
    // Karma
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.0
        KInertiaTensor(3)=3.0
        KInertiaTensor(5)=3.0
        KCOMOffset=(X=0.0,Y=0.0,Z=0.3)
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
    KParams=KParams0
}
