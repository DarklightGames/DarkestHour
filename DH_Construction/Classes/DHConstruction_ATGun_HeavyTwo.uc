//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_ATGun_HeavyTwo extends DHConstruction_Vehicle;

function static class<DHVehicle> GetVehicleClass(DHActorProxy.Context Context)
{
    if (Context.LevelInfo == none) return none;

    switch (Context.TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            break;

        case ALLIES_TEAM_INDEX:
            switch (Context.LevelInfo.AlliedNation)
            {
                case NATION_USSR:
                case NATION_Poland:
                case NATION_Czechoslovakia:
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
}

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_large'
    Stages(0)=(Progress=0)
    ProgressMax=14
    DuplicateFriendlyDistanceInMeters=30.0
}
