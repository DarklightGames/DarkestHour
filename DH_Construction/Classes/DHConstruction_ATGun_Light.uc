//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_ATGun_Light extends DHConstruction_Vehicle;

function static class<DHVehicle> GetVehicleClass(DHActorProxy.Context Context)
{
    if (Context.LevelInfo == none)
    {
        return None;
    }

    switch (Context.TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            switch (Context.LevelInfo.AxisNation)
            {
                case NATION_Germany:
                    return class'DH_Guns.DH_Pak38ATGun';
                case NATION_Italy:
                    return class'DH_Guns.DH_Cannone4732Gun';
                default:
                    return None;
            }
        case ALLIES_TEAM_INDEX:

            switch (Context.LevelInfo.AlliedNation)
            {
                case NATION_USSR:
                case NATION_Poland:
                case NATION_Czechoslovakia:
                    switch (Context.LevelInfo.Weather)
                    {
                        case WEATHER_Snowy:
                            return class'DH_Guns.DH_45mmM1937Gun_Snow';
                        default:
                            return class'DH_Guns.DH_45mmM1937Gun';
                    }
            }
    }
}

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_small'
    Stages(0)=(Progress=0)
    ProgressMax=8
}
