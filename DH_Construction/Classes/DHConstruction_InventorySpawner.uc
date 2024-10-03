//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_InventorySpawner extends DHConstruction
    abstract;

var class<DHInventorySpawner>   SpawnerClass;
var DHInventorySpawner          Spawner;

static function DHConstruction.ConstructionError GetPlayerError(DHActorProxy.Context Context)
{
    local DHConstruction.ConstructionError Error;

    if (default.SpawnerClass == none)
    {
        Error.Type = ERROR_Fatal;
        return Error;
    }

    return super.GetPlayerError(Context);
}

simulated function OnConstructed()
{
    if (Role == ROLE_Authority)
    {
        if (Spawner != none)
        {
            Spawner.Destroy();
        }

        Spawner = Spawn(SpawnerClass, Level,, Location, Rotation);
        Spawner.SetTeamIndex(GetTeamIndex());
        Spawner.OnExhausted = self.OnExhausted;
        Spawner.bShouldDestroyOnExhaustion = true;
    }
}

static function UpdateProxy(DHActorProxy AP)
{
    local int i;
    local DHConstructionProxy CP;

    super.UpdateProxy(AP);

    CP = DHConstructionProxy(AP);

    if (CP == none)
    {
        return;
    }

    CP.SetDrawType(DT_Mesh);
    CP.LinkMesh(default.SpawnerClass.default.Mesh);

    for (i = 0; i < default.SpawnerClass.default.Skins.Length; ++i)
    {
        CP.Skins[i] = CP.CreateProxyMaterial(default.SpawnerClass.default.Skins[i]);
    }
}

static function string GetMenuName(DHActorProxy.Context Context)
{
    if (default.SpawnerClass != none)
    {
        return default.SpawnerClass.static.GetMenuName(Context.PlayerController);
    }

    return "";
}

static function GetCollisionSize(DHActorProxy.Context Context, out float NewRadius, out float NewHeight)
{
    if (default.SpawnerClass != none)
    {
        NewRadius = default.SpawnerClass.default.CollisionRadius;
        NewHeight = default.SpawnerClass.default.CollisionHeight;
    }
}

function Reset()
{
    super.Reset();

    if (Spawner != none)
    {
        Spawner.Destroy();
    }
}

simulated function OnExhausted(DHInventorySpawner Spawner)
{
    if (Owner != none)
    {
        Destroy();
    }
}

defaultproperties
{
    GroupClass=class'DHConstructionGroup_Ammunition'
    bDummyOnConstruction=true
    ProxyTraceDepthMeters=2.0
    bCanPlaceIndoors=true
    ConstructionVerb="drop"
    DuplicateFriendlyDistanceInMeters=1.0

    CompletionPointValue=100
}

