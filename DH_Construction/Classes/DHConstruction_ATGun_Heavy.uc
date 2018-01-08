//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_ATGun_Heavy extends DHConstruction_Vehicle;

function static class<ROVehicle> GetVehicleClass(DHConstruction.Context Context)
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
                    default:
                        break;
                }
            }
            break;
    }

    return none;
}

// The Flak 88 is very powerful due to the 360 degrees arc of fire and it's
// ability to penetrate almost everything in the Allied arsenal, so it's cost
// is higher.
function static int GetSupplyCost(DHConstruction.Context Context)
{
    if (Context.PlayerController != none)
    {
        switch (Context.PlayerController.GetTeamNum())
        {
            case AXIS_TEAM_INDEX:
                return 1750;
            case ALLIES_TEAM_INDEX:
                return 1500;
            default:
                break;
        }
    }

    return 0;
}

function static vector GetPlacementOffset(DHConstruction.Context Context)
{
    if (Context.TeamIndex == AXIS_TEAM_INDEX)
    {
        return vect(0, 0, 8);
    }

    return super.GetPlacementOffset(Context);
}

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_large'
    Stages(0)=(Progress=0)
    ProgressMax=14
    PlacementOffset=(Z=30.0)
    SupplyCost=1750
}
