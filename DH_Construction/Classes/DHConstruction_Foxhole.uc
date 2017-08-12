//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_Foxhole extends DHConstruction;

var DynamicProjector DirtProjector;

simulated function OnConstructed()
{
    super.OnConstructed();

    if (Level.NetMode != NM_DedicatedServer)
    {
        DirtProjector = Spawn(class'DynamicProjector', self);

        if (DirtProjector != none)
        {
            DirtProjector.SetBase(self);
            DirtProjector.bNoProjectOnOwner = true;
            DirtProjector.bProjectActor = false;
            DirtProjector.bProjectOnAlpha = true;
            DirtProjector.bProjectParticles = false;
            DirtProjector.bProjectBSP = true;
            DirtProjector.MaterialBlendingOp = PB_AlphaBlend;
            DirtProjector.ProjTexture = Material'DH_Construction_tex.Foxholes.foxhole_01_projector';
            DirtProjector.FrameBufferBlendingOp = PB_AlphaBlend;
            DirtProjector.FOV = 1;
            DirtProjector.MaxTraceDistance = 512.0;
            DirtProjector.SetDrawScale((default.CollisionRadius * 2) / DirtProjector.ProjTexture.MaterialUSize());
            DirtProjector.SetRelativeLocation(vect(0.0, 0.0, 100.0));
            DirtProjector.SetRelativeRotation(rot(-16384, 0, 0));
        }
    }
}

simulated event Destroyed()
{
    super.Destroyed();

    if (DirtProjector != none)
    {
        DirtProjector.Destroy();
    }
}

defaultproperties
{
    Stages(0)=(StaticMesh=StaticMesh'DH_Construction_stc.Foxholes.foxhole_01_unpacked')
    ProgressMax=12
    bPokesTerrain=true
    bCanOnlyPlaceOnTerrain=true
    bSnapToTerrain=true
    bShouldAlignToGround=false
    bCanBeTornDown=false
    bCanBeMantled=true
    bCanBeDamaged=false
    ProxyDistanceInMeters=10
    CollisionRadius=256.0
    StaticMesh=StaticMesh'DH_Construction_stc.Foxholes.foxhole_01'
    PokeTerrainDepth=128
    SupplyCost=0
    PlacementOffset=(Z=0.0)
    MenuName="Foxhole"
    bAlwaysRelevant=true            // This is so that the terrain poking gets applied for everyone and also doesn't get applied more than once.
    DuplicateFriendlyDistanceInMeters=15.0
    bLimitTerrainSurfaceTypes=true
    TerrainSurfaceTypes(0)=EST_Default
    TerrainSurfaceTypes(1)=EST_Dirt
    TerrainSurfaceTypes(2)=EST_Snow
    TerrainSurfaceTypes(3)=EST_Mud
    TerrainSurfaceTypes(4)=EST_Plant
}
