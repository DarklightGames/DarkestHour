//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction extends Actor
    abstract
    placeable;

enum EConstructionError
{
    ERROR_None,
    ERROR_Fatal,                // Some fatal error occurred, usually a case of unexpected values
    ERROR_NoGround,             // No solid ground was able to be found
    ERROR_TooSteep,             // The ground slope exceeded the allowable maximum
    ERROR_InWater,              // The construction is in water and the construction type disallows this
    ERROR_Restricted,           // Construction overlaps a restriction volume
    ERROR_NoRoom,               // No room to place this construction
    ERROR_NotOnTerrain,         // Construction is not on terrain
    ERROR_TooCloseFriendly,     // Too close to an identical friendly construction
    ERROR_TooCloseEnemy,        // Too close to an identical enemy construction
    ERROR_InMinefield,          // Cannot be in a minefield!
    ERROR_NearSpawnPoint,       // Cannot be so close to a spawn point (or location hint)
    ERROR_Indoors,              // Cannot be placed indoors
    ERROR_InObjective,          // Cannot be placed inside an objective area
    ERROR_TeamLimit,            // Limit reached for this type of construction
    ERROR_NoSupplies,           // Not within range of any supply caches
    ERROR_InsufficientSupply,   // Not enough supplies to build this construction
    ERROR_BadSurface,           // Cannot construct on this surface type
    ERROR_GroundTooHard,        // This is used when something needs to snap to the terrain, but the engine's native trace functionality isn't cooperating!
    ERROR_RestrictedType,       // Restricted construction type (can't build on this map!)
    ERROR_SquadTooSmall,        // Not enough players in the squad!
    ERROR_Other
};

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
var int TeamLimit;              // The amount of this type of construction that is allowed, per team.

// Manager
var     DHConstructionManager   Manager;

// Placement
var     float   ProxyDistanceInMeters;          // The distance at which the proxy object will be away from the player when being placed
var     bool    bShouldAlignToGround;
var     bool    bCanPlaceInWater;
var     bool    bCanPlaceIndoors;
var     float   IndoorsCeilingHeightInMeters;
var     bool    bCanOnlyPlaceOnTerrain;
var     float   GroundSlopeMaxInDegrees;
var     bool    bSnapRotation;
var     int     RotationSnapAngle;
var     rotator StartRotationMin;
var     rotator StartRotationMax;
var     int     LocalRotationRate;
var     bool    bInheritsOwnerRotation;         // If true, the base rotation of the placement (prior to local rotation) will be inherited from the owner.
var     bool    bCanPlaceInObjective;
var     int     SquadMemberCountMinimum;        // The number of members you must have in your squad to create this.

// Terrain placement
var     bool    bSnapToTerrain;                 // If true, the origin of the placement (prior to the PlacementOffset) will coincide with the nearest terrain vertex during placement.
var     bool    bPokesTerrain;                  // If true, terrain is poked when placed on terrain.
var     bool    bDidPokeTerrain;
var     int     PokeTerrainRadius;
var     int     PokeTerrainDepth;
var     float   TerrainScaleMax;                // The maximum terrain scale allowable
var     bool    bLimitTerrainSurfaceTypes;      // If true, only allow placement on terrain surfaces types in the SurfaceTypes array
var     array<ESurfaceTypes> TerrainSurfaceTypes;

var     vector          PlacementOffset;        // 3D offset in the proxy's local-space during placement
var     sound           PlacementSound;         // Sound to play when construction is first placed down
var     float           PlacementSoundRadius;
var     float           PlacementSoundVolume;
var     class<Emitter>  PlacementEmitterClass;  // Emitter to spawn when the construction is first placed down

var     float   FloatToleranceInMeters;             // The distance the construction is allowed to "float" off of the ground at any given point along it's circumfrence
var     float   DuplicateFriendlyDistanceInMeters;  // The distance required between identical constructions of the same type for FRIENDLY constructions.
var     float   DuplicateEnemyDistanceInMeters;     // The distance required between identical constructions of the same type for ENEMY constructions.

// Construction
var     int     SupplyCost;                     // The amount of supply points this construction costs
var     bool    bDestroyOnConstruction;         // If true, this actor will be destroyed after being fully constructed
var     int     Progress;                       // The current count of progress
var     int     ProgressMax;                    // The amount of construction points required to be built

