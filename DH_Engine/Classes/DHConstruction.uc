//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHConstruction extends Actor
    abstract
    placeable;

enum EConstructionErrorType
{
    ERROR_None,
    ERROR_Fatal,                    // Some fatal error occurred, usually a case of unexpected values
    ERROR_NoGround,                 // No solid ground was able to be found
    ERROR_TooSteep,                 // The ground slope exceeded the allowable maximum
    ERROR_InWater,                  // The construction is in water and the construction type disallows this
    ERROR_Restricted,               // Construction overlaps a restriction volume
    ERROR_NoRoom,                   // No room to place this construction
    ERROR_NotOnTerrain,             // Construction is not on terrain
    ERROR_TooCloseFriendly,         // Too close to an identical friendly construction
    ERROR_TooCloseEnemy,            // Too close to an identical enemy construction
    ERROR_InMinefield,              // Cannot be in a minefield!
    ERROR_NearSpawnPoint,           // Cannot be so close to a spawn point (or location hint)
    ERROR_Indoors,                  // Cannot be placed indoors
    ERROR_InObjective,              // Cannot be placed inside an objective area
    ERROR_MaxActive,                // Max active limit reached
    ERROR_NoSupplies,               // Not within range of any supply caches
    ERROR_InsufficientSupply,       // Not enough supplies to build this construction
    ERROR_BadSurface,               // Cannot construct on this surface type
    ERROR_GroundTooHard,            // This is used when something needs to snap to the terrain, but the engine's native trace functionality isn't cooperating!0
    ERROR_RestrictedType,           // Restricted construction type (can't build on this map!)
    ERROR_SquadTooSmall,            // Not enough players in the squad!
    ERROR_PlayerBusy,               // Player is in an undesireable state (e.g. MG deployed, crawling, prone transitioning or otherwise unable to switch weapons)
    ERROR_TooCloseToObjective,      // Too close to an objective
    ERROR_TooCloseToEnemyObjective, // Too close to enemy controlled objective
    ERROR_MissingRequirement,       // Not close enough to a required friendly construciton
    ERROR_InDangerZone,             // Cannot place this construction inside enemy territory.
    ERROR_Exhausted,                // Your team cannot place any more of these this round.
    ERROR_SocketOccupied,           // The construction socket is already occupied.
    ERROR_Custom,                   // Custom error type (provide an error message in OptionalString)
    ERROR_Other
};

var struct ConstructionError
{
    var EConstructionErrorType  Type;
    var string                  CustomErrorString;  // When Type is ERROR_Custom, this will contain the error string to be used.
    var int                     OptionalInteger;
    var Object                  OptionalObject;
    var string                  OptionalString;
} ProxyError;

enum ETeamOwner
{
    TEAM_Axis,
    TEAM_Allies,
    TEAM_Neutral
};

// Client state management
var name StateName, OldStateName;

var() ETeamOwner TeamOwner;     // This enum is for the levelers' convenience only.
var bool bIsNeutral;            // If true, this construction is neutral (can be built by either team)
var private int OldTeamIndex;   // Used by the client to fire off an event when the team index changes.
var private int TeamIndex;

// Manager
var     DHConstructionManager       Manager;
var     class<DHConstructionGroup>  GroupClass;

// Placement
var     float   ProxyTraceDepthMeters;          // The depth of the trace from the player's eye when determining the provisional proxy position.
var     float   ProxyTraceHeightMeters;         // The height at which the proxy object will no longer snap to the ground.
var     bool    bShouldAlignToGround;
var     bool    bCanPlaceInWater;
var     bool    bCanPlaceIndoors;
var     float   IndoorsCeilingHeightInMeters;
var     bool    bCanOnlyPlaceOnTerrain;
var     float   GroundSlopeMaxInDegrees;
var     bool    bSnapRotation;
var     int     RotationSnapAngle;
var     Rotator StartRotationMin;
var     Rotator StartRotationMax;
var     int     LocalRotationRate;
var     bool    bCanPlaceInObjective;
var     int     SquadMemberCountMinimum;        // The number of members you must have in your squad to create this.
var     float   ArcLengthTraceIntervalInMeters; // The arc-length interval, in meters, used when tracing "outwards" during placement to check for blocking objects.

var     float   ObjectiveDistanceMinMeters;             // The minimum distance, in meters, that this construction must be placed away from all objectives.
var     float   EnemyObjectiveDistanceMinMeters;        // The minimum distance, in meters, that this construction must be placed away from enemy objectives.
var     bool    bShouldSwitchToLastWeaponOnPlacement;
var     bool    bCanBePlacedInDangerZone;

struct ProximityRequirement
{
    var class<DHConstruction>   ConstructionClass;
    var float                   DistanceMeters;
};

var     array<ProximityRequirement> ProximityRequirements;

// Terrain placement
var     bool    bSnapToTerrain;                 // If true, the origin of the placement (prior to the PlacementOffset) will coincide with the nearest terrain vertex during placement.
var     bool    bPokesTerrain;                  // If true, terrain is poked when placed on terrain.
var     bool    bDidPokeTerrain;
var private int PokeTerrainRadius;
var private int PokeTerrainDepth;
var     float   TerrainScaleMax;                // The maximum terrain scale allowable
var     bool    bLimitTerrainSurfaceTypes;      // If true, only allow placement on terrain surfaces types in the SurfaceTypes array
var     array<ESurfaceTypes> TerrainSurfaceTypes;

var private Vector      PlacementOffset;        // 3D offset in the proxy's local-space during placement
var     Sound           PlacementSound;         // Sound to play when construction is first placed down
var     float           PlacementSoundRadius;
var     float           PlacementSoundVolume;
var     class<Emitter>  PlacementEmitterClass;  // Emitter to spawn when the construction is first placed down

