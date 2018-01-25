//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_Watchtower extends DHConstruction;

defaultproperties
{
    Stages(0)=(StaticMesh=StaticMesh'DH_Construction_stc.Constructions.GER_watchtower_undeployed')
    ProgressMax=2   // tODO: increase later
    StaticMesh=StaticMesh'DH_Construction_stc.Constructions.GER_watchtower'
    DrawScale=1.0
    bShouldAlignToGround=false
    bCanBeTornDownByFriendlies=false
    bCanOnlyPlaceOnTerrain=true
    bCanPlaceIndoors=false
    bCanPlaceInWater=false
    CollisionRadius=120.0
    CollisionHeight=300.0
    bShouldBlockSquadRallyPoints=true
    bLimitTerrainSurfaceTypes=true
    TerrainSurfaceTypes(0)=EST_Default
    TerrainSurfaceTypes(1)=EST_Dirt
    TerrainSurfaceTypes(2)=EST_Snow
    TerrainSurfaceTypes(3)=EST_Mud
    TerrainSurfaceTypes(4)=EST_Plant
    bIsNeutral=true
    MenuName="Watchtower"
}