// Stagnation
var     bool    bCanDieOfStagnation;            // If true, this construction will automatically destroy if no progress has been made for the amount of seconds specified in StagnationLifespan
var     float   StagnationLifespan;

// Tear-down
var     bool    bCanBeTornDown;                 // Whether or not players can
var     int     TearDownProgress;
var     int     TearDownProgressMax;

// Broken
var     float           BrokenLifespan;             // How long does the actor stay around after it's been killed?
var     StaticMesh      BrokenStaticMesh;           // Static mesh to use when the construction is broken
var     sound           BrokenSound;                // Sound to play when the construction is broken
var     float           BrokenSoundRadius;
var     float           BrokenSoundVolume;
var     class<Emitter>  BrokenEmitterClass;         // Emitter to spawn when the construction is broken

// Reset
var     bool            bShouldDestroyOnReset;      // bShouldDestroyOnReset

// Damage
struct DamageTypeScale
{
    var class<DamageType>   DamageType;
    var float               Scale;
};

var int                         MinDamagetoHurt;    // The minimum amount of damage required to actually harm the construction
var array<DamageTypeScale>      DamageTypeScales;
var array<class<DamageType> >   HarmfulDamageTypes;

// Tattered
var int                         TatteredHealthThreshold;    // The health below which the construction is considered "tattered". -1 for no tattering

// Health
var private int     Health;
var     int         HealthMax;

// Menu
var     localized string    MenuName;
var     localized Material  MenuIcon;

// Level Info
var DH_LevelInfo LevelInfo;

// Staging
struct Stage
{
    var int Progress;           // The progress level at which this stage is used.
    var StaticMesh StaticMesh;  // This can be overridden in GetStaticMesh
    var sound Sound;
    var Emitter Emitter;
};

var int StageIndex;
var array<Stage> Stages;

// Mantling
var bool bCanBeMantled;

// Squad rally points
var bool bShouldBlockSquadRallyPoints;

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        TeamIndex, StateName;
}

simulated function OnConstructed();
function OnStageIndexChanged(int OldIndex);
simulated function OnTeamIndexChanged();
function OnProgressChanged();
function OnHealthChanged();

simulated function bool IsBroken() { return false; }
simulated function bool IsConstructed() { return false; }
simulated function bool IsTattered() { return false; }
simulated function bool CanBeBuilt() { return false; }

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

function IncrementProgress()
{
    Progress += 1;
    OnProgressChanged();
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    SetCollisionSize(0.0, 0.0);

    Disable('Tick');

    LevelInfo = class'DH_LevelInfo'.static.GetInstance(Level);

    if (Role == ROLE_Authority)
    {
        SetTeamIndex(int(TeamOwner));
        Health = HealthMax;
    }

    Manager = class'DHConstructionManager'.static.GetInstance(Level);

    if (Manager != none)
    {
        Manager.Register(self);
    }
    else
    {
        Warn("Unable to find construction manager!");
    }
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
    local vector HitLocation, HitNormal, TraceEnd, TraceStart;

    // Trace to get the terrain height at this location.
    TraceStart = Location - GetPlacementOffset();
    TraceStart.Z += 1000.0;

    TraceEnd = Location - GetPlacementOffset();
    TraceEnd.Z -= 1000.0;

    foreach TraceActors(class'TerrainInfo', TI, HitLocation, HitNormal, TraceEnd, TraceStart)
    {
        if (TI != none)
        {
            TI.PokeTerrain(HitLocation, Radius, Depth);
        }
    }
}

// A dummy state, use this when you want this actor to stay around but be
// completely uninteractive with the world. Useful if you want another actor to
// govern the lifetime of this actor, for example.
simulated state Dummy
{
    // Take no damage.
    function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex);

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
        // construction. Unforunately, this seems to only have a less than 100%
        // success rate due to some underlying bug in the native PokeTerrain
        // functionality.
        PokeTerrain(PokeTerrainRadius, -PokeTerrainDepth);
    }

    super.Destroyed();
}