var     float   FloatToleranceInMeters;             // The distance the construction is allowed to "float" off of the ground at any given point along it's circumfrence
var     float   DuplicateFriendlyDistanceInMeters;  // The distance required between identical constructions of the same type for FRIENDLY constructions.
var     float   DuplicateEnemyDistanceInMeters;     // The distance required between identical constructions of the same type for ENEMY constructions.

var     Vector  ExplosionDamageTraceOffset;         // Optimal location for tracing this actor when dealing explosive damage (relative to origin)

// Construction
var private int SupplyCost;                     // The amount of supply points this construction costs
var     bool    bDestroyOnConstruction;         // If true, this actor will be destroyed after being fully constructed
var     bool    bDummyOnConstruction;           // If true, this actor will be put into the "dummy" state after being fully constructed.
var     int     Progress;                       // The current count of progress
var     int     ProgressMax;                    // The amount of construction points required to be built
var     bool    bShouldRefundSuppliesOnTearDown;

// Stagnation
var     bool    bCanDieOfStagnation;            // If true, this construction will automatically destroy if no progress has been made for the amount of seconds specified in StagnationLifespan
var     float   StagnationLifespan;

// Tear-down
var     bool    bCanBeTornDownWhenConstructed;      // Whether or not players can tear down the construction after it has been constructed.
var     bool    bCanBeTornDownByFriendlies;         // Whether or not friendly players can tear down the construction (e.g. to stop griefing of important constructions)
var     bool    bBreakOnTearDown;                   // If true, the construction breaks when torn down
var     float   TearDownProgress;
var     float   TakeDownProgressInterval;

// Broken
var     float           BrokenLifespan;             // How long does the actor stay around after it's been killed?
var     StaticMesh      BrokenStaticMesh;           // Static mesh to use when the construction is broken
var     array<Sound>    BrokenSounds;                // Sound to play when the construction is broken
var     float           BrokenSoundRadius;
var     float           BrokenSoundVolume;
var     float           BrokenSoundPitch;
var     class<Emitter>  BrokenEmitterClass;         // Emitter to spawn when the construction is broken

// Reset
var     bool            bShouldDestroyOnReset;

// Damage
struct DamageTypeScale
{
    var class<DamageType>   DamageType;
    var float               Scale;
};

var int                         MinDamagetoHurt;        // The minimum amount of damage required to actually harm the construction
var array<DamageTypeScale>      DamageTypeScales;
var array<class<DamageType> >   HarmfulDamageTypes;
var float                       FriendlyFireDamageScale; // Set to 0.0 to disable friendly fire damage

// Impact Damage
var bool                        bCanTakeImpactDamage;
var class<DamageType>           ImpactDamageType;
var float                       ImpactDamageModifier;
var float                       LastImpactTimeSeconds;

// Tattered
var int                         TatteredHealthThreshold;    // The health below which the construction is considered "tattered". -1 for no tattering
var StaticMesh                  TatteredStaticMesh;

// Cut
var float                       CutDuration;                // Cut duration
var StaticMesh                  CutStaticMesh;              // Static mesh to display when cut
var Sound                       CutSound;
var float                       CutSoundVolume;
var float                       CutSoundRadius;

// Health
var private int     Health;
var     int         HealthMax;

// Menu
var     localized string    MenuName;
var     Material            MenuIcon;
var     localized string    MenuDescription;

// Level Info
var DH_LevelInfo LevelInfo;

// Staging
struct Stage
{
    var int Progress;           // The progress level at which this stage is used.
    var StaticMesh StaticMesh;  // This can be overridden in GetStaticMesh
    var Sound Sound;
    var Emitter Emitter;
};

var int StageIndex;
var array<Stage> Stages;

// Mantling
var bool bCanBeMantled;

// Squad rally points
var bool bShouldBlockSquadRallyPoints;

// Delayed damage
var int DelayedDamage;
var class<DamageType> DelayedDamageType;

// When true, this construction will automatically be put this into the
// Constructed state if it was placed via the SDK.
var bool bShouldAutoConstruct;

// Whether or not this construction has been fully constructed before.
// Used to make sure not to send duplicate events.
var bool bHasBeenConstructed;

var localized string ConstructionVerb;  // eg. dig, emplace, build etc.

// Scoring
var DHPlayer InstigatorController;
var int CompletionPointValue;

// Artillery
var bool bIsArtillery;

// Construction Sockets
struct SConstructionSocket
{
    var Vector Location;
    var Rotator Rotation;
    var bool bLimitLocalRotation;
    var Range LocalRotationYawRange;
    var array<class<DHConstruction> > IncludeClasses;
    var array<class<DHConstruction> > ExcludeClasses;
    var DHConstructionSocket SocketActor;
};
var array<SConstructionSocket> ConstructionSockets;

// Cached values that are calculated only when needed (e.g., when any of the user-editable properties change such as variant or skin)
struct RuntimeData
{
    var string  MenuName;           // The name to display on the interface.
    var bool    bHasVariants;       // If true, this construction has variants (e.g., an AT gun with a different mount)
    var bool    bHasSkins;          // If true, this construction has skins for the selected variant.
};

// Variant & Skin Index
var int VariantIndex;
var int SkinIndex;

// When true, this construction is "active" and counts towards the owning team's active limit.
var bool bIsActive;

// Debugging
var bool bSinglePlayerOnly;  // If true, this construction can only be placed in single player mode.
                             // Used to prevent players from placing constructions that are not yet ready for multiplayer.

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        TeamIndex, StateName;
}

// Modify this to have this construction be a proxy for another construction
// based on the context (e.g., the player's faction)
static function class<DHConstruction> GetConstructionClass(DHActorProxy.Context Context)
{
    return default.Class;
}

static function bool IsProxyClass(DHActorProxy.Context Context)
{
    return GetConstructionClass(Context) != default.Class;
}

simulated function OnPlaced();
simulated function OnConstructed();
function OnStageIndexChanged(int OldIndex);
simulated function OnTeamIndexChanged();
function OnProgressChanged(Pawn InstigatedBy);
function OnHealthChanged();

