//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
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
            DestroyedAnimName = RampDownIdleAnim;
        }
    }
}

// Modified to handle binoculars overlay (same as in a vehicle weapon pawn)
simulated function DrawHUD(Canvas C)
{
    local PlayerController PC;
    local float            SavedOpacity, ScreenRatio;

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView)
    {
        // Draw binoculars overlay
        if (DriverPositions[DriverPositionIndex].bDrawOverlays && !IsInState('ViewTransition'))
        {
            SavedOpacity = C.ColorModulate.W;
            C.ColorModulate.W = 1.0;
            C.DrawColor.A = 255;
            C.Style = ERenderStyle.STY_Alpha;
            ScreenRatio = float(C.SizeY) / float(C.SizeX);
            C.SetPos(0.0, 0.0);

            C.DrawTile(BinocsOverlay, C.SizeX, C.SizeY,                         // screen drawing area (to fill screen)
                0.0, (1.0 - ScreenRatio) * float(BinocsOverlay.VSize) / 2.0,    // position in texture to begin drawing tile (from left edge, with vertical position to suit screen aspect ratio)
                BinocsOverlay.USize, float(BinocsOverlay.VSize) * ScreenRatio); // width & height of tile within texture

            C.ColorModulate.W = SavedOpacity; // reset HudOpacity to original value
        }

        // Draw vehicle & passenger list
        if (ROHud(PC.myHUD) != none)
        {
            ROHud(PC.myHUD).DrawVehicleIcon(C, self);
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
// Also to add Higgins boat hint instead of usual vehicle hints
simulated function ClientKDriverEnter(PlayerController PC)
{
    // Fix possible replication timing problems on a net client
    if (Role < ROLE_Authority && PC != none)
    {
        // Server passed the PC with this function, so we can safely set new Controller here, even though may take a little longer for new Controller value to replicate
        // And we know new Owner will also be the PC & new net Role will AutonomousProxy, so we can set those too, avoiding problems caused by variable replication delay
        // e.g. DrawHUD() can be called before Controller is replicated; SwitchMesh() may fail because new Role isn't received until later
        Controller = PC;
        SetOwner(PC);
        Role = ROLE_AutonomousProxy;

        // Fix for possible camera problem when deploying into spawn vehicle (see notes in DHVehicleMGPawn.ClientKDriverEnter)
        if (PC.IsInState('Spectating'))
        {
            PC.GotoState('PlayerWalking');
        }
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

// Modified to avoid adding vehicle momentum from the Super, as can kill or injure the driver & he's only stepping away from the controls, not actually jumping out
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
    DestroyedAnimName = RampUpIdleAnim;
}

simulated function RampDownIdle()
{
    LoopAnim(RampDownIdleAnim);
    DestroyedAnimName = RampDownIdleAnim;
}

// Matt: hack fix because of the way the Higgins boat has been modelled, which completely screws up the normal use of a collision static mesh in the animation mesh
// Boat is modelled with the wrong rotation & Z location, so in the animation mesh it is given 90 degrees yaw, a little pitch & a Z axis translation
// But the engine doesn't apply the rotation & translation to the col mesh, & also a col mesh doesn't move with the boat animation as it pitches & rolls
// As a workaround, I've taken the col mesh out of the anim mesh, & instead added it as a col mesh actor, attached to the relevant bone
// With a separate col mesh actor for the bow ramp, attached to ramp hinge bone so it lowers & raises with ramp, providing protection to players inside when raised
// TODO - adjust Higgins animation mesh to remove unwanted rotation & translation (incl re-make/adjust its animations) - then delete this override & add back normal col static mesh
simulated function SpawnVehicleAttachments()
{
    super.SpawnVehicleAttachments();

    // The ramp rotation gets screwed up, so simply set it correctly using a literal (from trial & error!) instead of complex calcs
    CollisionAttachments[0].Actor.SetRelativeRotation(rot(0, 0, 650));

    // Remove enough collision from the boat so it doesn't sink into the ground & it bumps into objects, but its crude collision boxes are ignored by projectiles
    // NB - can't just set in default props, as col meshes need to copy boat's intended collision settings when they spawn, so have to change these afterwards
    SetCollision(true, false); // bCollideActors true, but bBlockActors false
    bProjTarget = false;
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
    bIsApc=true
    bKeyVehicle=true // means we skip usual check for nearby friendly players before resetting empty vehicle & making it respawn
    InitialPositionIndex=1
    BinocPositionIndex=2
    bEngineOff=false
    bSavedEngineOff=false
    BinocsOverlay=texture'DH_VehicleOptics_tex.Allied.BINOC_overlay_7x50Allied'
    RampDownSound=sound'DH_AlliedVehicleSounds.higgins.HigginsRampOpen01'
    RampUpSound=sound'DH_AlliedVehicleSounds.higgins.HigginsRampClose01'
    RampSoundVolume=180.0
    RampUpIdleAnim="Ramp_idle_raised"
    RampDownIdleAnim="Ramp_idle_dropped"
    WashSound=sound'DH_AlliedVehicleSounds.higgins.wash01'
    VehicleAttachments(0)=(AttachBone="Box01") // attachment bone for wash sound attachment
    EngineSound=SoundGroup'DH_AlliedVehicleSounds.higgins.HigginsEngine_loop'
    EngineSoundBone="Engine"
    DestroyedAnimName="Ramp_idle_dropped"
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
    TorqueCurve=(Points=((OutVal=1.0),(InVal=200.0,OutVal=0.75),(InVal=1500.0,OutVal=10.0),(InVal=2200.0)))
    GearRatios(0)=-0.2
    GearRatios(1)=0.2
    GearRatios(2)=0.3
    GearRatios(3)=0.45
    GearRatios(4)=0.8
    TransRatio=0.1
    ChangeUpPoint=1990.0
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
    ExhaustPipes(0)=(ExhaustPosition=(X=-280.0,Y=-31.0,Z=99.0),ExhaustRotation=(Pitch=31000))
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_HigginsBoatMGPawn',WeaponBone="mg_base")
    PassengerPawns(0)=(AttachBone="passenger_L1",DrivePos=(X=0.0,Y=0.0,Z=20.0),DriveAnim="higgins_rider1_idle")
    PassengerPawns(1)=(AttachBone="passenger_L2",DrivePos=(X=0.0,Y=0.0,Z=20.0),DriveAnim="higgins_rider2_idle")
    PassengerPawns(2)=(AttachBone="passenger_L3",DrivePos=(X=0.0,Y=0.0,Z=20.0),DriveAnim="higgins_rider3_idle")
    PassengerPawns(3)=(AttachBone="passenger_R1",DrivePos=(X=0.0,Y=0.0,Z=20.0),DriveAnim="higgins_rider4_idle")
    PassengerPawns(4)=(AttachBone="passenger_R2",DrivePos=(X=0.0,Y=0.0,Z=20.0),DriveAnim="higgins_rider5_idle")
    PassengerPawns(5)=(AttachBone="passenger_R3",DrivePos=(X=0.0,Y=0.0,Z=20.0),DriveAnim="higgins_rider6_idle")
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
    VehHitpoints(0)=(PointRadius=50.0,PointBone="Master1z00",PointOffset=(X=-160.0,Z=60.0)) // engine
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
    VehicleNameString="Higgins Boat"
    MaxDesireability=1.9
    GroundSpeed=80.0
    WaterSpeed=80.0
    HealthMax=800.0
    Health=800
    Mesh=SkeletalMesh'DH_HigginsBoat_anm.HigginsBoat'
    Skins(0)=texture'DH_VehiclesUS_tex.ext_vehicles.HigginsBoat'
    CollisionAttachments(0)=(StaticMesh=StaticMesh'DH_allies_vehicles_stc.higgins.HigginsBoat_ramp_coll',AttachBone="Master2z00",Offset=(X=0.0,Y=-252.0,Z=-36.0)) // col mesh for bow ramp
    CollisionAttachments(1)=(StaticMesh=StaticMesh'DH_allies_vehicles_stc.higgins.HigginsBoat_coll',AttachBone="Master1z00",Offset=(X=0.0,Y=0.0,Z=0.01)) // col mesh for rest of the boat
    CollisionHeight=60.0
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.3
        KInertiaTensor(3)=4.0
        KInertiaTensor(5)=4.5
        KLinearDamping=0.05
        KAngularDamping=0.05
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
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.higgins'
}
