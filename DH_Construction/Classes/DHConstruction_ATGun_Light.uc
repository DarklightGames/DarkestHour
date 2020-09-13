//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DHConstruction_ATGun_Light extends DHConstruction_Vehicle;

function static class<DHVehicle> GetVehicleClass(DHActorProxy.Context Context)
{
    if (Context.LevelInfo == none)
    {
        return none;
    }

    switch (Context.TeamIndex)
    {

        case AXIS_TEAM_INDEX: 
            switch (Context.LevelInfo.Season)
            {
                default:
                    return class'DH_Guns.DH_Pak38ATGun';
            }
        case ALLIES_TEAM_INDEX:
            switch (Context.LevelInfo.AlliedNation)
            {

                //case NATION_Britain:
                //case NATION_Canada:
                    //return class'DH_Guns.DH_6PounderGun'; // Need the 2 Pounder from MN
                case NATION_USSR:
                    switch (Context.LevelInfo.Weather)
                    {
                        case WEATHER_Snowy:
                            return class'DH_Guns.DH_45mmM1937Gun_Snow';
                        default:
                            return class'DH_Guns.DH_45mmM1937Gun';
                    }
                default:
                    break; //return class'DH_Guns.DH_AT57Gun';
            }
    }

    return none;
}

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_small'
    Stages(0)=(Progress=0)
    ProgressMax=10
}
