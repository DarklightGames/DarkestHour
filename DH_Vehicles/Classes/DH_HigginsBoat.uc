//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_HigginsBoat extends DHBoatVehicle;

#exec OBJ LOAD FILE=..\Animations\DH_HigginsBoat_anm.ukx
#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex.utx

var     texture     BinocsOverlay;
var     int         BinocPositionIndex;

var     sound       RampDownSound;
var     sound       RampUpSound;
var     float       RampSoundVolume;
var     name        RampUpIdleAnim; // effectively a replacement for BeginningIdleAnim, which is set to null (just easier that overriding functions to stop unwanted BeginningIdleAnim)
var     name        RampDownIdleAnim;

// Modified to loop either the ramp up or down idle animation on a net client (also set a matching destroyed vehicle animation)
// No benefit on a server as visuals aren't a factor, & in terms of collision the server & clients are going to out of synch whatever we do, so there's no point trying to match
simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    if (Role < ROLE_Authority)
    {
        if (DriverPositionIndex >= InitialPositionIndex)
        {
            LoopAnim(RampUpIdleAnim);
        }
        else
        {
            LoopAnim(RampDownIdleAnim);
            DestAnimName = RampDownIdleAnim;
        }
    }
}

// Modified to avoid resetting position indexes, as we need to keep the ramp in its current up/down position
function KDriverEnter(Pawn P)
{
    bDriverAlreadyEntered = true;
    Instigator = self;
    ResetTime = Level.TimeSeconds - 1.0;

    super(Vehicle).KDriverEnter(P);

    Driver.bSetPCRotOnPossess = false;
}

// Modified to set PPI to match DPI instead of usual InitialPositionIndex, because we enter in the position the boat has been left, i.e. ramp up or down
// Also to add Higgins boat hint
simulated function ClientKDriverEnter(PlayerController PC)
{
    // Fixes potential problem on net clients when deploying into a spawn vehicle (see notes in DHVehicleMGPawn.ClientKDriverEnter)
    if (Role < ROLE_Authority && PC != none && PC.IsInState('Spectating'))
    {
        PC.GotoState('PlayerWalking');
    }

    bDesiredBehindView = false;
    FPCamPos = default.FPCamPos;
    GotoState('EnteringVehicle');
    PendingPositionIndex = DriverPositionIndex;

    super(ROVehicle).ClientKDriverEnter(PC); // skip over Super in ROWheeledVehicle as it sets PPI to match IPI

    if (DHPlayer(PC) != none)
    {
        DHPlayer(PC).QueueHint(42, true);
    }
}

// Modified to to add ramp sounds // Matt: alternative would be to add these as notifies to the ramp animations
simulated state ViewTransition
{
    simulated function HandleTransition()
    {
        super.HandleTransition();

        if (DriverPositionIndex < InitialPositionIndex && PreviousPositionIndex == InitialPositionIndex)
        {
            PlayOwnedSound(RampDownSound, SLOT_Misc, RampSoundVolume / 255.0,, 150.0,, false);
        }
        else if (DriverPositionIndex == InitialPositionIndex && PreviousPositionIndex < DriverPositionIndex)
        {
            PlayOwnedSound(RampUpSound, SLOT_Misc, RampSoundVolume / 255.0,, 150.0,, false);
        }
    }
}

// Modified to avoid adding vehicle momentum from Super in DHWheeledVehicle, as can kill or injure the driver & he's only stepping away from the controls, not actually jumping out
function bool KDriverLeave(bool bForceLeave)
{
    return super(ROVehicle).KDriverLeave(bForceLeave);
}

// Modified to avoid resetting position indexes, as we need to keep the ramp in its current up/down position
// But if player was on the binoculars, we need to change the position indexes back to 1, so the next player in doesn't find himself with a drawn binocs overlay
function DriverLeft()
{
    if (DriverPositionIndex == BinocPositionIndex)
    {
        DriverPositionIndex = InitialPositionIndex;
        PreviousPositionIndex = InitialPositionIndex;
    }

    MaybeDestroyVehicle();
    DrivingStatusChanged();
}

