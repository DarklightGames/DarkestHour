//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_ATGun_Medium extends DHConstruction_Vehicle;

function static class<DHVehicle> GetVehicleClass(DHActorProxy.Context Context)
{
    switch (Context.TeamIndex)
    {
        // case AXIS_TEAM_INDEX:
        //     break;

        case ALLIES_TEAM_INDEX:
            if (Context.LevelInfo == none) break;

            switch (Context.LevelInfo.AlliedNation)
            {
                case NATION_USA:
                    return class'DH_Guns.DH_AT57Gun';
                case NATION_Britain:
                case NATION_Canada:
                    return class'DH_Guns.DH_6PounderGun';
                case NATION_USSR:
                case NATION_Poland:
                case NATION_Czechoslovakia:
                    switch (Context.LevelInfo.Weather)
                    {
                        case WEATHER_Snowy:
                            return class'DH_Guns.DH_45mmM1942Gun_Snow';
                        default:
                            return class'DH_Guns.DH_45mmM1942Gun';
                    }
            }
    }
}

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_small'
    Stages(0)=(Progress=0)
    ProgressMax=10
}
