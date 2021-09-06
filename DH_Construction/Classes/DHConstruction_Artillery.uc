//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHConstruction_Artillery extends DHConstruction_Vehicle;

function static class<DHVehicle> GetVehicleClass(DHActorProxy.Context Context)
{
    switch (Context.TeamIndex)
    {
        case ALLIES_TEAM_INDEX:
            switch (Context.LevelInfo.AlliedNation)
            {
                case NATION_USA:
                    return class'DH_Guns.DH_M116Gun';
                default:
                    break;
            }
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
    SupplyCost=1750
}

