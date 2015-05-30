//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHWheeledVehicle extends ROWheeledVehicle
    abstract;

#exec OBJ LOAD FILE=..\Textures\DH_InterfaceArt_tex.utx

enum ECarHitPointType
{
    CHP_Normal,
    CHP_RFTire,
    CHP_RRTire,
    CHP_LFTire,
    CHP_LRTire,
    CHP_Petrol,
};

var     ECarHitPointType    CarHitPointType;

struct CarHitpoint
{
    var float             PointRadius;        // squared radius of the head of the pawn that is vulnerable to headshots
    var float             PointHeight;        // distance from base of neck to center of head - used for headshot calculation
    var float             PointScale;         // scale factor for radius & height
    var name              PointBone;          // bone to reference in offset
    var vector            PointOffset;        // amount to offset the hitpoint from the bone
    var bool              bPenetrationPoint;  // this is a penetration point, open hatch, etc
    var float             DamageMultiplier;   // amount to scale damage to the vehicle if this point is hit
    var ECarHitPointType  CarHitPointType;    // what type of hit point this is
};

var     array<CarHitpoint>  CarVehHitpoints;  // an array of possible small points that can be hit (index zero is always the driver)

// General
var     float       MinVehicleDamageModifier; // minimum damage modifier (from DamageType) needed to damage this vehicle
var     float       PointValue;               // used for scoring
var     bool        bEmittersOn;              // dust & exhaust effects are enabled
var     float       DriverTraceDistSquared;   // CheckReset() variable (changed to a squared value, as VSizeSquared is more efficient than VSize)
var     float       ObjectCollisionResistance;// vehicle's resistance to colliding with other actors - a higher value reduces damage more
var     float       ViewTransitionDuration;   // used to control the time we stay in state ViewTransition
var     bool        bPlayerCollisionBoxMoves; // driver's collision box moves with animations (e.g. raised/lowered on unbuttoning/buttoning), so we need to play anims on server
var     bool        bClientInitialized;       // clientside flag that replicated actor has completed initialization (set at end of PostNetBeginPlay)
                                              // (allows client code to determine whether actor is just being received through replication, e.g. in PostNetReceive)
// Obstacle crushing
var     bool        bCrushedAnObject;         // vehicle has just crushed something, causing temporary movement stall
var     float       LastCrushedTime;          // records time object was crushed, so we know when the movement stall should end
var     float       ObjectCrushStallTime;     // how long the movement stall lasts

// Engine
var     bool        bEngineOff;               // vehicle engine is simply switched off
var     bool        bSavedEngineOff;          // clientside record of current value, so PostNetReceive can tell if a new value has been replicated
var     float       IgnitionSwitchTime;       // records last time the engine was switched on/off - requires interval to stop people spamming the ignition switch
var     float       IgnitionSwitchInterval;   // how frequently the engine can be manually switched on/off

var     byte                SpawnVehicleType;
var     float               FriendlyResetDistance;

// New sounds & sound attachment actors
var     float               MaxPitchSpeed;
var     sound               EngineSound;
var     ROSoundAttachment   EngineSoundAttach;
var     name                EngineSoundBone;
var     sound               RumbleSound; // interior rumble sound
var     ROSoundAttachment   InteriorRumbleSoundAttach;
var     name                RumbleSoundBone;
var     sound               VehicleBurningSound;
var     sound               DestroyedBurningSound;
var     sound               DamagedStartUpSound;
var     float               LastBottomOutTime; // last time a bottom out sound was played

// Resupply attachments
var     class<RODummyAttachment>    ResupplyAttachmentClass;
var     RODummyAttachment           ResupplyAttachment;
var     name                        ResupplyAttachBone;
var     class<RODummyAttachment>    ResupplyDecoAttachmentClass;
var     RODummyAttachment           ResupplyDecoAttachment;
var     name                        ResupplyDecoAttachBone;

// Debugging
var     bool        bDebuggingText;
var     bool        bDebugExitPositions;

// Notifications
var     ObjectMap   NotifyParameters;

replication
{
    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        bEngineOff, SpawnVehicleType;
//      bEngineDead      // Matt: removed as I have deprecated it (EngineHealth <= 0 does the same thing)
//      EngineHealthMax  // Matt: removed as I have deprecated it (it never changed anyway & didn't need to be replicated)
//      bResupplyVehicle // Matt: removed as I have deprecated it (it never changed anyway & didn't need to be replicated)

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerStartEngine,
        ServerToggleDebugExits, ServerKillEngine; // these ones only during development
}

// Modified to spawn any sound or resuppply attachments & so net clients show unoccupied rider positions on the HUD vehicle icon
simulated function PostBeginPlay()
{
    super(Vehicle).PostBeginPlay(); // skip over Super in ROWheeledVehicle to avoid setting an initial timer, which we no longer use

    if (HasAnim(BeginningIdleAnim))
    {
        PlayAnim(BeginningIdleAnim);
    }

    if (Role == ROLE_Authority)
    {
        // Spawn the actual resupply actor - this is not the visual attachment, it's the real thing on the server
        if (ResupplyAttachmentClass != none && ResupplyAttachBone != '' && ResupplyAttachment == none)
        {
            ResupplyAttachment = Spawn(ResupplyAttachmentClass);
            AttachToBone(ResupplyAttachment, ResupplyAttachBone);
        }

        // For single player mode, we may as well set this here, as it's only intended to stop idiot players blowing up friendly vehicles in spawn
        if (Level.NetMode == NM_Standalone)
        {
            bDriverAlreadyEntered = true;
        }
    }
    else
    {
        // Matt: set this on a net client to work with our new rider pawn system, as rider pawns won't exist on client unless occupied
        // It forces client's WeaponPawns array to normal length, even though rider pawn slots may be empty - simply so we see all the grey rider position dots on HUD vehicle icon
        WeaponPawns.Length = PassengerWeapons.Length;
    }

    // Clientside sound & decorative attachments
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (EngineSound != none && EngineSoundBone != '' && EngineSoundAttach == none)
        {
            EngineSoundAttach = Spawn(class'ROSoundAttachment');
            EngineSoundAttach.AmbientSound = EngineSound;
            AttachToBone(EngineSoundAttach, EngineSoundBone);
        }

        if (RumbleSound != none && RumbleSoundBone != '' && InteriorRumbleSoundAttach == none)
        {
            InteriorRumbleSoundAttach = Spawn(class'ROSoundAttachment');
            InteriorRumbleSoundAttach.AmbientSound = RumbleSound;
            AttachToBone(InteriorRumbleSoundAttach, RumbleSoundBone);
        }

        if (ResupplyDecoAttachmentClass != none && ResupplyDecoAttachBone != '' && ResupplyDecoAttachment == none)
        {
            ResupplyDecoAttachment = Spawn(ResupplyDecoAttachmentClass);
            AttachToBone(ResupplyDecoAttachment, ResupplyDecoAttachBone);
        }

        NotifyParameters = new class'ObjectMap';
        NotifyParameters.Insert("VehicleClass", Class);
    }
}

// Modified to initialize engine-related properties & to set bClientInitialized flag
simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    SetEngine();

    if (Role < ROLE_Authority)
    {
        bClientInitialized = true;
    }
}

