//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHConstruction_ATGun_HeavyTwo extends DHConstruction_Vehicle;

function static class<DHVehicle> GetVehicleClass(DHActorProxy.Context Context)
{
    switch (Context.TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            if (Context.LevelInfo != none)  //reserved place, currently there are none
            {
                switch (Context.LevelInfo.Season)
                {
                    case SEASON_Spring:
                        return none;
                    case SEASON_Autumn:
                        return none;
                    case SEASON_Winter:
                        return none;
                    default:
                        break;
                }

                switch (Context.LevelInfo.Weather)
                {
                    case WEATHER_Snowy:
                        return none;
                    default:
                        break;
                }

                return none;
            }
            return none;
        case ALLIES_TEAM_INDEX:
            if (Context.LevelInfo != none)
            {
                switch (Context.LevelInfo.AlliedNation)
                {
                    case NATION_Britain:
                    case NATION_Canada:
                        return none;
                    case NATION_USA:
                        switch (Context.LevelInfo.Weather)
                        {
                            case WEATHER_Snowy:
                                return none;
                            default:
                                return none;
                        }
                    case NATION_USSR:
                    case NATION_Poland:
                        switch (Context.LevelInfo.Weather)
                        {
                            case WEATHER_Snowy:
                                return class'DH_Guns.DH_ZiS2Gun_Snow';
                            default:
                                return class'DH_Guns.DH_ZiS2Gun';
                        }
                    default:
                        break;
                }
            }
            break;
    }

    return none;
}

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_large'
    Stages(0)=(Progress=0)
    ProgressMax=14
    DuplicateFriendlyDistanceInMeters=30.0
}
