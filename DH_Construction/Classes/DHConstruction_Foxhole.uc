//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_Foxhole extends DHConstruction;

var DynamicProjector DirtProjector;

simulated function OnConstructed()
{
    local vector RL;

    super.OnConstructed();

    Log("OnConstructed");

    if (Level.NetMode != NM_DedicatedServer)
    {
        DirtProjector = Spawn(class'DynamicProjector', self);

        Log("DirtProjector" @ DirtProjector);

        RL.Z = 100.0;

        if (DirtProjector != none)
        {
            DirtProjector.SetBase(self);
            DirtProjector.bHidden = false;
            DirtProjector.bNoProjectOnOwner = true;
            DirtProjector.bProjectActor = false;
            DirtProjector.bProjectOnAlpha = true;
            DirtProjector.bProjectParticles = false;
            DirtProjector.bProjectBSP = true;
            DirtProjector.MaterialBlendingOp = PB_AlphaBlend;
            DirtProjector.ProjTexture = texture'DH_Construction_tex.ui.construction_aura';
            DirtProjector.FrameBufferBlendingOp = PB_AlphaBlend;
            DirtProjector.FOV = 1;
            DirtProjector.MaxTraceDistance = 1000.0;
            DirtProjector.SetDrawScale((default.CollisionRadius * 2) / DirtProjector.ProjTexture.MaterialUSize());
            DirtProjector.SetRelativeLocation(RL);
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
    bPokesTerrain=true
    bCanOnlyPlaceOnTerrain=true
    bSnapToTerrain=true
    bShouldAlignToGround=false
    bCanBeTornDown=false
    bCanBeMantled=true
    ProxyDistanceInMeters=10
    CollisionRadius=200.0
    StaticMesh=StaticMesh'DH_Military_stc.Foxholes.GUP-Foxhole'
    PokeTerrainDepth=128
    SupplyCost=0
    PlacementOffset=(Z=0.0)
    MenuName="Foxhole"
    bAlwaysRelevant=true            // This is so that the terrain poking doesn't get applied more than once.
    DuplicateDistanceInMeters=15.0
    bLimitSurfaceTypes=true
    SurfaceTypes(0)=EST_Default
    SurfaceTypes(1)=EST_Dirt
    SurfaceTypes(2)=EST_Snow
    SurfaceTypes(3)=EST_Mud
}