// Matt: modified to handle engine on/off (including dust/exhaust emitters), instead of constantly checking in Tick
simulated function PostNetReceive()
{
    // Driver has changed position
    if (DriverPositionIndex != SavedPositionIndex)
    {
        PreviousPositionIndex = SavedPositionIndex;
        SavedPositionIndex = DriverPositionIndex;
        NextViewPoint();
    }

    // Engine has been switched on or off (but if not bClientInitialized, then actor has just replicated & SetEngine() will get called in PostBeginPlay)
    if (bEngineOff != bSavedEngineOff && bClientInitialized)
    {
        bSavedEngineOff = bEngineOff;
        SetEngine();
    }
}

// New function to set up the engine properties
simulated function SetEngine()
{
    if (bEngineOff)
    {
        TurnDamping = 0.0;

        // If engine is dead then start a fire
        if (EngineHealth <= 0)
        {
            DamagedEffectHealthFireFactor = 1.0;
            DamagedEffectHealthSmokeFactor = 1.0; // appears necessary to get native code to spawn a DamagedEffect if it doesn't already exist
                                                  // (presumably doesn't check for fire unless vehicle is at least damaged enough to smoke)

            if (DamagedEffect == none && Health == HealthMax) // clientside Health hack to get native code to spawn DamagedEffect (it won't unless vehicle has taken some damage)
            {
                Health--;
            }

            AmbientSound = VehicleBurningSound;
            SoundVolume = 255;
            SoundRadius = 200.0;
        }
        else
        {
            AmbientSound = none;
        }

        if (bEmittersOn)
        {
            StopEmitters();
        }
    }
    else
    {
        if (IdleSound != none)
        {
            AmbientSound = IdleSound;
        }

        if (!bEmittersOn)
        {
            StartEmitters();
        }
    }
}

// Modified to avoid playing engine start sound when entering vehicle
function KDriverEnter(Pawn P)
{
    bDriverAlreadyEntered = true; // Matt: added here as a much simpler alternative to the Timer() in ROWheeledVehicle
    DriverPositionIndex = InitialPositionIndex;
    PreviousPositionIndex = InitialPositionIndex;
    Instigator = self;
    ResetTime = Level.TimeSeconds - 1.0;

    if (bEngineOff && !P.IsHumanControlled()) // lets bots start vehicle
    {
        ServerStartEngine();
    }

    super(Vehicle).KDriverEnter(P); // need to skip over Super from ROVehicle

    Driver.bSetPCRotOnPossess = false; // so when driver gets out he'll be facing the same direction as he was inside the vehicle
}

// Modified to add engine start/stop hint
simulated function ClientKDriverEnter(PlayerController PC)
{
    local DHPlayer P;

    P = DHPlayer(PC);

    if (P != none)
    {
        P.QueueHint(40, true);

        if (SpawnVehicleType != class'DHSpawnManager'.default.SVT_None)
        {
            P.QueueHint(14, true);

            if (SpawnVehicleType == class'DHSpawnManager'.default.SVT_EngineOff)
            {
                P.QueueHint(15, true);
            }

            P.QueueHint(16, true);
        }
    }

    super.ClientKDriverEnter(PC);
}

simulated function ClientKDriverLeave(PlayerController PC)
{
    if (SpawnVehicleType == class'DHSpawnManager'.default.SVT_EngineOff && !bEngineOff && DHPlayer(PC) != none)
    {
        DHPlayer(PC).QueueHint(17, true);
    }

    super.ClientKDriverLeave(PC);
}

// Modified to use InitialPositionIndex & to play BeginningIdleAnim on internal mesh when entering vehicle
simulated state EnteringVehicle
{
    simulated function HandleEnter()
    {
        if (DriverPositions[InitialPositionIndex].PositionMesh != none)
        {
            LinkMesh(DriverPositions[InitialPositionIndex].PositionMesh);
        }

        if (HasAnim(BeginningIdleAnim))
        {
            PlayAnim(BeginningIdleAnim); // shouldn't actually be necessary, but a reasonable fail-safe
        }

        if (IsHumanControlled())
        {
            PlayerController(Controller).SetFOV(DriverPositions[InitialPositionIndex].ViewFOV);
        }
    }
}

// Modified to prevent entry if player is on fire
function bool TryToDrive(Pawn P)
{
    local int i;

    if (bDebuggingText && P != none)
    {
        P.ClientMessage("Vehicle Health:" @ Health $ ", EngineHealth:" @ EngineHealth);
    }

    // Trying to enter a vehicle that isn't on our team
    if (P != none && P.GetTeamNum() != VehicleTeam)
    {
        // Deny entry to TeamLocked enemy vehicle
        if (bTeamLocked)
        {
            DenyEntry(P, 1); // can't use enemy vehicle

            return false;
        }

        // Don't allow non-TeamLocked vehicle to be stolen if it already has an enemy occupant
        if (Driver != none && P.GetTeamNum() != Driver.GetTeamNum())
        {
            DenyEntry(P, 1); // can't use enemy vehicle

            return false;
        }

        for (i = 0; i < WeaponPawns.Length; ++i)
        {
            if (WeaponPawns[i].Driver != none && P.GetTeamNum() != WeaponPawns[i].Driver.GetTeamNum())
            {
                DenyEntry(P, 1); // can't use enemy vehicle

                return false;
            }
        }
    }

    // Deny entry if vehicle has driver or is dead, or if player is crouching or on fire or reloading a weapon (plus several very obscure other reasons)
    if (Driver != none ||
        Health <= 0 ||
        P == none ||
        (DHPawn(P) != none && DHPawn(P).bOnFire) ||
        (P.Weapon != none && P.Weapon.IsInState('Reloading')) ||
        P.Controller == none ||
        !P.Controller.bIsPlayer ||
        P.DrivenVehicle != none ||
        P.IsA('Vehicle') ||
        bNonHumanControl ||
        !Level.Game.CanEnterVehicle(self, P))
    {
        return false;
    }

    // Deny entry if vehicle can only be used by tank crew & player is not a tanker role
    if (bMustBeTankCommander && (ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo) == none || ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo == none
        || !ROPlayerReplicationInfo(P.Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew) && P.IsHumanControlled())
    {
       DenyEntry(P, 0); // not qualified to operate vehicle

       return false;
    }

    // Passed all checks, so allow player to enter the vehicle
    if (bEnterringUnlocks && bTeamLocked)
    {
        bTeamLocked = false;
    }

    KDriverEnter(P);

    return true;
}

