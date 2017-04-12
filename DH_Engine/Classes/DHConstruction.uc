//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstruction extends Actor
    abstract
    placeable;

enum EConstructionError
{
    ERROR_None,
    ERROR_Fatal,            // Some fatal error occurred, usually a case of unexpected values
    ERROR_NoGround,         // No solid ground was able to be found
    ERROR_TooSteep,         // The ground slope exceeded the allowable maximum
    ERROR_InWater,          // The construction is in water and the construction type disallows this
    ERROR_Restricted,       // Construction overlaps a restriction volume
    ERROR_NoRoom,           // No room to place this construction
    ERROR_NotOnTerrain,     // Construction is not on terrain
    ERROR_TooClose,         // Too close to an identical construction
    ERROR_InMinefield,      // Cannot be in a minefield!
    ERROR_NearSpawnPoint,   // Cannot be so close to a spawn point (or location hint)
    ERROR_Other             // ERROR:
};

enum ETeamOwner
{
    TEAM_Axis,
    TEAM_Allies,
    TEAM_Neutral
};

var() ETeamOwner TeamOwner;                 // This enum is for the levelers' convenience only.
var private int TeamIndex;

// Placement
var     float   ProxyDistanceInMeters;      // The distance at which the proxy object will be away from the player when
var     bool    bShouldAlignToGround;
var     bool    bCanPlaceInWater;
var     bool    bCanPlaceIndoors;
var     bool    bCanOnlyPlaceOnTerrain;
var     float   GroundSlopeMaxInDegrees;
var     rotator StartRotationMin;
var     rotator StartRotationMax;
var     int     LocalRotationRate;
var     vector  PlacementOffset;

var     sound   PlacementSound;
var     float   PlacementSoundRadius;
var     float   PlacementSoundVolume;

var     float   FloatToleranceInMeters;         // The distance the construction is allowed to "float" off of the ground at any given point along it's circumfrence
var     float   DuplicateDistanceInMeters;      // The distance required between identical constructions of the same type
var     class<Emitter> PlacementEmitterClass;

// Construction
var     int     SupplyCost;                     // The amount of supply points this construction costs.
var     bool    bDestroyOnConstruction;         // If true, this actor will be destroyed after being fully constructed.
var     int     Progress;                       // The current count of progress.
var     int     ProgressMax;                    // The amount of construction points required to be built.

// Death
var     int     DeadLifespan;                   // How long does the actor stay around after it's been killed?

// Damage
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

replication
{
    reliable if (bNetDirty && Role == ROLE_Authority)
        TeamIndex, Health;
    reliable if (Role < ROLE_Authority)
        ServerDecrementProgress, ServerIncrementProgress;
}

function OnConstructed();
function OnStageIndexChanged(int OldIndex);
function OnTeamIndexChanged();
function OnHealthChanged();
function OnProgressChanged();

final simulated function int GetTeamIndex()
{
    return TeamIndex;
}

final function SetTeamIndex(int TeamIndex)
{
    self.TeamIndex = TeamIndex;
    OnTeamIndexChanged();
}

function ServerDecrementProgress()
{
    Progress -= 1;
    OnProgressChanged();
}

function ServerIncrementProgress()
{
    Progress += 1;
    OnProgressChanged();
}

simulated function PostBeginPlay()
{
    local DH_LevelInfo LI;

    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        Log("FINDING LEVEL INFO");

        foreach AllActors(class'DH_LevelInfo', LI)
        {
            LOG("FOUND LEVEL INFO");
            LevelInfo = LI;
            break;
        }

        Log("LEVELINFO IS" @ LevelInfo);
        LOG("SETTING TEAM INDEX");

        SetTeamIndex(int(TeamOwner));

        Health = HealthMax;
    }
}

auto simulated state Constructing
{
    function OnProgressChanged()
    {
        local int i;
        local int OldStageIndex;

        if (Progress < 0)
        {
            // TODO: possibly refund supplies to nearby supply cache/vehicle?
            Destroy();
        }
        else if (Progress >= ProgressMax)
        {
            GotoState('Constructed');
        }
        else
        {
            for (i = Stages.Length - 1; i >= 0; --i)
            {
                if (Progress >= Stages[i].Progress && StageIndex != i)
                {
                    OldStageIndex = StageIndex;
                    StageIndex = i;
                    OnStageIndexChanged(OldStageIndex);
                    UpdateAppearance();
                    NetUpdateTime = Level.TimeSeconds - 1.0;
                    break;
                }
            }
        }
    }
Begin:
    if (Role == ROLE_Authority)
    {
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
Begin:
    if (Role == ROLE_Authority)
    {
        OnConstructed();

        if (bDestroyOnConstruction)
        {
            Destroy();
        }
        else
        {
            UpdateAppearance();
            NetUpdateTime = Level.TimeSeconds - 1.0;
        }
    }
}

simulated state Dead
{
Begin:
    // TODO: set SM to destroyed SM
    Lifespan = DeadLifespan;
}

event TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitIndex);

    OnHealthChanged();
}

function UpdateAppearance()
{
    if (StageIndex < 0 || StageIndex >= default.Stages.Length)
    {
        SetStaticMesh(default.StaticMesh);
    }
    else
    {
        SetStaticMesh(default.Stages[StageIndex].StaticMesh);
    }
}

function static string GetMenuName(DHPlayer PC)
{
    return default.MenuName;
}

function static Material GetMenuIcon(DHPlayer PC)
{
    return default.MenuIcon;
}

simulated function bool CanBeBuilt()
{
    return IsInState('Constructing');
}

function static GetCollisionSize(int TeamIndex, DH_LevelInfo LI, out float NewRadius, out float NewHeight)
{
    NewRadius = default.CollisionRadius;
    NewHeight = default.CollisionHeight;
}

// This function is used for determining if a player is able to build this type
// of construction. You can override this if you want to have a team or
// role-specific constructions, for example.
function static bool CanPlayerBuild(DHPlayer PC)
{
    return true;
}

function Reset()
{
    Destroy();
}

// Override to set a new proxy appearance if you require something more
// complex than a simple static mesh.
function static UpdateProxy(DHConstructionProxy CP)
{
    local int i;
    local array<Material> StaticMeshSkins;

    CP.SetDrawType(DT_StaticMesh);
    CP.SetStaticMesh(default.StaticMesh);

    StaticMeshSkins = (new class'UStaticMesh').FindStaticMeshSkins(CP.StaticMesh);

    for (i = 0; i < StaticMeshSkins.Length; ++i)
    {
        CP.Skins[i] = CP.CreateProxyMaterial(StaticMeshSkins[i]);
    }
}

function static vector GetPlacementOffset()
{
    return default.PlacementOffset;
}

defaultproperties
{
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

    CollisionHeight=30.0
    CollisionRadius=60.0

    bNetNotify=true
    NetUpdateFrequency=0.1
    bAlwaysRelevant=false
    bOnlyDirtyReplication=true

    bBlockZeroExtentTraces=true
    bBlockNonZeroExtentTraces=true
    bBlockProjectiles=true
    bProjTarget=true

    // Temp to prevent bots from bunching up at Destroyable statics
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

    LocalRotationRate=32768

    // Death
    DeadLifespan=15.0

    // Progress
    StageIndex=-1
    Progress=0
    ProgressMax=8

    TeamIndex=NEUTRAL_TEAM_INDEX
}