simulated function bool IsBroken() { return false; }
simulated function bool IsConstructed() { return false; }
simulated function bool IsTattered() { return false; }
simulated function bool CanBeBuilt() { return false; }
simulated function bool CanBeCut() { return false; }
simulated function bool IsDummy() { return false; }

final simulated function int GetTeamIndex()
{
    return TeamIndex;
}

final function SetTeamIndex(int TeamIndex)
{
    self.TeamIndex = TeamIndex;
    OnTeamIndexChanged();
    NetUpdateTime = Level.TimeSeconds - 1.0;
}

// Return a reliable location for tracing this actor by explosives, as tracing
// origin can fail unexpectedly (for example, if it's sunk under the terrain)
simulated function Vector GetExplosiveDamageTraceLocation()
{
    return Location + (ExplosionDamageTraceOffset >> Rotation);
}

function IncrementProgress(Pawn InstigatedBy)
{
    Progress += 1;
    OnProgressChanged(InstigatedBy);
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    SetCollisionSize(0.0, 0.0);

    Disable('Tick');

    LevelInfo = Class'DH_LevelInfo'.static.GetInstance(Level);
    Manager = Class'DHConstructionManager'.static.GetInstance(Level);

    if (Role == ROLE_Authority)
    {
        SetTeamIndex(int(TeamOwner));
        Health = HealthMax;
    }

    if (Manager != none)
    {
        Manager.Register(self);
    }
    else
    {
        Warn("Unable to find construction manager!");
    }
}

simulated function SpawnConstructionSockets()
{
    local int i;
    local DHConstructionSocket Socket;

    if (Role != ROLE_Authority)
    {
        return;
    }

    for (i = 0; i < ConstructionSockets.Length; ++i)
    {
        if (ConstructionSockets[i].SocketActor != none)
        {
            // Socket actor is already spawned.
            continue;
        }

        Socket = Spawn(Class'DHConstructionSocket', self);

        if (Socket == none)
        {
            Warn("Failed to spawn construction socket" @ i @ "for" @ self);
            continue;
        }

        Socket.bLimitLocalRotation = ConstructionSockets[i].bLimitLocalRotation;
        Socket.LocalRotationYawRange = ConstructionSockets[i].LocalRotationYawRange;
        Socket.IncludeClasses = ConstructionSockets[i].IncludeClasses;
        Socket.ExcludeClasses = ConstructionSockets[i].ExcludeClasses;
        Socket.SetBase(self);
        Socket.SetRelativeLocation(ConstructionSockets[i].Location);
        Socket.SetRelativeRotation(ConstructionSockets[i].Rotation);
        ConstructionSockets[i].SocketActor = Socket;
    }
}

simulated function DestroyConstructionSockets()
{
    local int i;

    for (i = 0; i < ConstructionSockets.Length; ++i)
    {
        if (ConstructionSockets[i].SocketActor != none)
        {
            ConstructionSockets[i].SocketActor.Destroy();
        }
    }
}

// Called when this construction is placed by a player to update the active and remaining counts.
function Activate(int InstigatorTeamIndex)
{
    local DHGameReplicationInfo GRI;
    local int ConstructionIndex;

    if (bIsActive)
    {
        return;
    }

    if (!IsPlacedByPlayer())
    {
        Warn("Activate call was attempted on a non-player placed construction!");
        return;
    }
    
    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI == none)
    {
        return;
    }

    ConstructionIndex = GRI.GetTeamConstructionIndex(InstigatorTeamIndex, Class);

    if (ConstructionIndex != -1)
    {
        // Decrement the remaining count of this construction type.
        GRI.Constructions[ConstructionIndex].Remaining = Max(0, int(GRI.Constructions[ConstructionIndex].Remaining) - 1);
        GRI.Constructions[ConstructionIndex].Active += 1;
    }

    bIsActive = true;
}

// Called when this construction is torn down, broken or destroyed.
// `bInstigatorIsFriendly` indicates if this deactivation was caused by friendly action,
// used to determine if the Remaining count should be incremented.
function Deactivate(optional bool bInstigatorIsFriendly)
{
    local DHGameReplicationInfo GRI;
    local int ConstructionIndex;

    if (Role != ROLE_Authority)
    {
        // Only the server can deactivate constructions.
        return;
    }

    if (!bIsActive)
    {
        // We are not active, so we can't deactivate.
        return;
    }

    if (!IsPlacedByPlayer())
    {
        // We don't care about non-player placed constructions.
        return;
    }

    GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);

    if (GRI == none)
    {
        return;
    }

    ConstructionIndex = GRI.GetTeamConstructionIndex(TeamIndex, Class);

    if (ConstructionIndex != -1)
    {
        // Increment the remaining count of this construction type.
        GRI.Constructions[ConstructionIndex].Active = Max(0, int(GRI.Constructions[ConstructionIndex].Active) - 1);

        if (bInstigatorIsFriendly)
        {
            // Instigator is friendly, so increment the remaining count (i.e., put it back in the pool).
            GRI.Constructions[ConstructionIndex].Remaining += 1;
        }
    }

    bIsActive = false;
}

// Called when this construction is spawned by a player
function OnSpawnedByPlayer(DHPlayer PC)
{
    if (PC == none)
    {
        return;
    }
    
    Activate(PC.GetTeamNum());
}