simulated function Tick(float dt)
{
    local bool  LostTraction;
    local float MySpeed, MotionSoundVolume, ThrottlePosition;
    local int   i;

    super(ROVehicle).Tick(dt); // Matt: skip over the Super in ROWheeledVehicle, as it is already entirely re-stated her, so just duplicates everything

    // Pack the throttle setting into a byte to replicate it
    if (Role == ROLE_Authority)
    {
        if (Throttle < 0.0)
        {
            ThrottleRep = (100.0 * Abs(Throttle));
        }
        else
        {
            ThrottleRep = 101 + (100.0 * Throttle);
        }
    }

    // Don't bother doing effects on dedicated server
    if (Level.NetMode != NM_DedicatedServer)
    {
        MySpeed = Abs(ForwardVel);

        // Update engine & interior rumble sounds dependent on speed
        if (MySpeed > 0.1)
        {
            MotionSoundVolume = FClamp(MySpeed / MaxPitchSpeed * 255.0, 0.0, 255.0);
        }

        UpdateMovementSound(MotionSoundVolume);

        if (!bDropDetail)
        {
            LostTraction = true;

            // Update dust kicked up by wheels
            for (i = 0; i < Dust.Length; ++i)
            {
                Dust[i].UpdateDust(Wheels[i], DustSlipRate, DustSlipThresh);
            }

            // Unpack the replicated throttle byte
            if (ThrottleRep < 101)
            {
                ThrottlePosition = Float(ThrottleRep) / 100.0;
            }
            else if (ThrottleRep == 101)
            {
                ThrottlePosition = 0.0;
            }
            else
            {
                ThrottlePosition = Float(ThrottleRep - 101) / 100.0;
            }

            for (i = 0; i < ExhaustPipes.Length; ++i)
            {
                if (ExhaustPipes[i].ExhaustEffect != none)
                {
                    ExhaustPipes[i].ExhaustEffect.UpdateExhaust(ThrottlePosition);
                }
            }
        }
    }

    TurnDamping = default.TurnDamping;

    // Lets make the vehicle not slide when its parked
    if (Abs(ForwardVel) < 50.0)
    {
        MinBrakeFriction = LowSpeedBrakeFriction;
    }
    else
    {
        MinBrakeFriction = Default.MinBrakeFriction;
    }

    // If we crushed an object, apply break and clamp throttle (server only)
    if (bCrushedAnObject)
    {
        if (Controller.IsA('ROPlayer'))
        {
            ROPlayer(Controller).bPressedJump = true;
        }

        Throttle = FClamp(Throttle, -0.1, 0.1);

        // if our crush stall time is over, we are no longer crushing
        if (LastCrushedTime + ObjectCrushStallTime < Level.TimeSeconds)
        {
            bCrushedAnObject = false;
        }
    }

    if (bEngineOff)
    {
        Velocity = vect(0.0, 0.0, 0.0);
        Throttle = 0.0;
        ThrottleAmount = 0.0;
        Steering = 0.0;
    }
}

// Matt: drops all RO stuff about bDriverAlreadyEntered, bDisableThrottle & CheckForCrew, as in DH we don't wait for crew anyway - so just set bDriverAlreadyEntered in KDriverEnter()
function Timer()
{
    // Check to see if we need to destroy a spiked, abandoned vehicle
    if (bSpikedVehicle)
    {
        if (Health > 0 && IsVehicleEmpty())
        {
            KilledBy(self);
        }
        else
        {
            bSpikedVehicle = false; // cancel spike timer if vehicle is now occupied or destroyed
        }
    }
}

// New function to update movement sound volumes, similar to a tracked vehicle updating its tread sounds
// Although here we optimise by incorporating MotionSoundVolume as a passed function argument instead of a separate instance variable
simulated function UpdateMovementSound(float MotionSoundVolume)
{
    if (EngineSoundAttach != none)
    {
        EngineSoundAttach.SoundVolume = MotionSoundVolume * 0.75;
    }

    if (InteriorRumbleSoundAttach != none)
    {
        InteriorRumbleSoundAttach.SoundVolume = MotionSoundVolume * 2.5;
    }
}

// Modified to avoid starting exhaust & dust effects just because we got in - now we need to wait until the engine is started
// Also to play idle animation for other net clients (not just owning client), so we reset visuals like hatches
// And to avoid unnecessary stuff on dedicated server & the call to Super in Vehicle class (it only duplicates)
simulated event DrivingStatusChanged()
{
    local PlayerController PC;

    if (Level.NetMode != NM_DedicatedServer)
    {
        // Player has exited
        if (!bDriving)
        {
            // Vehicle will now stop, so no motion sound
            UpdateMovementSound(0.0);

            // Play neutral idle animation
            if (HasAnim(BeginningIdleAnim))
            {
                PlayAnim(BeginningIdleAnim);
            }
        }

        PC = Level.GetLocalPlayerController();

        // Update bDropDetail, which if true will avoid dust & exhaust emitters as unnecessary detail
        bDropDetail = bDriving && PC != none && (PC.ViewTarget == none || !PC.ViewTarget.IsJoinedTo(self)) && (Level.bDropDetail || Level.DetailMode == DM_Low);
    }

    if (bDriving)
    {
        Enable('Tick');
    }
    else
    {
        Disable('Tick');
    }
}

// Modified to use fire button to start or stop engine
simulated function Fire(optional float F)
{
    // Clientside checks to prevent unnecessary replicated function call to server if invalid (including clientside time check)
    if (Throttle == 0.0)
    {
        ServerStartEngine();
    }
}

// Emptied out to prevent unnecessary replicated function calls to server - vehicles don't use AltFire
function AltFire(optional float F)
{
}

// New function to kill exhaust & wheel dust emitters
simulated function StopEmitters()
{
    local int i;

    if (Level.NetMode != NM_DedicatedServer && !bDropDetail)
    {
        for (i = 0; i < Dust.Length; ++i)
        {
            if (Dust[i] != none)
            {
                Dust[i].Kill();
            }
        }

        Dust.Length = 0;

        for (i = 0; i < ExhaustPipes.Length; ++i)
        {
            if (ExhaustPipes[i].ExhaustEffect != none)
            {
                ExhaustPipes[i].ExhaustEffect.Kill();
            }
        }
    }

    bEmittersOn = false;
}

// New function to spawn exhaust & wheel dust emitters
simulated function StartEmitters()
{
    local int    i;
    local coords WheelCoords;

    if (Level.NetMode != NM_DedicatedServer && !bDropDetail)
    {
        Dust.Length = Wheels.Length;

        for (i = 0; i < Wheels.Length; ++i)
        {
            if (Dust[i] != none)
            {
                Dust[i].Destroy();
            }

            // Create wheel dust emitters
            WheelCoords = GetBoneCoords(Wheels[i].BoneName);
            Dust[i] = Spawn(class'VehicleWheelDustEffect', self,, WheelCoords.Origin + ((vect(0.0, 0.0, -1.0) * Wheels[i].WheelRadius) >> Rotation));

            if (Level.bDropDetail || Level.DetailMode == DM_Low)
            {
                Dust[i].MaxSpritePPS = 3;
                Dust[i].MaxMeshPPS = 3;
            }

            Dust[i].SetBase(self);
            Dust[i].SetDirtColor(Level.DustColor);
        }

        for (i = 0; i < ExhaustPipes.Length; ++i)
        {
            if (ExhaustPipes[i].ExhaustEffect != none)
            {
                ExhaustPipes[i].ExhaustEffect.Destroy();
            }

            // Create exhaust emitters
            if (Level.bDropDetail || Level.DetailMode == DM_Low)
            {
                ExhaustPipes[i].ExhaustEffect = Spawn(ExhaustEffectLowClass, self,, Location + (ExhaustPipes[i].ExhaustPosition >> Rotation), ExhaustPipes[i].ExhaustRotation + Rotation);
            }
            else
            {
                ExhaustPipes[i].ExhaustEffect = Spawn(ExhaustEffectClass, self,, Location + (ExhaustPipes[i].ExhaustPosition >> Rotation), ExhaustPipes[i].ExhaustRotation + Rotation);
            }

            ExhaustPipes[i].ExhaustEffect.SetBase(self);

            if (!bDriving) // if bDriving, Tick will be enabled & ExhaustEffect will get updated anyway, based on vehicle speed
            {
                ExhaustPipes[i].ExhaustEffect.UpdateExhaust(0.0); // nil update just sets the lowest setting for an idling engine
            }
        }

        bEmittersOn = true;
    }
}

