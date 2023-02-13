//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_GrenadeCrate extends DHConstruction_InventorySpawner;

static function class<DHInventorySpawner> GetSpawnerClass(DHActorProxy.Context Context)
{
    return Context.LevelInfo.GetTeamNationClass(Context.TeamIndex).default.GrenadeCrateClass;
}

defaultproperties
{
    StartRotationMin=(Yaw=16384)
    StartRotationMax=(Yaw=16384)
    SupplyCost=400
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.grenade'
}
