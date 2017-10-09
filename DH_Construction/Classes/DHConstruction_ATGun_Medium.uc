//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_ATGun_Medium extends DHConstruction_Vehicle;

function static class<ROVehicle> GetVehicleClass(DHConstruction.Context Context)
{
    switch (Context.TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            if (Context.LevelInfo != none && Context.LevelInfo.Season == SEASON_Autumn)
            {
                return class'DH_Guns.DH_Pak40ATGun_CamoOne';
            }
            else
            {
                return class'DH_Guns.DH_Pak40ATGun';
            }
        case ALLIES_TEAM_INDEX:
            if (Context.LevelInfo != none && (Context.LevelInfo.AlliedNation == NATION_Britain || Context.LevelInfo.AlliedNation == NATION_Canada))
            {
                return class'DH_Guns.DH_6PounderGun';
            }
            else
            {
                return class'DH_Guns.DH_AT57Gun';
            }
    }
}

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_small'
    Stages(0)=(Progress=0)
    ProgressMax=12
    PlacementOffset=(Z=24.0)
    SupplyCost=750
}