// Server side function called to switch engine on/off
function ServerStartEngine()
{
    local DHGameReplicationInfo GRI;

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    // Throttle must be zeroed & also a time check so people can't spam the ignition switch
    if (Throttle == 0.0 && (Level.TimeSeconds - IgnitionSwitchTime) > default.IgnitionSwitchInterval)
    {
        IgnitionSwitchTime = Level.TimeSeconds;

        if (EngineHealth > 0)
        {
            bEngineOff = !bEngineOff;

            SetEngine();

            if (bEngineOff)
            {
                if (ShutDownSound != none)
                {
                    PlaySound(ShutDownSound, SLOT_None, 1.0);
                }
            }
            else if (StartUpSound != none)
            {
                PlaySound(StartUpSound, SLOT_None, 1.0);
            }

            if (GRI != none && SpawnVehicleType == class'DHSpawnManager'.default.SVT_EngineOff)
            {
                if (bEngineOff)
                {
                    GRI.AddSpawnVehicle(self);
                }
                else
                {
                    GRI.RemoveSpawnVehicle(self);
                }
            }
        }
        else
        {
            PlaySound(DamagedStartUpSound, SLOT_None, 2.0);
        }
    }
}

// Modified to give players the same momentum as the vehicle when exiting
// Also to remove overlap with DriverDied(), moving common features into DriverLeft(), which gets called by both functions
function bool KDriverLeave(bool bForceLeave)
{
    local vector ExitVelocity;

    if (!bForceLeave)
    {
        ExitVelocity = Velocity;
        ExitVelocity.Z += 60.0; // add a little height kick to allow for hacked in damage system
    }

    if (super(ROVehicle).KDriverLeave(bForceLeave))
    {
        if (!bForceLeave)
        {
            Instigator.Velocity = ExitVelocity;
        }

        return true;
    }

    return false;
}

// Modified to remove overlap with KDriverLeave(), moving common features into DriverLeft(), which gets called by both functions
function DriverDied()
{
    super(ROVehicle).DriverDied();
}

// Modified to avoid playing engine shut down sound when leaving vehicle & also to use IdleTimeBeforeReset
// Also to add common features from KDriverLeave() & DriverLeft(), which both call this function
function DriverLeft()
{
    DriverPositionIndex = InitialPositionIndex;
    PreviousPositionIndex = InitialPositionIndex;
    MaybeDestroyVehicle();
    DrivingStatusChanged(); // the Super from Vehicle, as we need to skip over Super in ROVehicle
}

// Modified to include setting ResetTime for an empty vehicle away from its spawn (moved from DriverLeft)
function MaybeDestroyVehicle()
{
    if (!bNeverReset && IsVehicleEmpty())
    {
        if (IsDisabled())
        {
            bSpikedVehicle = true;
            SetTimer(VehicleSpikeTime, false);

            if (bDebuggingText)
            {
                Level.Game.Broadcast(self, "Initiating" @ VehicleSpikeTime @ "sec spike timer for disabled vehicle" @ Tag);
            }
        }

        // If vehicle is now empty & some way from its spawn point (> 83m or out of sight), set a time for CheckReset() to maybe re-spawn the vehicle after a certain period
        // Changed from VSize > 5000 to VSizeSquared > 25000000, as is more efficient processing & does same thing
        if (ParentFactory != none && (VSizeSquared(Location - ParentFactory.Location) > 25000000.0 || !FastTrace(ParentFactory.Location, Location)))
        {
            ResetTime = Level.TimeSeconds + IdleTimeBeforeReset;
        }
    }
}

// Modified to use new, simplified system with exit positions for all vehicle positions included in the vehicle class default properties
function bool PlaceExitingDriver()
{
    local int    i;
    local vector Extent, HitLocation, HitNormal, ZOffset, ExitPosition;

    if (Driver == none)
    {
        return false;
    }

    Extent = Driver.default.CollisionRadius * vect(1.0, 1.0, 0.0);
    Extent.Z = Driver.default.CollisionHeight;
    ZOffset = Driver.default.CollisionHeight * vect(0.0, 0.0, 0.5);

    // Debug exits - uses DHWheeledVehicle class default, allowing bDebugExitPositions to be toggled for all DHWheeledVehicles
    if (class'DHWheeledVehicle'.default.bDebugExitPositions)
    {
        for (i = 0; i < ExitPositions.Length; ++i)
        {
            ExitPosition = Location + (ExitPositions[i] >> Rotation) + ZOffset;

            Spawn(class'DHDebugTracer',,, ExitPosition);
        }
    }

    for (i = 0; i < ExitPositions.Length; ++i)
    {
        ExitPosition = Location + (ExitPositions[i] >> Rotation) + ZOffset;

        if (Trace(HitLocation, HitNormal, ExitPosition, Location + ZOffset, false, Extent) != none ||
            Trace(HitLocation, HitNormal, ExitPosition, ExitPosition + ZOffset, false, Extent) != none)
        {
            continue;
        }

        if (Driver.SetLocation(ExitPosition))
        {
            return true;
        }
    }

    return false;
}