// Terrain poking is wacky. Here's a few things you should know before using
// this system. First off, it's incredibly finicky. For starts, if the Radius
// is too low, it decreases the chance of a PokeTerrain success. Secondly,
// for some reason, non-zero PlacementOffset values play havoc with the ability
// to successfully poke the terrain. Even when it should realistically have no
// effect whatsoever. Additionally, in order to ensure that the Terrain can be
// reliably poked, it's recommended to have the TerrainInfo's Location be at
// world origin, or it increases the likelihood of failure (or in some cases,
// makes it impossible!)
simulated function PokeTerrain(float Radius, float Depth)
{
    local TerrainInfo TI;
    local Vector HitLocation, HitNormal, TraceEnd, TraceStart, MyPlacementOffset;

    MyPlacementOffset = GetPlacementOffset(GetContext());

    // Trace to get the terrain height at this location.
    TraceStart = Location - MyPlacementOffset;
    TraceStart.Z += 1000.0;

    TraceEnd = Location - MyPlacementOffset;
    TraceEnd.Z -= 1000.0;

    foreach TraceActors(Class'TerrainInfo', TI, HitLocation, HitNormal, TraceEnd, TraceStart)
    {
        if (TI != none)
        {
            // HACK: There is a terrible bug on Mac/Linux platforms where having a
            // larger poke radius causes the terrain to be poked excessively.
            // This little trick fixes the problem, even if it doesn't look
            // as nice!
            if (PlatformIsMacOS() || PlatformIsUnix())
            {
                Radius = 1.0;
            }

            TI.PokeTerrain(HitLocation, Radius, Depth);
        }
    }
}

// A dummy state, use this when you want this actor to stay around but be
// completely uninteractive with the world. Useful if you want another actor to
// govern the lifetime of this actor, for example.
simulated state Dummy
{
    simulated function BeginState()
    {
        super.BeginState();

        DestroyConstructionSockets();
    }

    simulated function bool IsDummy()
    {
        return true;
    }

    // Take no damage.
    function TakeDamage(int Damage, Pawn EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional int HitIndex);

Begin:
    if (Role == ROLE_Authority)
    {
        StateName = GetStateName();
        SetCollision(false, false, false);
        SetDrawType(DT_None);
        NetUpdateTime = Level.TimeSeconds - 1.0;
    }
}

simulated event Destroyed()
{
    if (Manager != none)
    {
        Manager.Unregister(self);
    }

    if (bPokesTerrain && bDidPokeTerrain)
    {
        // NOTE: This attempts to "unpoke" the terrain, if it was poked upon
        // construction. Unforunately, this seems to have a less than 100%
        // success rate due to some underlying bug in the native PokeTerrain
        // functionality.
        GetTerrainPokeParameters(PokeTerrainRadius, PokeTerrainDepth);

        PokeTerrain(PokeTerrainRadius, -PokeTerrainDepth);
    }

    DestroyConstructionSockets();

    Deactivate(false);

    super.Destroyed();
}

function array<DHConstructionSupplyAttachment> GetTouchingSupplyAttachments()
{
    local array<DHConstructionSupplyAttachment> Attachments;
    local DHConstructionSupplyAttachment Attachment;

    foreach AllActors(Class'DHConstructionSupplyAttachment', Attachment)
    {
        if (Attachment.IsTouchingActor(self))
        {
            Attachments[Attachments.Length] = Attachment;
        }
    }

    return Attachments;
}

// Returns the number of supply points that were refunded.
function int RefundSupplies(Pawn Instigator)
{
    local int i;
    local int MySupplyCost;
    local int SuppliesToRefund, SuppliesRefunded;
    local array<DHConstructionSupplyAttachment> Attachments;
    local UComparator AttachmentComparator;

    MySupplyCost = GetSupplyCost(GetContext());

    if (IsPlacedByPlayer() && (TeamIndex == NEUTRAL_TEAM_INDEX || TeamIndex == Instigator.GetTeamNum()))
    {
        // Sort the supply attachments by priority.
        Attachments = GetTouchingSupplyAttachments();
        AttachmentComparator = new Class'UComparator';
        AttachmentComparator.CompareFunction = Class'DHConstructionSupplyAttachment'.static.CompareFunction;
        Class'USort'.static.Sort(Attachments, AttachmentComparator);

        // Refund supplies to the touching supply attachments.
        for (i = 0; i < Attachments.Length && MySupplyCost > 0; ++i)
        {
            SuppliesToRefund = Min(MySupplyCost, Attachments[i].SupplyCountMax - Attachments[i].GetSupplyCount());
            Attachments[i].SetSupplyCount(Attachments[i].GetSupplyCount() + SuppliesToRefund);
            SuppliesRefunded += SuppliesToRefund;
            MySupplyCost -= SuppliesToRefund;
        }
    }

    return SuppliesRefunded;
}

function TearDown(Pawn Instigator)
{
    local int SuppliesRefunded;

    if (bShouldRefundSuppliesOnTearDown)
    {
        SuppliesRefunded = RefundSupplies(Instigator);

        if (SuppliesRefunded > 0)
        {
            // Send a message to the instigating player about the amount of supplies that were refunded.
            Instigator.ReceiveLocalizedMessage(Class'DHsupplyMessage', Class'UInteger'.static.FromShorts(7, SuppliesRefunded));
        }
    }

    if (IsPlacedByPlayer())
    {
        if (Instigator.GetTeamNum() == TeamIndex)
        {
            // Deactivate with friendly instigator (i.e., put the construction back in the remaining pool).
            Deactivate(true);
        }

        Destroy();
    }
    else
    {
        // This construction was placed in the editor, so go to the
        // dummy state.
        GotoState('Dummy');
    }
}

