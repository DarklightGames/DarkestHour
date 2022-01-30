//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================
// This class exists so Germans can access 88 guns on 1941 maps without breaking
// historical limits of other heavy guns.

class DHConstruction_ATGun_HeavyEarly extends DHConstruction_Vehicle;

function static class<DHVehicle> GetVehicleClass(DHActorProxy.Context Context)
{
    switch (Context.TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            if (Context.LevelInfo == none) break;

            if (Context.LevelInfo.Weather == WEATHER_Snowy)
            {
                return class'DH_Guns.DH_Flak88Gun_Snow';
            }

            switch (Context.LevelInfo.Season)
            {
                case SEASON_Spring:
                    return class'DH_Guns.DH_Flak88Gun_Green';
                case SEASON_Autumn:
                    return class'DH_Guns.DH_Flak88Gun_Tan';
                case SEASON_Winter:
                    return class'DH_Guns.DH_Flak88Gun_Snow';
            }

            return class'DH_Guns.DH_Flak88Gun';

        // case ALLIES_TEAM_INDEX:
        //     break;
    }
}

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.at_large'
    Stages(0)=(Progress=0)
    ProgressMax=14
    DuplicateFriendlyDistanceInMeters=30.0
}