// Slightly modified to add randomised damage but mainly to tidy & standardise with TakeDamage in other vehicle classes
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    local Controller InstigatorController;
    local float      VehicleDamageMod, HitCheckDistance;
    local int        InstigatorTeam, PossibleDriverDamage, i;

    // Fix for suicide death messages
    if (DamageType == class'Suicided')
    {
        DamageType = class'ROSuicided';
        ROVehicleWeaponPawn(Owner).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
    }
    else if (DamageType == class'ROSuicided')
    {
        ROVehicleWeaponPawn(Owner).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
    }

    // Quick fix for the thing giving itself impact damage
    if (InstigatedBy == self)
    {
        return;
    }

    // Don't allow your own teammates to destroy vehicles in spawns (and you know some jerks would get off on doing that to their team :))
    if (!bDriverAlreadyEntered)
    {
        if (InstigatedBy != none)
        {
            InstigatorController = InstigatedBy.Controller;
        }

        if (InstigatorController == none && DamageType.default.bDelayedDamage)
        {
            InstigatorController = DelayedDamageInstigatorController;
        }

        if (InstigatorController != none)
        {
            InstigatorTeam = InstigatorController.GetTeamNum();

            if (GetTeamNum() != 255 && InstigatorTeam != 255 && GetTeamNum() == InstigatorTeam)
            {
                return;
            }
        }
    }

    // Set damage modifier from the DamageType, based on type of vehicle
    if (class<ROWeaponDamageType>(DamageType) != none)
    {
        if (bIsApc)
        {
            VehicleDamageMod = class<ROWeaponDamageType>(DamageType).default.APCDamageModifier;
        }
        else
        {
            VehicleDamageMod = class<ROWeaponDamageType>(DamageType).default.VehicleDamageModifier;
        }
    }
    else if (class<ROVehicleDamageType>(DamageType) != none)
    {
        if (bIsApc)
        {
            VehicleDamageMod = class<ROVehicleDamageType>(DamageType).default.APCDamageModifier;
        }
        else
        {
            VehicleDamageMod = class<ROVehicleDamageType>(DamageType).default.VehicleDamageModifier;
        }
    }

    // No damage, except possibly to driver, if less than MinVehicleDamageModifier for this vehicle
    if (VehicleDamageMod < MinVehicleDamageModifier)
    {
        VehicleDamageMod = 0.0;
    }

    // Add in the DamageType's vehicle damage modifier & a little damage randomisation
    Damage *= RandRange(0.75, 1.08);
    PossibleDriverDamage = Damage; // saved in case we need to damage driver, as VehicleDamageMod isn't relevant to driver
    Damage *= VehicleDamageMod;

    // Check RO VehHitPoints (driver, engine, ammo)
    for (i = 0; i < VehHitpoints.Length; ++i)
    {
        // Series of checks to see if we hit the vehicle driver
        if (VehHitpoints[i].HitPointType == HP_Driver)
        {
            if (Driver != none && DriverPositions[DriverPositionIndex].bExposed)
            {
                // Lower-powered rounds have a limited HitCheckDistance, as they won't rip through the vehicle
                // For more powerful rounds, HitCheckDistance will remain default zero, meaning no limit on check distance in IsPointShot()
                if (VehicleDamageMod <= 0.25)
                {
                    HitCheckDistance = DriverHitCheckDist;
                }

                if (IsPointShot(Hitlocation,Momentum, 1.0, i, HitCheckDistance))
                {
                    Driver.TakeDamage(PossibleDriverDamage, InstigatedBy, Hitlocation, Momentum, DamageType);
                }
            }
        }
        else if (IsPointShot(Hitlocation, Momentum, 1.0, i))
        {
            // Engine hit
            if (VehHitpoints[i].HitPointType == HP_Engine)
            {
                if (bDebuggingText)
                {
                    Level.Game.Broadcast(self, "Hit vehicle engine");
                }

                DamageEngine(Damage, InstigatedBy, Hitlocation, Momentum, DamageType);
            }
            // Hit ammo store - explodes & vehicle is destroyed
            else if (VehHitpoints[i].HitPointType == HP_AmmoStore)
            {
                if (bDebuggingText)
                {
                    Level.Game.Broadcast(self, "Hit vehicle ammo store - exploded");
                }

                Damage *= Health;
                break;
            }
        }
    }

    // Call the Super from Vehicle (skip over others)
    super(Vehicle).TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, DamageType);
}

// Modified so if we hit a vehicle we use its velocity to calculate damage, & also to factor in an ObjectCollisionResistance for this vehicle
event TakeImpactDamage(float AccelMag)
{
    local int Damage;

    if (Vehicle(ImpactInfo.Other) != none) // collided with another vehicle
    {
        Damage = Int(VSize(ImpactInfo.Other.Velocity) * 20.0 * ImpactDamageModifier());
        TakeDamage(Damage, Vehicle(ImpactInfo.Other), ImpactInfo.Pos, vect(0.0, 0.0, 0.0), class'DHVehicleCollisionDamageType');
    }
    else // collided with something else
    {
        Damage = Int(AccelMag * ImpactDamageModifier() / ObjectCollisionResistance);
        TakeDamage(Damage, self, ImpactInfo.Pos, vect(0.0, 0.0, 0.0), class'DHVehicleCollisionDamageType');
    }

    // Play bottom out sound (modified to not play across level, lowered volume, and limit sound occurrence to every second)
    if (ImpactDamageSounds.Length > 0 && Level.TimeSeconds - LastBottomOutTime > 1.0)
    {
        PlaySound(ImpactDamageSounds[Rand(ImpactDamageSounds.Length - 1)], SLOT_None, TransientSoundVolume * 2.5, false, 120,, true);
        LastBottomOutTime = Level.TimeSeconds;
    }

    if (Health < 0 && (Level.TimeSeconds - LastImpactExplosionTime) > TimeBetweenImpactExplosions)
    {
        VehicleExplosion(Normal(ImpactInfo.ImpactNorm), 0.5);
        LastImpactExplosionTime = Level.TimeSeconds;
    }
}

// Modified to randomise explosion damage (except for resupply vehicles) & to add DestroyedBurningSound
function VehicleExplosion(vector MomentumNormal, float PercentMomentum)
{
    local vector LinearImpulse, AngularImpulse;
    local float  RandomExplModifier;

    RandomExplModifier = FRand();

    if (ResupplyAttachment != none)
    {
        HurtRadius(ExplosionDamage, ExplosionRadius, ExplosionDamageType, ExplosionMomentum, Location);
    }
    else
    {
        HurtRadius(ExplosionDamage * RandomExplModifier, ExplosionRadius * RandomExplModifier, ExplosionDamageType, ExplosionMomentum, Location);
    }

    AmbientSound = DestroyedBurningSound;
    SoundVolume = 255.0;
    SoundRadius = 600.0;

    if (!bDisintegrateVehicle)
    {
        ExplosionCount++;

        if (Level.NetMode != NM_DedicatedServer)
        {
            ClientVehicleExplosion(false);
        }

        LinearImpulse = PercentMomentum * RandRange(DestructionLinearMomentum.Min, DestructionLinearMomentum.Max) * MomentumNormal;
        AngularImpulse = PercentMomentum * RandRange(DestructionAngularMomentum.Min, DestructionAngularMomentum.Max) * VRand();

        NetUpdateTime = Level.TimeSeconds - 1.0;
        KAddImpulse(LinearImpulse, vect(0.0, 0.0, 0.0));
        KAddAngularImpulse(AngularImpulse);
    }
}

// Modified to kill engine if zero health
function DamageEngine(int Damage, Pawn InstigatedBy, vector Hitlocation, vector Momentum, class<DamageType> DamageType)
{
    if (EngineHealth > 0)
    {
        Damage = Level.Game.ReduceDamage(Damage, self, InstigatedBy, HitLocation, Momentum, DamageType);
        EngineHealth -= Damage;
    }

    // Heavy damage to engine slows vehicle way down // Matt: won't have any effect setting this here - will move elsewhere later
    if (EngineHealth <= (default.EngineHealth * 0.25) && EngineHealth > 0)
    {
        Throttle = FClamp(Throttle, -0.5, 0.5);
    }
    // Kill the engine if its health has now fallen to zero
    else if (EngineHealth <= 0)
    {
        if (bDebuggingText)
        {
            Level.Game.Broadcast(self, "Engine is dead");
        }

        bEngineOff = true;
        SetEngine();
    }
}

