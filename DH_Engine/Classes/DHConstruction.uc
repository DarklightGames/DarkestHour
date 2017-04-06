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
    ERROR_Other             // ERROR:
};

enum ETeamOwner
{
    TEAM_Axis,
    TEAM_Allies,
    TEAM_Neutral
};

var() ETeamOwner TeamOwner;         // This is for levelers' convenience only.

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
var     sound   PlacementSound;
var     float   FloatToleranceInMeters;
var     float   DuplicateDistanceInMeters;  // The distance required between identical constructions of the same type
var     class<Emitter> PlacementEmitterClass;

// Construction
var     int     SupplyCost;
var     bool    bDestroyOnConstruction;

// Destruction
var     int     DestroyedLifespan;          // How long does the actor stay around after it's been destroyed?

// Damage
var private int     Health;
var     int         HealthMax;

// Menu
var     localized string    MenuName;
var     localized Material  MenuIcon;

// Staging
struct Stage
{
    var int StageHealth;
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
        ServerAddHealth;
}

function OnConstructed();
function OnStageIndexChanged(int OldIndex);
function OnTeamIndexChanged();

final simulated function int GetTeamIndex()
{
    return TeamIndex;
}

function SetHealth(int Health)
{
    self.Health = Clamp(Health, 0, HealthMax);

    OnHealthChanged();
}

function AddHealth(int Health)
{
    self.Health = Min(HealthMax, self.Health + Health);

    OnHealthChanged();
}

final function SetTeamIndex(int TeamIndex)
{
    self.TeamIndex = TeamIndex;

    SetStaticMesh(GetStaticMesh(TeamIndex, StageIndex));

    OnTeamIndexChanged();
}

function ServerAddHealth(int Health)
{
    AddHealth(Health);
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    SetTeamIndex(int(TeamOwner));

    Health = 1;

    if (Role == ROLE_Authority)
    {
        PlaySound(PlacementSound, SLOT_Misc, 4.0,, 60.0,, true);
    }
}

function OnHealthChanged()
{
    local int i;
    local int OldStageIndex;
    local bool bDidFindStage;

    if (Health <= 0)
    {
        Destroy();
    }
    else if (Health >= HealthMax)
    {
        GotoState('Constructed');
    }
    else
    {
        for (i = Stages.Length - 1; i >= 0; --i)
        {
            if (Health >= Stages[i].StageHealth)
            {
                OldStageIndex = StageIndex;
                StageIndex = i;
                OnStageIndexChanged(OldStageIndex);
                SetStaticMesh(GetStaticMesh(TeamIndex, StageIndex));
                NetUpdateTime = Level.TimeSeconds - 1.0;
                bDidFindStage = true;
                break;
            }
        }

        if (!bDidFindStage)
        {
            Warn("Invalid internal state of construction! Check your defaultproperties for consistency.");
            Destroy();
        }
    }
}

auto simulated state Constructing
{
    event BeginState()
    {
        if (Level.NetMode != NM_DedicatedServer && PlacementEmitterClass != none)
        {
            // TODO: this needs to happen
            Spawn(PlacementEmitterClass);
        }
    }

Begin:
    if (Role == ROLE_Authority)
    {
        if (default.Stages.Length == 0)
        {
            // There are no intermediate stages, so put the construction immediately
            // into the fully constructed state.
            SetHealth(HealthMax);
        }

        SetHealth(default.Health);
    }
}

simulated state Constructed
{
Begin:
    if (Role == ROLE_Authority)
    {
        OnConstructed();

        SetStaticMesh(GetStaticMesh(TeamIndex, -1));

        NetUpdateTime = Level.TimeSeconds - 1.0;

        if (bDestroyOnConstruction)
        {
            Destroy();
        }
    }
}

// TODO: have destroyed thing
/*
state IsDestroyed
{
Begin:
    // TODO: set destroyed SM
    LifeSpan = DestroyedLifespan;
}
*/

event TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitIndex);

    OnHealthChanged();
}

function static StaticMesh GetStaticMesh(int TeamIndex, int StageIndex)
{
    if (StageIndex < 0 || StageIndex >= default.Stages.Length)
    {
        return default.StaticMesh;
    }

    return default.Stages[StageIndex].StaticMesh;
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
    // TODO: this probably needs something else
    return Health < HealthMax;
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
    StageIndex=-1

    bStatic=false
    bNoDelete=false
    bCanBeDamaged=true
    bUseCylinderCollision=false
    bCollideActors=true
    bCollideWorld=false
    bBlockActors=true
    bBlockKarma=true

    CollisionHeight=1.0
    CollisionRadius=1.0

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

    LocalRotationRate=32768

    // Destruction
    DestroyedLifespan=15.0
}

