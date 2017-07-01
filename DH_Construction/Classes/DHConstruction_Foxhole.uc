//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_Foxhole extends DHConstruction;

var Projector DirtProjector;

simulated function OnConstructed()
{
    super.OnConstructed();

    if (Level.NetMode != NM_DedicatedServer)
    {
        DirtProjector = Spawn(class'Projector', self,, Location);

        if (DirtProjector != none)
        {

        }
    }
}

defaultproperties
{
    bPokesTerrain=true
    bCanOnlyPlaceOnTerrain=true
    bSnapToTerrain=true
    bShouldAlignToGround=false
    bCanBeTornDown=false
    ProxyDistanceInMeters=10
    CollisionRadius=200.0
    StaticMesh=StaticMesh'DH_Military_stc.Foxholes.GUP-Foxhole'
    PokeTerrainDepth=128
    SupplyCost=0
    PlacementOffset=(Z=-12.0)
    MenuName="Foxhole"
    bAlwaysRelevant=true            // This is so that the terrain poking doesn't get applied more than once.
    DuplicateDistanceInMeters=15.0  // TODO: just something to stop rampant construction
    bLimitSurfaceTypes=true
    SurfaceTypes(0)=EST_Default
    SurfaceTypes(1)=EST_Dirt
    SurfaceTypes(2)=EST_Snow
    SurfaceTypes(3)=EST_Mud
}
