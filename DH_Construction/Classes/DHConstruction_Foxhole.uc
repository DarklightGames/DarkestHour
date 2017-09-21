//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_Foxhole extends DHConstruction;

var TerrainInfo         TerrainInfo;

// Dirt projector
var DynamicProjector    DirtProjector;

// Large terrain
var float               LargeTerrainScaleThreshold;
var StaticMesh          LargeTerrainScaleStaticMesh;
var float               LargeTerrainScaleCollisionRadius;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    TerrainInfo = TerrainInfo(Owner);

    if (TerrainInfo == none)
    {
        Destroy();
    }
}

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
            DirtProjector.bGradient = true;
            DirtProjector.SetDrawScale(GetDirtProjectorDrawScale() / DirtProjector.ProjTexture.MaterialUSize());
            DirtProjector.SetRelativeLocation(vect(0.0, 0.0, 128.0));
            DirtProjector.SetRelativeRotation(rot(-16384, 0, 0));
        }
    }
}

function float GetDirtProjectorDrawScale()
{
    // TODO: magic numbers
    if (IsTerrainScaleLarge(TerrainInfo))
    {
        return 768.0;
    }
    else
    {
        return 384.0;
    }
}

static function float GetTerrainScale(TerrainInfo TI)
{
    if (TI != none)
    {
        return class'UVector'.static.MaxElement(TI.TerrainScale);
    }

    return 0.0;
}

static function bool IsTerrainScaleLarge(TerrainInfo TI)
{
    return GetTerrainScale(TI) > default.LargeTerrainScaleThreshold;
}

function StaticMesh GetConstructedStaticMesh()
{
    if (IsTerrainScaleLarge(TerrainInfo))
    {
        return LargeTerrainScaleStaticMesh;
    }

    return super.GetConstructedStaticMesh();
}

simulated event Destroyed()
{
    super.Destroyed();

    if (DirtProjector != none)
    {
        DirtProjector.Destroy();
    }
}

function static GetCollisionSize(int TeamIndex, DH_LevelInfo LI, DHConstructionProxy CP, out float NewRadius, out float NewHeight)
{
    super.GetCollisionSize(TeamIndex, LI, CP, NewRadius, NewHeight);

    if (CP != none && GetTerrainScale(TerrainInfo(CP.GroundActor)) > default.LargeTerrainScaleThreshold)
    {
        NewRadius = default.LargeTerrainScaleCollisionRadius;
    }
}

simulated static function GetTerrainPokeParameters(out int Radius, out int Depth)
{
    // TODO: override depending on terrain size
    super.GetTerrainPokeParameters(Radius, Depth);
}

defaultproperties
{
    Stages(0)=(StaticMesh=StaticMesh'DH_Construction_stc.Foxholes.foxhole_01_unpacked')
    ProgressMax=12
    bPokesTerrain=true
    bCanOnlyPlaceOnTerrain=true
    bSnapToTerrain=true
    bShouldAlignToGround=false
    bCanBeTornDownWhenConstructed=false
    bCanBeDamaged=false
    ProxyDistanceInMeters=10
    CollisionRadius=192.0
    StaticMesh=StaticMesh'DH_Construction_stc.Foxholes.foxhole_01'
    LargeTerrainScaleStaticMesh=StaticMesh'DH_Construction_stc.Foxholes.foxhole_02'
    PokeTerrainDepth=128
    PokeTerrainRadius=128.0
    SupplyCost=0
    PlacementOffset=(Z=0.0)
    MenuName="Foxhole"
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.foxhole'
    bAlwaysRelevant=true            // This is so that the terrain poking gets applied for everyone and also doesn't get applied more than once.
    DuplicateFriendlyDistanceInMeters=15.0
    bLimitTerrainSurfaceTypes=true
    TerrainSurfaceTypes(0)=EST_Default
    TerrainSurfaceTypes(1)=EST_Dirt
    TerrainSurfaceTypes(2)=EST_Snow
    TerrainSurfaceTypes(3)=EST_Mud
    TerrainSurfaceTypes(4)=EST_Plant
    bShouldBlockSquadRallyPoints=true
    bIsNeutral=true
    LargeTerrainScaleThreshold=128.0
    LargeTerrainScaleCollisionRadius=256.0
    ConstructionVerb="dig"
}
