//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHVehicle extends ROWheeledVehicle
    abstract;

#exec OBJ LOAD FILE=..\Sounds\DHMenuSounds.uax

// Structs
struct PassengerPawn
{
    var name    AttachBone;
    var vector  DrivePos;
    var rotator DriveRot;
    var name    DriveAnim;
    var vector  FPCamPos;
};

struct VehicleAttachment
{
    var class<Actor>    AttachClass;
    var Actor           Actor;
    var StaticMesh      StaticMesh;
    var name            AttachBone;
    var vector          Offset;
    var array<Material> Skins;
    var bool            bHasCollision;
};

struct RandomAttachOption
{
    var StaticMesh  StaticMesh;     // a possible random decorative attachment mesh
    var byte        PercentChance;  // the % chance of this attachment being the one spawned
};

// General
var DHVehicleCannon Cannon;                      // reference to the vehicle's cannon weapon
var DHVehicleMG     MGun;                        // reference to the vehicle's mounted MG weapon
var array<material> CannonSkins;                 // option to specify cannon's camo skins in vehicle class, avoiding need for separate cannon pawn & cannon classes just for different camo
var     array<PassengerPawn> PassengerPawns;     // array with properties usually specified in separate passenger pawn classes, just to avoid need for lots of classes
var     byte        FirstRiderPositionIndex;     // used by passenger pawn to find its position in PassengerPawns array
var     bool        bIsArtilleryVehicle;         // is an artillery support vehicle, where targets can be marked by an observer, with impacts showing on overhead map
var     float       PointValue;                  // used for scoring
var     int         ReinforcementCost;           // reinforcement loss for losing this vehicle
var     float       FriendlyResetDistance;       // used in CheckReset() as maximum range to check for friendly pawns, to avoid re-spawning empty vehicle
var     bool        bClientInitialized;          // clientside flag that replicated actor has completed initialization (set at end of PostNetBeginPlay)
                                                 // (allows client code to determine whether actor is just being received through replication, e.g. in PostNetReceive)
var     TreeMap_string_Object  NotifyParameters; // an object that can hold references to several other objects, which can be used by messages to build a tailored message
var     int         WeaponLockTimeForTK;         // Number of seconds a player's weapons are locked for TKing this vehicle
var     int         PreventTeamChangeForTK;      // Number of seconds a player cannot team change after TKing this vehicle

// Driver & driving
var     bool        bRequiresDriverLicense;      // Vehicle requires player to have a driver license to be in driver position
var     bool        bNeedToInitializeDriver;     // clientside flag that we need to do some driver set up, once we receive the Driver actor
var     float       MaxCriticalSpeed;            // if vehicle goes over max speed, it forces player to pull back on throttle
                                                 // ... calculated as (desired kph * 1000 * 60.352 / 3600)
var     name        PlayerCameraBone;            // just to avoid using literal references to 'Camera_driver' bone & allow extra flexibility
var     float       ViewTransitionDuration;      // used to control the time we stay in state ViewTransition
var     bool        bLockCameraDuringTransition; // lock the camera's rotation to the camera bone during view transitions
var     int         PrioritizeWeaponPawnEntryFromIndex; // index from which passenger/crew seats will be filled (unless the driver's seat is available)

// Damage
var     float       FrontLeftAngle, FrontRightAngle, RearRightAngle, RearLeftAngle; // used by the hit detection system to determine which side of the vehicle was hit
var     float       HeavyEngineDamageThreshold;  // proportion of remaining engine health below which the engine is so badly damaged it limits speed
var     bool        bCanCrash;                   // vehicle can be damaged by static geometry during impacts (damages the engine)
var     bool        bWheelsAreDamaged;           // if wheels are damaged, the vehicle is slowed down
var     float       EngineDamageFromGrenadeModifier;  // if engine can be damaged, by grenades (can't check bAPC & bTreaded, because there might be a vehile with engine exposed)
var     float       DamagedWheelSpeedFactor;     // the max speed the vehicle can go if wheels are damaged (1.0 is no change)
var     float       ImpactWorldDamageMult;       // multiplier for world geometry impact damage when vehicle bCanCrash
var     float       DirectHEImpactDamageMult;    // damage multiplier for direct HE impact (direct hits with HE rounds) defaults: 1.0
var array<material> DestroyedMeshSkins;          // option to skin destroyed vehicle static mesh to match camo variant (avoiding need for multiple destroyed meshes)
var     sound       DamagedStartUpSound;         // sound played when trying to start a damaged engine
var     sound       DamagedShutDownSound;        // sound played when damaged engine shuts down
var     sound       VehicleBurningSound;         // ambient sound when vehicle's engine is burning
var     sound       DestroyedBurningSound;       // ambient sound when vehicle is destroyed and burning
var     float       SpawnProtEnds;               // is set when a player spawns the vehicle for damage protection in DarkestHour spawn type maps
var     float       SpawnKillTimeEnds;           // is set when a player spawns the vehicle for spawn kill protection in DarkestHour spawn type maps
var     array<int>  TrackHealth[2];              // Amount of health each track has remaining
var     float       SatchelResistance;           // 1.0 default (0.5 means less resistance to satchels)
var class<DamageType> LastHitByDamageType;       // Stores the last damage type this vehicle was hit by.
                                                 // Unlike `HitDamageType`, this variable is not replicated.

// Engine
var     bool        bEngineOff;                  // vehicle engine is simply switched off
var     bool        bSavedEngineOff;             // clientside record of current value, so PostNetReceive can tell if a new value has been replicated
var     float       IgnitionSwitchTime;          // records last time the engine was switched on/off - requires interval to stop people spamming the ignition switch
var     float       IgnitionSwitchInterval;      // how frequently the engine can be manually switched on/off
var     float       EngineRestartFailChance;     // chance of engine failing to re-start (only temporarily) after it has been switched off (0 to 1 value)

// Driving effects
var     bool        bIsWinterVariant;            // Notes in the defaults if a vehicle uses Winter or Snow skins to force use of the white dust emitter (saves levelers from remembering to set the right dust color in Level Properties)
var     bool        bEmittersOn;                 // dust & exhaust effects are enabled
var     float       MaxPitchSpeed;               // used to set movement sounds volume, based on vehicle's speed
var     sound       RumbleSound;                 // interior rumble sound
var     name        RumbleSoundBone;             // attachment bone for rumble sound attachment
var     Actor       RumbleSoundAttach;           // reference to rumble sound attachment actor
var     float       RumbleSoundVolumeModifier;   // allows adjustment of interior rumble sound volume
var     sound       EngineSound;                 // engine sound - rarely used as sound is already played using IdleSound, with its pitch related to speed by native code,
var     name        EngineSoundBone;             // but EngineSound is overlaid on IdleSound, so can give greater depth of sound & serves some purpose, although not much
var     Actor       EngineSoundAttach;
var     float       LastImpactSound;             // last time an impact damage sound was played (used to limit constant sounds as vehicle 'bottoms out' on ground)

// Treads & track wheels
var     bool                bHasTreads;
var     int                 LeftTreadIndex, RightTreadIndex;   // index position of treads in Skins array
var     VariableTexPanner   LeftTreadPanner, RightTreadPanner; // texture panners used to make it look like the treads are moving
var     float               TreadVelocityScale;                // allows adjustment of treads rotation speed for each vehicle
var     rotator             LeftTreadPanDirection, RightTreadPanDirection; // make sure the treads move the correct way!
var     sound               LeftTreadSound, RightTreadSound;               // tread movement sound
var     name                LeftTrackSoundBone, RightTrackSoundBone;       // attachment bone names for tread sound attachments
var     Actor               LeftTreadSoundAttach, RightTreadSoundAttach;   // references to sound attachments used to make tread sounds
var     array<name>         LeftWheelBones, RightWheelBones;               // bone names for track wheels on each side, used to animate wheels (visual only)
var     float               LeftWheelsRotation, RightWheelsRotation;       // keep track of the wheel rotation position for animation
var     float               WheelRotationScale;                            // allows adjustment of wheel rotation speed for each vehicle, relative to tread movement speed

// Damaged treads
var     float               TreadHitMaxHeight;     // height (in UU) of top of treads above hull mesh centre, used to detect tread hits (replaces RO's TreadHitMinAngle)
var     float               TreadDamageThreshold;  // minimum TreadDamageModifier in DamageType to possibly break treads
var     bool                bLeftTrackDamaged;     // the left track has been damaged
var     bool                bRightTrackDamaged;    // the left track has been damaged
var     sound               TrackDamagedSound;     // alternative tread sound to play when a track is damaged
var     material            DamagedTreadPanner;    // replacement skin used for a damaged tread
var     StaticMesh          DamagedTrackStaticMeshLeft, DamagedTrackStaticMeshRight; // static meshes to use for damaged left & right tracks
var     Actor               DamagedTrackLeft, DamagedTrackRight; // static mesh attachment to show damaged track, e.g. broken track links (clientside only)
var     name                DamagedTrackAttachBone;

// Vehicle HUD icon
var     TexRotator          VehicleHudTurret;        // rotating icon representing the vehicle's cannon
var     TexRotator          VehicleHudTurretLook;
var     float               VehicleHudTreadsPosX[2]; // 0.0 to 1.0 X positioning of tread damage indicators (index 0 = left, 1 = right)
var     float               VehicleHudTreadsPosY;    // 0.0 to 1.0 Y positioning of tread damage indicators
var     float               VehicleHudTreadsScale;   // drawing scale of tread damage indicators
var     bool                bShouldDrawPositionDots;
var     bool                bShouldDrawOccupantList;

// Map icon
var     class<DHMapIconAttachment>  MapIconAttachmentClass;
var     DHMapIconAttachment         MapIconAttachment;

// Vehicle attachments
var     array<VehicleAttachment>    VehicleAttachments;      // vehicle attachments, generally decorative, that won't be spawned on a server
var     array<VehicleAttachment>    CollisionAttachments;    // collision mesh attachments for a moving part of vehicle that should have collision, e.g. a ramp or driver's armoured visor
var     VehicleAttachment           RandomAttachment;        // option for a visual attachment with a random selection of static mesh type, e.g. schurzen with different stages of damage
var     array<RandomAttachOption>   RandomAttachOptions;     // possible static meshes to use with the random decorative attachment
var     byte                        RandomAttachmentIndex;   // the attachment index number selected randomly to be spawned for this vehicle
var     class<DHResupplyAttachment> ResupplyAttachmentClass; // option for a functioning (not decorative) resupply actor attachment
var     name                        ResupplyAttachmentBone;  // bone name for attaching resupply attachment
var     DHResupplyAttachment        ResupplyAttachment;      // reference to any resupply actor
var     float                       ShadowZOffset;           // vertical position offset for shadow, allowing shadow to be tuned (origin position in hull mesh affects shadow location)

// Supply
var     class<DHConstructionSupplyAttachment>   SupplyAttachmentClass;
var     name                                    SupplyAttachmentBone;
var     DHConstructionSupplyAttachment          SupplyAttachment;
var     vector                                  SupplyAttachmentOffset;
var     rotator                                 SupplyAttachmentRotation;
var     int                                     SupplyDropInterval;        // the amount of seconds that must elapse between supply drops
var     int                                     SupplyDropCountMax;         // How many supplies this vehicle can drop at a time.
var     int                                     SupplyLoadCountMax;         // How many supplies this vehicle can load at a time.
var     array<DHConstructionSupplyAttachment>   TouchingSupplyAttachments; // list of supply attachments we are in range of
var     int                                     TouchingSupplyCount;       // sum of all supplies in attachments we are in range of
var     float                                   ResupplyInterval;
var     int                                     LastResupplyTimestamp;

var     sound                                   SupplyDropSound;
var     float                                   SupplyDropSoundRadius;
var     float                                   SupplyDropSoundVolume;

var     int                                     SupplyCost;             // The amout of supplies it takes to create a vehicle of this type.

// Construction
var     vector                                  ConstructionPlacementOffset;
var     Mesh                                    ConstructionBaseMesh;

// Spawning
var     int                     VehiclePoolIndex;     // the vehicle pool index that this was spawned from
var     DHSpawnPoint_Vehicle    SpawnPointAttachment; // a spawn vehicle's spawn point attachment
var     DHSpawnPointBase        SpawnPoint;           // the spawn point that was used to spawn this vehicle
var     bool                    bHasSpawnKillPenalty;

// Absolute exit positions
struct SExitPosition
{
    var vector Location;
    var rotator Rotation;
};
var     array<SExitPosition> AbsoluteExitPositions;

// Debugging
var     bool        bDebuggingText;

replication
{
    // Variables the server will replicate to clients when this actor is 1st replicated
    reliable if (bNetInitial && bNetDirty && Role == ROLE_Authority)
        RandomAttachmentIndex;

    // Variables the server will replicate to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        bEngineOff, bRightTrackDamaged, bLeftTrackDamaged, SpawnPointAttachment, SupplyAttachment, TouchingSupplyCount, bWheelsAreDamaged;

    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerStartEngine, ServerUnloadSupplies, ServerLoadSupplies;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ********************** ACTOR INITIALISATION & DESTRUCTION  ********************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to create passenger pawn classes from PassengerWeapons array, to make net clients show empty rider positions on HUD vehicle icon,
// to match position indexes to initial position, to set bDriverAlreadyEntered in single player, to avoid setting initial timer RO's 'waiting for crew' system is deprecated,
// and to set up new NotifyParameters object (including this vehicle class, which gets passed to screen messages & allows them to display vehicle name
simulated function PostBeginPlay()
{
    local byte StartIndex, Index, i;

    super(Vehicle).PostBeginPlay(); // skip over Super in ROWheeledVehicle to avoid setting an initial timer, which we no longer use

    // Play neutral idle animation
    if (HasAnim(BeginningIdleAnim))
    {
        PlayAnim(BeginningIdleAnim);
    }

    // Create passenger pawn classes from the PassengerWeapons array
    if (PassengerPawns.Length > 0)
    {
        if (FirstRiderPositionIndex == 255)
        {
            FirstRiderPositionIndex = PassengerWeapons.Length; // set automatically, unless has been set specifically
        }

        StartIndex = PassengerWeapons.Length;
        PassengerWeapons.Length = PassengerWeapons.Length + PassengerPawns.Length;

        for (i = 0; i < PassengerPawns.Length; ++i)
        {
            Index = StartIndex + i;
            PassengerWeapons[Index].WeaponPawnClass = class'DHPassengerPawn'.default.PassengerClasses[Index];
            PassengerWeapons[Index].WeaponBone = PassengerPawns[i].AttachBone;
        }
    }

    // If InitialPositionIndex is not zero, match position indexes now so when a player gets in, we don't trigger an up transition by changing DriverPositionIndex
    if (Role == ROLE_Authority)
    {
        if (InitialPositionIndex > 0)
        {
            DriverPositionIndex = InitialPositionIndex;
            PreviousPositionIndex = InitialPositionIndex;
        }
    }
    // On net client, force length of WeaponPawns array to normal length so it works with our new passenger pawn system
    // Passenger pawns won't now exist on client unless occupied, so although passenger slots may be empty in array we still see grey passenger position dots on HUD vehicle icon
    else
    {
        WeaponPawns.Length = PassengerWeapons.Length;
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        // Set up new NotifyParameters object
        NotifyParameters = new class'TreeMap_string_Object';
        NotifyParameters.Put("VehicleClass", Class);
    }
}

// Modified to initialize engine-related properties, & also on a net client to flag if bNeedToInitializeDriver, to match clientside position indexes to replicated DriverPositionIndex,
// to flag bClientInitialized, & to skip lots of pointless stuff if an already destroyed vehicle gets replicated
simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();

    // Net client initialisation, based on replicated info about driving status/position
    if (Role < ROLE_Authority)
    {
        bSavedEngineOff = bEngineOff;
        bClientInitialized = true;

        // If an already destroyed vehicle gets replicated, there's nothing more we want to do here; it will only turn the engine on & set irrelevant variables
        if (Health <= 0)
        {
            return;
        }

        if (bDriving)
        {
            bNeedToInitializeDriver = true;
        }

        SavedPositionIndex = DriverPositionIndex;
        PreviousPositionIndex = DriverPositionIndex;
        PendingPositionIndex = DriverPositionIndex;
    }

    // Set up the engine (all modes)
    SetEngine();

    // Spawn a variety of vehicle attachment options
    SpawnVehicleAttachments();
}

// Modified to destroy extra attachments & effects - including the DestructionEffect emitter
// That's because if an already exploded vehicle replicates to a net client, the vehicle gets Destroyed() before the natural LifeSpan of the emitter
// That left the DestructionEffect burning away in mid air after the vehicle has disappeared (the Super calls Kill() on the emitter, but it doesn't seem to work)
simulated function Destroyed()
{
    if (Role < ROLE_Authority && DestructionEffect != none)
    {
        DestructionEffect.Destroy(); // has to go before the Super, as that fails to destroy it, but does clear the actor reference
    }

    super.Destroyed();

    DestroyAttachments();

    if (NotifyParameters != none)
    {
        NotifyParameters.Clear();
    }
}

function StartEngineFire(Pawn InstigatedBy);

function KilledBy(Pawn EventInstigator)
{
    local Controller Killer;
    local class<DamageType> DT;

    if (EventInstigator != None)
    {
        Killer = EventInstigator.Controller;
    }

    if (LastHitByDamageType == none || EventInstigator == self)
    {
        DT = class'Suicided';
    }
    else
    {
        DT = LastHitByDamageType;
    }

    Died(Killer, DT, Location);
}