// Modified to use DriverTraceDistSquared instead of literal values (& add debug)
event CheckReset()
{
    local Pawn P;

    // Vehicle occupied, so reset ResetTime
    if (!IsVehicleEmpty())
    {
        ResetTime = Level.TimeSeconds + IdleTimeBeforeReset;

        return;
    }
    // Vehicle empty & is a bKeyVehicle, so destroy it now to make it respawn
    else if (bKeyVehicle)
    {
        Died(none, class'DamageType', Location);

        return;
    }

    // Check for friendlies nearby
    foreach CollidingActors(class'Pawn', P, FriendlyResetDistance)
    {
        if (P != self && P.Controller != none && P.GetTeamNum() == GetTeamNum()) // traces only work on friendly players nearby
        {
            if (ROPawn(P) != none && (VSizeSquared(P.Location - Location) < DriverTraceDistSquared)) // Matt: changed so compare squared values, as VSizeSquared is more efficient
            {
                if (bDebuggingText)
                {
                    Level.Game.Broadcast(self, Tag @ "is empty vehicle, but set new ResetTime as found friendly player nearby");
                }

                ResetTime = Level.TimeSeconds + IdleTimeBeforeReset;

                return;
            }
            else if (FastTrace(P.Location + P.CollisionHeight * vect(0.0, 0.0, 1.0), Location + CollisionHeight * vect(0.0, 0.0, 1.0)))
            {
                if (bDebuggingText)
                {
                    Level.Game.Broadcast(self, Tag @ "is empty vehicle, but set new ResetTime as found friendly pawn nearby");
                }

                ResetTime = Level.TimeSeconds + IdleTimeBeforeReset;

                return;
            }
        }
    }

    // If factory is active, we want it to spawn new vehicle NOW
    if (ParentFactory != none)
    {
        if (bDebuggingText)
        {
            Level.Game.Broadcast(self, Tag @ "is empty vehicle & re-spawned as no friendly player nearby");
        }

        ParentFactory.VehicleDestroyed(self);
        ParentFactory.Timer();
        ParentFactory = none; // so doesn't call ParentFactory.VehicleDestroyed() again in Destroyed()
    }

    Destroy();
}

// Modified to avoid "accessed none" errors
function bool IsVehicleEmpty()
{
    local int i;

    if (Driver != none)
    {
        return false;
    }

    for (i = 0; i < WeaponPawns.Length; ++i)
    {
        if (WeaponPawns[i] != none && WeaponPawns[i].Driver != none)
        {
            return false;
        }
    }

    return true;
}

// Modified to score the vehicle kill
function Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
    super.Died(Killer, DamageType, HitLocation);

    if (Killer != none)
    {
        DarkestHourGame(Level.Game).ScoreVehicleKill(Killer, self, PointValue);
    }
}

// Modified to destroy extra attachments & effects
simulated event DestroyAppearance()
{
    super.DestroyAppearance();

    Disable('Tick'); // otherwise Tick spams "accessed none" errors for Left/RightTreadPanner & it's inconvenient to check != none in Tick
    DestroyAttachments();
}

// Modified to destroy extra effects & attachments
simulated function Destroyed()
{
    super.Destroyed();

    DestroyAttachments();
}

// New function to destroy effects & attachments when the vehicle gets destroyed
simulated function DestroyAttachments()
{
    if (ResupplyAttachment != none && Role == ROLE_Authority)
    {
        ResupplyAttachment.Destroy();
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (EngineSoundAttach != none)
        {
            EngineSoundAttach.Destroy();
        }

        if (InteriorRumbleSoundAttach != none)
        {
            InteriorRumbleSoundAttach.Destroy();
        }

        if (ResupplyDecoAttachment != none)
        {
            ResupplyDecoAttachment.Destroy();
        }

        if (bEmittersOn)
        {
            StopEmitters();
        }
    }
}

// Matt: modified to avoid wasting network resources by calling ServerChangeViewPoint on the server when it isn't valid
simulated function NextWeapon()
{
    if (DriverPositionIndex < DriverPositions.Length - 1 && DriverPositionIndex == PendingPositionIndex && !IsInState('ViewTransition') && bMultiPosition)
    {
        PendingPositionIndex = DriverPositionIndex + 1;
        ServerChangeViewPoint(true);
    }
}

simulated function PrevWeapon()
{
    if (DriverPositionIndex > 0 && DriverPositionIndex == PendingPositionIndex && !IsInState('ViewTransition') && bMultiPosition)
    {
        PendingPositionIndex = DriverPositionIndex -1;
        ServerChangeViewPoint(false);
    }
}

// Modified so if player has moving collision box, server goes to state ViewTransition just to play animations
function ServerChangeViewPoint(bool bForward)
{
    if (bForward)
    {
        if (DriverPositionIndex < (DriverPositions.Length - 1))
        {
            PreviousPositionIndex = DriverPositionIndex;
            DriverPositionIndex++;

            if (Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer)
            {
                NextViewPoint();
            }
            else if (bPlayerCollisionBoxMoves && Level.NetMode == NM_DedicatedServer)
            {
                GoToState('ViewTransition');
            }
        }
    }
    else
    {
        if (DriverPositionIndex > 0)
        {
            PreviousPositionIndex = DriverPositionIndex;
            DriverPositionIndex--;

            if (Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer)
            {
                NextViewPoint();
            }
            else if (bPlayerCollisionBoxMoves && Level.NetMode == NM_DedicatedServer)
            {
                GoToState('ViewTransition');
            }
        }
    }
}

// Modified to use Sleep to control exit from state (including on server), to avoid unnecessary stuff on a server, & to add handling of FOV changes
simulated state ViewTransition
{
    simulated function HandleTransition()
    {
        if (Level.NetMode != NM_DedicatedServer)
        {
            // Switch to mesh for new position as may be different
            if (Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer)
            {
                if (DriverPositions[DriverPositionIndex].PositionMesh != none && !bDontUsePositionMesh)
                {
                    LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
                }
            }

            // If moving to a less zoomed position, we zoom out now, otherwise we wait until end of transition to zoom in
            if (DriverPositions[DriverPositionIndex].ViewFOV > DriverPositions[PreviousPositionIndex].ViewFOV && IsHumanControlled())
            {
                if (DriverPositions[DriverPositionIndex].bDrawOverlays)
                {
                    PlayerController(Controller).SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);
                }
                else
                {
                    PlayerController(Controller).DesiredFOV = DriverPositions[DriverPositionIndex].ViewFOV;
                }
            }

            // Play any transition animation for the driver
            if (Driver != none && Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim) && Driver.HasAnim(DriverPositions[PreviousPositionIndex].DriverTransitionAnim))
            {
                Driver.PlayAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);
            }
        }

        ViewTransitionDuration = 0.0; // start with zero in case we don't have a transition animation

        // Play any transition animation for the vehicle itself
        // On dedicated server we only want to run this section, to set Sleep duration to control leaving state (or play button/unbutton anims if driver's collision box moves)
        if (PreviousPositionIndex < DriverPositionIndex)
        {
            if (HasAnim(DriverPositions[PreviousPositionIndex].TransitionUpAnim))
            {
                if (Level.NetMode != NM_DedicatedServer || bPlayerCollisionBoxMoves)
                {
                    PlayAnim(DriverPositions[PreviousPositionIndex].TransitionUpAnim);
                }

                ViewTransitionDuration = GetAnimDuration(DriverPositions[PreviousPositionIndex].TransitionUpAnim);
            }
        }
        else if (HasAnim(DriverPositions[PreviousPositionIndex].TransitionDownAnim))
        {
            if (Level.NetMode != NM_DedicatedServer || bPlayerCollisionBoxMoves)
            {
                PlayAnim(DriverPositions[PreviousPositionIndex].TransitionDownAnim);
            }

            ViewTransitionDuration = GetAnimDuration(DriverPositions[PreviousPositionIndex].TransitionDownAnim);
        }
    }

    // Emptied out so that Sleep is the sole timing for exiting this state
    simulated function AnimEnd(int channel)
    {
    }

    // Reverted to global Timer as Sleep is now the sole means of exiting this state
    simulated function Timer()
    {
        global.Timer();
    }

    simulated function EndState()
    {
        // If we have moved to a more zoomed position, we zoom in now, because we didn't do it earlier
        if (Level.NetMode != NM_DedicatedServer && DriverPositions[DriverPositionIndex].ViewFOV < DriverPositions[PreviousPositionIndex].ViewFOV && IsHumanControlled())
        {
            PlayerController(Controller).SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);
        }
    }

