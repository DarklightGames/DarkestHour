//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_Foxhole extends DHConstruction;

var TerrainInfo         TerrainInfo;

// Dirt projector
var DynamicProjector    DirtProjector;
var Material            DirtProjectorMaterial;
var float               DirtProjectorDrawScale;
var float               DirtProjectorDrawScaleLarge;

// Large terrain
var float               LargeTerrainScaleThreshold;
var StaticMesh          LargeTerrainScaleStaticMesh;
var float               LargeTerrainScaleCollisionRadius;

// Large foxhole
var int                 PokeTerrainDepthLarge;
var int                 PokeTerrainRadiusLarge;


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
    local vector X, Y, Z;

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
            DirtProjector.ProjTexture = DirtProjectorMaterial;
            DirtProjector.FrameBufferBlendingOp = PB_AlphaBlend;
            DirtProjector.FOV = 1;
            DirtProjector.MaxTraceDistance = 1024.0;
            DirtProjector.bGradient = true;
            DirtProjector.SetDrawScale(GetDirtProjectorDrawScale() / DirtProjector.ProjTexture.MaterialUSize());
            GetAxes(Rotation, X, Y, Z);
            DirtProjector.SetRelativeLocation(Z * 128.0);
            DirtProjector.SetRelativeRotation(rot(-16384, 0, 0));
        }
    }
}

simulated function float GetDirtProjectorDrawScale()
{
    if (IsTerrainScaleLarge(TerrainInfo))
    {
        return DirtProjectorDrawScaleLarge;
    }
    else
    {
        return DirtProjectorDrawScale;
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

static function bool IsPlaceableByPlayer(DHPlayerReplicationInfo PRI)
{
    return PRI.IsSLorASL() || PRI.IsPatron();
}

static function bool IsTerrainScaleLarge(TerrainInfo TI)
{
    return TI != none && GetTerrainScale(TI) > default.LargeTerrainScaleThreshold;
}

static function StaticMesh GetConstructedStaticMesh(DHActorProxy.Context Context)
{
    if (IsTerrainScaleLarge(TerrainInfo(Context.GroundActor)))
    {
        return default.LargeTerrainScaleStaticMesh;
    }

    return super.GetConstructedStaticMesh(Context);
}

simulated event Destroyed()
{
    super.Destroyed();

    if (DirtProjector != none)
    {
        DirtProjector.Destroy();
    }
}

function static GetCollisionSize(DHActorProxy.Context Context, out float NewRadius, out float NewHeight)
{
    super.GetCollisionSize(Context, NewRadius, NewHeight);

    if (GetTerrainScale(TerrainInfo(Context.GroundActor)) > default.LargeTerrainScaleThreshold)
    {
        NewRadius = default.LargeTerrainScaleCollisionRadius;
    }
}

simulated function GetTerrainPokeParameters(out int Radius, out int Depth)
{
    if (IsTerrainScaleLarge(TerrainInfo))
    {
        Depth = PokeTerrainDepthLarge;
        Radius = PokeTerrainRadiusLarge;
    }
    else
    {
        super.GetTerrainPokeParameters(Radius, Depth);
    }
}

defaultproperties
{
    Stages(0)=(StaticMesh=StaticMesh'DH_Construction_stc.Foxholes.foxhole_01_unpacked')
    ProgressMax=8
    bPokesTerrain=true
    bCanOnlyPlaceOnTerrain=true
    bSnapToTerrain=true
    bShouldAlignToGround=false
    bCanBeTornDownWhenConstructed=false
    bCanBeDamaged=false
    ProxyTraceDepthMeters=10
    CollisionRadius=192.0
    StaticMesh=StaticMesh'DH_Construction_stc.Foxholes.foxhole_01'
    LargeTerrainScaleStaticMesh=StaticMesh'DH_Construction_stc.Foxholes.foxhole_02'
    PokeTerrainDepth=128
    PokeTerrainRadius=128
    PokeTerrainDepthLarge=82
    PokeTerrainRadiusLarge=128
    SupplyCost=0
    PlacementOffset=(Z=0.0)
    MenuName="Foxhole"
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.foxhole'
    bAlwaysRelevant=true            // This is so that the terrain poking gets applied for everyone and also doesn't get applied more than once.
    DuplicateFriendlyDistanceInMeters=10.0
    bLimitTerrainSurfaceTypes=true
    TerrainSurfaceTypes(0)=EST_Default
    TerrainSurfaceTypes(1)=EST_Dirt
    TerrainSurfaceTypes(2)=EST_Snow
    TerrainSurfaceTypes(3)=EST_Mud
    TerrainSurfaceTypes(4)=EST_Plant
    TerrainSurfaceTypes(5)=EST_Custom01 // Sand
    bShouldBlockSquadRallyPoints=true
    bIsNeutral=true
    LargeTerrainScaleThreshold=128.0
    LargeTerrainScaleCollisionRadius=256.0
    ConstructionVerb="dig"
    DirtProjectorDrawScaleLarge=850.0
    DirtProjectorDrawScale=550.0
    GroupClass=class'DHConstructionGroup_Defenses'
    DirtProjectorMaterial=Material'DH_Construction_tex.Foxholes.foxhole_01_projector'
}
