//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstruction extends Actor
    abstract;

// Ownership
var()   int TeamIndex;

// Placement
var     float   ProxyDistanceInMeters;      // The distance at which the proxy object will be away from the player when
var     bool    bShouldAlignToGround;
var     bool    bCanPlaceInWater;
var     bool    bCanPlaceIndoors;
var     float   GroundSlopeMaxInDegrees;
var     rotator StartRotationMin;
var     rotator StartRotationMax;
var     int     LocalRotationRate;

// Construction
var     int     CurrentStageIndex;
var     bool    bDestroyOnConstruction;

// Damage
var     int     Health;
var     int     HealthMax;

var     class<Actor>    ActorClass;

var     localized string    MenuName;
var     localized Material  MenuMaterial;

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

struct ConstructionStage
{
    var int Health;
    var StaticMesh StaticMesh;
    var sound Sound;
    var Emitter Emitter;
};

var int StageIndex;
var array<ConstructionStage> ConstructionStages;

function OnHealthChanged();

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

simulated function OnConstructionStageIndexChanged(int OldIndex);

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

simulated function OnConstructed()
{
}

event TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
    Log("took damage");

    super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitIndex);

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

    LocalRotationRate=32768
}

