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
            return class'DH_Weapons.DH_PanzerfaustSpawner';
        case ALLIES_TEAM_INDEX:
            return none;
        default:
            return none;
    }
}

defaultproperties
{
    StartRotationMin=(Yaw=16384)
    StartRotationMax=(Yaw=16384)
    SupplyCost=850
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_crate'
}

