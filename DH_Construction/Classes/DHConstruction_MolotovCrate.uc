//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHConstruction_MolotovCrate extends DHConstruction_InventorySpawner;

static function class<DHInventorySpawner> GetSpawnerClass(DHActorProxy.Context Context)
{
    switch (Context.TeamIndex)
    {
        case ALLIES_TEAM_INDEX:
            switch (Context.LevelInfo.AlliedNation)
            {
                case NATION_USSR:
                    return class'DH_Weapons.DH_IncendiaryBottleNo1Spawner';
                default:
                    break;
            }
        default:
            return none;
    }
}

defaultproperties
{
    StartRotationMin=(Yaw=16384)
    StartRotationMax=(Yaw=16384)
    SupplyCost=400
    //MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.Molotov'
}
