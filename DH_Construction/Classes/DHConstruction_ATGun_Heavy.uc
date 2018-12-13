//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHConstruction_ATGun_Heavy extends DHConstruction_Vehicle;

function static class<DHVehicle> GetVehicleClass(DHActorProxy.Context Context)
{
    switch (Context.TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            if (Context.LevelInfo != none)
            {
                switch (Context.LevelInfo.Season)
                {
                    case SEASON_Spring:
                        return class'DH_Guns.DH_Flak88Gun_Green';
                    case SEASON_Autumn:
                        return class'DH_Guns.DH_Flak88Gun_Tan';
                    case SEASON_Winter:
                        return class'DH_Guns.DH_Flak88Gun_Snow';
                    default:
                        break;
                }

                switch (Context.LevelInfo.Weather)
                {
                    case WEATHER_Snowy:
                        return class'DH_Guns.DH_Flak88Gun';
                    default:
                        break;
                }

                return class'DH_Guns.DH_Flak88Gun';
            }
            return class'DH_Guns.DH_Flak88Gun';
        case ALLIES_TEAM_INDEX:
            if (Context.LevelInfo != none)
            {
                switch (Context.LevelInfo.AlliedNation)
                {
                    case NATION_Britain:
                    case NATION_Canada:
                        return class'DH_Guns.DH_17PounderGun';
                    case NATION_USA:
                        switch (Context.LevelInfo.Weather)
                        {
                            case WEATHER_Snowy:
                                return class'DH_Guns.DH_M5Gun_Snow';
                            default:
                                return class'DH_Guns.DH_M5Gun';
                        }
                    case NATION_USSR:
                        switch (Context.LevelInfo.Weather)
                        {
                            case WEATHER_Snowy:
                                return class'DH_Guns.DH_ZiS3Gun_Snow';
                            default:
                                return class'DH_Guns.DH_ZiS3Gun';
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