auto simulated state Constructing
{
    simulated function BeginState()
    {
        // Client
        if (Level.NetMode != NM_DedicatedServer)
        {
            if (PlacementEmitterClass != none)
            {
                Spawn(PlacementEmitterClass);
            }

            if (PlacementSound != none)
            {
                PlaySound(PlacementSound, SLOT_Misc, PlacementSoundVolume,, PlacementSoundRadius,, true);
            }
        }
    }

    simulated function bool CanBeBuilt()
    {
        return true;
    }

    function TakeTearDownDamage(Pawn InstigatedBy)
    {
        Progress -= 1;
        OnProgressChanged(InstigatedBy);
    }

    function OnProgressChanged(Pawn InstigatedBy)
    {
        local int i;
        local int OldStageIndex;
        local DHGameReplicationInfo GRI;
        local DH_LevelInfo LI;

        GRI = DHGameReplicationInfo(Level.Game.GameReplicationInfo);
        LI = Class'DH_LevelInfo'.static.GetInstance(Level);

        if (bCanDieOfStagnation)
        {
            Lifespan = StagnationLifespan;
        }

        if (Progress < 0)
        {
            TearDown(InstigatedBy);
        }
        else if (Progress >= ProgressMax)
        {
            GotoState('Constructed');
        }
        else
        {
            for (i = Stages.Length - 1; i >= 0; --i)
            {
                if (Progress >= Stages[i].Progress)
                {
                    if (StageIndex != i)
                    {
                        OldStageIndex = StageIndex;
                        StageIndex = i;
                        OnStageIndexChanged(OldStageIndex);
                        UpdateAppearance();
                        NetUpdateTime = Level.TimeSeconds - 1.0;
                    }

                    break;
                }
            }
        }
    }

// This only runs on server/authority
Begin:
    if (Role == ROLE_Authority) // this is likely unneeded
    {
        // When placed in the SDK, the Owner will be none.
        // DEBUG: Construct instantly.
        if ((Owner == none &&
             bShouldAutoConstruct) ||
            (DarkestHourGame(Level.Game) != none &&
             DarkestHourGame(Level.Game).bDebugConstructions))
        {
            bShouldAutoConstruct = false;
            Progress = ProgressMax;
        }

        // Reset the draw type to static mesh (this is to undo the Dummy state
        // setting the draw type to none).
        SetDrawType(DT_StaticMesh);

        StateName = GetStateName();

        if (default.Stages.Length == 0)
        {
            // There are no intermediate stages, so put the construction immediately
            // into the fully constructed state.
            Progress = ProgressMax;
        }

        OnProgressChanged(none);
    }
}

simulated function bool IsPlacedByPlayer()
{
    // Dynamically placed actors are owned by the LevelInfo. If it was placed
    // in-editor, it will not have an owner. This is a nice implicit way of
    // knowing if something was created in-editor or not.
    return Owner != none;
}

simulated state Constructed
{
    simulated function BeginState()
    {
        local DarkestHourGame G;

        if (Role == ROLE_Authority)
        {
            // Reset lifespan so that we don't die of stagnation.
            Lifespan = 0;

            if (!bHasBeenConstructed)
            {
                G = DarkestHourGame(Level.Game);

                if (G != none && G.Metrics != none && G.GameReplicationInfo != none)
                {
                    G.Metrics.OnConstructionBuilt(self, G.GameReplicationInfo.ElapsedTime - G.RoundStartTime);
                }

                if (InstigatorController != none)
                {
                    InstigatorController.ReceiveScoreEvent(Class'DHScoreEvent_ConstructionCompleted'.static.Create(Class));
                }

                SpawnConstructionSockets();

                bHasBeenConstructed = true;
            }

            if (bDestroyOnConstruction)
            {
                Destroy();
            }
            else if (bDummyOnConstruction)
            {
                GotoState('Dummy');
            }
            else
            {
                StageIndex = default.StageIndex;
                TearDownProgress = 0;
                UpdateAppearance();
                StateName = GetStateName();
                NetUpdateTime = Level.TimeSeconds - 1.0;
            }
        }

        if (bPokesTerrain)
        {
            GetTerrainPokeParameters(PokeTerrainRadius, PokeTerrainDepth);
            PokeTerrain(PokeTerrainRadius, PokeTerrainDepth);

            bDidPokeTerrain = true;
        }

        OnConstructed();
    }

    function KImpact(Actor Other, Vector Pos, Vector ImpactVel, Vector ImpactNorm)
    {
        local float Momentum;
        local int Damage;
        local Pawn P;

        if (Level.TimeSeconds - LastImpactTimeSeconds >= 1.0)  // TODO: magic number
        {
            LastImpactTimeSeconds = Level.TimeSeconds;

            if (bCanTakeImpactDamage && Role == ROLE_Authority)
            {
                Momentum = Other.KGetMass() * VSize(ImpactVel);
                Damage = int(Momentum * ImpactDamageModifier);
                P = Pawn(Other);

                if (P != none && GetTeamIndex() != -1 && P.GetTeamNum() == GetTeamIndex())
                {
                    Damage *= FriendlyFireDamageScale;
                }

                if (Damage > 0)
                {
                    DelayedDamage = Damage;
                    DelayedDamageType = ImpactDamageType;
                    GotoState(GetStateName(), 'DelayedDamage');
                }
            }
        }
    }

    simulated function bool IsConstructed()
    {
        return true;
    }

    function TakeTearDownDamage(Pawn InstigatedBy)
    {
        TearDownProgress += TakeDownProgressInterval;

        if (TearDownProgress >= ProgressMax)
        {
            // If the construction has no stages or is cut, then destroy it
            if (default.Stages.Length == 0 || StaticMesh == CutStaticMesh)
            {
                Destroy();
            }
            else if (bBreakOnTearDown)
            {
                BreakMe();
            }
            else
            {
                Progress = ProgressMax - 1;
                GotoState('Constructing');
            }
        }
    }

    function OnHealthChanged()
    {
        local StaticMesh NewStaticMesh;

        if (TatteredHealthThreshold != -1)
        {
            if (Health <= TatteredHealthThreshold)
            {
                NewStaticMesh = GetTatteredStaticMesh();

                if (NewStaticMesh == none)
                {
                    Warn("No tattered static mesh found!");
                }
                else
                {
                    SetStaticMesh(NewStaticMesh);
                    NetUpdateTime = Level.TimeSeconds - 1.0;
                }
            }
        }
    }

    simulated function bool CanTakeTearDownDamageFromPawn(Pawn P, optional bool bShouldSendErrorMessage)
    {
        return bCanBeTornDownWhenConstructed && (bCanBeTornDownByFriendlies || (P != none && P.GetTeamNum() != TeamIndex));
    }

// This is required because we cannot call TakeDamage within the KImpact
// function, because down the line is disables karma collision after going into
// the broken state, causing a crash in native code. Delaying the damage until
// the next frame works to avoid the crash!
DelayedDamage:
    Sleep(0.1);
    TakeDamage(DelayedDamage, none, vect(0, 0, 0), vect(0, 0, 0), DelayedDamageType);
}