auto simulated state Constructing
{
    simulated function bool CanBeBuilt()
    {
        return true;
    }

    function TakeTearDownDamage()
    {
        Progress -= 1;

        OnProgressChanged();
    }

    function OnProgressChanged()
    {
        local int i;
        local int OldStageIndex;

        if (bCanDieOfStagnation)
        {
            Lifespan = StagnationLifespan;
        }

        if (Progress < 0)
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

Begin:
    if (Role == ROLE_Authority)
    {
        if (Owner == none)
        {
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

        OnProgressChanged();
    }

    // Client-side effects
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

simulated state Constructed
{
    simulated function BeginState()
    {
        if (Role == ROLE_Authority)
        {
            // Reset lifespan so that we don't die of stagnation.
            Lifespan = 0;

            if (bDestroyOnConstruction)
            {
                Destroy();
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
            PokeTerrain(PokeTerrainRadius, PokeTerrainDepth);

            bDidPokeTerrain = true;
        }

        OnConstructed();
    }

    simulated function bool IsConstructed()
    {
        return true;
    }

    function TakeTearDownDamage()
    {
        TearDownProgress += 1;

        if (TearDownProgress >= TearDownProgressMax)
        {
            if (default.Stages.Length == 0)
            {
                Destroy();
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
        if (TatteredHealthThreshold != -1)
        {
            if (Health <= TatteredHealthThreshold)
            {
                SetStaticMesh(GetTatteredStaticMesh());
                NetUpdateTime = Level.TimeSeconds - 1.0;
            }
        }
    }
}

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
        }
    }

    event TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
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
        SetStaticMesh(GetConstructedStaticMesh());
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
        KSetBlockKarma(true);
    }
}

function StaticMesh GetTatteredStaticMesh();

function StaticMesh GetConstructedStaticMesh()
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

function static string GetMenuName(DHPlayer PC)
{
    return default.MenuName;
}

function static Material GetMenuIcon(DHPlayer PC)
{
    return default.MenuIcon;
}

function static GetCollisionSize(int TeamIndex, DH_LevelInfo LI, out float NewRadius, out float NewHeight)
{
    NewRadius = default.CollisionRadius;
    NewHeight = default.CollisionHeight;
}

function static bool ShouldShowOnMenu(DHPlayer PC)
{
    return true;
}

// This function is used for determining if a player is able to build this type
// of construction. You can override this if you want to have a team or
// role-specific constructions, for example.
function static EConstructionError GetPlayerError(DHPlayer PC, optional out Object OptionalObject)
{
    local DH_LevelInfo LI;
    local DHPawn P;
    local DHConstructionManager CM;
    local DHPlayerReplicationInfo PRI;
    local DHSquadReplicationInfo SRI;

    if (PC == none)
    {
        return ERROR_Fatal;
    }

    LI = PC.GetLevelInfo();

    if (LI != none && LI.IsConstructionRestricted(default.Class))
    {
        return ERROR_RestrictedType;
    }

    P = DHPawn(PC.Pawn);

    if (P == none)
    {
        return ERROR_Fatal;
    }

    if (default.SupplyCost > 0 && P.TouchingSupplyCount < default.SupplyCost)
    {
        return ERROR_InsufficientSupply;
    }

    CM = class'DHConstructionManager'.static.GetInstance(PC.Level);

    if (CM == none)
    {
        return ERROR_Fatal;
    }

    if (default.TeamLimit > 0 && CM.CountOf(PC.GetTeamNum(), default.Class) >= default.TeamLimit)
    {
        return ERROR_TeamLimit;
    }

    SRI = PC.SquadReplicationInfo;
    PRI = DHPlayerReplicationInfo(P.PlayerReplicationInfo);

    // TODO: in future we may allow non-squad leaders to make constructions.
    if (PRI == none || SRI == none || !PRI.IsSquadLeader())
    {
        return ERROR_Fatal;
    }

    if (PC.Level.NetMode != NM_Standalone && SRI.GetMemberCount(P.GetTeamNum(), PRI.SquadIndex) < default.SquadMemberCountMinimum)
    {
        return ERROR_SquadTooSmall;
    }

    return ERROR_None;
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
            GotoState('Constructing');
        }
    }
}

