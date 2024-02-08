//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_AAGun_Light extends DHConstruction_Vehicle;

function static class<DHVehicle> GetVehicleClass(DHActorProxy.Context Context)
{
    if (Context.LevelInfo == none)
    {
        return none;
    }

    switch (Context.TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            switch (Context.LevelInfo.AxisNation)
            {
                case NATION_Germany:
                    if (Context.LevelInfo.Season == SEASON_Winter)
                    {
                        return class'DH_Guns.DH_Flak38Gun_Snow';
                    }
                    else
                    {
                        return class'DH_Guns.DH_Flak38Gun';
                    }
                default:
                    break;
            }
            break;
        case ALLIES_TEAM_INDEX:
            if (Context.LevelInfo != none && Context.LevelInfo.AlliedNation == NATION_USA)
            {
                if (Context.LevelInfo.Season == SEASON_Winter)
                {
                    return class'DH_Guns.DH_M45QuadmountGun_Snow';
                }
                else
                {
                    return class'DH_Guns.DH_M45QuadmountGun';
                }
            }
        default:
            break;
    }

    return none;
}

defaultproperties
{
    MenuIcon=Texture'DH_InterfaceArt2_tex.Icons.aa_light'
    Stages(0)=(Progress=0)
    ProgressMax=7
}

