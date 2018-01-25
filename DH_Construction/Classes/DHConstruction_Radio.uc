//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_Radio extends DHConstruction;

var class<DHArtilleryTrigger>   ArtilleryTriggerClass;
var DHArtilleryTrigger          ArtilleryTrigger;

var localized string            NoNearbyPlatoonHQErrorString;
var float                       PlatoonHQProximityInMeters;

var StaticMesh                  TeamStaticMeshes[2];

simulated function OnConstructed()
{
    super.OnConstructed();

    if (Role == ROLE_Authority)
    {
        if (ArtilleryTriggerClass != none)
        {
            ArtilleryTrigger = Spawn(ArtilleryTriggerClass, self);
            ArtilleryTrigger.TeamCanUse = AT_ArtyTriggerable(GetTeamIndex());
            ArtilleryTrigger.bShouldShowOnSituationMap = true;
            ArtilleryTrigger.SetBase(self);
            ArtilleryTrigger.SetRelativeLocation(vect(0, 0, 64));
        }
    }
}

function DestroyArtilleryTrigger()
{
    if (ArtilleryTrigger != none)
    {
        ArtilleryTrigger.Destroy();
    }
}

simulated function Destroyed()
{
    super.Destroyed();

    DestroyArtilleryTrigger();
}

simulated function OnBroken()
{
    super.OnBroken();

    DestroyArtilleryTrigger();
}

function StaticMesh GetConstructedStaticMesh()
{
    return default.TeamStaticMeshes[GetTeamIndex()];
}

function static StaticMesh GetProxyStaticMesh(DHConstruction.Context Context)
{
    return default.TeamStaticMeshes[Context.TeamIndex];
}

// Specialized proxy error function to ensure that we are placing this
// near a Platoon HQ.
static function DHConstruction.ConstructionError GetCustomProxyError(DHConstructionProxy P)
{
    local DHConstruction.ConstructionError E;
    local DHSpawnPoint_PlatoonHQ SP;
    local DHConstruction.Context Context;
    local bool bDidFindHQ;

    Context = P.GetContext();

    foreach P.RadiusActors(class'DHSpawnPoint_PlatoonHQ', SP, class'DHUnits'.static.MetersToUnreal(default.PlatoonHQProximityInMeters))
    {
        if (SP.GetTeamIndex() == Context.TeamIndex)
        {
            bDidFindHQ = true;
            break;
        }
    }

    if (!bDidFindHQ)
    {
        E.Type = ERROR_Custom;
        E.CustomErrorString = default.NoNearbyPlatoonHQErrorString;
        E.OptionalInteger = default.PlatoonHQProximityInMeters;
        E.OptionalString = class'DHConstruction_PlatoonHQ'.default.MenuName;
    }

    return E;
}

defaultproperties
{
    TeamStaticMeshes(0)=StaticMesh'DH_Construction_stc.Artillery.GER_Artillery_Radio'
    TeamStaticMeshes(1)=StaticMesh'DH_Construction_stc.Artillery.USA_Artillery_Radio'

    NoNearbyPlatoonHQErrorString="You must {verb} a {name} within {integer}m of an established friendly {string}";

    ArtilleryTriggerClass=Class'DH_Engine.DHArtilleryTrigger'
    MenuName="Radio"
    DrawType=DT_StaticMesh
    ProxyDistanceInMeters=2.5
    DuplicateFriendlyDistanceInMeters=50.0
    SupplyCost=250
    PlatoonHQProximityInMeters=50.0
    bCanBeTornDownByFriendlies=false
}

