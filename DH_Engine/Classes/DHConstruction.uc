//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstruction extends Actor
    abstract;

// Ownership
var() private int TeamIndex;

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

// Construction
var     int     SupplyCost;
var     int     CurrentStageIndex;
var     bool    bDestroyOnConstruction;

// Destruction
var     int     DestroyedLifespan;          // How long does the actor stay around after it's been destroyed?

// Damage
var     int     Health;
var     int     HealthMax;

// Menu
var     localized string    MenuName;
var     localized Material  MenuMaterial;

// Anchors
enum EAnchorType
{
    ANCHOR_Above,
    ANCHOR_Below
};

struct Anchor
{
    var EAnchorType Type;
    var vector Location;
};

var array<Anchor> Anchors;

// Staging
struct Stage
{
    var int Health;
    var StaticMesh StaticMesh;  // This can be overridden in GetStaticMesh
    var sound Sound;
    var Emitter Emitter;
};

var int StageIndex;
var array<Stage> Stages;

function OnConstructed();
function OnStageIndexChanged(int OldIndex);
function OnTeamIndexChanged();
function OnHealthChanged();

final function int GetTeamIndex()
{
    return TeamIndex;
}

final function SetTeamIndex(int TeamIndex)
{
    self.TeamIndex = TeamIndex;

    SetStaticMesh(GetStaticMesh(TeamIndex, StageIndex));

    OnTeamIndexChanged();
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (Role == ROLE_Authority)
    {
        PlaySound(PlacementSound, SLOT_Misc, 4.0,, 60.0,, true);
    }
}

auto state Constructing
{
    function OnHealthChanged()
    {
        if (Health <= 0)
        {
            Destroy();
        }
        // TODO: handle taking damage during construction
        else if (Health > Stages[StageIndex].Health)
        {
            OnStageIndexChanged(StageIndex++);

            SetStaticMesh(GetStaticMesh(TeamIndex, StageIndex));
        }
        else if (Health >= HealthMax)
        {
            GotoState('Constructed');
        }
    }
Begin:
// TODO: temporary!
GotoState('Constructed');
}

state Constructed
{
    function OnHealthChanged()
    {

    }
Begin:
    OnConstructed();

    if (bDestroyOnConstruction)
    {
        Destroy();
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

    // TODO: probably want to go into some sort of destroyed state once health is depleted

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

function static string GetMenuName(int TeamIndex)
{
    return default.MenuName;
}

defaultproperties
{
    RemoteRole=ROLE_SimulatedProxy
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.hedgehog_01'
    Stages(0)=(Health=0,StaticMesh=none,Sound=none,Emitter=none)
    HealthMax=100
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

    LocalRotationRate=32768

    // Destruction
    DestroyedLifespan=15.0

    PlacementSound=Sound'Inf_Player.Gibimpact.Gibimpact' // TODO: placeholder
}