// Called by notifies from the animation
simulated function RampUpIdle()
{
    LoopAnim(RampUpIdleAnim);
    DestAnimName = RampUpIdleAnim;
}

simulated function RampDownIdle()
{
    LoopAnim(RampDownIdleAnim);
    DestAnimName = RampDownIdleAnim;
}

// Modified to handle binoculars overlay
simulated function DrawHUD(Canvas C)
{
    local PlayerController PC;
    local float            SavedOpacity;

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView)
    {
        // Draw vehicle, turret, ammo count, passenger list
        if (ROHud(PC.myHUD) != none)
        {
            ROHud(PC.myHUD).DrawVehicleIcon(C, self);
        }

        // Draw binoculars overlay
        if (DriverPositions[DriverPositionIndex].bDrawOverlays && !IsInState('ViewTransition'))
        {
            SavedOpacity = C.ColorModulate.W;
            C.ColorModulate.W = 1.0;
            C.DrawColor.A = 255;
            C.Style = ERenderStyle.STY_Alpha;

            DrawBinocsOverlay(C);

            C.ColorModulate.W = SavedOpacity; // reset HudOpacity to original value
        }
    }
}

// New function, same as tank cannon pawn
simulated function DrawBinocsOverlay(Canvas C)
{
    local float ScreenRatio;

    ScreenRatio = float(C.SizeY) / float(C.SizeX);
    C.SetPos(0.0, 0.0);
    C.DrawTile(BinocsOverlay, C.SizeX, C.SizeY, 0.0 , (1.0 - ScreenRatio) * float(BinocsOverlay.VSize) / 2.0, BinocsOverlay.USize, float(BinocsOverlay.VSize) * ScreenRatio);
}

// Functions emptied as they relate to start/stop engine, which we don't allow in the Higgins boat:
function Fire(optional float F);

function ServerStartEngine();

// Functions emptied so we don't damage things we run into:
event RanInto(Actor Other);

function bool EncroachingOn(Actor Other)
{
    return false;
}

