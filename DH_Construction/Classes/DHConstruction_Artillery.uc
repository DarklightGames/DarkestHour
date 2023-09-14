//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_Artillery extends DHConstruction_Vehicle;

function static class<DHVehicle> GetVehicleClass(DHActorProxy.Context Context)
{
    switch (Context.TeamIndex)
    {
        case ALLIES_TEAM_INDEX:
            if (Context.LevelInfo == none)
            {
                break;
            }

            switch (Context.LevelInfo.AlliedNation)
            {
                case NATION_Britain:
                case NATION_Canada:
                case NATION_USA:
                    if (Context.LevelInfo.Season == SEASON_Winter)
                    {
                        return class'DH_Guns.DH_M116Gun_Winter';
                    }
                    else
                    {
                        return class'DH_Guns.DH_M116Gun';
                    }
                case NATION_Poland:
                case NATION_USSR:
                    if (Context.LevelInfo.Season == Season_Winter)
                    {
                        return class'DH_Guns.DH_M1927Gun_Winter';
                    }
                    else
                    {
                        return class'DH_Guns.DH_M1927Gun';
                    }
                default:
                    break;
            }
            break;
        case AXIS_TEAM_INDEX:
            return class'DH_Guns.DH_LeIG18Gun';
        default:
            break;
    }

    return none;
}

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.Artillery'
    Stages(0)=(Progress=0)
    ProgressMax=9
    bIsArtillery=true
    SupplyCost=1500
    TeamLimit=3
}