// Modified to score the vehicle kill, & to subtract the vehicle's reinforcement cost for the loss
function Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
    local DarkestHourGame DHG;
    local DHGameReplicationInfo GRI;
    local DHPlayer DHKiller;
    local int RoundTime;

    DHG = DarkestHourGame(Level.Game);

    if (DHG != none)
    {
        GRI = DHGameReplicationInfo(DHG.GameReplicationInfo);
    }

    // Log driver and vehicle kills before calling the super.
    // NOTE: We match the conditions in the super function
    // instead of overriding it completely.
    if (GRI != none &&
        !bDeleteMe &&
        !Level.bLevelChange &&
        !bVehicleDestroyed &&
        !Level.Game.PreventDeath(self, Killer, damageType, HitLocation) &&
        DamageType != class'Suicided')
    {
        RoundTime = GRI.ElapsedTime - GRI.RoundStartTime;
        DHG.Metrics.OnVehicleFragged(PlayerController(Killer), self, DamageType, HitLocation, RoundTime);

        if (Controller != none && !bRemoteControlled && !bEjectDriver)
        {
            DHG.Metrics.OnPlayerFragged(PlayerController(Killer), PlayerController(Controller), DamageType, HitLocation, 0, RoundTime);
        }
    }

    super.Died(Killer, DamageType, HitLocation);

    if (MapIconAttachment != none)
    {
        MapIconAttachment.Destroy();
    }

    DHKiller = DHPlayer(Killer);

    if (DHG == none || GRI == none || DHKiller == none)
    {
        return;
    }

    // Handle reinforcement loss for the vehicle
    if (ReinforcementCost != 0)
    {
        // Deducts reinforcements based on the vehicle's "reinforcement cost"
        DHG.ModifyReinforcements(VehicleTeam, -ReinforcementCost);
    }

    // If is not a team kill and the vehicle is NOT spawn protected, then +score for killer
    if (DHKiller.GetTeamNum() != GetTeamNum() && !IsSpawnProtected())
    {
        DHG.SendScoreEvent(DHKiller, class'DHScoreEvent_VehicleKill'.static.Create(Class));
    }

    // If killed by a friendly
    if (DHKiller.GetTeamNum() == GetTeamNum())
    {
        if (DHKiller.PlayerReplicationInfo != none)
        {
            // Broadcast a message to all players
            Level.Game.BroadcastLocalizedMessage(class'DHGameMessage', 23, DHKiller.PlayerReplicationInfo,, self); // "[instigator] killed a friendly [vehiclename]"

            // Death message icon
            Level.Game.BroadcastDeathMessage(DHKiller, DHKiller, class'DHVehicleTeamKillDamageType');

            // Lock weapons
            DHKiller.WeaponLockViolations++;
            DHKiller.LockWeapons(WeaponLockTimeForTK);
            DHKiller.ReceiveLocalizedMessage(class'DHWeaponsLockedMessage', 4); // "Your weapons have been locked due to friendly fire!"

            // Prevent team change
            DHKiller.NextChangeTeamTime = GRI.ElapsedTime + PreventTeamChangeForTK;
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ***************************** KEY ENGINE EVENTS  ******************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to handle engine on/off (including dust/exhaust emitters), damaged tracks & fire effects, instead of constantly checking in Tick
// Also to initialize driver-related stuff when we receive the Driver actor
simulated function PostNetReceive()
{
    // Player has changed view position
    // Checking bClientInitialized means we do nothing until PostNetBeginPlay() has matched position indexes, meaning we leave SetPlayerPosition() to handle any initial anims
    if (DriverPositionIndex != SavedPositionIndex && bClientInitialized)
    {
        PreviousPositionIndex = SavedPositionIndex;
        SavedPositionIndex = DriverPositionIndex;

        if (Driver != none) // no point playing transition anim if there's no driver (if he's just left, the BeginningIdleAnim will play)
        {
            NextViewPoint();
        }
    }

    // Engine has been switched on or off (but if not bClientInitialized, then actor has just replicated & SetEngine() will get called in PostBeginPlay)
    if (bEngineOff != bSavedEngineOff && bClientInitialized)
    {
        bSavedEngineOff = bEngineOff;
        IgnitionSwitchTime = Level.TimeSeconds; // so next time we can run a clientside time check to make sure engine toggle is valid, before sending call to ServerStartEngine()
        SetEngine();
    }

    // EngineHealth is now <= 0 AND we are NOT displaying the engine fire (so lets have the client update things by calling SetEngine())
    if (EngineHealth <= 0 && DamagedEffectHealthFireFactor != 1.0 && bClientInitialized)
    {
        SetEngine();
    }

    // One of the tracks has been damaged (uses DamagedTreadPanner as an effective flag that net client hasn't already done this)
    if (((bLeftTrackDamaged && Skins.Length > LeftTreadIndex && Skins[LeftTreadIndex] != DamagedTreadPanner) ||
        (bRightTrackDamaged && Skins.Length > LeftTreadIndex && Skins[RightTreadIndex] != DamagedTreadPanner)) && Health > 0)
    {
        SetDamagedTracks();
    }

    // Initialize the driver
    if (bNeedToInitializeDriver && Driver != none)
    {
        bNeedToInitializeDriver = false;
        SetPlayerPosition();
    }
}

// Modified to handle treads (including damaged treads), engine & interior rumble sounds, & MaxCriticalSpeed,
// to prevent all movement if vehicle can't move (engine off or both tracks disabled), & to disable Tick if vehicle is stationary & has no driver
// Also to remove (from deprecated ROTreadCraft version) RO disabled throttle stuff & modifying value of WheelLatFrictionScale based on speed (did nothing)
// And to make the wheel rotation relative to DeltaTime, as before the wheel speed was variable & depended on the CPU's tick rate
simulated function Tick(float DeltaTime)
{
    local KRigidBodyState   BodyState;
    local rotator           WheelsRotation;
    local float             VehicleSpeed, MotionSoundVolume, LinTurnSpeed;
    local int               i;

    // Stop all movement if engine off or both tracks damaged
    if (bEngineOff || (bLeftTrackDamaged && bRightTrackDamaged))
    {
        Velocity = vect(0.0, 0.0, 0.0);
        Throttle = 0.0;
        ThrottleAmount = 0.0;
        Steering = 0.0;
        ForwardVel = 0.0;
    }
    else if (Controller != none)
    {
        // Damaged treads mean vehicle can only turn one way & speed is limited
        if (bLeftTrackDamaged)
        {
            Throttle = FClamp(Throttle, -0.5, 0.5);

            if (IsHumanControlled())
            {
                PlayerController(Controller).aStrafe = -32768.0;
            }
            else
            {
                Steering = 1.0;
            }
        }
        else if (bRightTrackDamaged)
        {
            Throttle = FClamp(Throttle, -0.5, 0.5);

            if (IsHumanControlled())
            {
                PlayerController(Controller).aStrafe = 32768.0;
            }
            else
            {
                Steering = -1.0;
            }
        }
        // Heavy damage to engine limits speed
        else if (EngineHealth <= (default.EngineHealth * HeavyEngineDamageThreshold))
        {
            Throttle = FClamp(Throttle, -0.5, 0.5);
        }
    }

    if (Role == ROLE_Authority)
    {
        // Recalculate the total supply count for our pawn, or -1 if there are
        // no supplies around.
        if (TouchingSupplyAttachments.Length == 0)
        {
            TouchingSupplyCount = -1;
        }
        else
        {
            TouchingSupplyCount = 0;

            for (i = 0; i < TouchingSupplyAttachments.Length; ++i)
            {
                if (TouchingSupplyAttachments[i] != none)
                {
                    TouchingSupplyCount += TouchingSupplyAttachments[i].GetSupplyCount();
                }
            }
        }
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        VehicleSpeed = Abs(ForwardVel); // don't need VSize(Velocity), as already have ForwardVel

        // Vehicle is moving
        if (VehicleSpeed > 0.1)
        {
            // Force player to pull back on throttle if over max speed
            if (VehicleSpeed >= MaxCriticalSpeed && MaxCriticalSpeed > 0.0 && IsHumanControlled())
            {
                PlayerController(Controller).aForward = -32768.0;
            }
            else if (bWheelsAreDamaged && (VehicleSpeed >= MaxCriticalSpeed * DamagedWheelSpeedFactor) && MaxCriticalSpeed > 0.0 && IsHumanControlled())
            {
                PlayerController(Controller).aForward = -32768.0;
            }

            // Update tread, interior rumble & engine sound volumes, based on speed
            MotionSoundVolume = FClamp(VehicleSpeed / MaxPitchSpeed * 255.0, 0.0, 255.0);
            UpdateMovementSound(MotionSoundVolume);

            // Update tread & wheel movement, based on speed
            if (bHasTreads)
            {
                KGetRigidBodyState(BodyState);
                LinTurnSpeed = 0.5 * BodyState.AngVel.Z;

                if (LeftTreadPanner != none)
                {
                    LeftTreadPanner.PanRate = (ForwardVel / TreadVelocityScale) + LinTurnSpeed;
                    LeftWheelsRotation += LeftTreadPanner.PanRate * WheelRotationScale * DeltaTime;
                    WheelsRotation.Pitch = LeftWheelsRotation;

                    for (i = 0; i < LeftWheelBones.Length; ++i)
                    {
                        if (LeftWheelBones[i] != '')
                        {
                            SetBoneRotation(LeftWheelBones[i], WheelsRotation);
                        }
                    }
                }

                if (RightTreadPanner != none)
                {
                    RightTreadPanner.PanRate = (ForwardVel / TreadVelocityScale) - LinTurnSpeed;
                    RightWheelsRotation += RightTreadPanner.PanRate * WheelRotationScale * DeltaTime;
                    WheelsRotation.Pitch = RightWheelsRotation;

                    for (i = 0; i < RightWheelBones.Length; ++i)
                    {
                        if (RightWheelBones[i] != '')
                        {
                            SetBoneRotation(RightWheelBones[i], WheelsRotation);
                        }
                    }
                }
            }
        }
        // If vehicle isn't moving, zero the movement sounds & tread movement
        else
        {
            UpdateMovementSound(0.0);

            if (LeftTreadPanner != none)
            {
                LeftTreadPanner.PanRate = 0.0;
            }

            if (RightTreadPanner != none)
            {
                RightTreadPanner.PanRate = 0.0;
            }
        }

        if (TouchingSupplyCount >= 0 && Controller != none && IsLocallyControlled() && SupplyAttachment != none)
        {
            PlayerController(Controller).ReceiveLocalizedMessage(class'DHSupplyVehicleMessage',,,, Controller);
        }
    }

    super.Tick(DeltaTime);

    // Disable Tick if vehicle isn't moving & has no driver
    if (!bDriving && ForwardVel ~= 0.0)
    {
        Disable('Tick');
    }
}

// Modified to remove RO stuff about bDriverAlreadyEntered, bDisableThrottle & CheckForCrew, as DH doesn't wait for crew anyway - so just set bDriverAlreadyEntered in KDriverEnter()
function Timer()
{
    // Check to see if we need to destroy a spiked, abandoned vehicle
    if (bSpikedVehicle)
    {
        if (Health > 0 && (!bHasTreads || IsVehicleEmpty()))
        {
            if (LastHitBy != none && LastHitBy.Pawn != none)
            {
                KilledBy(LastHitBy.Pawn);
            }
            else
            {
                KilledBy(Self);
            }
        }
        else
        {
            bSpikedVehicle = false; // cancel spike timer if vehicle is now occupied or destroyed
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  *******************************  VIEW/DISPLAY  ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to make locking of view during ViewTransition optional, to handle FPCamPos, & to optimise & simplify generally
simulated function SpecialCalcFirstPersonView(PlayerController PC, out Actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    local quat RelativeQuat, VehicleQuat, NonRelativeQuat;

    ViewActor = self;

    // Set CameraRotation
    if (IsInState('ViewTransition') && bLockCameraDuringTransition)
    {
        CameraRotation = GetBoneRotation(PlayerCameraBone); // if camera is locked during a current transition, lock rotation to PlayerCameraBone
    }
    else if (PC != none)
    {
        // Factor in the vehicle's rotation, as PC's rotation is relative to vehicle
        RelativeQuat = QuatFromRotator(Normalize(PC.Rotation));
        VehicleQuat = QuatFromRotator(Rotation);
        NonRelativeQuat = QuatProduct(RelativeQuat, VehicleQuat);
        CameraRotation = Normalize(QuatToRotator(NonRelativeQuat));
    }

    // Get camera location & adjust for any offset positioning
    CameraLocation = GetBoneCoords(PlayerCameraBone).Origin;

    if (FPCamPos != vect(0.0, 0.0, 0.0))
    {
        CameraLocation += FPCamPos >> Rotation;
    }

    // Finalise the camera with any shake
    if (PC != none)
    {
        CameraRotation = Normalize(CameraRotation + PC.ShakeRot);
        CameraLocation += PC.ShakeOffset >> PC.Rotation;
    }
}

// Modified to fix bug where any HUDOverlay would be destroyed if function called before net client received Controller reference through replication
// Also to remove irrelevant stuff about driver weapon crosshair & to optimise a little
// Includes omitting calling DrawVehicle (as is just a 1 liner that can be optimised) & DrawPassengers (as is just an empty function)
simulated function DrawHUD(Canvas C)
{
    local PlayerController PC;

    PC = PlayerController(Controller);

    if (PC != none && !PC.bBehindView)
    {
        // Player is in a position where a HUDOverlay should be drawn
        if (DriverPositions[DriverPositionIndex].bDrawOverlays && !IsInState('ViewTransition') && HUDOverlay != none && !Level.IsSoftwareRendering())
        {
            HUDOverlay.SetLocation(PC.CalcViewLocation + (HUDOverlayOffset >> PC.CalcViewRotation));
            HUDOverlay.SetRotation(PC.CalcViewRotation);
            C.DrawActor(HUDOverlay, false, true, FClamp(HUDOverlayFOV * (PC.DesiredFOV / PC.DefaultFOV), 1.0, 170.0));
        }

        // Draw vehicle, turret, ammo count, passenger list
        if (ROHud(PC.myHUD) != none)
        {
            ROHud(PC.myHUD).DrawVehicleIcon(C, self);
        }
    }
}

// Modified so if player is transitioning to a different driver position, we restrict view yaw to the lowest of the old & new positions
// Prevents screwed up views through the inside of vehicle while transitioning, e.g. unbuttoning in a tank,
// where player suddenly has much wider view limits from new position & can see through unmodelled tank interior
// Also so we don't limit view yaw if player is in behind view
simulated function int LimitYaw(int yaw)
{
    if (!bLimitYaw || (IsHumanControlled() && PlayerController(Controller).bBehindView))
    {
        return yaw;
    }

    if (IsInState('ViewTransition')) // if transitioning, first clamp yaw to the limits of the old position, then clamp to new position as usual
    {
        yaw = Clamp(yaw, DriverPositions[PreviousPositionIndex].ViewNegativeYawLimit, DriverPositions[PreviousPositionIndex].ViewPositiveYawLimit);
    }

    return Clamp(yaw, DriverPositions[DriverPositionIndex].ViewNegativeYawLimit, DriverPositions[DriverPositionIndex].ViewPositiveYawLimit);
}

// Modified so we don't limit view pitch if in behind view
// Also to correct apparent error in ROVehicle, where PitchDownLimit was being used instead of DriverPositions[x].ViewPitchDownLimit in multi position weapon
function int LimitPawnPitch(int pitch)
{
    pitch = pitch & 65535;

    if (bLimitPitch && !(IsHumanControlled() && PlayerController(Controller).bBehindView) && DriverPositions.Length > 0)
    {
        if (pitch > DriverPositions[DriverPositionIndex].ViewPitchUpLimit && pitch < DriverPositions[DriverPositionIndex].ViewPitchDownLimit)
        {
            if (pitch - DriverPositions[DriverPositionIndex].ViewPitchUpLimit < DriverPositions[DriverPositionIndex].ViewPitchDownLimit - pitch)
            {
                pitch = DriverPositions[DriverPositionIndex].ViewPitchUpLimit;
            }
            else
            {
                pitch = DriverPositions[DriverPositionIndex].ViewPitchDownLimit;
            }
        }
    }

    return pitch;
}

// Modified to switch to external mesh & unzoomed FOV for behind view
// Also to only adjust PC's rotation to make it relative to vehicle if we've just switched back from behind view into 1st person view
// This is because when we enter a vehicle we now zero the PC's rotation on entering, so it's already relative & we start facing the same way as the vehicle
simulated function POVChanged(PlayerController PC, bool bBehindViewChanged)
{
    if (PC == none)
    {
        return;
    }

    if (PC.bBehindView)
    {
        if (bBehindViewChanged)
        {
            FixPCRotation(PC); // switching to behind view, so make rotation non-relative to vehicle

            // Switch to external vehicle mesh & unzoomed view
            SwitchMesh(-1, true); // -1 signifies switch to default external mesh
            PC.SetFOV(PC.DefaultFOV);
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
        if (bBehindViewChanged)
        {
            PC.SetRotation(rotator(vector(PC.Rotation) << Rotation)); // make rotation relative to vehicle again (changed so only if switching back from behind view)

            // Switch back to position's normal vehicle mesh & view FOV
            if (DriverPositions.Length > 0)
            {
                SwitchMesh(DriverPositionIndex, true);
                SetViewFOV(DriverPositionIndex, PC);
            }
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

// New helper functions that get or set the appropriate ViewFOV for the given position in the DriverPositions array
// If no ViewFOV is specified for the given position it uses the player's default view FOV (i.e. player's normal FOV when on foot)
// This avoids having to hard code the default FOV for nearly all vehicle positions, & it also facilitates the player having a customisable view FOV
simulated function float GetViewFOV(int PositionIndex)
{
    if (PositionIndex >= 0 && PositionIndex < DriverPositions.Length && DriverPositions[PositionIndex].ViewFOV > 0.0)
    {
        return DriverPositions[PositionIndex].ViewFOV;
    }

    if (IsHumanControlled())
    {
        return PlayerController(Controller).DefaultFOV;
    }

    return class'DHPlayer'.default.DefaultFOV;
}

simulated function SetViewFOV(int PositionIndex, optional PlayerController PC)
{
    if (PC == none)
    {
        PC = PlayerController(Controller);
    }

    if (PC != none)
    {
        PC.SetFOV(GetViewFOV(PositionIndex));
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************************** VEHICLE ENTRY  ******************************** //
///////////////////////////////////////////////////////////////////////////////////////

// Re-written so this function checks & picks a vehicle position the player can use, if there is one
// It ignores any positions already occupied by another player, & any tank crew positions the player can't use (including in an armored vehicle that he's locked out of)
// Also simplified by removing the check on player distance vs EntryRadius & the ClosestWeaponPawn stuff (it really doesn't matter which is closest)
// If player is close enough to see the 'enter vehicle' message, he should always be able to enter, otherwise it's confusing & contradictory
function Vehicle FindEntryVehicle(Pawn P)
{
    local ROVehicleWeaponPawn WP;
    local Vehicle             VehicleGoal;
    local bool                bPlayerIsTankCrew, bCanEnterTankCrewPositions, bHasTankCrewPositions;
    local int                 i;
    local Vehicle             LowPriorityEntry;

    if (P == none)
    {
        return none;
    }

    if (P.IsHumanControlled())
    {
        // Check & save whether player is a tank crewman and, if so, whether he can enter tank crew positions (i.e. vehicle's crew haven't locked him out)
        if (class'DHPlayerReplicationInfo'.static.IsPlayerTankCrew(P))
        {
            bPlayerIsTankCrew = true;
            bCanEnterTankCrewPositions = !AreCrewPositionsLockedForPlayer(P, true);
        }

        // Select driver position if it's empty, & player isn't barred by tank crew restriction, & it isn't a locked armored vehicle that player can't enter
        if (Driver == none && (!bMustBeTankCommander || bCanEnterTankCrewPositions) && (!default.bRequiresDriverLicense || class'DHPlayerReplicationInfo'.static.IsPlayerLicensedToDrive(DHPlayer(P.Controller))))
        {
            return self;
        }

        bHasTankCrewPositions = bMustBeTankCommander;

        // Otherwise loop through the weapon pawns to find the first the player can use
        for (i = 0; i < WeaponPawns.Length; ++i)
        {
            WP = ROVehicleWeaponPawn(WeaponPawns[i]);

            // Select weapon pawn if it's empty, & player isn't barred by tank crew restriction, & this isn't a locked armored vehicle that player can't enter
            if (WP != none && WP.Driver == none && (!WP.bMustBeTankCrew || bCanEnterTankCrewPositions))
            {
                if (i >= PrioritizeWeaponPawnEntryFromIndex)
                {
                    return WP;
                }

                if (LowPriorityEntry == none)
                {
                    LowPriorityEntry = WP;
                    continue;
                }
            }

            if (LowPriorityEntry == none)
            {
                bHasTankCrewPositions = bHasTankCrewPositions || WP.bMustBeTankCrew;
            }
        }

        if (LowPriorityEntry != none)
        {
            return LowPriorityEntry;
        }

        // There are no empty, usable vehicle positions for this player, so give him a screen message (only if vehicle is his team's) & don't let him enter
        if (P.GetTeamNum() == VehicleTeam || !bTeamLocked)
        {
            if (default.bRequiresDriverLicense && !class'DHPlayerReplicationInfo'.static.IsPlayerLicensedToDrive(DHPlayer(P.Controller)))
            {
                DisplayVehicleMessage(3, P); // all rider positions full (if non-tanker tries to enter a tank that has rider positions)
            }
            else if (!bHasTankCrewPositions || bPlayerIsTankCrew)
            {
                DisplayVehicleMessage(2, P); // vehicle is full (this simple message if vehicle isn't a tank or if player is a tank crewman)
            }
            else if (FirstRiderPositionIndex < WeaponPawns.Length)
            {
                DisplayVehicleMessage(3, P); // all rider positions full (if non-tanker tries to enter a tank that has rider positions)
            }
            else
            {
                DisplayVehicleMessage(4, P); // can't ride on this vehicle (if non-tanker tries to enter a tank that doesn't have rider positions)
            }
        }

        return none;
    }

    // Otherwise it must be a bot entering, & bots know what they want to enter (their 'RouteGoal')
    if (P.Controller != none)
    {
        VehicleGoal = Vehicle(P.Controller.RouteGoal);
    }

    if (VehicleGoal == self)
    {
        if (Driver == none && !(bMustBeTankCommander && AreCrewPositionsLockedForPlayer(P)))
        {
            return self;
        }
    }
    else if (VehicleGoal != none)
    {
        for (i = 0; i < WeaponPawns.Length; ++i)
        {
            WP = ROVehicleWeaponPawn(WeaponPawns[i]);

            if (VehicleGoal == WP)
            {
                if (WP.Driver == none && !(WP.bMustBeTankCrew && AreCrewPositionsLockedForPlayer(P)))
                {
                    return WP;
                }

                if (Driver == none && !(bMustBeTankCommander && AreCrewPositionsLockedForPlayer(P))) // bot tries to enter driver's position if can't use its weapon pawn goal
                {
                    return self;
                }

                return none;
            }
        }
    }

    return none;
}

// Modified to prevent entry if player is on fire, or if it's a crew position in an armored vehicle has been locked by its crew
function bool TryToDrive(Pawn P)
{
    local bool bEnemyVehicle;
    local int  i;

    // Deny entry if vehicle is destroyed, or if player is on fire or reloading a weapon (plus several very obscure other reasons)
    if (Health <= 0 || P == none || (DHPawn(P) != none && DHPawn(P).bOnFire) || (P.Weapon != none && P.Weapon.IsInState('Reloading')) ||
        P.Controller == none || !P.Controller.bIsPlayer || P.DrivenVehicle != none || P.IsA('Vehicle') || bNonHumanControl || !Level.Game.CanEnterVehicle(self, P))
    {
        return false;
    }

    // Check whether trying to enter a vehicle that doesn't belong to our team
    // If vehicle is team locked, i.e. can only be used by one team (the normal setting), it's a simple check against the VehicleTeam
    if (bTeamLocked)
    {
        bEnemyVehicle = P.GetTeamNum() != VehicleTeam;
    }
    // But if vehicle isn't team locked & can be used by either team, we need to check if already has an enemy occupant (enemies can't share!)
    else
    {
        if (Driver != none && P.GetTeamNum() != Driver.GetTeamNum())
        {
            bEnemyVehicle = true;
        }
        else
        {
            for (i = 0; i < WeaponPawns.Length; ++i)
            {
                if (WeaponPawns[i] != none && WeaponPawns[i].Driver != none && P.GetTeamNum() != WeaponPawns[i].Driver.GetTeamNum())
                {
                    bEnemyVehicle = true;
                    break;
                }
            }
        }
    }

    // Deny entry if it's an enemy vehicle
    if (bEnemyVehicle)
    {
        DisplayVehicleMessage(1, P); // can't use enemy vehicle

        return false;
    }

    // TODO: these checks on a tank crew position are perhaps unnecessary duplication, as they will have been reliably checked on the server in either:
    // (1) FindEntryVehicle() - if player pressed 'use' to try to enter a vehicle, or
    // (2) ServerChangeDriverPosition()/CanSwitchToVehiclePosition() - if player tried to switch vehicle position [EDIT - no longer applies, now goes straight to KDriverEnter], or
    // (3) DHSpawnManager.SpawnVehicle() - if player spawns into a new vehicle from the DH deploy screen
    // (4) DHSpawnPoint_Vehicle.FindEntryVehicle() - if player deploys into an existing spawn vehicle from the DH deploy screen
    // And there shouldn't be any other way of getting to this function
    if (bMustBeTankCommander)
    {
        // Deny entry to a tank crew position if player isn't a tank crew role
        if (!class'DHPlayerReplicationInfo'.static.IsPlayerTankCrew(P) && P.IsHumanControlled())
        {
            DisplayVehicleMessage(0, P); // not qualified to operate vehicle
            return false;
        }

        // Deny entry to a tank crew position in an armored vehicle if it's been locked & player isn't an allowed crewman (gives message)
        if (AreCrewPositionsLockedForPlayer(P))
        {
            return false;
        }
    }

    if (default.bRequiresDriverLicense && !class'DHPlayerReplicationInfo'.static.IsPlayerLicensedToDrive(DHPlayer(P.Controller)) && P.IsHumanControlled())
    {
        DisplayVehicleMessage(0, P); // not qualified to operate vehicle
        return false;
    }

    // Deny entry if vehicle has a driver
    // Note this comes after other checks because if the player can't enter it anyway (e.g. enemy or locked vehicle or tank crew only),
    // he should get a 'can't use' message regardless of whether it happens to be currently occupied
    if (Driver != none)
    {
        return false;
    }

    // Passed all checks, so allow player to enter the vehicle
    KDriverEnter(P);

    return true;
}

// Modified to avoid playing engine start sound when entering vehicle, but to get a bot to start the engine on entering
// Also to handle passed in pawn being a vehicle, which now happens when player switches vehicle position (no longer briefly repossesses & unpossesses his player pawn)
// And to check & update any vehicle lock settings as a new player has entered, & to set bDriverAlreadyEntered as much simpler alternative to Timer() in ROWheeledVehicle
// Generally optimised & re-ordered a little, with some redundancy from the Supers removed
function KDriverEnter(Pawn P)
{
    local Controller C;
    local DHPawn     DHP;

    // Get a controller reference
    // If the entering player has a controller we need to save it because the pawn will lose it when unpossessed
    // And if player is switching from another vehicle position, his player pawn will no longer have a controller, so we need to use the new DHPawn.SwitchingController
    if (P != none)
    {
        DHP = DHPawn(P);

        if (P.Controller != none)
        {
            C = P.Controller;
        }

        if (DHP != none && DHP.SwitchingController != none)
        {
            if (C == none)
            {
                C = DHP.SwitchingController;
            }

            DHP.SetSwitchingController(none); // reset this now we've used it
        }
    }

    if (C == none)
    {
        return;
    }

    // Standard updates because a player has entered
    ResetTime = Level.TimeSeconds - 1.0; // cancel any CheckReset timer as vehicle now occupied
    Instigator = self;                   // restore usual value as KDriverLeave() will have changed it if a player has exited
    bDriverAlreadyEntered = true;        // ADDED as a much simpler alternative to Timer() in ROWheeledVehicle

    if (bEnterringUnlocks && bTeamLocked) // MOVED here from TryToDrive()
    {
        bTeamLocked = false;
    }

    // Make the player our 'Driver'
    DriverPositionIndex = InitialPositionIndex;
    PreviousPositionIndex = InitialPositionIndex;
    bDriving = true;
    Driver = P;
    Driver.StartDriving(self);

    // Make the player unpossess its current pawn & possess this vehicle pawn
    if (C.Pawn != none) // ADDED this check because if only switching vehicle position, controller will no longer have any player pawn to Unpossess()
    {
        C.Unpossess();
    }

    Driver.SetOwner(self); // this keeps the driver net relevant
    C.bVehicleTransition = true; // to stop bots from doing Restart() during possession
    C.Possess(self);
    C.bVehicleTransition = false;
    DrivingStatusChanged();
    Level.Game.DriverEnteredVehicle(self, P);
    Driver.bSetPCRotOnPossess = false; // so when player gets out, he'll be facing the same direction as he was in the vehicle
    UpdateVehicleLockOnPlayerEntering(self); // ADDED to tell our vehicle to check & update any vehicle lock settings as new player has entered

    // Bot code
    StuckCount = 0;

    if (IsHumanControlled())
    {
        VehicleLostTime = 0.0;
    }
    else if (bEngineOff) // ADDED so bot starts engine
    {
        ServerStartEngine();
    }
}

// Modified to work around various net client problems caused by replication timing issues
// Also to avoid playing engine start up force feedback, as we don't start the engine when player enters
// And to add engine start/stop hint, to enforce bDesiredBehindView=false (avoids a view rotation bug), & to cleanly handle player's initial view rotation
simulated function ClientKDriverEnter(PlayerController PC)
{
    local DHPlayer DHP;

    // Fix possible replication timing problems on a net client
    if (Role < ROLE_Authority && PC != none)
    {
        // Server passed the PC with this function, so we can safely set new Controller here, even though may take a little longer for new Controller value to replicate
        // And we know new Owner will also be the PC & new net Role will AutonomousProxy, so we can set those too, avoiding problems caused by variable replication delay
        // e.g. DrawHUD() can be called before Controller is replicated; SwitchMesh() may fail because new Role isn't received until later
        Controller = PC;
        SetOwner(PC);
        Role = ROLE_AutonomousProxy;

        // Fix for possible camera problem when deploying into spawn vehicle (see notes in DHVehicleWeaponPawn.ClientKDriverEnter)
        if (PC.IsInState('Spectating'))
        {
            PC.GotoState('PlayerWalking');
        }
    }

    bDesiredBehindView = false; // may be true in user.ini config file if player exited game while in behind view in same vehicle (config values change class defaults)

    FPCamPos = default.FPCamPos;

    SavedPositionIndex = InitialPositionIndex; // ADDED
    PendingPositionIndex = InitialPositionIndex;

    if (!bDontUsePositionMesh)
    {
        GotoState('EnteringVehicle');
    }

    // REMOVED as player's rotation always gets zeroed in the Super so he starts facing forwards (due to bZeroPCRotOnEntry)
    // Player's rotation is now always relative to the vehicle (& in POVChanged() we no longer alter his rotation to make it relative)
//  if (!bDesiredBehindView)
//      PC.SetRotation(Rotation);

    StoredVehicleRotation = Rotation;

    // Hints re engine start/stop & use of deploy vehicles
    DHP = DHPlayer(PC);

    if (DHP != none)
    {
        DHP.QueueHint(40, true);
    }

    super(Vehicle).ClientKDriverEnter(PC);
}

// Modified to use InitialPositionIndex & to play BeginningIdleAnim on internal mesh when entering vehicle
simulated state EnteringVehicle
{
    simulated function HandleEnter()
    {
        SwitchMesh(InitialPositionIndex);

        if (HasAnim(BeginningIdleAnim))
        {
            PlayAnim(BeginningIdleAnim); // shouldn't actually be necessary, but a reasonable fail-safe
        }

        SetViewFOV(InitialPositionIndex);
    }
}

// Modified to avoid starting exhaust & dust effects just because we got in - now we need to wait until the engine is started
// Also to play neutral idle animation for all modes, so players see things like closed hatches & also any collision stuff is re-set (including on server)
// We no longer disable Tick when driver exits, as vehicle may still be moving & dust effects need updating as vehicle slows
// Instead we disable Tick at the end of Tick itself, if vehicle isn't moving & has no driver
simulated event DrivingStatusChanged()
{
    if (bDriving)
    {
        Enable('Tick'); // necessary even if engine is off, if we have a driver, to prevent vehicle from being driven
    }
    else if (HasAnim(BeginningIdleAnim))
    {
        PlayAnim(BeginningIdleAnim);
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  *************************** CHANGING DRIVER POSITION *************************** //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to avoid wasting network resources by calling ServerChangeViewPoint on the server when it isn't valid
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
        PendingPositionIndex = DriverPositionIndex - 1;
        ServerChangeViewPoint(false);
    }
}

// Modified to call NextViewPoint() for all modes, including dedicated server
// New player hit detection system (basically using normal hit detection as for an infantry player pawn) relies on server playing same animations as net clients
// Server also needs to be in state ViewTransition if player is unbuttoning to prevent player exiting until fully unbuttoned
function ServerChangeViewPoint(bool bForward)
{
    if (bForward)
    {
        if (DriverPositionIndex < (DriverPositions.Length - 1))
        {
            PreviousPositionIndex = DriverPositionIndex;
            DriverPositionIndex++;
            NextViewPoint();
        }
    }
    else
    {
        if (DriverPositionIndex > 0)
        {
            PreviousPositionIndex = DriverPositionIndex;
            DriverPositionIndex--;
            NextViewPoint();
        }
    }
}

// Modified so dedicated server doesn't go to state ViewTransition if player is only moving between unexposed positions
// This is because player can't be shot & so server doesn't need to play transition anims (note this wouldn't even be called on dedicated server in original RO)
simulated function NextViewPoint()
{
    if (Level.NetMode != NM_DedicatedServer || DriverPositions[DriverPositionIndex].bExposed || DriverPositions[PreviousPositionIndex].bExposed)
    {
        GotoState('ViewTransition');
    }
}

// Modified to enable or disable player's hit detection when moving to or from an exposed position, to use Sleep to control exit from state,
// to add handling of FOV changes & better handling of locked camera, to avoid switching mesh & FOV if in behind view, & to avoid unnecessary stuff on a server
simulated state ViewTransition
{
    simulated function HandleTransition()
    {
        local PlayerController PC;

        if (IsFirstPerson())
        {
            PC = PlayerController(Controller);

            // Switch to mesh for new position as may be different
            // Note added IsFirstPerson() check stops this on dedicated server or on listen server host that's not controlling this vehicle
            SwitchMesh(DriverPositionIndex);

            // Unless moving onto an overlay position, apply any zoom for the new position now
            // If we are moving onto an overlay position, we instead leave it to end of the transition
            if (!DriverPositions[DriverPositionIndex].bDrawOverlays)
            {
                PC.DesiredFOV = GetViewFOV(DriverPositionIndex); // set DesiredFOV so any zoom change gets applied smoothly
            }
        }

        if (Driver != none)
        {
            // If moving to an exposed position, enable the driver's hit detection
            if (DriverPositions[DriverPositionIndex].bExposed && !DriverPositions[PreviousPositionIndex].bExposed && ROPawn(Driver) != none)
            {
                ROPawn(Driver).ToggleAuxCollision(true);
            }

            // Play any transition animation for the driver
            if (Driver.HasAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim) && Driver.HasAnim(DriverPositions[PreviousPositionIndex].DriverTransitionAnim))
            {
                Driver.PlayAnim(DriverPositions[DriverPositionIndex].DriverTransitionAnim);
            }
        }

        // Play any transition animation for the vehicle itself & set a duration to control when we exit this state
        ViewTransitionDuration = 0.0; // start with zero in case we don't have a transition animation

        if (PreviousPositionIndex < DriverPositionIndex)
        {
            if (HasAnim(DriverPositions[PreviousPositionIndex].TransitionUpAnim))
            {
                PlayAnim(DriverPositions[PreviousPositionIndex].TransitionUpAnim);
                ViewTransitionDuration = GetAnimDuration(DriverPositions[PreviousPositionIndex].TransitionUpAnim);
            }
        }
        else if (HasAnim(DriverPositions[PreviousPositionIndex].TransitionDownAnim))
        {
            PlayAnim(DriverPositions[PreviousPositionIndex].TransitionDownAnim);
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
        if (IsFirstPerson())
        {
            // If we've finished moving onto an overlay position, now snap to any zoom setting or camera offset it has (we avoiding doing this earlier)
            if (DriverPositions[DriverPositionIndex].bDrawOverlays)
            {
                SetViewFOV(DriverPositionIndex);
            }

            // If camera was locked to PlayerCameraBone during transition, match rotation to that now, so the view can't snap to another rotation
            if (bLockCameraDuringTransition && ViewTransitionDuration > 0.0)
            {
                Controller.SetRotation(rotator(vector(GetBoneRotation(PlayerCameraBone)) << Rotation)); // camera bone rotation, made relative to vehicle
            }
        }

        // If moving to an unexposed position, disable the driver's hit detection
        if (!DriverPositions[DriverPositionIndex].bExposed && DriverPositions[PreviousPositionIndex].bExposed && ROPawn(Driver) != none)
        {
            ROPawn(Driver).ToggleAuxCollision(false);
        }
    }

Begin:
    HandleTransition();
    Sleep(ViewTransitionDuration);
    GotoState('');
}

///////////////////////////////////////////////////////////////////////////////////////
//  ******************************** VEHICLE EXIT  ********************************* //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to add clientside pre-checks before sending the function call to the server
// Optimises network performance generally & specifically avoids a rider camera bug when unsuccessfully trying to switch to another vehicle position
simulated function SwitchWeapon(byte F)
{
    if (Role == ROLE_Authority || CanSwitchToVehiclePosition(F))
    {
        ServerChangeDriverPosition(F);
    }
}

// Modified to add checks before trying to switch position, to make sure the player isn't going to be prevented from entering the new position
// Also to record the controller in the DHPawn (as SwitchingController), which is now now required by the new vehicle position's KDriverEnter()
// Exiting player no longer briefly re-possesses player pawn before trying to enter new vehicle position, so DHPawn passed in to KDriverEnter() has no Controller
// And we now call KDriverEnter() directly, instead of TryToDrive(), as we've already checked & verified the player can switch
// Generally re-factored to avoid repeating any of the same checks & to reduce repetition & make clearer
function ServerChangeDriverPosition(byte F)
{
    local DHPawn            SwitchingPlayer, Bot;
    local VehicleWeaponPawn WeaponPawn;

    SwitchingPlayer = DHPawn(Driver);

    if (SwitchingPlayer == none || !CanSwitchToVehiclePosition(F))
    {
        return; // can't switch if fails any of these checks
    }

    WeaponPawn = WeaponPawns[F - 2];

    if (WeaponPawn != none)
    {
        // If human player wants to switch to a bot's position, make the bot swap with him
        if (AIController(WeaponPawn.Controller) != none)
        {
            Bot = DHPawn(WeaponPawn.Driver);

            if (Bot != none)
            {
                Bot.SetSwitchingController(WeaponPawn.Controller);
                WeaponPawn.KDriverLeave(true); // kicks bot out
            }
        }

        // Switch player to new vehicle weapon position
        // We record our controller as the SwitchingController, which is now required by the new vehicle position's KDriverEnter()
        // And we now call KDriverEnter() directly, instead of TryToDrive(), as we've already checked & verified the player can switch
        SwitchingPlayer.SetSwitchingController(Controller);
        KDriverLeave(true);
        WeaponPawn.KDriverEnter(SwitchingPlayer);

        if (Bot != none)
        {
            KDriverEnter(Bot); // if we kicked a bot out of the target position, now switch it into this position
        }
    }
}

// New helper function to check whether player is able to switch to new vehicle position
// Avoids (1) net client sending unnecessary replicated function calls to server, & (2) player exiting current position to unsuccessfully try to enter new position
// We make sure player isn't trying to 'teleport' outside to external rider position while buttoned up, or to enter any position already occupied by another human player,
// or a tank crew position he can't use, including in an armored vehicle that he's locked out of (although shouldn't be an issue as he's already in the driver position)
simulated function bool CanSwitchToVehiclePosition(byte F)
{
    F -= 2; // adjust passed F to selected weapon pawn index (e.g. pressing 2 for turret position ends up with F=0 for weapon pawn no.0)

    // Can't switch if player has selected an invalid weapon pawn position
    // Note if player presses 0 or 1, which are invalid choices, the F byte ends up as 254 or 255 & so fails this check (which is what we want)
    if (F >= WeaponPawns.Length)
    {
        return false;
    }

    // Can't switch if player selected a rider position on an armored vehicle, but is buttoned up (no 'teleporting' outside to external rider position) - gives message
    if (IsA('DHArmoredVehicle') && F >= FirstRiderPositionIndex && !CanExit())
    {
        return false;
    }

    // Note on a net client we probably won't get a weapon pawn reference for an unoccupied rider pawn, as actor doesn't usually exist on a client
    // But that's fine because there's nothing we need to check for an unoccupied rider pawn & we can always switch to it if we got here
    // If we let the switch go ahead, the rider pawn will get replicated to the owning net client as the player enters it on the server
    if (WeaponPawns[F] != none)
    {
        if (WeaponPawns[F].IsA('ROVehicleWeaponPawn') && ROVehicleWeaponPawn(WeaponPawns[F]).bMustBeTankCrew)
        {
            // Can't switch if player has selected a tank crew position but isn't a tank crew role
            if (!class'DHPlayerReplicationInfo'.static.IsPlayerTankCrew(self) && IsHumanControlled())
            {
                DisplayVehicleMessage(0); // not qualified to operate vehicle

                return false;
            }

            // Can't switch to a tank crew position in an armored vehicle if it's been locked & player isn't an allowed crewman (gives message)
            // We DO NOT apply this check to a net client, as it doesn't have the required variables (bVehicleLocked & CrewedLockedVehicle)
            if (Role == ROLE_Authority && AreCrewPositionsLockedForPlayer(self))
            {
                return false;
            }
        }

        // Can't switch if new vehicle position already has a human occupant
        // bDriving check is there to also catch 'LeaveBody' debug pawns, which won't have a PRI, stopping player switching into same position as one
        if (WeaponPawns[F].bDriving && !(WeaponPawns[F].PlayerReplicationInfo != none && WeaponPawns[F].PlayerReplicationInfo.bBot))
        {
            return false;
        }
    }

    return true;
}

// Modified so if player is only switching vehicle positions, he no longer briefly re-possesses his player pawn before trying to enter the new vehicle position
// And to remove overlap with DriverDied(), moving common features into DriverLeft(), which gets called by both functions, & to remove some redundancy
// Also to prevent exit if player is buttoned up, to show a message if no valid exit can be found, & to give player the same momentum as the vehicle when exiting
function bool KDriverLeave(bool bForceLeave)
{
    local Controller SavedController;
    local vector     ExitVelocity;
    local bool       bSwitchingVehiclePosition;

    // Prevent exit from vehicle if player is buttoned up (or if game type or mutator prevents exit)
    if (!bForceLeave && (!CanExit() || (Level.Game != none && !Level.Game.CanLeaveVehicle(self, Driver))))
    {
        return false;
    }

    bSwitchingVehiclePosition = bForceLeave && DHPawn(Driver) != none && DHPawn(Driver).SwitchingController != none;

    // Find an exit location for the player & try to move him there, unless we're only switching vehicle position
    if (!bSwitchingVehiclePosition && Driver != none && (!bRemoteControlled || bHideRemoteDriver))
    {
        Driver.bHardAttach = false;
        Driver.bCollideWorld = true;
        Driver.SetCollision(true, true);

        // If we couldn't move player to an exit location & we're not forcing exit, leave him inside (restoring his attachment & collision properties)
        if (!PlaceExitingDriver() && !bForceLeave)
        {
            Driver.bHardAttach = true;
            Driver.bCollideWorld = false;
            Driver.SetCollision(false, false);
            DisplayVehicleMessage(13); // no exit can be found (added)

            return false;
        }
    }

    // Exit is successful, so stop controlling this vehicle pawn
    if (Controller != none)
    {
        if (Controller.RouteGoal == self)
        {
            Controller.RouteGoal = none;
        }

        if (Controller.MoveTarget == self)
        {
            Controller.MoveTarget = none;
        }

        SavedController = Controller; // save because Unpossess() will clear our reference
        Controller.UnPossess();

        // If player is actually exiting the vehicle, not just switching positions, take control of the exiting player pawn
        // We now skip this block if only switching, so we no longer briefly re-possess the player pawn
        if (!bSwitchingVehiclePosition && Driver != none && Driver.Health > 0)
        {
//          Driver.SetOwner(SavedController); // removed as gets set anyway in the possession process
            SavedController.bVehicleTransition = true; // to stop bots from doing Restart() during possession
            SavedController.Possess(Driver);
            SavedController.bVehicleTransition = false;

            if (SavedController.IsA('PlayerController'))
            {
                PlayerController(SavedController).ClientSetViewTarget(Driver); // set PlayerController to view the person that got out
            }
        }

        if (Controller == SavedController) // if our Controller somehow didn't change, clear it
        {
            Controller = none;
        }
    }

    if (Driver != none)
    {
        Instigator = Driver; // so if vehicle continues on & hits something, the old driver is responsible for any damage caused

        // Update exiting player pawn if he has actually left the vehicle
        if (!bSwitchingVehiclePosition)
        {
            Driver.bSetPCRotOnPossess = Driver.default.bSetPCRotOnPossess; // undo temporary change made when entering vehicle
            Driver.StopDriving(self);

            // Give a player exiting the vehicle the same momentum as vehicle, with a little added height kick
            ExitVelocity = Velocity;
            ExitVelocity.Z += 60.0;
            Driver.Velocity = ExitVelocity;
        }
        // Or if human player has only switched vehicle position, we just set PlayerStartTime, telling bots not to enter this vehicle position for a little while
        // This is the only line that's relevant from StopDriving(), as we're no longer calling that if only switching position
        else if (PlayerController(SavedController) != none)
        {
            PlayerStartTime = Level.TimeSeconds + 12.0;
        }
    }

    DriverLeft();

    return true;
}

// Modified to remove overlap with KDriverLeave(), moving common features into DriverLeft(), which gets called by both functions, & to remove some redundancy
// Also made it so function progresses to call DriverLeft() even if has no Controller, which specifically works with the LeaveBody() debug exec
function DriverDied()
{
    local Controller SavedController;

    if (Driver != none)
    {
        Level.Game.DiscardInventory(Driver);
        Driver.StopDriving(self);
        Driver.Controller = Controller;
        Driver.DrivenVehicle = self; // for in game stats, so it knows player was killed inside a vehicle

        if (Controller != none)
        {
            if (IsHumanControlled()) // set PlayerController to view the dead driver
            {
                Controller.SetLocation(Location);
                PlayerController(Controller).SetViewTarget(Driver);
                PlayerController(Controller).ClientSetViewTarget(Driver);
            }

            SavedController = Controller; // save because Unpossess() will clear our reference
            Controller.Unpossess();

            if (Controller == SavedController) // if our Controller didn't change, clear it
            {
                Controller = none;
            }

            SavedController.Pawn = Driver;
        }
    }

    DriverLeft();
}

// Modified to add common features from KDriverLeave() & DriverDied(), which both call this function
// Unlike RO, we avoid playing engine shut down sound when leaving vehicle
function DriverLeft()
{
    Throttle = 0.0;
    Steering = 0.0;
    Rise = 0.0;

    Level.Game.DriverLeftVehicle(self, Driver);
    Driver = none;
    bDriving = false;
    DrivingStatusChanged();

    if (Health > 0)
    {
        DriverPositionIndex = InitialPositionIndex;
        PreviousPositionIndex = InitialPositionIndex;

        MaybeDestroyVehicle(); // checks if vehicle is now empty & may set a timer to destroy later
    }
}

// Modified to stop any engine shut down force feedback if player exits just after switching off engine & the FF is still playing (he's exited so he shouldn't feel it)
simulated function ClientKDriverLeave(PlayerController PC)
{
    super.ClientKDriverLeave(PC);

    if (PC != none && PC.bEnableGUIForceFeedback)
    {
        PC.StopForceFeedback(ShutDownForce);
    }
}

// New function to check if player can exit - implement in subclass as required
simulated function bool CanExit()
{
    return true;
}

// Modified to use new, simplified system with exit positions for all vehicle positions included in the vehicle class default properties
// Also to trace from player's actual world location, with a smaller trace extent so player is less likely to snag on objects that wouldn't really block his exit
function bool PlaceExitingDriver()
{
    local vector Extent, ZOffset, ExitPosition, HitLocation, HitNormal;
    local int    i;

    if (Driver == none)
    {
        return false;
    }

    // Set extent & ZOffset, using a smaller extent than original
    Extent.X = Driver.default.DrivingRadius;
    Extent.Y = Driver.default.DrivingRadius;
    Extent.Z = Driver.default.DrivingHeight;
    ZOffset.Z = Driver.default.CollisionHeight * 0.5;

    for (i = 0; i < AbsoluteExitPositions.Length; ++i)
    {
        ExitPosition = Location;

        if (Driver.SetLocation(ExitPosition))
        {
            return true;
        }
    }

    // Check through exit positions to see if player can be moved there, using the 1st valid one we find
    for (i = 0; i < ExitPositions.Length; ++i)
    {
        ExitPosition = Location + (ExitPositions[i] >> Rotation) + ZOffset;

        if (Trace(HitLocation, HitNormal, ExitPosition, Driver.Location + ZOffset - Driver.default.PrePivot, false, Extent) == none
            && Trace(HitLocation, HitNormal, ExitPosition, ExitPosition + ZOffset, false, Extent) == none
            && Driver.SetLocation(ExitPosition))
        {
            return true;
        }
    }

    return false;
}

function array<vector> GetExitPositions()
{
    return self.ExitPositions;
}

///////////////////////////////////////////////////////////////////////////////////////
//  ************************* ENGINE START/STOP & EFFECTS ************************** //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to use fire button to start or stop engine
simulated function Fire(optional float F)
{
    // Clientside checks to prevent unnecessary replicated function call to server if invalid (including clientside time check)
    if (Role == ROLE_Authority || (Throttle == 0.0 && (Level.TimeSeconds - IgnitionSwitchTime) > default.IgnitionSwitchInterval))
    {
        ServerStartEngine();
    }
}

// Server side function called to switch engine on/off
function ServerStartEngine()
{
    local bool bFirstTimeStarted;

    // Throttle must be zeroed & also a time check so people can't spam the ignition switch
    if (Throttle == 0.0 && (Level.TimeSeconds - IgnitionSwitchTime) > default.IgnitionSwitchInterval)
    {
        bFirstTimeStarted = IgnitionSwitchTime == 0.0; // if IgnitionSwitchTime never been set this must be the 1st engine start
        IgnitionSwitchTime = Level.TimeSeconds;

        // Engine won't start if it's dead
        // Also a random chance of temporary failure each time when trying to re-start an engine that has been switched off (engine doesn't turn over the 1st time)
        // Random failure not applied the 1st time vehicle is entered & started (typically when deploying into a spawned vehicle), only when trying to re-start
        // Same non-start sound suits both situations
        if (EngineHealth <= 0 || (bEngineOff && !bFirstTimeStarted && EngineRestartFailChance > 0.0 && FRand() < EngineRestartFailChance))
        {
            PlaySound(DamagedStartUpSound, SLOT_None, 2.0);
        }
        // Otherwise toggle the engine on or off, with appropriate sound
        else
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
        }
    }
}

// New function to set the engine properties & effects, based on whether engine is on & if it's damaged
simulated function SetEngine()
{
    // Engine off
    if (bEngineOff || Health <= 0 || EngineHealth <= 0)
    {
        TurnDamping = 0.0;

        // If engine is dead then start a fire
        if (IsVehicleBurning())
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

        if (ShutDownForce != "")
        {
            ClientPlayForceFeedback(ShutDownForce); // built in checks mean FF only plays for local player & only if he has it enabled
        }
    }
    // Engine on
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

        if (StartUpForce != "")
        {
            ClientPlayForceFeedback(StartUpForce);
        }
    }
}

// New function to spawn exhaust & wheel dust emitters
simulated function StartEmitters()
{
    local PlayerController PC;
    local coords           WheelCoords;
    local bool             bLowDetail;
    local int              i;

    if (Level.NetMode != NM_DedicatedServer)
    {
        // Update bDropDetail, which if true will avoid dust & exhaust emitters as unnecessary detail
        // Note - won't drop detail if player's ViewTarget is the vehicle or anything joined to it, including a VehicleWeaponPawn (will be the case for player in a vehicle position)
        if (Level.bDropDetail || Level.DetailMode == DM_Low)
        {
            PC = Level.GetLocalPlayerController();

            if (PC != none && (PC.ViewTarget == none || !PC.ViewTarget.IsJoinedTo(self)))
            {
                bDropDetail = true;

                return;
            }

            bLowDetail = true; // we may not be dropping detail, but we've established that we're on low detail settings, so we'll use this later to avoid checking again
        }

        bDropDetail = false;

        // Create wheel dust emitters
        Dust.Length = Wheels.Length;

        for (i = 0; i < Wheels.Length; ++i)
        {
            if (Dust[i] != none)
            {
                Dust[i].Destroy();
            }

            WheelCoords = GetBoneCoords(Wheels[i].BoneName);
            Dust[i] = Spawn(class'VehicleWheelDustEffect', self,, WheelCoords.Origin + ((vect(0.0, 0.0, -1.0) * Wheels[i].WheelRadius) >> Rotation));
            Dust[i].CullDistance = 12000; // ~200m

            if (bLowDetail)
            {
                Dust[i].MaxSpritePPS = 3;
                Dust[i].MaxMeshPPS = 3;
                Dust[i].CullDistance = 5000;
            }

            Dust[i].SetBase(self);

            // Boat vehicle uses different 'dirt' colour (white-grey) to simulate a spray effect instead of the usual wheel dust
            // This also forces vehicles in snow camo skins to use the white-grey dust, which should save levelers from forgetting to set the correct color on Winter maps
            if (IsA('DHBoatVehicle') || bIsWinterVariant)
            {
                Dust[i].SetDirtColor(Level.WaterDustColor);
            }
            else
            {
                Dust[i].SetDirtColor(Level.DustColor);
            }
        }

        // Create exhaust emitters
        for (i = 0; i < ExhaustPipes.Length; ++i)
        {
            if (ExhaustPipes[i].ExhaustEffect != none)
            {
                ExhaustPipes[i].ExhaustEffect.Destroy();
            }

            if (bLowDetail)
            {
                ExhaustPipes[i].ExhaustEffect = Spawn(ExhaustEffectLowClass, self,, Location + (ExhaustPipes[i].ExhaustPosition >> Rotation), ExhaustPipes[i].ExhaustRotation + Rotation);
            }
            else
            {
                ExhaustPipes[i].ExhaustEffect = Spawn(ExhaustEffectClass, self,, Location + (ExhaustPipes[i].ExhaustPosition >> Rotation), ExhaustPipes[i].ExhaustRotation + Rotation);
                ExhaustPipes[i].ExhaustEffect.CullDistance = 12000; // ~200m
            }

            ExhaustPipes[i].ExhaustEffect.SetBase(self);

            // If we don't have a driver, we do a nil update that just sets the lowest exhaust setting for an idling engine
            // Note - don't need to do anything if we do have a driver, as Tick will be enabled & exhaust will get updated anyway, based on vehicle speed
            if (!bDriving)
            {
                ExhaustPipes[i].ExhaustEffect.UpdateExhaust(0.0);
            }
        }

        bEmittersOn = true;
    }
}

// New function to kill exhaust & wheel dust emitters
simulated function StopEmitters()
{
    local int i;

    if (Level.NetMode != NM_DedicatedServer)
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
    bDropDetail = true; // an optimisation as makes the Super in Tick skip over updating dust & exhaust emitters
}

///////////////////////////////////////////////////////////////////////////////////////
//  *********************************  DAMAGE  ************************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to handle possible tread damage, to add randomised damage, & to add engine fire to APCs
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    local class<ROWeaponDamageType> WepDamageType;
    local Controller InstigatorController;
    local float      DamageModifier, TreadDamageMod;
    local int        InstigatorTeam, i;

    // Suicide/self-destruction
    if (DamageType == class'Suicided' || DamageType == class'ROSuicided')
    {
        super(Vehicle).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, class'ROSuicided');

        return;
    }

    // Quick fix for the vehicle giving itself impact damage
    if (InstigatedBy == self)
    {
        return;
    }

    // Why take more damage if already dead??? (this might fix a bug where vehicles were being "seemingly" being exploded multiple times)
    if (Health <= 0)
    {
        return;
    }

    // Check for friendly damage
    if (InstigatedBy != none)
    {
        InstigatorController = InstigatedBy.Controller;

        if (InstigatorController == none && DamageType.default.bDelayedDamage)
        {
            InstigatorController = DelayedDamageInstigatorController;
        }

        if (InstigatorController != none)
        {
            InstigatorTeam = InstigatorController.GetTeamNum();

            // Is this friendly damage
            if (GetTeamNum() != 255 && InstigatorTeam != 255 && GetTeamNum() == InstigatorTeam)
            {
                // Inform the instigator they are doing something wrong
                if (PlayerController(InstigatorController) != none)
                {
                    PlayerController(InstigatorController).ClientPlaySound(Sound'DHMenuSounds.BuzzBuzz',,, SLOT_Interface);
                }

                // If no one has ever entered the vehicle, then don't allow team damage
                if (!bDriverAlreadyEntered)
                {
                    return;
                }
            }
        }
    }

    // Apply damage modifier from the DamageType, plus a little damage randomisation
    WepDamageType = class<ROWeaponDamageType>(DamageType);

    if (WepDamageType != none)
    {
        if (bIsApc)
        {
            DamageModifier = WepDamageType.default.APCDamageModifier;
        }
        else
        {
            DamageModifier = WepDamageType.default.VehicleDamageModifier;
        }

        DamageModifier *= RandRange(0.75, 1.08);

        if (bHasTreads)
        {
            TreadDamageMod = WepDamageType.default.TreadDamageModifier;
        }
    }

    Damage *= DamageModifier;

    // If damage is less than 1 AND this is NOT a vehicle with damageable wheels, exit
    // The fucntion will exit shortly, but only after we check if the hit was on a wheel (this is for APCs with damageable wheels like HTs)
    // This is useful as we don't have to call IsPointShot() for vehicles without damagable wheels when damage is <1 (which will be quite often)
    if (Damage < 1 && !HasDamageableWheels())
    {
        return;
    }

    // Check RO VehHitpoints (engine, ammo)
    // Note driver hit check is deprecated as we use a new player hit detection system, which basically uses normal hit detection as for an infantry player pawn
    for (i = 0; i < VehHitpoints.Length; ++i)
    {
        if (IsPointShot(HitLocation, Momentum, 1.0, i))
        {
            // Okay if damage is < 1 AND its not a "wheel" hit, then continue to the next, otherwise continue
            if (Damage < 1 && VehHitpoints[i].HitPointType != HP_Driver)
            {
                continue;
            }

            // Engine hit
            if (VehHitpoints[i].HitPointType == HP_Engine)
            {
                if (bDebuggingText)
                {
                    Log("Hit vehicle engine");
                }

                DamageEngine(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
            }
            // Hit ammo store
            else if (VehHitpoints[i].HitPointType == HP_AmmoStore)
            {
                if (bDebuggingText)
                {
                    Log("Hit vehicle ammo store");
                }

                Damage *= VehHitpoints[i].DamageMultiplier;
                break;
            }
            // Hit wheels (uses a deprecated "driver" hit point type)
            else if (VehHitpoints[i].HitPointType == HP_Driver)
            {
                if (bDebuggingText)
                {
                    Log("Hit vehicle wheel");
                }

                // If wheel takes enough damage, vehicle has wheel damage
                if (!bWheelsAreDamaged)
                {
                    bWheelsAreDamaged = true;
                }
            }
        }
    }

    // Check damage again, this time without acception for wheels
    if (Damage < 1)
    {
        return;
    }

    // Check if we hit & damaged either track
    if (bHasTreads && TreadDamageMod >= TreadDamageThreshold)
    {
        CheckTreadDamage(HitLocation, Momentum);
    }

    if (InstigatedBy != none && InstigatedBy != self)
    {
        LastHitBy = InstigatedBy.Controller;
        LastHitByDamageType = DamageType;
    }

    if (bDebuggingText)
    {
        Log("Damaging vehicle with:" @ Damage);
    }

    // Call the Super from Vehicle (skip over others)
    super(Vehicle).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);

    // If a vehicle's health is lower than DamagedEffectHealthFireFactor OR
    // If the vehicle is APC or Treaded and is empty and damage is significant, just set fire the engine (and spike the vehicle)
    // Theel TODO: "significant" damage should be based on something
    if ((Health <= (default.HealthMax * default.DamagedEffectHealthFireFactor) && Health > 0) ||
        ((bHasTreads || bIsApc) && IsVehicleEmpty() && Damage >= 100))
    {
        if (bDebuggingText)
        {
            Log("Setting fire to spike the vehicle as significant damage was done.");
        }

        EngineHealth = 0;
        bSpikedVehicle = true;
        SetSpikeTimer();
        SetEngine();
    }
}

// New function to remove lengthy functionality from the already very long TakeDamage() function
// Uses new method for track hit detection that works properly - TreadHitMaxHeight is the height (in Unreal units) of the top of tracks above hull mesh origin
// Problem with original RO method (TreadHitMinAngle) was the InAngle calculation was distorted by the position of the hit along the vehicle mesh's X axis
// New method is simpler & works, producing consistent results along the length of the hull
function CheckTreadDamage(vector HitLocation, vector Momentum)
{
    local vector HitLocationRelativeOffset, X, RightSidePerp, Z;
    local float  HitDirectionDegrees, InAngleDegrees;
    local string HitSide, OppositeSide;

    // Get the offset of the HitLocation from vehicle's centre, relative to vehicle's facing direction
    // If the hit's relative height (Z component) is above vehicle's TreadHitMaxHeight then it can't be a tread hit & we exit
    HitLocationRelativeOffset = (HitLocation - Location) << Rotation;

    if (HitLocationRelativeOffset.Z > TreadHitMaxHeight)
    {
        return;
    }

    // Calculate the angle direction of hit relative to vehicle's facing direction, so we can work out out which side was hit (a 'top down 2D' angle calc)
    // Convert hit offset to a rotator &, because it's relative, we can simply use the yaw element to give us the angle direction of hit, relative to vehicle
    // Must ignore relative height of hit (represented now by rotator's pitch) as isn't a factor in 'top down 2D' calc & would sometimes actually distort result
    HitDirectionDegrees = class'UUnits'.static.UnrealToDegrees(rotator(HitLocationRelativeOffset).Yaw);

    if (HitDirectionDegrees < 0.0)
    {
        HitDirectionDegrees += 360.0; // convert negative angles to 180 to 360 degree format
    }

    // Right side hit
    if (HitDirectionDegrees >= FrontRightAngle && HitDirectionDegrees < RearRightAngle)
    {
        HitSide = "Right"; // use strings instead of the obvious bools as they're useful in debugging text
        OppositeSide = "Left";
    }
    // Left side hit
    else if (HitDirectionDegrees >= RearLeftAngle && HitDirectionDegrees < FrontLeftAngle)
    {
        HitSide = "Left";
        OppositeSide = "Right";
    }
    // Didn't hit left or right side, so not a hit on treads
    else
    {
        return;
    }

    // Check for 'hit bug', where a projectile may pass through the 1st face of vehicle's collision & be detected as a hit on the opposite side (on the way out)
    // Calculate incoming angle of the shot, relative to a perpendicular line from the side we think we hit
    // If the angle is too high it's impossible, so we do a crude fix by switching the hit to the opposite
    GetAxes(Rotation, X, RightSidePerp, Z);
    InAngleDegrees = class'UUnits'.static.RadiansToDegrees(Acos(Normal(-Momentum) dot RightSidePerp));

    if (HitSide == "Left")
    {
        InAngleDegrees = Abs(InAngleDegrees - 180.0); // correct angle for left hit, as we used the right side perpendicular
    }

    if (InAngleDegrees > 120.0)
    {
        if (bDebuggingText || class'DH_LevelInfo'.static.DHDebugMode())
        {
            Log("Hit detection bug - switching tread hit from" @ HitSide @ "to" @ OppositeSide @ "as 'in angle' to original side was" @ int(InAngleDegrees) @ "degrees");
        }

        HitSide = OppositeSide;
    }

    // Damage the track we hit, if it isn't already damaged
    if ((HitSide == "Right" && !bRightTrackDamaged) || (HitSide == "Left" && !bLeftTrackDamaged))
    {
        DestroyTrack(HitSide == "Left"); // passing true means left track damage

        if (bDebuggingText && Role == ROLE_Authority)
        {
            Log(HitSide @ "track destroyed (hit height =" @ HitLocationRelativeOffset.Z $ ")");
        }
    }
}

// Modified to damage engine if the vehicle bCanCrash & the impact damage exceeds its threshold
// Also to tone down the sounds played when the vehicle impacts on something, as often caused constant 'bottoming out' sounds on the ground
event TakeImpactDamage(float AccelMag)
{
    local int Damage;

    Damage = int(AccelMag * ImpactDamageModifier());
    TakeDamage(Damage, self, ImpactInfo.Pos, vect(0.0, 0.0, 0.0), class'DHVehicleCollisionDamageType');

    // Handle damage to engine if impact damage is past threshold & the vehicle bCanCrash
    if (bCanCrash && Damage > ImpactDamageThreshold)
    {
        DamageEngine(Damage * ImpactWorldDamageMult, self, ImpactInfo.Pos, vect(0.0, 0.0, 0.0), class'DHVehicleCollisionDamageType');
    }

    // Play impact sound (often vehicle 'bottoming out' on ground)
    // Modified to reduce sound radius so doesn't play across level, & limited sound occurrence to every second
    if (ImpactDamageSounds.Length > 0 && (Level.TimeSeconds - LastImpactSound) > 1.0)
    {
        PlaySound(ImpactDamageSounds[Rand(ImpactDamageSounds.Length - 1)], SLOT_None, TransientSoundVolume * 2.5, false, 120.0,, true);
        LastImpactSound = Level.TimeSeconds;
    }

    // Make vehicle explode if it's now dead
    if (Health < 0 && (Level.TimeSeconds - LastImpactExplosionTime) > TimeBetweenImpactExplosions)
    {
        VehicleExplosion(Normal(ImpactInfo.ImpactNorm), 0.5);
        LastImpactExplosionTime = Level.TimeSeconds;
    }
}

// Modified to kill engine if zero health
function DamageEngine(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
    // Don't let friendlies damage engines
    if (InstigatedBy != none && InstigatedBy.Controller != none && InstigatedBy.Controller.GetTeamNum() == GetTeamNum())
    {
        return;
    }

    // Apply new damage
    if (EngineHealth > 0)
    {
        Damage = Level.Game.ReduceDamage(Damage, self, InstigatedBy, HitLocation, Momentum, DamageType);
        EngineHealth -= Damage;
    }

    // Kill the engine if its health has now fallen to zero
    if (EngineHealth <= 0)
    {
        if (bDebuggingText)
        {
            Log("Engine is dead");
        }

        if (!bEngineOff)
        {
            bEngineOff = true;
            PlaySound(DamagedShutDownSound, SLOT_None, FClamp(Abs(Throttle), 0.3, 0.75));
        }

        // There is no point in calling SetEngine() if the vehicle is destroyed
        if (Health > 0)
        {
            SetEngine();
            MaybeDestroyVehicle();
        }
    }
}

function bool IsTreadInRadius(vector Location, out float Radius, out int TrackNum)
{
    local int           i;
    local coords        WheelCoords;
    local float         D;

    for (i = 0; i < Wheels.Length; ++i)
    {
        WheelCoords = GetBoneCoords(Wheels[i].BoneName);

        D = VSize(Location - WheelCoords.Origin);

        if (D < Radius)
        {
            Radius = D;
            TrackNum = int(Wheels[i].bLeftTrack);
            return true;
        }
    }

    return false;
}

function DamageTrack(int Damage, bool bLeftTrack)
{
    TrackHealth[int(bLeftTrack)] -= Damage;

    if (bDebuggingText)
    {
        if (bLeftTrack)
        {
            Log("Damaging the left track with" @ Damage @ "damage.");
        }
        else
        {
            Log("Damaging the right track with" @ Damage @ "damage.");
        }
    }

    if (TrackHealth[int(bLeftTrack)] <= 0)
    {
        DestroyTrack(bLeftTrack);
    }
}

function DestroyTrack(bool bLeftTrack)
{
    if (bLeftTrack)
    {
        bLeftTrackDamaged = true;
    }
    else
    {
        bRightTrackDamaged = true;
    }

    SetDamagedTracks();
}

// Emptied out as blast damage to exposed vehicle occupants is now handled from HurtRadius() in the projectile class
function DriverRadiusDamage(float DamageAmount, float DamageRadius, Controller EventInstigator, class<DamageType> DamageType, float Momentum, vector HitLocation)
{
}

// Modified to call Destroyed_HandleDriver(), the same as would happen in original UT2004 Vehicle code or a RO/DH VehicleWeaponPawn when vehicle is killed
// RO added this state in between when the vehicle is 'destroyed' in an everyday sense and when the Vehicle actor gets Destroyed()
// So this state needs to do certain things now that would normally happen in Destroyed(), instead of waiting for that to happen some time later
// The Driver is dead now so Destroyed_HandleDriver() is one of those things, but it isn't included
state VehicleDestroyed
{
ignores Tick;

    function BeginState()
    {
        if (Driver != none)
        {
            Destroyed_HandleDriver();
        }
    }
}

// Modified to randomise explosion damage (except for resupply vehicles) & to add DestroyedBurningSound
function VehicleExplosion(vector MomentumNormal, float PercentMomentum)
{
    local vector LinearImpulse, AngularImpulse;
    local float  ExplosionModifier;

    // Don't explode if vehicle is already exploded! (this fixes the stupid constantly exploding vehicle bug)
    if (ExplosionCount > 0)
    {
        return;
    }

    if (ResupplyAttachment != none)
    {
        ExplosionModifier = 1.0;
    }
    else
    {
        ExplosionModifier = FRand();
    }

    ExplosionCount++;
    HurtRadius(ExplosionDamage * ExplosionModifier, ExplosionRadius * ExplosionModifier, ExplosionDamageType, ExplosionMomentum, Location);
    AmbientSound = DestroyedBurningSound;
    SoundVolume = 255;
    SoundRadius = 300.0;

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

// Modified to prevent an already blown up vehicle from triggering an explosion on a net client, if the vehicle becomes net relevant & replicates to that client
// If vehicle has previously exploded, ExplosionCount will be 1, & when that replicates in the initial batch of variables, it triggers native code to call this function
// In that situation we just want to spawn the DestructionEffect, skipping the explosion sound & view shake
simulated event ClientVehicleExplosion(bool bFinal)
{
    local PlayerController PC;
    local float            Dist, Scale;

    // On net client, only do these things if bClientInitialized, meaning we haven't just received this actor through replication, so it must have just blown up
    if (bClientInitialized || Role == ROLE_Authority)
    {
        // View shake
        PC = Level.GetLocalPlayerController();

        if (PC != none && PC.ViewTarget != none)
        {
            Dist = VSize(Location - PC.ViewTarget.Location);

            if (Dist < (ExplosionRadius * 2.5))
            {
                if (Dist < ExplosionRadius)
                {
                    Scale = 1.0;
                }
                else
                {
                    Scale = ((ExplosionRadius * 2.5) - Dist) / ExplosionRadius;
                }

                PC.ShakeView(ShakeRotMag * Scale, ShakeRotRate, ShakeRotTime, ShakeOffsetMag * Scale, ShakeOffsetRate, ShakeOffsetTime);
            }
        }

        // Explosion sound
        if (ExplosionSounds.Length > 0)
        {
            PlaySound(ExplosionSounds[Rand(ExplosionSounds.Length)], SLOT_None, ExplosionSoundVolume * TransientSoundVolume,, ExplosionSoundRadius);
        }
    }

    // Spawn destroyed vehicle effect
    // If vehicle disintegrates (falls below DisintegrationHealth), this function gets called twice & two effects get spawned
    // The 1st call spawns a normal effect, but this is followed by a 2nd disintegration call (with bFinal), which spawns a disintegration effect
    // This is handled by native code so we can't change what happens - a fix is to destroy the 1st effect if a 2nd is going to be spawned
    if (DestructionEffect != none)
    {
        DestructionEffect.Destroy();
    }

    // Low detail effect
    if (Level.bDropDetail || Level.DetailMode == DM_Low)
    {
        if (bFinal)
        {
            DestructionEffect = Spawn(DisintegrationEffectLowClass, self,, Location, Rotation);
        }
        else
        {
            DestructionEffect = Spawn(DestructionEffectLowClass, self);
        }
    }
    // Standard detail effect
    else
    {
        if (bFinal)
        {
            DestructionEffect = Spawn(DisintegrationEffectClass, self,, Location, Rotation);
        }
        else
        {
            DestructionEffect = Spawn(DestructionEffectClass, self);
        }
    }

    DestructionEffect.LifeSpan = TimeTilDissapear;
    DestructionEffect.SetBase(self);
}

// Modified to make sure driver's health is no more than zero on a net client, in case that isn't replicated until later
// Health now affects collision handling in DHPawn's StopDriving() function
simulated function Destroyed_HandleDriver()
{
    if (Role < ROLE_Authority && Driver != none && Driver.Health > 0 && Driver.DrivenVehicle == self)
    {
        Driver.Health = 0;
    }

    super.Destroyed_HandleDriver();
}

function bool IsSpawnProtected()
{
    return SpawnProtEnds > Level.TimeSeconds;
}

function bool IsSpawnKillProtected()
{
    return SpawnKillTimeEnds > Level.TimeSeconds;
}

// Debug function to simulate a spawn kill happening on the vehicle
exec function DebugSpawnKill()
{
    if (Level.NetMode == NM_Standalone && SpawnPointAttachment != none)
    {
        SpawnPointAttachment.OnSpawnKill(None, None);
    }
}

// Modified to handle a turret's yaw bone being specified for a vehicle hit point, with any positional offset being based on turret's rotation
// Also optimised a little & PointHeight is deprecated (concerned head shot calcs that aren't relevant here)
function bool IsPointShot(vector HitLocation, vector LineCheck, float AdditionalScale, int Index, optional float CheckDistance)
{
    local coords HitPointCoords;
    local vector HitPointLocation, Difference;
    local float  t, DotMM, ClosestDistance;

    if (VehHitpoints[Index].PointBone == '')
    {
        return false;
    }

    // Get location of the hit point we're going to check
    if (Cannon != none && VehHitpoints[Index].PointBone == Cannon.YawBone)
    {
        HitPointCoords = Cannon.GetBoneCoords(VehHitpoints[Index].PointBone);
    }
    else
    {
        HitPointCoords = GetBoneCoords(VehHitpoints[Index].PointBone);
    }

    HitPointLocation = HitPointCoords.Origin;

    if (VehHitpoints[Index].PointOffset != vect(0.0, 0.0, 0.0))
    {
        HitPointLocation += VehHitpoints[Index].PointOffset >> rotator(HitPointCoords.XAxis);
    }

    // Set the hit line to check
    if (CheckDistance > 0.0)
    {
        LineCheck = Normal(LineCheck) * CheckDistance;
    }
    else
    {
        LineCheck *= 2.0 * (CollisionHeight + CollisionRadius); // TODO: this vector length adjustment is pretty meaningless & if a CheckDistance isn't specified only the direction matters
    }

    // Find closest distance of line check to hit point (all squared for now, for efficiency)
    Difference = HitPointLocation - HitLocation;
    t = LineCheck Dot Difference;

    if (t > 0.0) // if not positive it means line check is heading away from hit point, so distance is simply based on HitLocation as that's the closest point
    {
        DotMM = LineCheck dot LineCheck;

        if (t < DotMM)
        {
            t /= DotMM;
            Difference -= t * LineCheck;
        }
        else
        {
            Difference -= LineCheck;
        }
    }

    // Convert distance back from squared & return true if within the hit point's radius (including any scaling)
    ClosestDistance = Sqrt(Difference dot Difference);

    return ClosestDistance < (VehHitpoints[Index].PointRadius * VehHitpoints[Index].PointScale * AdditionalScale);
}

///////////////////////////////////////////////////////////////////////////////////////
//  *************************  SETUP, UPDATE, CLEAN UP  ***************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Modified to include Skins array (so no need to add manually in each subclass) & to add extra material properties & remove obsolete stuff
// Also removes all literal material references, so they aren't repeated again & again - instead they are pre-cached once in DarkestHourGame.PrecacheGameTextures()
static function StaticPrecache(LevelInfo L)
{
    local int i, j;

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

    for (i = 0; i < default.DestroyedMeshSkins.Length; ++i)
    {
        if (default.DestroyedMeshSkins[i] != none)
        {
            L.AddPrecacheMaterial(default.DestroyedMeshSkins[i]);
        }
    }

    for (i = 0; i < default.CannonSkins.Length; ++i)
    {
        if (default.CannonSkins[i] != none)
        {
            L.AddPrecacheMaterial(default.CannonSkins[i]);
        }
    }

    if (default.VehicleHudImage != none)
    {
        L.AddPrecacheMaterial(default.VehicleHudImage);
    }

    L.AddPrecacheMaterial(default.MPHMeterMaterial);
    L.AddPrecacheMaterial(default.DamagedTreadPanner);

    if (default.HighDetailOverlay != none)
    {
        L.AddPrecacheMaterial(default.HighDetailOverlay);
    }

    if (default.DestroyedVehicleMesh != none)
    {
        L.AddPrecacheStaticMesh(default.DestroyedVehicleMesh);
    }

    if (default.DamagedTrackStaticMeshLeft != none)
    {
        L.AddPrecacheStaticMesh(default.DamagedTrackStaticMeshLeft);
    }

    if (default.DamagedTrackStaticMeshRight != none)
    {
        L.AddPrecacheStaticMesh(default.DamagedTrackStaticMeshRight);
    }

    for (i = 0; i < default.VehicleAttachments.Length; ++i)
    {
        for (j = 0; j < default.VehicleAttachments[i].Skins.Length; ++j)
        {
            if (default.VehicleAttachments[i].Skins[j] != none)
            {
                L.AddPrecacheMaterial(default.VehicleAttachments[i].Skins[j]);
        }
        }

        if (default.VehicleAttachments[i].StaticMesh != none)
        {
            L.AddPrecacheStaticMesh(default.VehicleAttachments[i].StaticMesh);
        }
    }

    for (i = 0; i < default.RandomAttachOptions.Length; ++i)
    {
        if (default.RandomAttachOptions[i].StaticMesh != none)
        {
            L.AddPrecacheStaticMesh(default.RandomAttachOptions[i].StaticMesh);
        }
    }

    for (i = 0; i < default.CollisionAttachments.Length; ++i)
    {
        if (default.CollisionAttachments[i].StaticMesh != none)
        {
            L.AddPrecacheStaticMesh(default.CollisionAttachments[i].StaticMesh);
        }
    }
}

// Modified to removes all literal material references, so they aren't repeated again & again - instead they are pre-cached once in DarkestHourGame.PrecacheGameTextures()
// Also to add extra material properties & remove obsolete stuff
simulated function UpdatePrecacheMaterials()
{
    local int i, j;

    super(Actor).UpdatePrecacheMaterials(); // pre-caches the Skins array

    for (i = 0; i < DestroyedMeshSkins.Length; ++i)
    {
        if (DestroyedMeshSkins[i] != none)
        {
            Level.AddPrecacheMaterial(DestroyedMeshSkins[i]);
        }
    }

    for (i = 0; i < CannonSkins.Length; ++i)
    {
        if (CannonSkins[i] != none)
        {
            Level.AddPrecacheMaterial(CannonSkins[i]);
        }
    }

    Level.AddPrecacheMaterial(VehicleHudImage);
    Level.AddPrecacheMaterial(MPHMeterMaterial);
    Level.AddPrecacheMaterial(DamagedTreadPanner);

    if (HighDetailOverlay != none)
    {
        Level.AddPrecacheMaterial(HighDetailOverlay);
    }

    if (DestroyedVehicleMesh != none)
    {
        Level.AddPrecacheStaticMesh(DestroyedVehicleMesh);
    }

    if (DamagedTrackStaticMeshLeft != none)
    {
        Level.AddPrecacheStaticMesh(DamagedTrackStaticMeshLeft);
    }

    if (DamagedTrackStaticMeshRight != none)
    {
        Level.AddPrecacheStaticMesh(DamagedTrackStaticMeshRight);
    }

    for (i = 0; i < VehicleAttachments.Length; ++i)
    {
        for (j = 0; j < VehicleAttachments[i].Skins.Length; ++j)
        {
            if (VehicleAttachments[i].Skins[j] != none)
            {
                Level.AddPrecacheMaterial(VehicleAttachments[i].Skins[j]);
            }
        }
    }
}

simulated function UpdatePrecacheStaticMeshes()
{
    local int i;

    super.UpdatePrecacheStaticMeshes();

    for (i = 0; i < VehicleAttachments.Length; ++i)
    {
        if (VehicleAttachments[i].StaticMesh != none)
        {
            Level.AddPrecacheStaticMesh(VehicleAttachments[i].StaticMesh);
        }
    }

    for (i = 0; i < RandomAttachOptions.Length; ++i)
    {
        if (RandomAttachOptions[i].StaticMesh != none)
        {
            Level.AddPrecacheStaticMesh(RandomAttachOptions[i].StaticMesh);
        }
    }

    for (i = 0; i < CollisionAttachments.Length; ++i)
    {
        if (CollisionAttachments[i].StaticMesh != none)
        {
            Level.AddPrecacheStaticMesh(CollisionAttachments[i].StaticMesh);
        }
    }
}

// New function to spawn specific attachments & variety of possible generic vehicle attachments (which avoid need for subclassed common functionality & lots of instance variables)
simulated function SpawnVehicleAttachments()
{
    local VehicleAttachment VA;
    local class<Actor>      AttachClass;
    local Actor             A;
    local int               RandomNumber, CumulativeChance, i, j;

    // Treads & movement sound attachments
    if (Level.NetMode != NM_DedicatedServer)
    {
        if (bHasTreads)
        {
            SetupTreads();
        }

        if (EngineSound != none && EngineSoundBone != '' && EngineSoundAttach == none)
        {
            EngineSoundAttach = SpawnAttachment(class'ROSoundAttachment', EngineSoundBone);
            EngineSoundAttach.AmbientSound = EngineSound;
        }

        if (RumbleSound != none && RumbleSoundBone != '' && RumbleSoundAttach == none)
        {
            RumbleSoundAttach = SpawnAttachment(class'ROSoundAttachment', RumbleSoundBone);
            RumbleSoundAttach.AmbientSound = RumbleSound;
        }
    }

    if (Role == ROLE_Authority)
    {
        if (ResupplyAttachmentClass != none && ResupplyAttachmentBone != '' && ResupplyAttachment == none)
        {
            ResupplyAttachment = DHResupplyAttachment(SpawnAttachment(ResupplyAttachmentClass, ResupplyAttachmentBone));

            if (ResupplyAttachment != none)
            {
                ResupplyAttachment.SetTeamIndex(VehicleTeam);
            }
        }

        if (SupplyAttachmentClass != none && SupplyAttachmentBone != '' && SupplyAttachment == none)
        {
            SupplyAttachment = DHConstructionSupplyAttachment(SpawnAttachment(SupplyAttachmentClass, SupplyAttachmentBone,, SupplyAttachmentOffset, SupplyAttachmentRotation));

            if (SupplyAttachment != none)
            {
                SupplyAttachment.SetTeamIndex(VehicleTeam);
                SupplyAttachment.SetInitialSupply();
            }
        }

        if (MapIconAttachmentClass != none && SupplyAttachment == none)
        {
            MapIconAttachment = Spawn(MapIconAttachmentClass, self);

            if (MapIconAttachment != none)
            {
                MapIconAttachment.SetBase(self);
                MapIconAttachment.Setup();
                MapIconAttachment.SetTeamIndex(VehicleTeam);
            }
            else
            {
                MapIconAttachmentClass.static.OnError(ERROR_SpawnFailed);
            }
        }

        // If vehicle has possible random decorative attachments, select which one (if any at all, depending on specified chances)
        if (RandomAttachOptions.Length > 0 && RandomAttachmentIndex >= RandomAttachOptions.Length)
        {
            RandomNumber = RAND(100);

            for (i = 0; i < RandomAttachOptions.Length; ++i)
            {
                CumulativeChance += RandomAttachOptions[i].PercentChance;

                if (RandomNumber < CumulativeChance)
                {
                    RandomAttachmentIndex = i; // set replicated variable so clients know which random attachment to spawn
                    break;
                }
            }
        }
    }

    // If a valid random attachment type has been selected, copy it to the VehicleAttachments array, so it gets spawned next like a standard vehicle attachment
    if (RandomAttachmentIndex < RandomAttachOptions.Length && RandomAttachOptions[RandomAttachmentIndex].StaticMesh != none)
    {
        RandomAttachment.StaticMesh = RandomAttachOptions[RandomAttachmentIndex].StaticMesh;
        VehicleAttachments[VehicleAttachments.Length] = RandomAttachment;
    }

    // Spawn any decorative attachments
    for (i = 0; i < VehicleAttachments.Length; ++i)
    {
        VA = VehicleAttachments[i];

        // Spawn on a server only if attachment has collision, & only spawn if either has specified static mesh or a specified actor class
        if ((Level.NetMode != NM_DedicatedServer || VA.bHasCollision) && (VA.StaticMesh != none || VA.AttachClass != none))
        {
            // Default is base deco attachment class, but a specialised subclass can be specified if desired
            if (VA.AttachClass != none)
            {
                AttachClass = VA.AttachClass;
            }
            else
            {
                AttachClass = class'DHDecoAttachment';
            }

            A = SpawnAttachment(AttachClass, VA.AttachBone, VA.StaticMesh, VA.Offset);

            // Apply any specified options for static mesh, attachment bone, offset, or collision
            if (A != none)
            {
                for (j = 0; j < VA.Skins.Length; ++j)
                {
                    if (VA.Skins[j] != none)
                    {
                        A.Skins[j] = VA.Skins[j];
                    }
                }

                if (VA.bHasCollision)
                {
                    A.SetCollision(true, true); // bCollideActors & bBlockActors both true, so attachment blocks players walking through & stops projectiles
                    A.bWorldGeometry = true;    // means we get appropriate projectile impact effects, as if we'd hit a normal static mesh actor
                    // TODO - modify ProcessTouch() in projectiles to play hit effects on things other than VehicleWeapons & DHPawns, so we don't need to make this world geometry
                }

                VehicleAttachments[i].Actor = A; // save a reference to this actor in the VehicleAttachments slot
            }
        }
    }

    // Spawn any collision static mesh attachments
    for (i = 0; i < CollisionAttachments.Length; ++i)
    {
        CollisionAttachments[i].Actor = class'DHCollisionMeshActor'.static.AttachCollisionMesh
            (self, CollisionAttachments[i].StaticMesh, CollisionAttachments[i].AttachBone, CollisionAttachments[i].Offset, class<DHCollisionMeshActor>(CollisionAttachments[i].AttachClass));
    }
}

// New helper function to handle spawning an actor to attach to this vehicle, just to avoid code repetition
simulated function Actor SpawnAttachment(class<Actor> AttachClass, optional name AttachBone, optional StaticMesh AttachStaticMesh, optional vector AttachOffset, optional rotator AttachRotation)
{
    local Actor A;

    if (AttachClass != none)
    {
        A = Spawn(AttachClass);

        if (A != none)
        {
            if (AttachStaticMesh != none && A.DrawType == DT_StaticMesh)
            {
                A.SetStaticMesh(AttachStaticMesh);
            }

            if (AttachBone != '')
            {
                AttachToBone(A, AttachBone);
            }
            else
            {
                A.SetBase(self);
            }

            if (AttachRotation != rot(0, 0, 0))
            {
                A.SetRelativeRotation(AttachRotation);
            }

            if (AttachOffset != vect(0.0, 0.0, 0.0))
            {
                A.SetRelativeLocation(AttachOffset);
            }
        }
    }

    return A;
}

// New function to set correct initial position of player & vehicle on a net client, when this actor is replicated
simulated function SetPlayerPosition()
{
    local name VehicleAnim, PlayerAnim;
    local int  i;

    // Put vehicle & player in correct animation pose - if player not in initial position, we need to recreate the up/down anims that will have played to get there
    if (DriverPositionIndex != InitialPositionIndex)
    {
        if (DriverPositionIndex > InitialPositionIndex)
        {
            // Step down through each position until we find the 'most recent' transition up anim & player transition anim (or have reached the initial position)
            for (i = DriverPositionIndex; i > InitialPositionIndex && (VehicleAnim == ''|| PlayerAnim == ''); --i)
            {
                if (VehicleAnim == '' && DriverPositions[i - 1].TransitionUpAnim != '')
                {
                    VehicleAnim = DriverPositions[i - 1].TransitionUpAnim;
                }

                // DriverTransitionAnim only relevant if there is also one in the position below
                if (PlayerAnim == '' && DriverPositions[i].DriverTransitionAnim != '' && DriverPositions[i - 1].DriverTransitionAnim != '')
                {
                    PlayerAnim = DriverPositions[i].DriverTransitionAnim;
                }
            }
        }
        else
        {
            // Step up through each position until we find the 'most recent' transition down anim & player transition anim (or have reached the initial position)
            for (i = DriverPositionIndex; i < InitialPositionIndex && (VehicleAnim == ''|| PlayerAnim == ''); ++i)
            {
                if (VehicleAnim == '' && DriverPositions[i + 1].TransitionDownAnim != '')
                {
                    VehicleAnim = DriverPositions[i + 1].TransitionDownAnim;
                }

                // DriverTransitionAnim only relevant if there is also one in the position above
                if (PlayerAnim == '' && DriverPositions[i].DriverTransitionAnim != '' && DriverPositions[i + 1].DriverTransitionAnim != '')
                {
                    PlayerAnim = DriverPositions[i].DriverTransitionAnim;
                }
            }
        }

        // Play the animations but freeze them at the end of the anim, so they effectively become an idle anim
        // These transitions already happened - we're playing catch up after actor replication, to recreate the position the player & cannon are already in
        if (VehicleAnim != '' && HasAnim(VehicleAnim))
        {
            PlayAnim(VehicleAnim);
            SetAnimFrame(1.0);
        }

        if (PlayerAnim != '' && Driver != none && !bHideRemoteDriver && bDrawDriverinTP && Driver.HasAnim(PlayerAnim))
        {
            // When vehicle replicates to net client, StartDriving() event gets called on player pawn if vehicle has a driver
            // StartDriving() plays DriveAnim on the driver, which is for the usual initial driver position, but that would override our correct PlayerAnim here
            // So if player pawn hasn't already played DriveAnim, set a flag to stop it playing DriveAnim in StartDriving(), although only this 1st time
            if (DHPawn(Driver) != none && !DHPawn(Driver).bClientPlayedDriveAnim)
            {
                DHPawn(Driver).bClientSkipDriveAnim = true;
            }

            Driver.StopAnimating(true); // stops the player's looping DriveAnim, otherwise it can blend with the new anim
            Driver.PlayAnim(PlayerAnim);
            Driver.SetAnimFrame(1.0);
        }
    }
}

// Modified to avoid "accessed none" errors on rider pawns that don't always exist on net clients
function SetTeamNum(byte NewTeam)
{
    local byte OriginalTeam;
    local int  i;

    OriginalTeam = Team;
    PrevTeam = NewTeam;
    Team = NewTeam;

    if (NewTeam != OriginalTeam)
    {
        TeamChanged();
    }

    for (i = 0; i < WeaponPawns.Length; ++i)
    {
        if (WeaponPawns[i] != none)
        {
            WeaponPawns[i].SetTeamNum(NewTeam);
        }
    }
}

// Modified from ROTreadCraft to replace literal for pan direction, so can be easily subclassed, & to incorporate extra tread sounds that were spawned in PostBeginPlay()
// Also made tread sounds have same sound radius as engine, so we can actually hear that sound - makes tanks seem more "in the same world"
simulated function SetupTreads()
{
    LeftTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));

    if (LeftTreadPanner != none)
    {
        LeftTreadPanner.Material = Skins[LeftTreadIndex];
        LeftTreadPanner.PanDirection = LeftTreadPanDirection;
        LeftTreadPanner.PanRate = 0.0;
        Skins[LeftTreadIndex] = LeftTreadPanner;
    }

    RightTreadPanner = VariableTexPanner(Level.ObjectPool.AllocateObject(class'VariableTexPanner'));

    if (RightTreadPanner != none)
    {
        RightTreadPanner.Material = Skins[RightTreadIndex];
        RightTreadPanner.PanDirection = RightTreadPanDirection;
        RightTreadPanner.PanRate = 0.0;
        Skins[RightTreadIndex] = RightTreadPanner;
    }

    if (LeftTreadSound != none && LeftTrackSoundBone != '' && LeftTreadSoundAttach == none)
    {
        LeftTreadSoundAttach = SpawnAttachment(class'ROSoundAttachment', LeftTrackSoundBone);
        LeftTreadSoundAttach.AmbientSound = LeftTreadSound;
        LeftTreadSoundAttach.SoundRadius = SoundRadius;
        LeftTreadSoundAttach.TransientSoundRadius = TransientSoundRadius;
    }

    if (RightTreadSound != none && RightTrackSoundBone != '' && RightTreadSoundAttach == none)
    {
        RightTreadSoundAttach = SpawnAttachment(class'ROSoundAttachment', RightTrackSoundBone);
        RightTreadSoundAttach.AmbientSound = RightTreadSound;
        RightTreadSoundAttach.SoundRadius = SoundRadius;
        RightTreadSoundAttach.TransientSoundRadius = TransientSoundRadius;
    }
}

// Modified from ROTreadCraft to change sound volumes, including damaged treads being quieter, & to include an engine sound
// Also optimised by incorporating MotionSoundVolume as a passed function argument instead of a separate instance variable
simulated function UpdateMovementSound(float MotionSoundVolume)
{
    if (EngineSoundAttach != none)
    {
        EngineSoundAttach.SoundVolume = MotionSoundVolume * 0.75;
    }

    if (RumbleSoundAttach != none)
    {
        RumbleSoundAttach.SoundVolume = MotionSoundVolume * RumbleSoundVolumeModifier;
    }

    if (LeftTreadSoundAttach != none)
    {
        if (bLeftTrackDamaged)
        {
            LeftTreadSoundAttach.SoundVolume = MotionSoundVolume * 0.25; // damaged tracks are quieter
        }
        else
        {
            LeftTreadSoundAttach.SoundVolume = MotionSoundVolume * 0.9; // was only 0.75 in RO
        }
    }

    if (RightTreadSoundAttach != none)
    {
        if (bRightTrackDamaged)
        {
            RightTreadSoundAttach.SoundVolume = MotionSoundVolume * 0.25;
        }
        else
        {
            RightTreadSoundAttach.SoundVolume = MotionSoundVolume * 0.9;
        }
    }
}

// New function to set up damaged tracks
simulated function SetDamagedTracks()
{
    if (Level.NetMode == NM_DedicatedServer || !bHasTreads)
    {
        return;
    }

    if (bLeftTrackDamaged)
    {
        Skins[LeftTreadIndex] = DamagedTreadPanner;

        if (LeftTreadSoundAttach != none)
        {
            LeftTreadSoundAttach.AmbientSound = TrackDamagedSound;
        }

        // Added support for spawning damaged track model as decorative static mesh
        if (DamagedTrackStaticMeshLeft != none && DamagedTrackLeft == none)
        {
            DamagedTrackLeft = SpawnAttachment(class'DHDecoAttachment', DamagedTrackAttachBone, DamagedTrackStaticMeshLeft);
            DamagedTrackLeft.Skins[0] = default.Skins[LeftTreadIndex]; // sets damaged tread skin to match treads for this tank (i.e. whether normal or snowy)
        }
    }

    if (bRightTrackDamaged)
    {
        Skins[RightTreadIndex] = DamagedTreadPanner;

        if (RightTreadSoundAttach != none)
        {
            RightTreadSoundAttach.AmbientSound = TrackDamagedSound;
        }

        if (DamagedTrackStaticMeshRight != none && DamagedTrackRight == none)
        {
            DamagedTrackRight = SpawnAttachment(class'DHDecoAttachment', DamagedTrackAttachBone, DamagedTrackStaticMeshRight);
            DamagedTrackRight.Skins[0] = default.Skins[RightTreadIndex];
        }
    }
}

// Modified to use DHShadowProjector class, which uses this vehicle's ShadowZOffset to position its shadow, instead of a hard-coded literal value
// Allows shadow position to be tuned to look right, as hull mesh origin position affects vehicle actor location relative to the ground, affecting shadow location
simulated function UpdateShadow()
{
    if (VehicleShadow != none) // shouldn't already have a vehicle shadow, so destroy any that somehow exists
    {
        VehicleShadow.Destroy();
        VehicleShadow = none;
    }

    if (Level.NetMode != NM_DedicatedServer && bVehicleShadows && bDrawVehicleShadow)
    {
        VehicleShadow = Spawn(class'DHShadowProjector', self, '', Location);

        if (VehicleShadow != none)
        {
            VehicleShadow.ShadowActor      = self;
            VehicleShadow.bBlobShadow      = false;
            VehicleShadow.LightDirection   = Normal(vect(1.0, 1.0, 6.0));
            VehicleShadow.LightDistance    = 1200.0;
            VehicleShadow.MaxTraceDistance = ShadowMaxTraceDist;
            VehicleShadow.CullDistance     = ShadowCullDistance;

            DHShadowProjector(VehicleShadow).ShadowZOffset = ShadowZOffset; // added

            VehicleShadow.InitShadow();
        }
    }
}

// New function triggered when a player enters a vehicle, to check & update any vehicle locked settings
// Here we just make sure the player's bInLockedVehicle flag is false, so his vehicle HUD doesn't display a locked vehicle icon
// The real vehicle locking functionality is implemented in the DHArmoredVehicle subclass
function UpdateVehicleLockOnPlayerEntering(Vehicle EntryPosition)
{
    local DHPawn Player;

    if (EntryPosition != none)
    {
        Player = DHPawn(EntryPosition.Driver);

        if (Player != none)
        {
            Player.SetInLockedVehicle(false);
        }
    }
}

// Modified to destroy extra attachments & effects, & to add option to skin destroyed vehicle static mesh to match camo variant (avoiding need for multiple destroyed meshes)
simulated event DestroyAppearance()
{
    local int i;

    super.DestroyAppearance();

    DestroyAttachments();

    if (Level.NetMode != NM_DedicatedServer && DestroyedMeshSkins.Length > 0)
    {
        for (i = 0; i < DestroyedMeshSkins.Length; ++i)
        {
            if (DestroyedMeshSkins[i] != none)
            {
                Skins[i] = DestroyedMeshSkins[i];
            }
        }
    }
}

// New function to destroy effects & attachments when the vehicle gets destroyed
simulated function DestroyAttachments()
{
    local int i;

    if (Role == ROLE_Authority)
    {
        if (SpawnPointAttachment != none)
        {
            SpawnPointAttachment.Destroy();
        }

        if (ResupplyAttachment != none)
        {
            ResupplyAttachment.Destroy();
        }

        if (SupplyAttachment != none)
        {
            SupplyAttachment.Destroy();
        }

        if (MapIconAttachment != none)
        {
            MapIconAttachment.Destroy();
        }
    }

    for (i = 0; i < VehicleAttachments.Length; ++i)
    {
        if (VehicleAttachments[i].Actor != none)
        {
            VehicleAttachments[i].Actor.Destroy();
        }
    }

    for (i = 0; i < CollisionAttachments.Length; ++i)
    {
        if (CollisionAttachments[i].Actor != none)
        {
            CollisionAttachments[i].Actor.Destroy();
        }
    }

    if (Level.NetMode != NM_DedicatedServer)
    {
        if (EngineSoundAttach != none)
        {
            EngineSoundAttach.Destroy();
        }

        if (RumbleSoundAttach != none)
        {
            RumbleSoundAttach.Destroy();
        }

        if (bHasTreads)
        {
            if (LeftTreadPanner != none)
            {
                Level.ObjectPool.FreeObject(LeftTreadPanner);
                LeftTreadPanner = none;
            }

            if (RightTreadPanner != none)
            {
                Level.ObjectPool.FreeObject(RightTreadPanner);
                RightTreadPanner = none;
            }

            if (LeftTreadSoundAttach != none)
            {
                LeftTreadSoundAttach.Destroy();
            }

            if (RightTreadSoundAttach != none)
            {
                RightTreadSoundAttach.Destroy();
            }

            if (DamagedTrackLeft != none)
            {
                DamagedTrackLeft.Destroy();
            }

            if (DamagedTrackRight != none)
            {
                DamagedTrackRight.Destroy();
            }
        }

        StopEmitters();
    }
}

///////////////////////////////////////////////////////////////////////////////////////
//  *******************************  MISCELLANEOUS ********************************  //
///////////////////////////////////////////////////////////////////////////////////////

// Unloading supplies.
exec simulated function ROManualReload()
{
    LoadSupplies();
}

simulated function UnloadSupplies()
{
    local PlayerController PC;

    PC = PlayerController(Controller);

    if (SupplyAttachment == none || PC == none)
    {
        return;
    }

    if (!SupplyAttachment.HasSupplies())
    {
        // "The vehicle's supply cache is empty."
        PC.ReceiveLocalizedMessage(class'DHSupplyMessage', 4);
        return;
    }

    if (TouchingSupplyCount == -1)
    {
        // "There are no nearby supply caches."
        PC.ReceiveLocalizedMessage(class'DHSupplyMessage', 3);
        return;
    }

    ServerUnloadSupplies();
}

// Loading supplies.
exec simulated function ROMGOperation()
{
    UnloadSupplies();
}

simulated function LoadSupplies()
{
    local PlayerController PC;

    PC = PlayerController(Controller);

    if (SupplyAttachment == none || PC == none)
    {
        return;
    }

    if (TouchingSupplyCount == -1)
    {
        // "There are no nearby supply caches."
        PC.ReceiveLocalizedMessage(class'DHSupplyMessage', 3);
        return;
    }

    if (TouchingSupplyCount == 0)
    {
        // "The nearby supply cache is empty."
        PC.ReceiveLocalizedMessage(class'DHSupplyMessage', 5);
        return;
    }

    if (SupplyAttachment.IsFull())
    {
        // "The vehicle's supply cache is full."
        PC.ReceiveLocalizedMessage(class'DHSupplyMessage', 2);
        return;
    }

    ServerLoadSupplies();
}

// This function allows the vehicle to unload supplies to nearby supply caches.
function ServerUnloadSupplies()
{
    local DHConstructionSupplyAttachment CSA;
    local int SupplyDropCount, i;
    local DHPlayer PC;
    local bool bDidFindFullCache;

    PC = DHPlayer(Controller);

    if (SupplyAttachment == none || PC == none)
    {
        return;
    }

    SupplyDropCount = Min(SupplyDropCountMax, SupplyAttachment.GetSupplyCount());

    if (SupplyDropCount <= 0)
    {
        // No supplies left!
        return;
    }

    for (i = 0; i < TouchingSupplyAttachments.Length; ++i)
    {
        CSA = TouchingSupplyAttachments[i];

        if (CSA != none && CSA.bAreSuppliesTransactable && CSA.GetTeamIndex() == GetTeamNum())
        {
            if (CSA.IsFull())
            {
                bDidFindFullCache = true;
                continue;
            }

            SupplyDropCount = Min(SupplyDropCount, CSA.SupplyCountMax - CSA.GetSupplyCount());

            // Add supplies to the nearby supply attachment.
            CSA.SetSupplyCount(CSA.GetSupplyCount() + SupplyDropCount);
            SupplyAttachment.SetSupplyCount(SupplyAttachment.GetSupplyCount() - SupplyDropCount);

            // Play a sound to let everybody know a supply drop happened.
            PlaySound(SupplyDropSound, SLOT_None, SupplyDropSoundVolume, true, SupplyDropSoundRadius, 1.0, true);

            // "250 supplies have been unloaded from the vehicle to a nearby Supply Cache"
            PC.ReceiveLocalizedMessage(class'DHSupplyMessage', class'UInteger'.static.FromShorts(0, SupplyDropCount),,, CSA);

            return;
        }
    }

    // No supplies were transacted, but at least one full cache was found and skipped.
    if (bDidFindFullCache)
    {
        // "The nearby supply cache is full."
        PC.ReceiveLocalizedMessage(class'DHSupplyMessage', 6);
    }
}

// This function allows the vehicle to load supplies from nearby supply caches.
function ServerLoadSupplies()
{
    local DHConstructionSupplyAttachment CSA;
    local int i;
    local int SupplyLoadCount;
    local DHPlayer PC;

    PC = DHPlayer(Controller);

    if (SupplyAttachment == none || PC == none)
    {
        return;
    }

    if (SupplyAttachment.IsFull())
    {
        // "The vehicle's supply cache is full."
        PC.ReceiveLocalizedMessage(class'DHSupplyMessage', 2);
        return;
    }

    // Calculate the maximum amount of supplies we can load.
    SupplyLoadCount = Min(SupplyLoadCountMax, SupplyAttachment.SupplyCountMax - SupplyAttachment.GetSupplyCount());

    for (i = 0; i < TouchingSupplyAttachments.Length; ++i)
    {
        CSA = TouchingSupplyAttachments[i];

        if (CSA != none && CSA.bAreSuppliesTransactable && CSA.GetTeamIndex() == GetTeamNum() && CSA.HasSupplies())
        {
            SupplyLoadCount = Min(CSA.GetSupplyCount(), SupplyLoadCount);

            // Remove supplies from the nearby supply attachment.
            CSA.SetSupplyCount(CSA.GetSupplyCount() - SupplyLoadCount);

            // Add supplies to the vehicle's supply attachment.
            SupplyAttachment.SetSupplyCount(SupplyAttachment.GetSupplyCount() + SupplyLoadCount);

            // Play a sound to let everybody know a supply drop happened.
            PlaySound(SupplyDropSound, SLOT_None, SupplyDropSoundVolume, true, SupplyDropSoundRadius, 1.0, true);

            // "250 supplies have been loaded into the vehicle from a nearby Supply Cache"
            PC.ReceiveLocalizedMessage(class'DHSupplyMessage', class'UInteger'.static.FromShorts(1, SupplyLoadCount),,, CSA);

            return;
        }
    }

    // "There are no nearby supply caches."
    PC.ReceiveLocalizedMessage(class'DHSupplyMessage', 3);
}

// Modified to include any SupplyAttachment
function bool ResupplyAmmo()
{
    local bool bDidResupply;

    if (Level.TimeSeconds > LastResupplyTimestamp + ResupplyInterval)
    {
        bDidResupply = super.ResupplyAmmo();

        if (SupplyAttachment != none && SupplyAttachment.Resupply())
        {
            bDidResupply = true;
        }
    }

    if (bDidResupply)
    {
        LastResupplyTimestamp = Level.TimeSeconds;
    }

    return bDidResupply;
}

// Modified to prevent players from dying so easily when near a slightly moving vehicle
// Supposedly the system tries to move the pawn over slightly & if it fails it calls this function
// Which before just slayed the player into full gibs (10000 damage) - let's not do that
function bool EncroachingOn(Actor Other)
{
    return false;
}

// New function to handle switching between external & internal mesh (just saves code repetition)
simulated function SwitchMesh(int PositionIndex, optional bool bUpdateAnimations)
{
    local mesh NewMesh;

    if (Role == ROLE_AutonomousProxy || Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer)
    {
        // If switching to a valid driver position, get its PositionMesh
        if (PositionIndex >= 0 && PositionIndex < DriverPositions.Length)
        {
            NewMesh = DriverPositions[PositionIndex].PositionMesh;
        }
        // Else switch to default external mesh (pass PositionIndex of -1 to signify this, as it's an invalid position)
        else
        {
            NewMesh = default.Mesh;
        }

        // Only switch mesh if we actually have a different new mesh
        if (NewMesh != Mesh && NewMesh != none)
        {
            LinkMesh(NewMesh);

            // Option to play any necessary animations to get the new mesh in the correct position, e.g. with switching to/from behind view
            if (bUpdateAnimations)
            {
                SetPlayerPosition();
            }
        }
    }
}

// Modified to include setting ResetTime for an empty vehicle, which natively calls future CheckReset() event that may destroy & respawn an apparently abandoned vehicle
// Moved this functionality here from DriverLeft() as it fits well here, but functionality has been substantially modified & improved
// We never consider destroying a spawn vehicle, or a factory's last/only vehicle (it won't spawn a replacement so no point 'recycling') unless factory deactivated
// But we do do now set a ResetTime for an empty bNeverReset vehicle (e.g, AT gun) if its factory has since been deactivated & should destroy an empty vehicle
// And we skip check that vehicle has moved from its spawning location if parent is DH spawn manager, as that has no location & doesn't spawn empty vehicle like a factory
function MaybeDestroyVehicle()
{
    local bool bDeactivatedFactoryWantsToDestroy;

    // If the vehicle is not on fire, then do the following checks
    if (!IsDisabled())
    {
        // Check whether was spawned by a vehicle factory that has since been deactivated & wants to destroy its vehicle when empty
        if (ParentFactory != none)
        {
            bDeactivatedFactoryWantsToDestroy = ParentFactory.IsA('ROVehicleFactory') && !ROVehicleFactory(ParentFactory).bFactoryActive
                && ROVehicleFactory(ParentFactory).bDestroyVehicleWhenInactive;
        }

        // (If the vehicle was spawned by a vehicle factory that has since been deactivated & wants to destroy its vehicle when empty
        // AND is not meant to reset)
        // OR is a spawn vehicle, return
        if ((!bDeactivatedFactoryWantsToDestroy && bNeverReset) || IsPermanentSpawnVehicle())
        {
            return;
        }
    }
    else // If vehicle is classed as disabled, set a spike timer to destroy it after a set period if still empty
    {
        bSpikedVehicle = true;
        SetSpikeTimer(); // separate function for easy subclassing

        if (bDebuggingText)
        {
            Log("Initiating" @ VehicleSpikeTime @ "sec spike timer for disabled vehicle" @ VehicleNameString);
        }
    }

    // Set a ResetTime for empty vehicle, so that CheckReset() event gets called after specified time
    // But if spawned by vehicle factory, make sure vehicle has moved some way from spawning location (> 83m or out of sight) as no point making it re-spawn nearby
    // Skip that check if spawned by DH spawn manager system as it doesn't spawn an empty vehicle that just sits there as a factory does
    // Also skip the check if our factory has deactivated & should destroy an empty vehicle
    if (ParentFactory != none && (ParentFactory.IsA('DHSpawnManager') || bDeactivatedFactoryWantsToDestroy
        || VSizeSquared(Location - ParentFactory.Location) > 25000000.0 || !FastTrace(ParentFactory.Location, Location))) // changed to VSizeSquared for efficiency
    {
        ResetTime = Level.TimeSeconds + IdleTimeBeforeReset;
    }
}

// New function to set a 'spike timer' to destroy a disabled, empty vehicle (just for easier subclassing)
function SetSpikeTimer()
{
    SetTimer(VehicleSpikeTime, false);
}

// Modified so we never destroy an empty spawn vehicle, or a factory's last/only vehicle (it won't spawn a replacement so no point 'recycling') unless factory deactivated
// Also when checking for nearby friendlies, we ignore empty team vehicles (previously counted) but count any player in a vehicle weapon position (previously ignored)
// And we only count friendly players that could actually use this vehicle, i.e. so nearby infantry don't prevent an abandoned tank from re-spawning
event CheckReset()
{
    local Controller C;
    local float      Distance;

    // Do nothing if vehicle is a spawn vehicle or it isn't empty
    // Originally this set a new timer if vehicle was found to be occupied, but there's no reason for that
    // Occupied vehicle shouldn't have CheckReset timer running & if player exits, leaving vehicle empty, then a new CheckReset timer gets started
    if (IsPermanentSpawnVehicle() || !IsVehicleEmpty())
    {
        return;
    }

    // Do nothing if it's a factory's last vehicle, as no point destroying/recycling vehicle if factory won't spawn replacement
    // The exception is if a factory has deactivated & should destroy its vehicle if it's empty
    if (IsFactorysLastVehicle() &&
        !(ParentFactory.IsA('ROVehicleFactory') && !ROVehicleFactory(ParentFactory).bFactoryActive && ROVehicleFactory(ParentFactory).bDestroyVehicleWhenInactive))
    {
        return;
    }

    if (!bKeyVehicle)
    {
        // Check for any nearby friendly players who could use this vehicle, which will prevent vehicle from being 'recycled'
        // Previously used a foreach CollidingActors iteration but no need as we can simply loop the ControllerList
        for (C = Level.ControllerList; C != none; C = C.NextController)
        {
            // Found friendly player who could use this vehicle, so now do distance check
            if (C != Controller && C.GetTeamNum() == GetTeamNum() && C.Pawn != none && C.Pawn.Health > 0
                && (!bMustBeTankCommander || class'DHPlayerReplicationInfo'.static.IsPlayerTankCrew(C.Pawn)))
            {
                Distance = VSize(C.Pawn.Location - Location);

                // Friendly player prevents vehicle reset if within FriendlyResetDistance & line of sight, or if on foot within half of FriendlyResetDistance (no LOS)
                if (Distance <= FriendlyResetDistance && ((C.Pawn.IsA('ROPawn') && Distance < 0.5 * FriendlyResetDistance)
                    || FastTrace(C.Pawn.Location + C.Pawn.CollisionHeight * vect(0.0, 0.0, 1.0), Location + CollisionHeight * vect(0.0, 0.0, 1.0))))
                {
                    // Instead of destroying vehicle we set a new ResetTime to check again fairly soon
                    // Was using IdleTimeBeforeReset but was being used in the wrong function, so we revert back to original fixed 10 second delay before repeating this check
                    // IdleTimeBeforeReset should be used when a player exits & leaves vehicle empty, setting initial CheckReset timer (functionality now in MaybeDestroyVehicle)
                    ResetTime = Level.TimeSeconds + 10.0;

                    if (bDebuggingText)
                    {
                        Log(VehicleNameString @ "CheckReset: is empty but set new ResetTime as found nearby friendly player" @ C.Pawn.GetHumanReadableName());
                    }

                    return;
                }
            }
        }
    }

    // Debug
    if (bDebuggingText)
    {
        if (bKeyVehicle)
        {
            Log(VehicleNameString @ "is empty vehicle & re-spawned as is a key vehicle (no check for nearby friendlies)");
        }
        else
        {
            Log(VehicleNameString @ "is empty vehicle & re-spawned as no friendly player nearby that can use vehicle");
        }
    }

    // Destroy & reset the vehicle as it is empty & appears abandoned
    // We want a new vehicle to be available or respawned now, without waiting for usual respawn time, because we've 'recycled' the vehicle rather than it being killed
    if (ParentFactory != none)
    {
        ParentFactory.VehicleDestroyed(self);

        // Make factory re-spawn immediately (but not if spawned by DH spawn manager system, as calling Timer doesn't handle respawn & does irrelevant stuff)
        if (!ParentFactory.IsA('DHSpawnManager'))
        {
            ParentFactory.Timer();
        }

        ParentFactory = none; // so doesn't call ParentFactory.VehicleDestroyed() again in our Destroyed() event
    }

    Destroy();
}

// New helper function to check whether this is the last or only vehicle of our parent spawn manager/vehicle factory
function bool IsFactorysLastVehicle()
{
    local DHGameReplicationInfo GRI;
    local ROVehicleFactory      VF;

    if (ParentFactory == none)
    {
        return true; // if somehow we don't have a factory, no other vehicle is going to get spawned so we the only one
    }

    if (ParentFactory.IsA('DHSpawnManager'))
    {
        GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

        return GRI != none && VehiclePoolIndex < arraycount(GRI.VehiclePoolMaxSpawns) && GRI.GetVehiclePoolSpawnsRemaining(VehiclePoolIndex) <= 0; // if spawn manager's last vehicle
    }

    VF = ROVehicleFactory(ParentFactory);

    return VF != none && (!VF.bAllowVehicleRespawn || VF.TotalSpawnedVehicles >= VF.VehicleRespawnLimit); // if vehicle factory's last vehicle
}

// New helper function to check whether tank crew positions in this vehicle have been locked, preventing a player from entering them
// Implemented in armored vehicle subclass, but useful here to facilitate a generic entry functions in this class
function bool AreCrewPositionsLockedForPlayer(Pawn P, optional bool bNoMessageToPlayer)
{
    return false;
}

// New function to determine if it has wheels that can be damaged
function bool HasDamageableWheels()
{
    local int i;

    for (i = 0; i < VehHitpoints.Length; ++i)
    {
        if (VehHitpoints[i].HitPointType == HP_Driver) // Driver repurposed as a wheel
        {
            return true;
        }
    }

    return false;
}

// Modified to prevent "enter vehicle" screen messages if vehicle is destroyed or if it's an enemy vehicle
// Also to pass new NotifyParameters to message, allowing it to display both the use/enter key & vehicle name
simulated event NotifySelected(Pawn User)
{
    if (Level.NetMode != NM_DedicatedServer && User != none && User.IsHumanControlled() && (User.GetTeamNum() == VehicleTeam || !bTeamLocked)
        && ((Level.TimeSeconds - LastNotifyTime) >= TouchMessageClass.default.LifeTime) && Health > 0)
    {
        NotifyParameters.Put("Controller", User.Controller);
        User.ReceiveLocalizedMessage(TouchMessageClass, 0,,, NotifyParameters);
        LastNotifyTime = Level.TimeSeconds;
    }
}

// New function, replacing RO's DenyEntry() function so we use the DH message class (also re-factored slightly to makes passed Pawn optional)
simulated function DisplayVehicleMessage(int MessageNumber, optional Pawn P, optional bool bPassController)
{
    if (P == none)
    {
        P = self;
    }

    if (bPassController) // option to pass pawn's controller as the OptionalObject, so it can be used in building the message
    {
        P.ReceiveLocalizedMessage(class'DHVehicleMessage', MessageNumber,,, Controller);
    }
    else
    {
        P.ReceiveLocalizedMessage(class'DHVehicleMessage', MessageNumber);
    }
}

// New helper function to check whether vehicle is a spawn vehicle
simulated function bool IsPermanentSpawnVehicle()
{
    return SpawnPointAttachment != none && !SpawnPointAttachment.bIsTemporary;
}

// Modified so vehicle is treated as disabled if it suffers a range of damage that renders it of very limited use, as well as if the engine is dead
// Includes if either track is disabled, or if it has a cannon with a smashed gunsight or jammed traverse or pitch mechanism
// Also includes an APC that takes major damage - the idea being it should give time for troops to bail out & escape before vehicle blows up
simulated function bool IsDisabled()
{
    local DHVehicleCannonPawn CP;

    if ((EngineHealth <= 0 && default.EngineHealth > 0)
        || bLeftTrackDamaged || bRightTrackDamaged
        || (bIsApc && Health <= (HealthMax / 3)))
    {
        return true;
    }

    if (Cannon != none)
    {
        CP = DHVehicleCannonPawn(Cannon.WeaponPawn);

        if (CP != none && (CP.bOpticsDamaged || CP.bTurretRingDamaged || CP.bGunPivotDamaged))
        {
            return true;
        }
    }

    return false;
}

// New function to get the location of the Engine VehHitPoint
function vector GetEngineLocation()
{
    return GetBoneCoords(VehHitPoints[0].PointBone).Origin;
}

// New helper function to check whether vehicle is burning
simulated function bool IsVehicleBurning()
{
    return EngineHealth <= 0;
}

// Modified to eliminate "Waiting for additional crew members" message (this is now only used by bots)
function bool CheckForCrew()
{
    return true;
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

// Modified to also check bDriving as well as Driver != none, so this function works reliably for a net client
// That's because another player's Driver pawn doesn't get replicated to a net client if that player is set to be bHidden, meaning it fails network relevance checks
// Affects vehicles or weapon pawns with bDrawDriverInTP=false, e.g. hull MGs and some tank driver positions, where the player isn't drawn
// Also to add WeaponPawns != none check to avoid "accessed none" errors, now rider pawns won't exist on client unless occupied
simulated function int NumPassengers()
{
    local int i, Num;

    if (Driver != none || bDriving)
    {
        Num = 1;
    }

    for (i = 0; i < WeaponPawns.Length; ++i)
    {
        if (WeaponPawns[i] != none && (WeaponPawns[i].Driver != none || WeaponPawns[i].bDriving))
        {
            ++Num;
        }
    }

    return Num;
}

// Returns pawn's base vehicle. The pawn can either be driving the vehicle
// (has DrivenVehicle set), or be the vehicle/vehicle weapon pawn itself.
simulated static function DHVehicle GetDrivenVehicleBase(Pawn P)
{
    local Vehicle V;

    if (P == none)
    {
        return none;
    }

    if (P.DrivenVehicle != none)
    {
        V = P.DrivenVehicle;
    }
    else
    {
        V = Vehicle(P);
    }

    if (V != none)
    {
        if (V.IsA('VehicleWeaponPawn'))
        {
            return DHVehicle(VehicleWeaponPawn(V).GetVehicleBase());
        }

        return DHVehicle(V);
    }
}

// Functions emptied out as not relevant to a vehicle in RO/DH (that doesn't have any DriverWeapons):
simulated event StartDriving(Vehicle V);
simulated event StopDriving(Vehicle V);
function bool IsHeadShot(vector Loc, vector Ray, float AdditionalScale) { return false; }
function AttachFlag(Actor FlagActor);
function ShouldCrouch(bool Crouch);
function ShouldProne(bool Prone);
event EndCrouch(float HeightAdjust);
event StartCrouch(float HeightAdjust);
function bool DoJump(bool bUpdating) { return false; }
function bool CheckWaterJump(out vector WallNormal) { return false; }
function JumpOutOfWater(vector JumpDir);
function ClimbLadder(LadderVolume L);
function EndClimbLadder(LadderVolume OldLadder);
simulated function AltFire(optional float F);
function bool StopWeaponFiring() { return false; }
simulated event StopPlayFiring();
function ChooseFireAt(Actor A);
function Actor ShootSpecial(Actor A) { return none; }
function ShouldTargetMissile(Projectile P);
function ShootMissile(Projectile P);
function GiveWeapon(string aClassName);
simulated function bool CanThrowWeapon() { return false; }
function TossWeapon(vector TossVel);
exec function SwitchToLastWeapon();
simulated function ChangedWeapon();
function ServerChangedWeapon(Weapon OldWeapon, Weapon NewWeapon);
function bool AddInventory(Inventory NewItem) { return false; }
function DeleteInventory(Inventory Item);
function Inventory FindInventoryType(class DesiredClass) { return none; }
simulated function Weapon GetDemoRecordingWeapon() { return none; }
exec function NextItem(); // only concerns UT2004 PowerUps) & just causes "accessed none" log errors if keybound & used

///////////////////////////////////////////////////////////////////////////////////////
//  *************************** DEBUG EXEC FUNCTIONS  *****************************  //
///////////////////////////////////////////////////////////////////////////////////////

// New helper function to check whether debug execs can be run
simulated function bool IsDebugModeAllowed()
{
    return Level.NetMode == NM_Standalone || class'DH_LevelInfo'.static.DHDebugMode();
}

// New debug exec to toggle between external & internal meshes (mostly useful with behind view if want to see internal mesh)
exec function ToggleMesh()
{
    local int i;

    if (IsDebugModeAllowed() && DriverPositions.Length > 0)
    {
        if (Mesh == default.DriverPositions[DriverPositionIndex].PositionMesh)
        {
            for (i = 0; i < DriverPositions.Length; ++i)
            {
                DriverPositions[i].PositionMesh = default.Mesh;
            }
        }
        else
        {
            for (i = 0; i < DriverPositions.Length; ++i)
            {
                DriverPositions[i].PositionMesh = default.DriverPositions[i].PositionMesh;
            }
        }

        SwitchMesh(DriverPositionIndex, true);
    }
}

// Modified to work with DHDebugMode & restricted to changing view limits & nothing to do with behind view (which is handled by exec functions BehindView & ToggleBehindView)
exec function ToggleViewLimit()
{
    if (IsDebugModeAllowed()) // removed requirement to be in single player mode, as valid in multi-player if in DHDebugMode
    {
        if (bLimitYaw == default.bLimitYaw && bLimitPitch == default.bLimitPitch)
        {
            bLimitYaw = false;
            bLimitPitch = false;
        }
        else
        {
            bLimitYaw = default.bLimitYaw;
            bLimitPitch = default.bLimitPitch;
        }
    }
}

// New debug exec to adjust the yaw limits for the current driver position
exec function SetViewLimits(int NewPitchUp, int NewPitchDown, int NewYawRight, int NewYawLeft)
{
    if (IsDebugModeAllowed())
    {
        Log(VehicleNameString @ ": ViewPitchUpLimit =" @ NewPitchUp @ "ViewPitchDownLimit =" @ NewPitchDown @ "ViewPositiveYawLimit =" @ NewYawRight @ "ViewNegativeYawLimit =" @ NewYawLeft
            @ "(was" @ DriverPositions[DriverPositionIndex].ViewPitchUpLimit @ DriverPositions[DriverPositionIndex].ViewPitchDownLimit
            @ DriverPositions[DriverPositionIndex].ViewPositiveYawLimit @ DriverPositions[DriverPositionIndex].ViewNegativeYawLimit $ ")");

        DriverPositions[DriverPositionIndex].ViewPitchUpLimit = NewPitchUp;
        DriverPositions[DriverPositionIndex].ViewPitchDownLimit = NewPitchDown;
        DriverPositions[DriverPositionIndex].ViewPositiveYawLimit = NewYawRight;
        DriverPositions[DriverPositionIndex].ViewNegativeYawLimit = NewYawLeft;
    }
}

// New debug exec to quickly damage the vehicle
exec function DamageVehicle(optional bool bDestroyVehicle)
{
    if (IsDebugModeAllowed() && Role == ROLE_Authority)
    {
        if (bDestroyVehicle)
        {
            super(Vehicle).TakeDamage(99999, none, Location, vect(10000.0,0.0,0.0), class'DHShellImpactDamageType');
        }
        else
        {
            Health /= 2;
            EngineHealth /= 2;
        }
    }
}

// New debug exec for testing engine damage
exec function KillEngine()
{
    if (IsDebugModeAllowed() && EngineHealth > 0)
    {
        DamageEngine(EngineHealth, none, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), none);
    }
}

// New debug exec for testing track damage
exec function DamTrack(string Track)
{
    if (IsDebugModeAllowed() && bHasTreads)
    {
        if (Track ~= "L" || Track ~= "Left")
        {
            DestroyTrack(true);
        }
        else if (Track ~= "R" || Track ~= "Right")
        {
            DestroyTrack(false);
        }
        else if (Track ~= "B" || Track ~= "Both")
        {
            DestroyTrack(true);
            DestroyTrack(false);
        }
    }
}

// New debug exec to toggle showing any optional collision mesh attachment
exec function ShowColMesh()
{
    local int i;

    if (IsDebugModeAllowed())
    {
        for (i = 0; i < CollisionAttachments.Length; ++i)
        {
            if (DHCollisionMeshActor(CollisionAttachments[i].Actor) != none)
            {
                DHCollisionMeshActor(CollisionAttachments[i].Actor).ToggleVisible();
            }
        }
    }
}

// New debug exec to adjust the volume of the interior rumble sound
exec function SetRumbleVol(float NewValue)
{
    if (IsDebugModeAllowed())
    {
        Log(VehicleNameString @ "RumbleSoundVolumeModifier =" @ NewValue @ "(was" @ RumbleSoundVolumeModifier $ ")");
        RumbleSoundVolumeModifier = NewValue;
    }
}

// Modified to use a small font so the extensive vehicle debug info fits on the screen (before a lot of it was missing at the bottom of the screen)
simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
    Canvas.Font = Canvas.SmallFont;

    super.DisplayDebug(Canvas, YL, YPos);
}

defaultproperties
{
    // Miscellaneous
    VehicleMass=3.0
    WeaponLockTimeForTK=5
    PreventTeamChangeForTK=1500 // 25 minutes
    PointValue=250
    CollisionRadius=175.0
    CollisionHeight=40.0
    VehicleNameString="ADD VehicleNameString !!"
    TouchMessageClass=class'DHVehicleTouchMessage'
    ResupplyAttachmentClass=class'DHResupplyAttachment'
    FirstRiderPositionIndex=255 // unless overridden in subclass, 255 means the value is set automatically when PassengerPawns array is added to the PassengerWeapons
    VehiclePoolIndex=-1
    MinRunOverSpeed=586.75 // increased from 0 to 35km/h so players don't get run over so easily by vehicles
    ObjectiveGetOutDist=1500.0
    CenterSpringForce="SpringONSSRV"
    bReplicateAnimations=false // override strange inherited property from ROWheeledVehicle - no reason for server to replicate anims & now we play transition anims on
                               // server it seems to sometimes override the client's anim & leave it 1 frame short of its end position, glitching the camera view
    // Driver & positions
    DriverAttachmentBone="Driver_attachment"
    DriverPositions(0)=(ViewFOV=0.0) // override inherited FOV values from ROWheeledVehicle - zero just means it uses player's default view FOV (unless overridden in subclass)
    DriverPositions(1)=(ViewFOV=0.0)
    PlayerCameraBone="Camera_driver"

    // Supply
    SupplyDropCountMax=250
    SupplyLoadCountMax=250
    SupplyDropInterval=5
    TouchingSupplyCount=-1
    SupplyDropSound=Sound'Inf_Weapons_Foley.AmmoPickup'
    SupplyDropSoundRadius=10.0
    SupplyDropSoundVolume=1.0

    // Spawning
    bHasSpawnKillPenalty=true

    // Hull corner angles (used to determine which side of vehicle was hit for armour penetration calcs)
    FrontLeftAngle=333.0
    FrontRightAngle=28.0
    RearRightAngle=152.0
    RearLeftAngle=207.0

    // Damage
    Health=175
    HealthMax=175.0
    EngineHealth=30
    TrackHealth(0)=100
    TrackHealth(1)=100
    VehHitpoints(0)=(PointRadius=25.0,PointBone="Engine",bPenetrationPoint=false,DamageMultiplier=1.0,HitPointType=HP_Engine) // no.0 becomes engine instead of driver
    VehHitpoints(1)=(PointRadius=0.0,PointScale=0.0,PointBone="",HitPointType=) // no.1 is no longer engine (neutralised by default, or overridden as required in subclass)
    TreadDamageThreshold=0.3
    bCanCrash=true
    SatchelResistance=1.0
    DirectHEImpactDamageMult=1.0
    DamagedWheelSpeedFactor=0.35
    ImpactDamageThreshold=33.0
    ImpactDamageMult=0.001
    ImpactWorldDamageMult=0.001
    DriverDamageMult=1.0
    DamagedTreadPanner=Texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha'

    // Smoking/burning engine effect
    HeavyEngineDamageThreshold=0.5
    DamagedEffectHealthSmokeFactor=0.75
    DamagedEffectHealthMediumSmokeFactor=0.5
    DamagedEffectHealthHeavySmokeFactor=0.25
    DamagedEffectHealthFireFactor=0.15

    // Vehicle destruction
    DestructionEffectClass=class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
    DestructionEffectLowClass=class'AHZ_ROVehicles.ATCannonDestroyedEmitter'
    DisintegrationEffectClass=class'ROEffects.ROVehicleDestroyedEmitter'
    DisintegrationEffectLowClass=class'ROEffects.ROVehicleDestroyedEmitter_simple'
    DisintegrationHealth=-10000.0 // very high default value so subclasses have to enable disintegration
    ExplosionDamage=150.0
    ExplosionRadius=400.0
    ExplosionSoundRadius=750.0
    DestructionLinearMomentum=(Min=100.0,Max=350.0)
    DestructionAngularMomentum=(Min=50.0,Max=150.0)

    // Vehicle reset/respawn
    VehicleSpikeTime=15.0    // if disabled
    IdleTimeBeforeReset=90.0 // if empty & no friendlies nearby
    FriendlyResetDistance=6000.0 // 100 meters

    // Sounds
    MaxPitchSpeed=150.0
    RumbleSoundVolumeModifier=2.5
    DamagedStartUpSound=Sound'DH_AlliedVehicleSounds.Damaged.engine_start_damaged'
    DamagedShutDownSound=Sound'DH_AlliedVehicleSounds.Damaged.engine_stop_damaged'
    VehicleBurningSound=Sound'Amb_Destruction.Fire.Krasnyi_Fire_House02'
    DestroyedBurningSound=Sound'Amb_Destruction.Fire.Kessel_Fire_Small_Barrel'
    RumbleSoundBone="body"
    IdleRPM=500.0 // determines engine sound at idle, relative to EngineRPMSoundRange (note that behind the scenes the native EngineRPM will actually be zero at idle)
    EngineRPMSoundRange=5000.0 // range of engine sound relative to current RPM (presumably max engine sound at IdleRPM + EngineRPMSoundRange)

    // Visual effects
    bIsWinterVariant=false
    ExhaustEffectClass=class'ROEffects.ExhaustPetrolEffect'
    ExhaustEffectLowClass=class'ROEffects.ExhaustPetrolEffect_simple'
    SparkEffectClass=none // removes the odd spark effects when vehicle drags bottom on ground
    SteeringScaleFactor=4.0
    RandomAttachmentIndex=255 // an invalid starting value, so will only get changed & replicated if a valid selection is made for a random decorative attachment
    ShadowZOffset=5.0 // the literal value used in the ShadowProjector class

    // HUD
    VehicleHudTreadsPosX(0)=0.35
    VehicleHudTreadsPosX(1)=0.65
    VehicleHudTreadsPosY=0.5
    VehicleHudTreadsScale=0.65
    bShouldDrawPositionDots=true
    bShouldDrawOccupantList=true

    // Engine
    bEngineOff=true
    bSavedEngineOff=true
    IgnitionSwitchInterval=4.0
    EngineRestartFailChance=0.05

    // Driving, steering & braking
    GearRatios(0)=-0.2
    GearRatios(1)=0.2
    GearRatios(2)=0.35
    GearRatios(3)=0.55
    GearRatios(4)=0.6
    TransRatio=0.12
    ChangeUpPoint=2000.0
    ChangeDownPoint=1000.0
    GroundSpeed=325.0
    TurnDamping=35.0
    SteerSpeed=50.0
    StopThreshold=100.0
    MinBrakeFriction=4.0
    MaxBrakeTorque=20.0
    HandbrakeThresh=200.0
    EngineBrakeFactor=0.0001
    EngineBrakeRPMScale=0.1
    EngineInertia=0.1
    ChassisTorqueScale=0.4
    FTScale=0.03  // is force transmission scale?
    LSDFactor=1.0 // is limited-slip differential?

    // Physics wheels properties
    WheelSoftness=0.025
    WheelPenScale=1.2
    WheelPenOffset=0.01
    WheelRestitution=0.1
    WheelInertia=0.1
    WheelLongSlip=0.001
    WheelLongFrictionScale=1.1
    WheelLatFrictionScale=2.0
    WheelHandbrakeSlip=0.01
    WheelHandbrakeFriction=0.1
    WheelSuspensionTravel=15.0
    WheelSuspensionMaxRenderTravel=15.0

    // These variables are effectively deprecated & should not be used - they are either ignored or values below are assumed & hard coded into functionality:
    bPCRelativeFPRotation=true
    bZeroPCRotOnEntry=true
    bFPNoZFromCameraPitch=false
    FPCamViewOffset=(X=0.0,Y=0.0,Z=0.0)
    bDesiredBehindView=false
    bDisableThrottle=false
    bKeepDriverAuxCollision=true // necessary for new player hit detection system, which basically uses normal hit detection as for an infantry player pawn

    //bDebuggingText=true
    ResupplyInterval=2.5
}
