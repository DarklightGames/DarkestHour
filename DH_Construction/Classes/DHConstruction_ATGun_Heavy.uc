//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_ATGun_Heavy extends DHConstruction_Vehicle;

function static class<DHVehicle> GetVehicleClass(DHActorProxy.Context Context)
{
    if (Context.LevelInfo == none) return none;

    switch (Context.TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            switch (Context.LevelInfo.Season)
            {
                case SEASON_Autumn:
                    return class'DH_Guns.DH_Pak40ATGun_CamoOne';
                default:
                    return class'DH_Guns.DH_Pak40ATGun';
            }
        case ALLIES_TEAM_INDEX:
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
                case NATION_Poland:
                    switch (Context.LevelInfo.Weather)
                    {
                        case WEATHER_Snowy:
                            return class'DH_Guns.DH_ZiS3GunLate_Snow';
                        default:
                            return class'DH_Guns.DH_ZiS3GunLate';
                    }
                case NATION_Czechoslovakia:
                    switch (Context.LevelInfo.Weather)
                    {
                        case WEATHER_Snowy:
                            return class'DH_Guns.DH_ZiS3GunLate_Snow';
                        default:
                            return class'DH_Guns.DH_ZiS3GunLate';
                    }
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
