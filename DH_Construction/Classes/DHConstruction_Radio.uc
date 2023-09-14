//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_Radio extends DHConstruction;

var class<DHRadio>              RadioClass;
var DHRadio                     Radio;
var vector                      RadioOffset;

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
    super.OnBroken();

    DestroyRadio();
}

static function StaticMesh GetConstructedStaticMesh(DHActorProxy.Context Context)
{
    return default.TeamStaticMeshes[Context.TeamIndex];
}

defaultproperties
{
    TeamStaticMeshes(0)=StaticMesh'DH_Construction_stc.Artillery.GER_Artillery_Radio'
    TeamStaticMeshes(1)=StaticMesh'DH_Construction_stc.Artillery.USA_Artillery_Radio'

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
    bCanBeTornDownByFriendlies=false
    bCanBeMantled=false // HACK: Stops the mantle icon from interfering with the touch message
    GroupClass=class'DHConstructionGroup_Logistics'
    bCanPlaceIndoors=true

    ProximityRequirements(0)=(ConstructionClass=class'DHConstruction_PlatoonHQ',DistanceMeters=50.0)

    CompletionPointValue=50
}

