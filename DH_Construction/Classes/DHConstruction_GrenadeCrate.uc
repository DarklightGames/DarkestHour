//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_GrenadeCrate extends DHConstruction_InventorySpawner;

static function class<DHInventorySpawner> GetSpawnerClass(DHConstruction.Context Context)
{
    switch (Context.TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            return class'DH_Weapons.DH_StielGranateSpawner';
        case ALLIES_TEAM_INDEX:
            switch (Context.LevelInfo.AlliedNation)
            {
                case NATION_USA:
                    return class'DH_Weapons.DH_M1GrenadeSpawner';
                case NATION_USSR:
                    return class'DH_Weapons.DH_F1GrenadeSpawner';
                case NATION_Britain:
                case NATION_Canada:
                    return class'DH_Weapons.DH_MillsBombSpawner';
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
    SupplyCost=500
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.grenade'
}