defaultproperties
{
    InitialPositionIndex=1
    BinocPositionIndex=2
    bEngineOff=false
    bSavedEngineOff=false
    BinocsOverlay=texture'DH_VehicleOptics_tex.Allied.BINOC_overlay_7x50Allied'
    RampDownSound=sound'DH_AlliedVehicleSounds.higgins.HigginsRampOpen01'
    RampUpSound=sound'DH_AlliedVehicleSounds.higgins.HigginsRampClose01'
    RampSoundVolume=180.0
    RampUpIdleAnim="Higgins-Idle"
    RampDownIdleAnim="Ramp_Idle"
    WashSound=sound'DH_AlliedVehicleSounds.higgins.wash01'
    WashSoundBoneL="Wash_L"
    WashSoundBoneR="Wash_R"
    EngineSound=SoundGroup'DH_AlliedVehicleSounds.higgins.HigginsEngine_loop'
    EngineSoundBone="Engine"
    DestAnimName="Higgins-Idle"
    DestAnimRate=1.0
    WheelSoftness=0.025
    WheelPenScale=1.2
    WheelPenOffset=0.01
    WheelRestitution=0.1
    WheelInertia=0.1
    WheelLongFrictionFunc=(Points=(,(InVal=100.0,OutVal=1.0),(InVal=200.0,OutVal=0.9),(InVal=10000000000.0,OutVal=0.9)))
    WheelLongSlip=0.001
    WheelLatSlipFunc=(Points=(,(InVal=30.0,OutVal=0.009),(InVal=45.0),(InVal=10000000000.0)))
    WheelLongFrictionScale=1.1
    WheelLatFrictionScale=1.55
    WheelHandbrakeSlip=0.01
    WheelHandbrakeFriction=0.1
    WheelSuspensionTravel=10.0
    WheelSuspensionMaxRenderTravel=5.0
    FTScale=0.03
    ChassisTorqueScale=0.095
    MinBrakeFriction=4.0
    MaxSteerAngleCurve=(Points=((OutVal=45.0),(InVal=300.0,OutVal=30.0),(InVal=500.0,OutVal=20.0),(InVal=600.0,OutVal=15.0),(InVal=1000000000.0,OutVal=10.0)))
    TorqueCurve=(Points=((OutVal=1.0),(InVal=200.0,OutVal=0.75),(InVal=1500.0,OutVal=2.0),(InVal=2200.0)))
    GearRatios(0)=-0.2
    GearRatios(1)=0.2
    GearRatios(2)=0.35
    GearRatios(3)=0.5
    GearRatios(4)=0.63
    TransRatio=0.09
    LSDFactor=1.0
    EngineBrakeFactor=0.0001
    EngineBrakeRPMScale=0.1
    MaxBrakeTorque=20.0
    SteerSpeed=20.0
    TurnDamping=50.0
    StopThreshold=100.0
    HandbrakeThresh=200.0
    EngineInertia=0.1
    SteerBoneName="Master3z00"
    RevMeterScale=4000.0
    ExhaustEffectClass=class'ROEffects.ExhaustDieselEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustDieselEffect_simple'
    ExhaustPipes(0)=(ExhaustPosition=(X=-270.0,Y=-30.0,Z=23.0),ExhaustRotation=(Pitch=31000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_HigginsBoatMGPawn',WeaponBone="mg_base")
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_HigginsPassengerOne',WeaponBone="passenger_L1")
    PassengerWeapons(2)=(WeaponPawnClass=class'DH_Vehicles.DH_HigginsPassengerTwo',WeaponBone="passenger_L2")
    PassengerWeapons(3)=(WeaponPawnClass=class'DH_Vehicles.DH_HigginsPassengerThree',WeaponBone="passenger_L3")
    PassengerWeapons(4)=(WeaponPawnClass=class'DH_Vehicles.DH_HigginsPassengerFour',WeaponBone="passenger_R1")
    PassengerWeapons(5)=(WeaponPawnClass=class'DH_Vehicles.DH_HigginsPassengerFive',WeaponBone="passenger_R2")
    PassengerWeapons(6)=(WeaponPawnClass=class'DH_Vehicles.DH_HigginsPassengerSix',WeaponBone="passenger_R3")
    IdleSound=sound'DH_AlliedVehicleSounds.HigginsIdle01'
    StartUpSound=sound'DH_AlliedVehicleSounds.higgins.HigginsStart01'
    ShutDownSound=sound'DH_AlliedVehicleSounds.higgins.HigginsStop01'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.higgins.HigginsBoat_destroyed'
    DamagedEffectOffset=(X=-170.0,Y=20.0,Z=50.0)
    VehicleTeam=1
    SteeringScaleFactor=2.0
    BeginningIdleAnim="" // easy way to stop unwanted BeginningIdleAnim being played in several functions without having to override them
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_HigginsBoat_anm.HigginsBoat',TransitionUpAnim="Ramp_Raise",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=32768,ViewNegativeYawLimit=-32768,bExposed=true,ViewFOV=90.0)
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_HigginsBoat_anm.HigginsBoat',TransitionDownAnim="Ramp_Drop",DriverTransitionAnim="stand_idlehip_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=32768,ViewNegativeYawLimit=-32768,bExposed=true,ViewFOV=90.0)
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_HigginsBoat_anm.HigginsBoat',DriverTransitionAnim="stand_idleiron_binoc",ViewPitchUpLimit=10000,ViewPitchDownLimit=60000,ViewPositiveYawLimit=32768,ViewNegativeYawLimit=-32768,bExposed=true,bDrawOverlays=true,ViewFOV=12.0)
    VehicleHudImage=texture'DH_InterfaceArt_tex.Tank_Hud.higgins_body'
    VehicleHudOccupantsX(0)=0.43
    VehicleHudOccupantsX(1)=0.57
    VehicleHudOccupantsX(2)=0.43
    VehicleHudOccupantsX(3)=0.43
    VehicleHudOccupantsX(4)=0.43
    VehicleHudOccupantsX(5)=0.57
    VehicleHudOccupantsX(6)=0.57
    VehicleHudOccupantsX(7)=0.57
    VehicleHudOccupantsY(0)=0.67
    VehicleHudOccupantsY(1)=0.67
    VehicleHudOccupantsY(3)=0.4
    VehicleHudOccupantsY(4)=0.5
    VehicleHudOccupantsY(5)=0.3
    VehicleHudOccupantsY(6)=0.4
    VehicleHudOccupantsY(7)=0.5
    VehicleHudEngineY=0.0
    VehHitpoints(0)=(PointRadius=50.0,PointBone="Master1z00",PointOffset=(X=-160.0,Z=60.0))
    bIsApc=true
    DriverAttachmentBone="driver_player"
    Begin Object Class=SVehicleWheel Name=LFWheel
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="wheel_LF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=-6.0)
        WheelRadius=30.0
    End Object
    Wheels(0)=SVehicleWheel'DH_Vehicles.DH_HigginsBoat.LFWheel'
    Begin Object Class=SVehicleWheel Name=RFWheel
        bPoweredWheel=true
        SteerType=VST_Steered
        BoneName="wheel_RF"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=-6.0)
        WheelRadius=30.0
    End Object
    Wheels(1)=SVehicleWheel'DH_Vehicles.DH_HigginsBoat.RFWheel'
    Begin Object Class=SVehicleWheel Name=LRWheel
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="wheel_LR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=-6.0)
        WheelRadius=30.0
    End Object
    Wheels(2)=SVehicleWheel'DH_Vehicles.DH_HigginsBoat.LRWheel'
    Begin Object Class=SVehicleWheel Name=RRWheel
        bPoweredWheel=true
        SteerType=VST_Inverted
        BoneName="wheel_RR"
        BoneRollAxis=AXIS_Y
        BoneOffset=(Z=-6.0)
        WheelRadius=30.0
    End Object
    Wheels(3)=SVehicleWheel'DH_Vehicles.DH_HigginsBoat.RRWheel'
    VehicleMass=6.0
    DrivePos=(Z=10.0)
    DriveAnim="stand_idlehip_satchel"
    ExitPositions(0)=(X=-30.0,Y=-38.0,Z=100.0)
    ExitPositions(1)=(X=-30.0,Y=38.0,Z=100.0)
    ExitPositions(2)=(X=185.0,Y=-38.0,Z=100.0)
    ExitPositions(3)=(X=115.0,Y=-38.0,Z=100.0)
    ExitPositions(4)=(X=45.0,Y=-38.0,Z=100.0)
    ExitPositions(5)=(X=185.0,Y=38.0,Z=100.0)
    ExitPositions(6)=(X=115.0,Y=38.0,Z=100.0)
    ExitPositions(7)=(X=45.0,Y=38.0,Z=100.0)
    EntryRadius=350.0
    DriverDamageMult=1.0
    VehicleNameString="Higgins Boat"
    MaxDesireability=1.9
    GroundSpeed=80.0
    WaterSpeed=80.0
    HealthMax=800.0
    Health=800
    Mesh=SkeletalMesh'DH_HigginsBoat_anm.HigginsBoat'
    Skins(0)=texture'DH_VehiclesUS_tex.ext_vehicles.HigginsBoat'
    DestroyedVehicleTexture=texture'DH_VehiclesUS_tex.Destroyed.HigginsBoat_dest'
    CollisionRadius=100.0
    CollisionHeight=60.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.3
        KInertiaTensor(3)=4.0
        KInertiaTensor(5)=4.5
        KLinearDamping=0.05
        KAngularDamping=0.05
        KBuoyancy=1.2
        KStartEnabled=true
        bKNonSphericalInertia=true
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=true
        bKStayUpright=true
        bKAllowRotate=true
        bDestroyOnWorldPenetrate=true
        bDoSafetime=true
        KFriction=0.5
        KImpactThreshold=850.0
    End Object
    KParams=KarmaParamsRBFull'DH_Vehicles.DH_HigginsBoat.KParams0'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=3
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.higgins'
}
