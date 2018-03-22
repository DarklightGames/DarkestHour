//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHConstruction_Radio extends DHConstruction;

var class<DHRadio>              RadioClass;
var DHRadio                     Radio;
var vector                      RadioOffset;

var localized string            NoNearbyPlatoonHQErrorString;
var float                       PlatoonHQProximityInMeters;

var StaticMesh                  TeamStaticMeshes[2];

simulated function OnConstructed()
{
    super.OnConstructed();

    if (Role == ROLE_Authority)
    {
        if (RadioClass != none)
        {
            Radio = Spawn(RadioClass, self);
            Radio.TeamIndex = GetTeamIndex();
            Radio.SetBase(self);
            Radio.SetRelativeLocation(RadioOffset);
        }
    }
}

function DestroyRadio()
{
    if (Radio != none)
    {
        Radio.Destroy();
    }
}

simulated function Destroyed()
{
    super.Destroyed();

    DestroyRadio();
}

simulated function OnBroken()
{
    DestroyRadio();

    super.OnBroken();
}

static function StaticMesh GetConstructedStaticMesh(DHConstruction.Context Context)
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

    StartRotationMin=(Yaw=32768)
    StartRotationMax=(Yaw=32768)
    RadioClass=Class'DH_Engine.DHRadio'
    RadioOffset=(Z=64)
    MenuName="Radio"
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.Radio'
    MenuDescription="Allows artillery call-ins."
    DrawType=DT_StaticMesh
    ProxyTraceDepthMeters=2.5
    DuplicateFriendlyDistanceInMeters=100.0
    SupplyCost=500
    PlatoonHQProximityInMeters=50.0
    bCanBeTornDownByFriendlies=false
    bCanBeMantled=false // HACK: Stops the mantle icon from interfering with the touch message
    GroupClass=class'DHConstructionGroup_Logistics'
    bCanPlaceIndoors=true
}