// Override to set a new proxy appearance if you require something more
// complex than a simple static mesh.
function static UpdateProxy(DHConstructionProxy CP)
{
    local int i;
    local array<Material> StaticMeshSkins;

    CP.SetDrawType(DT_StaticMesh);
    CP.SetStaticMesh(GetProxyStaticMesh(CP));

    StaticMeshSkins = (new class'UStaticMesh').FindStaticMeshSkins(CP.StaticMesh);

    for (i = 0; i < StaticMeshSkins.Length; ++i)
    {
        CP.Skins[i] = CP.CreateProxyMaterial(StaticMeshSkins[i]);
    }
}

function static StaticMesh GetProxyStaticMesh(DHConstructionProxy CP)
{
    return default.StaticMesh;
}

function static vector GetPlacementOffset()
{
    return default.PlacementOffset;
}

//==============================================================================
// DAMAGE
//==============================================================================

function bool ShouldTakeDamageFromDamageType(class<DamageType> DamageType)
{
    local int i;

    for (i = 0; i < HarmfulDamageTypes.Length; ++i)
    {
        if (DamageType == HarmfulDamageTypes[i] || ClassIsChildOf(DamageType, HarmfulDamageTypes[i]))
        {
            return true;
        }
    }

    return false;
}

function TakeTearDownDamage();

function TakeDamage(int Damage, Pawn InstigatedBy, vector Hitlocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    local class<DamageType> TearDownDamageType;

    if (bCanBeTornDown)
    {
        TearDownDamageType = class<DamageType>(DynamicLoadObject("DH_Equipment.DHShovelBashDamageType", class'class'));

        if (DamageType == TearDownDamageType)
        {
            TakeTearDownDamage();
            return;
        }
    }

    if (!ShouldTakeDamageFromDamageType(DamageType))
    {
        return;
    }

    Damage = GetScaledDamage(DamageType, Damage);

    if (Damage >= MinDamagetoHurt)
    {
        Health -= GetScaledDamage(DamageType, Damage);
    }

    OnHealthChanged();

    if (Health <= 0)
    {
        GotoState('Broken');
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

simulated function bool ShouldDestroyOnReset()
{
    // Dynamically placed actors are owned by the LevelInfo. If it was placed
    // in-editor, it will not have an owner. This is a nice implicit way of
    // knowing if something was created in-editor or not.
    return Owner != none;
}

defaultproperties
{
    OldTeamIndex=2  // NEUTRAL_TEAM_INDEX
    TeamIndex=2     // NEUTRAL_TEAM_INDEX
    RemoteRole=ROLE_SimulatedProxy
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.hedgehog_01'
    HealthMax=100
    Health=1
    ProxyDistanceInMeters=5.0
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

    CollisionHeight=30.0
    CollisionRadius=60.0

    bNetNotify=true
    NetUpdateFrequency=1.0
    bAlwaysRelevant=false
    bOnlyDirtyReplication=true

    bBlockZeroExtentTraces=true
    bBlockNonZeroExtentTraces=true
    bBlockProjectiles=true
    bProjTarget=true
    bPathColliding=true
    bWorldGeometry=true

    // Placement
    bCanPlaceInWater=false
    bCanPlaceIndoors=false
    FloatToleranceInMeters=0.5
    PlacementSound=Sound'Inf_Player.Gibimpact.Gibimpact' // TODO: placeholder
    PlacementEmitterClass=class'DH_Effects.DHConstructionEffect'
    PlacementSoundRadius=60.0
    PlacementSoundVolume=4.0
    IndoorsCeilingHeightInMeters=10.0
    PokeTerrainRadius=32
    PokeTerrainDepth=32
    TerrainScaleMax=256.0
    RotationSnapAngle=16384
    bInheritsOwnerRotation=true

    // Stagnation
    bCanDieOfStagnation=true
    StagnationLifespan=300

    LocalRotationRate=32768

    // Death
    BrokenLifespan=15.0
    bCanBeTornDown=true

    // Progress
    StageIndex=-1
    Progress=0
    ProgressMax=8
    TearDownProgressMax=4

    // Damage
    HarmfulDamageTypes(0)=class'ROArtilleryDamType'
//    HarmfulDamageTypes(1)=class'DH_SatchelDamType'
    HarmfulDamageTypes(2)=class'ROTankShellExplosionDamage'
    TatteredHealthThreshold=-1
}

