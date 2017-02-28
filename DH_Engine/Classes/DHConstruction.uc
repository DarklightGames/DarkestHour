//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHConstruction extends Actor
    abstract;

var     float   ProxyDistanceInMeters;      // The distance at which the proxy object will be away from the player when
var     bool    bShouldAlignToGround;
var     float   GroundSlopeMaxInDegrees;

var()   int TeamIndex;

var     int CurrentStageIndex;

var     int Health;
var     int HealthMax;

var     class<Actor>    ActorClass;
var     bool            bDestroyOnConstruction;

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

auto state Constructing
{
    function OnHealthChanged()
    {
        if (Health <= 0)
        {
            Destroy();
        }
        else if (Health > ConstructionStages[StageIndex].Health)
        {
            SetStaticMesh(ConstructionStages[StageIndex].StaticMesh);
        }
        else if (Health >= HealthMax)
        {
            GotoState('Constructed');
        }
    }
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

simulated function OnConstructed()
{
}

defaultproperties
{
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DH_Military_stc.Defences.hedgehog'
    ConstructionStages(0)=(Health=0,StaticMesh=none,Sound=none,Emitter=none)
    HealthMax=100
    ProxyDistanceInMeters=5.0
    GroundSlopeMaxInDegrees=25.0
}