simulated state Cut extends Constructed
{
    simulated function BeginState()
    {
        // Server
        if (Role == ROLE_Authority)
        {
            TearDownProgress = ProgressMax - (ProgressMax * TakeDownProgressInterval);
            SetStaticMesh(CutStaticMesh);
            StateName = GetStateName();
            NetUpdateTime = Level.TimeSeconds - 1.0;
        }

        // Client
        if (Level.NetMode != NM_DedicatedServer)
        {
            if (CutSound != none)
            {
                PlaySound(CutSound, SLOT_Misc, CutSoundVolume,, CutSoundRadius,, true);
            }
        }
    }
}

// Override this for additional functionality when construction breaks.
simulated function OnBroken();

simulated state Broken
{
    simulated function BeginState()
    {
        if (Role == ROLE_Authority)
        {
            UpdateAppearance();
            StateName = GetStateName();
            SetTimer(BrokenLifespan, false);
            NetUpdateTime = Level.TimeSeconds - 1.0;
        }

        if (Level.NetMode != NM_DedicatedServer)
        {
            if (BrokenEmitterClass != none)
            {
                Spawn(BrokenEmitterClass, self,, Location, Rotation);
            }

            if (BrokenSounds.Length > 0)
            {
                PlaySound(BrokenSounds[Rand(BrokenSounds.Length)],, BrokenSoundVolume,, BrokenSoundRadius, BrokenSoundPitch, true);
            }
        }

        if (Role == ROLE_Authority)
        {
            Deactivate(false);
        }

        OnBroken();
    }

    event TakeDamage(int Damage, Pawn EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional int HitIndex)
    {
        // Do nothing, since we're broken already!
    }

    simulated function bool IsBroken()
    {
        return true;
    }

    simulated function Timer()
    {
        if (Role == ROLE_Authority)
        {
            if (Owner == none)
            {
                GotoState('Dummy');
            }
            else
            {
                Destroy();
            }
        }
    }
}

function UpdateAppearance()
{
    if (IsConstructed())
    {
        SetStaticMesh(static.GetConstructedStaticMesh(GetContext()));
        SetCollision(true, true, true);
        KSetBlockKarma(true);
    }
    else if (IsBroken())
    {
        SetStaticMesh(GetBrokenStaticMesh());
        SetCollision(false, false, false);
        KSetBlockKarma(false);
    }
    else
    {
        SetStaticMesh(GetStageStaticMesh(StageIndex));
        SetCollision(true, true, true);
        KSetBlockKarma(false);
    }
}

function StaticMesh GetTatteredStaticMesh()
{
    return default.TatteredStaticMesh;
}

static function StaticMesh GetConstructedStaticMesh(DHActorProxy.Context Context)
{
    return default.StaticMesh;
}

function StaticMesh GetBrokenStaticMesh()
{
    return default.BrokenStaticMesh;
}

function StaticMesh GetStageStaticMesh(int StageIndex)
{
    if (StageIndex < 0 || StageIndex >= default.Stages.Length)
    {
        return default.StaticMesh;
    }
    else
    {
        return default.Stages[StageIndex].StaticMesh;
    }

    return none;
}

static function string GetMenuName(DHActorProxy.Context Context)
{
    return default.MenuName;
}

static function Material GetMenuIcon(DHActorProxy.Context Context)
{
    return default.MenuIcon;
}

simulated static function int GetSupplyCost(DHActorProxy.Context Context)
{
    return default.SupplyCost;
}

static function GetCollisionSize(DHActorProxy.Context Context, out float NewRadius, out float NewHeight)
{
    NewRadius = default.CollisionRadius;
    NewHeight = default.CollisionHeight;
}

static function bool ShouldShowOnMenu(DHActorProxy.Context Context)
{
    local DHPlayerReplicationInfo PRI;

    PRI = DHPlayerReplicationInfo(Context.PlayerController.PlayerReplicationInfo);

    if (default.bSinglePlayerOnly && (Context.LevelInfo != none && Context.LevelInfo.Level.NetMode != NM_Standalone))
    {
        return false;
    }

    // Only show constructions the player is allowed to place
    if (PRI != none)
    {
        return IsPlaceableByPlayer(PRI);
    }
    else
    {
        return false;
    }
}

static function bool IsPlaceableByPlayer(DHPlayerReplicationInfo PRI)
{
    return PRI.IsSLorASL();
}