Begin:
    HandleTransition();
    Sleep(ViewTransitionDuration);
    GotoState('');
}

// Modified to prevent moving to another vehicle position while moving between view points
function ServerChangeDriverPosition(byte F)
{
    if (IsInState('ViewTransition'))
    {
        return;
    }

    super.ServerChangeDriverPosition(F);
}

// Modified to add clientside checks before sending the function call to the server
simulated function SwitchWeapon(byte F)
{
    local ROVehicleWeaponPawn WeaponPawn;
    local bool                bMustBeTankerToSwitch;
    local byte                ChosenWeaponPawnIndex;

    ChosenWeaponPawnIndex = F - 2;

    // Stop call to server if player has selected an invalid weapon position
    // Note that if player presses 0 or 1, which are invalid choices for a vehicle driver, the byte index will end up as 254 or 255 & so will still fail this check (which is what we want)
    if (ChosenWeaponPawnIndex >= PassengerWeapons.Length)
    {
        return;
    }

    if (ChosenWeaponPawnIndex < WeaponPawns.Length)
    {
        WeaponPawn = ROVehicleWeaponPawn(WeaponPawns[ChosenWeaponPawnIndex]);
    }

    if (WeaponPawn != none)
    {
        // Stop call to server as weapon position already has a human player
        if (WeaponPawn.Driver != none && WeaponPawn.Driver.IsHumanControlled())
        {
            return;
        }

        if (WeaponPawn.bMustBeTankCrew)
        {
            bMustBeTankerToSwitch = true;
        }
    }
    // Stop call to server if weapon pawn doesn't exist, UNLESS PassengerWeapons array lists it as a rider position
    // This is because our new system means rider pawns won't exist on clients unless occupied, so we have to allow this switch through to server
    else if (class<ROPassengerPawn>(PassengerWeapons[ChosenWeaponPawnIndex].WeaponPawnClass) == none)
    {
        return;
    }

    // Stop call to server if player has selected a tank crew role but isn't a tanker
    if (bMustBeTankerToSwitch && (Controller == none || ROPlayerReplicationInfo(Controller.PlayerReplicationInfo) == none ||
        ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo == none || !ROPlayerReplicationInfo(Controller.PlayerReplicationInfo).RoleInfo.bCanBeTankCrew))
    {
        ReceiveLocalizedMessage(class'DHVehicleMessage', 0); // not qualified to operate vehicle

        return;
    }

    ServerChangeDriverPosition(F);
}

// Modified to remove irrelevant stuff about driver weapon crosshair & to optimise a little
// Includes omitting calling DrawVehicle (as is just a 1 liner that can be optimised) & DrawPassengers (as is just an empty function)
simulated function DrawHUD(Canvas Canvas)
{
    local PlayerController PC;
    local vector           CameraLocation;
    local rotator          CameraRotation;
    local Actor            ViewActor;

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView)
    {
        // Player is in a position where an overlay should be drawn
        if (DriverPositions[DriverPositionIndex].bDrawOverlays && !IsInState('ViewTransition'))
        {
            if (HUDOverlay == none)
            {
                ActivateOverlay(true);
            }

            // Draw any HUD overlay
            if (HUDOverlay != none && !Level.IsSoftwareRendering())
            {
                CameraRotation = PC.Rotation;
                SpecialCalcFirstPersonView(PC, ViewActor, CameraLocation, CameraRotation);
                HUDOverlay.SetLocation(CameraLocation + (HUDOverlayOffset >> CameraRotation));
                HUDOverlay.SetRotation(CameraRotation);

                Canvas.DrawActor(HUDOverlay, false, true, FClamp(HUDOverlayFOV * (PC.DesiredFOV / PC.DefaultFOV), 1.0, 170.0));
            }
        }

        // Draw vehicle, turret, ammo count, passenger list
        if (ROHud(PC.myHUD) != none)
        {
            ROHud(PC.myHUD).DrawVehicleIcon(Canvas, self);
        }
    }
    else if (HUDOverlay != none)
    {
        ActivateOverlay(false);
    }
}

// Modified to revert to Super in Pawn, skipping unnecessary stuff in ROWheeledVehicle & ROVehicle, as this is a many-times-a-second function & so should be optimised
function int LimitPitch(int pitch, optional float DeltaTime)
{
    return super(Pawn).LimitPitch(pitch, DeltaTime);
}

// Modified to include Skins array (so no need to add manually in each subclass) & to add extra material properties & remove obsolete stuff
// Also removes all literal material references, so they aren't repeated again & again - instead they are pre-cached once in DarkestHourGame.PrecacheGameTextures()
static function StaticPrecache(LevelInfo L)
{
    local int i;

    for (i = 0; i < default.PassengerWeapons.Length; ++i)
    {
        if (default.PassengerWeapons[i].WeaponPawnClass != none)
        {
            default.PassengerWeapons[i].WeaponPawnClass.static.StaticPrecache(L);
        }
    }

    for (i = 0; i < default.Skins.Length; ++i)
    {
        if (default.Skins[i] != none)
        {
            L.AddPrecacheMaterial(default.Skins[i]);
        }
    }

    L.AddPrecacheMaterial(default.VehicleHudImage);
    L.AddPrecacheMaterial(default.MPHMeterMaterial);

    if (default.HighDetailOverlay != none)
    {
        L.AddPrecacheMaterial(default.HighDetailOverlay);
    }

    if (default.DestroyedVehicleMesh != none)
    {
        L.AddPrecacheStaticMesh(default.DestroyedVehicleMesh);
    }
}

// Modified to removes all literal material references, so they aren't repeated again & again - instead they are pre-cached once in DarkestHourGame.PrecacheGameTextures()
// Also to add extra material properties & remove obsolete stuff
simulated function UpdatePrecacheMaterials()
{
    super(Actor).UpdatePrecacheMaterials(); // pre-caches the Skins array

    Level.AddPrecacheMaterial(VehicleHudImage);
    Level.AddPrecacheMaterial(MPHMeterMaterial);

    if (HighDetailOverlay != none)
    {
        Level.AddPrecacheMaterial(HighDetailOverlay);
    }

    if (DestroyedVehicleMesh != none)
    {
        Level.AddPrecacheStaticMesh(DestroyedVehicleMesh);
    }
}

// Matt: added as when player is in a vehicle, the HUD keybinds to GrowHUD & ShrinkHUD will now call these same named functions in the vehicle classes
// When player is in a vehicle, these functions do nothing to the HUD, but they can be used to add useful vehicle functionality in subclasses, especially as keys are -/+ by default
simulated function GrowHUD();
simulated function ShrinkHUD();

