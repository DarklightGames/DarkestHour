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
var     int     CurrentStageIndex;
var     bool    bDestroyOnConstruction;

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
struct ConstructionStage
{
    var int Health;
    var StaticMesh StaticMesh;
    var sound Sound;
    var Emitter Emitter;
};

var int StageIndex;
var array<ConstructionStage> ConstructionStages;

function OnConstructed();
function OnConstructionStageIndexChanged(int OldIndex);
function OnTeamIndexChanged();
function OnHealthChanged();

final function int GetTeamIndex()
{
    return TeamIndex;
}

final function SetTeamIndex(int TeamIndex)
{
    self.TeamIndex = TeamIndex;

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
        else if (Health > ConstructionStages[StageIndex].Health)
        {
            OnConstructionStageIndexChanged(StageIndex++);

            SetStaticMesh(ConstructionStages[StageIndex].StaticMesh);
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

event TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitIndex);

    // TODO: probably want to go into some sort of destroyed state once health is depleted

    OnHealthChanged();
}

defaultproperties
{
    RemoteRole=ROLE_SimulatedProxy
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DH_Construction_stc.Obstacles.hedgehog_01'
    ConstructionStages(0)=(Health=0,StaticMesh=none,Sound=none,Emitter=none)
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

    PlacementSound=Sound'Inf_Player.Gibimpact.Gibimpact' // TODO: placeholder
}