// This function is used for determining if a player is able to build this type
// of construction. You can override this if you want to have a team or
// role-specific constructions, for example.
static function ConstructionError GetPlayerError(DHActorProxy.Context Context)
{
    local DHPawn P;
    local DHConstructionManager CM;
    local DHPlayerReplicationInfo PRI;
    local DHSquadReplicationInfo SRI;
    local ConstructionError E;
    local DHGameReplicationInfo GRI;
    local int MaxActive;

    if (Context.PlayerController == none)
    {
        E.Type = ERROR_Fatal;
        return E;
    }

    if (Context.LevelInfo != none && Context.LevelInfo.IsConstructionRestricted(default.Class))
    {
        E.Type = ERROR_RestrictedType;
        return E;
    }

    P = DHPawn(Context.PlayerController.Pawn);

    if (P == none)
    {
        E.Type = ERROR_Fatal;
        return E;
    }

    if (!P.CanSwitchWeapon())
    {
        E.Type = ERROR_PlayerBusy;
        return E;
    }

    CM = Class'DHConstructionManager'.static.GetInstance(P.Level);

    if (CM == none)
    {
        E.Type = ERROR_Fatal;
        return E;
    }

    SRI = Context.PlayerController.SquadReplicationInfo;
    PRI = DHPlayerReplicationInfo(P.PlayerReplicationInfo);
    GRI = DHGameReplicationInfo(Context.PlayerController.GameReplicationInfo);

    if (PRI == none || SRI == none || GRI == none || !IsPlaceableByPlayer(PRI))
    {
        E.Type = ERROR_Fatal;
        return E;
    }

    MaxActive = Context.LevelInfo.GetConstructionMaxActive(Context.TeamIndex, default.Class);

    if (MaxActive >= 0 && GRI.GetTeamConstructionActive(Context.TeamIndex, default.Class) >= MaxActive)
    {
        E.Type = ERROR_MaxActive;
        E.OptionalInteger = MaxActive;
        return E;
    }

    if (P.Level.NetMode != NM_Standalone && !PRI.bAdmin && SRI.GetMemberCount(P.GetTeamNum(), PRI.SquadIndex) < default.SquadMemberCountMinimum)
    {
        E.Type = ERROR_SquadTooSmall;
        E.OptionalInteger = default.SquadMemberCountMinimum;
        return E;
    }

    if (static.GetSupplyCost(Context) > 0 && P.TouchingSupplyCount < static.GetSupplyCost(Context))
    {
        E.Type = ERROR_InsufficientSupply;
        return E;
    }

    if (!GRI.HasTeamConstructionRemaining(P.GetTeamNum(), default.Class))
    {
        E.Type = ERROR_Exhausted;
        return E;
    }

    return E;
}

simulated function Reset()
{
    if (Role == ROLE_Authority)
    {
        if (ShouldDestroyOnReset())
        {
            Destroy();
        }
        else
        {
            Health = HealthMax;
            bShouldAutoConstruct = true;
            GotoState('Constructing');
        }
    }
}

// Override to set a new proxy appearance if you require something more
// complex than a simple static mesh.
static function UpdateProxy(DHActorProxy CP)
{
    local int i;
    local array<Material> StaticMeshSkins;

    CP.SetDrawType(DT_StaticMesh);
    CP.SetStaticMesh(GetProxyStaticMesh(CP.GetContext()));

    StaticMeshSkins = (new Class'UStaticMesh').FindStaticMeshSkins(CP.StaticMesh);

    for (i = 0; i < StaticMeshSkins.Length; ++i)
    {
        CP.Skins[i] = CP.CreateProxyMaterial(StaticMeshSkins[i]);
    }
}

// Override to output if the construction class has variants or skins.
static function RuntimeData CreateProxyRuntimeData(DHConstructionProxy CP)
{
    local RuntimeData RuntimeData;

    RuntimeData.MenuName = GetMenuName(CP.GetContext());

    return RuntimeData;
}

// Override to return the default skin index for the selected variant.
static function int GetDefaultSkinIndexForVariant(DHActorProxy.Context Context, int VariantIndex);

static function StaticMesh GetProxyStaticMesh(DHActorProxy.Context Context)
{
    return static.GetConstructedStaticMesh(Context);
}

static function Vector GetPlacementOffset(DHActorProxy.Context Context)
{
    return default.PlacementOffset;
}

//==============================================================================
// DAMAGE
//==============================================================================

function bool ShouldTakeDamageFromDamageType(class<DamageType> DamageType)
{
    local int i;

    if (bCanTakeImpactDamage && DamageType == ImpactDamageType)
    {
        return true;
    }

    for (i = 0; i < HarmfulDamageTypes.Length; ++i)
    {
        if (DamageType == HarmfulDamageTypes[i] || ClassIsChildOf(DamageType, HarmfulDamageTypes[i]))
        {
            return true;
        }
    }

    return false;
}

simulated function bool CanTakeTearDownDamageFromPawn(Pawn P, optional bool bShouldSendErrorMessage)
{
    return true;
}

function CutConstruction(Pawn InstigatedBy);

function TakeTearDownDamage(Pawn InstigatedBy);

function TakeDamage(int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    local class<DamageType> TearDownDamageType;

    TearDownDamageType = class<DamageType>(DynamicLoadObject("DH_Equipment.DHShovelBashDamageType", Class'class'));

    if (DamageType != none && DamageType.static.ClassIsChildOf(DamageType, TearDownDamageType) && CanTakeTearDownDamageFromPawn(InstigatedBy, true))
    {
        TakeTearDownDamage(InstigatedBy);
        return;
    }

    if (bCanBeDamaged && ShouldTakeDamageFromDamageType(DamageType))
    {
        Damage = GetScaledDamage(DamageType, Damage);

        if (InstigatedBy != none && InstigatedBy.GetTeamNum() == TeamIndex)
        {
            Damage *= FriendlyFireDamageScale;
        }

        if (Damage >= MinDamagetoHurt)
        {
            Health -= Damage;

            OnHealthChanged();

            if (Health <= 0)
            {
                BreakMe();
            }
        }
    }
}

function int GetScaledDamage(class<DamageType> DamageType, int Damage)
{
    local int i;

    for (i = 0; i < DamageTypeScales.Length; ++i)
    {
        if (DamageType == DamageTypeScales[i].DamageType ||
            ClassIsChildOf(DamageType, DamageTypeScales[i].DamageType))
        {
            return Damage * DamageTypeScales[i].Scale;
        }
    }

    return Damage;
}

simulated function PostNetReceive()
{
    super.PostNetReceive();

    if (StateName != GetStateName())
    {
        GotoState(StateName);
    }

    if (TeamIndex != OldTeamIndex)
    {
        OnTeamIndexChanged();

        OldTeamIndex = TeamIndex;
    }
}

