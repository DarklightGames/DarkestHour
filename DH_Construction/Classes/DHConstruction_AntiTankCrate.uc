//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_AntiTankCrate extends DHConstruction_InventorySpawner;

static function class<DHInventorySpawner> GetSpawnerClass(DHActorProxy.Context Context)
{
    switch (Context.TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            switch (Context.LevelInfo.AxisNation)
            {
                case NATION_Germany:
                    return class'DH_Weapons.DH_PanzerfaustSpawner';
                default:
                    break;
            }
        default:
            break;
    }
    
    return none;
}

defaultproperties
{
    StartRotationMin=(Yaw=16384)
    StartRotationMax=(Yaw=16384)
    SupplyCost=850
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_crate'
}