// Matt: modified to switch to external mesh & default FOV for behind view
simulated function POVChanged(PlayerController PC, bool bBehindViewChanged)
{
    local int i;

    if (PC.bBehindView)
    {
        if (bBehindViewChanged)
        {
            if (bPCRelativeFPRotation)
            {
                PC.SetRotation(rotator(vector(PC.Rotation) >> Rotation));
            }

            for (i = 0; i < DriverPositions.Length; ++i)
            {
                DriverPositions[i].PositionMesh = default.Mesh;
                DriverPositions[i].ViewFOV = PC.DefaultFOV;
            }

            bDontUsePositionMesh = true;

            if ((Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer) && DriverPositions[DriverPositionIndex].PositionMesh != none)
            {
                LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
            }

            PC.SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);

            bLimitYaw = false;
            bLimitPitch = false;
        }

        bOwnerNoSee = false;

        if (Driver != none)
        {
            Driver.bOwnerNoSee = !bDrawDriverInTP;
        }

        if (PC == Controller) // no overlays for spectators
        {
            ActivateOverlay(false);
        }
    }
    else
    {
        if (bPCRelativeFPRotation)
        {
            PC.SetRotation(rotator(vector(PC.Rotation) << Rotation));
        }

        if (bBehindViewChanged)
        {
            for (i = 0; i < DriverPositions.Length; ++i)
            {
                DriverPositions[i].PositionMesh = default.DriverPositions[i].PositionMesh;
                DriverPositions[i].ViewFOV = default.DriverPositions[i].ViewFOV;
            }

            bDontUsePositionMesh = default.bDontUsePositionMesh;

            if ((Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer) && DriverPositions[DriverPositionIndex].PositionMesh != none)
            {
                LinkMesh(DriverPositions[DriverPositionIndex].PositionMesh);
            }

            PC.SetFOV(DriverPositions[DriverPositionIndex].ViewFOV);

            bLimitYaw = default.bLimitYaw;
            bLimitPitch = default.bLimitPitch;
        }

        bOwnerNoSee = !bDrawMeshInFP;

        if (Driver != none)
        {
            Driver.bOwnerNoSee = Driver.default.bOwnerNoSee;
        }

        if (bDriving && PC == Controller)
        {
            ActivateOverlay(true);
        }
    }
}

// Matt: DH version but keeping it just to view limits & nothing to do with behind view (which is handled by exec functions BehindView & ToggleBehindView)
exec function ToggleViewLimit()
{
    if (class'DH_LevelInfo'.static.DHDebugMode()) // removed requirement to be in single player mode, as valid in multi-player if in DHDebugMode
    {
        if (bLimitYaw == default.bLimitYaw && bLimitPitch == default.bLimitPitch)
        {
            bLimitYaw = false;
            bLimitPitch = false;
        }
        else
        {
            bLimitYaw = true;
            bLimitPitch = true;
        }
    }
}

// Matt: allows debugging exit positions to be toggled for all DHWheeledVehicles
exec function ToggleDebugExits()
{
    if (class'DH_LevelInfo'.static.DHDebugMode())
    {
        ServerToggleDebugExits();
    }
}

function ServerToggleDebugExits()
{
    if (class'DH_LevelInfo'.static.DHDebugMode())
    {
        class'DHWheeledVehicle'.default.bDebugExitPositions = !class'DHWheeledVehicle'.default.bDebugExitPositions;
        Log("DHWheeledVehicle.bDebugExitPositions =" @ class'DHWheeledVehicle'.default.bDebugExitPositions);
    }
}

// Matt: handy execs during development for testing engine damage
function exec KillEngine()
{
    if ((Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode()) && EngineHealth > 0)
    {
        ServerKillEngine();
    }
}

function ServerKillEngine()
{
    DamageEngine(EngineHealth, none, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), none);
}

// Modified to eliminate "Waiting for additional crewmembers" message // Matt: now only used by bots
function bool CheckForCrew()
{
    return true;
}

// Modified to add WeaponPawns != none check to avoid "accessed none" errors, now rider pawns won't exist on client unless occupied
simulated function int GetPassengerCount()
{
    local int i, Num;

    if (Driver != none)
    {
        Num = 1;
    }

    for (i = 0; i < WeaponPawns.Length; ++i)
    {
        if (WeaponPawns[i] != none && WeaponPawns[i].Driver != none)
        {
            ++Num;
        }
    }

    return Num;
}

// Informs tick that we crushed an object and it should apply break and affect server throttle
simulated function ObjectCrushed(float ReductionTime)
{
    ObjectCrushStallTime = ReductionTime;
    LastCrushedTime = Level.TimeSeconds;
    bCrushedAnObject = true;
}

// Modified to add an impact effect for running someone over (will slow vehicle down)
function bool EncroachingOn(Actor Other)
{
    // If its a player pawn, do lots of damage & call ObjectCrushed()
    if (Pawn(Other) != none && Vehicle(Other) == none && Other != Instigator && Other.Role == ROLE_Authority && (Other.bCollideActors || Other.bBlockActors) && VSizeSquared(Velocity) >= 100.0)
    {
        Other.TakeDamage(10000, Instigator, Other.Location, Velocity * Other.Mass, CrushedDamageType);
        ObjectCrushed(4.0);
    }

    return false;
}

simulated event NotifySelected(Pawn User)
{
    if (Level.NetMode != NM_DedicatedServer && User != none && User.IsHumanControlled() && ((Level.TimeSeconds - LastNotifyTime) >= TouchMessageClass.default.LifeTime) && Health > 0)
    {
        NotifyParameters.Insert("Controller", User.Controller);

        PlayerController(User.Controller).ReceiveLocalizedMessage(TouchMessageClass, 0,,, NotifyParameters);

        LastNotifyTime = Level.TimeSeconds;
    }
}

defaultproperties
{
    SparkEffectClass=none // Removes the odd spark effects when vehicle drags bottom
    ObjectCrushStallTime=1.0
    FriendlyResetDistance=4000.0
    ObjectCollisionResistance=1.0
    bEngineOff=true
    bSavedEngineOff=true
    bDisableThrottle=false
    VehicleBurningSound=sound'Amb_Destruction.Fire.Krasnyi_Fire_House02'
    DestroyedBurningSound=sound'Amb_Destruction.Fire.Kessel_Fire_Small_Barrel'
    DamagedStartUpSound=sound'DH_AlliedVehicleSounds2.Damaged.engine_start_damaged'
    PointValue=1.0
    DriverTraceDistSquared=20250000.0 // Matt: increased from 4500 as made variable into a squared value (VSizeSquared is more efficient than VSize)
    DestructionEffectClass=class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
    DisintegrationEffectClass=class'ROEffects.ROVehicleDestroyedEmitter'
    DisintegrationEffectLowClass=class'ROEffects.ROVehicleDestroyedEmitter_simple'
    ExplosionSoundRadius=1000.0
    ExplosionDamage=325.0
    ExplosionRadius=700.0
    DamagedEffectHealthSmokeFactor=0.75
    DamagedEffectHealthMediumSmokeFactor=0.5
    DamagedEffectHealthHeavySmokeFactor=0.25
    DamagedEffectHealthFireFactor=0.15
    ImpactDamageTicks=2.0
    ImpactDamageThreshold=20.0
    ImpactDamageMult=0.5
    IdleTimeBeforeReset=90.0
    VehicleSpikeTime=30.0
    EngineHealth=30
    ObjectiveGetOutDist=1500.0
    bKeepDriverAuxCollision=true
    HealthMax=175.0
    Health=175
    IgnitionSwitchInterval=4.0
    TouchMessageClass=class'DHVehicleTouchMessage'
}