function BreakMe()
{
    if (!IsBroken())
    {
        GotoState('Broken');
    }
}

simulated function bool ShouldDestroyOnReset()
{
    return IsPlacedByPlayer();
}

simulated function GetTerrainPokeParameters(out int Radius, out int Depth)
{
    Radius = default.PokeTerrainRadius;
    Depth = default.PokeTerrainDepth;
}

simulated function DHActorProxy.Context GetContext()
{
    local DHActorProxy.Context Context;

    Context.TeamIndex = GetTeamIndex();
    Context.LevelInfo = LevelInfo;
    Context.GroundActor = Owner;
    Context.VariantIndex = VariantIndex;
    Context.SkinIndex = SkinIndex;

    return Context;
}

static function DHActorProxy.Context ContextFromPlayerController(DHPlayer PC)
{
    local DHActorProxy.Context Context;

    if (PC != none)
    {
        Context.TeamIndex = PC.GetTeamNum();
        Context.LevelInfo = Class'DH_LevelInfo'.static.GetInstance(PC.Level);
        Context.PlayerController = PC;
    }

    return Context;
}

// This is used to return a custom error that is class specific for specialized
// placement logic. By default this simply returns no error.
static function DHConstruction.ConstructionError GetCustomProxyError(DHConstructionProxy P)
{
    local DHConstruction.ConstructionError E;

    return E;
}

static function bool IsArtillery()
{
    return default.bIsArtillery;
}

defaultproperties
{
    TeamOwner=TEAM_Neutral
    OldTeamIndex=2  // NEUTRAL_TEAM_INDEX
    TeamIndex=2     // NEUTRAL_TEAM_INDEX
    RemoteRole=ROLE_DumbProxy
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DH_Construction_stc.hedgehog_01'
    HealthMax=100
    Health=1
    ProxyTraceDepthMeters=5.0
    ProxyTraceHeightMeters=2.0
    GroundSlopeMaxInDegrees=25.0

    bStatic=false
    bNoDelete=false
    bCanBeDamaged=true
    bUseCylinderCollision=false
    bCollideActors=true
    bCollideWorld=false
    bBlockActors=true
    bBlockKarma=true
    bCanPlaceInObjective=true

    // Karma params
    Begin Object Class=KarmaParamsRBFull Name=KParams0
        KInertiaTensor(0)=1.000000
        KInertiaTensor(3)=3.000000
        KInertiaTensor(5)=3.000000
        KCOMOffset=(X=0,Y=0,Z=0)
        KLinearDamping=1.0
        KAngularDamping=1.0
        KStartEnabled=true
        bKNonSphericalInertia=true
        bHighDetailOnly=false
        bClientOnly=false
        bKDoubleTickRate=false
        bDestroyOnWorldPenetrate=false
        bDoSafetime=true
        KFriction=0.500000
        KImpactThreshold=100.000000
        KMaxAngularSpeed=1.0
        KMass=0.0
    End Object
    KParams=KParams0

    CollisionHeight=30.0
    CollisionRadius=60.0

    bNetNotify=true
    NetUpdateFrequency=10.0
    bAlwaysRelevant=true
    bOnlyDirtyReplication=true

    bBlockZeroExtentTraces=true
    bBlockNonZeroExtentTraces=true
    bBlockProjectiles=true
    bProjTarget=true
    bPathColliding=true
    bWorldGeometry=true
    ExplosionDamageTraceOffset=(Z=10.0)

    // Placement
    bCanPlaceInWater=false
    bCanPlaceIndoors=false
    FloatToleranceInMeters=0.5
    PlacementSound=Sound'Inf_Player.Gibimpact'
    PlacementEmitterClass=Class'DHConstructionEffect'
    PlacementSoundRadius=60.0
    PlacementSoundVolume=4.0
    IndoorsCeilingHeightInMeters=25.0
    PokeTerrainRadius=32
    PokeTerrainDepth=32
    TerrainScaleMax=256.0
    bShouldAlignToGround=true
    ArcLengthTraceIntervalInMeters=1.0
    bShouldSwitchToLastWeaponOnPlacement=true

    // Stagnation
    bCanDieOfStagnation=true
    StagnationLifespan=300

    LocalRotationRate=32768

    // Death
    BrokenLifespan=15.0
    bCanBeTornDownWhenConstructed=true

    // Progress
    StageIndex=-1
    ProgressMax=4

    // Damage
    TatteredHealthThreshold=-1
    MinDamagetoHurt=100
    HarmfulDamageTypes(0)=Class'DHArtilleryDamageType'              // Artillery
    HarmfulDamageTypes(1)=Class'ROTankShellExplosionDamage'         // HE Splash
    HarmfulDamageTypes(2)=Class'DHShellHEImpactDamageType'          // HE Impact
    HarmfulDamageTypes(3)=Class'DHShellAPImpactDamageType'          // AP Impact
    HarmfulDamageTypes(4)=Class'DHRocketImpactDamage'               // AT Rocket Impact
    HarmfulDamageTypes(5)=Class'DHThrowableExplosiveDamageType'     // Satchel/Grenades
    HarmfulDamageTypes(6)=Class'DHMortarDamageType'                 // Mortar

    // Impact
    bCanTakeImpactDamage=false
    ImpactDamageType=Class'Crushed'
    ImpactDamageModifier=0.1

    SquadMemberCountMinimum=2
    bCanBeMantled=true
    bCanBeTornDownByFriendlies=true
    FriendlyFireDamageScale=1.0
    bShouldAutoConstruct=true

    ConstructionVerb="build"

    bShouldRefundSuppliesOnTearDown=true
    TakeDownProgressInterval=0.5

    // Broken
    BrokenSoundRadius=100.0
    BrokenSoundPitch=1.0
    BrokenSoundVolume=5.0

    CompletionPointValue=10

    bIsArtillery=false
}
