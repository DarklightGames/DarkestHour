//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_ATGun_Heavy extends DHConstruction_Vehicle;

function static class<ROVehicle> GetVehicleClass(int TeamIndex, DH_LevelInfo LI)
{
    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            return class'DH_Guns.DH_Pak43ATGun';
        case ALLIES_TEAM_INDEX:
            if (LI != none)
            {
                switch (LI.AlliedNation)
                {
                    case NATION_Britain:
                    case NATION_Canada:
                        return class'DH_Guns.DH_17PounderGun';
                    case NATION_USA:
                        switch (LI.Weather)
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

defaultproperties
{
    Stages(0)=(Progress=0)
    ProgressMax=18
    PlacementOffset=(Z=30.0)
    SupplyCost=1000
}
