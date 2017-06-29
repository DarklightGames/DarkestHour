//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_AAGun_Light extends DHConstruction_Vehicle;

function static class<ROVehicle> GetVehicleClass(int TeamIndex, DH_LevelInfo LI)
{
    switch (TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            if (LI != none && LI.Season == SEASON_Winter)
            {
                return class'DH_Guns.DH_Flak38Gun_Trailer_Snow';
            }
            else
            {
                return class'DH_Guns.DH_Flak38Gun_Trailer';
            }
        case ALLIES_TEAM_INDEX:
            if (LI != none && LI.AlliedNation == NATION_USA)
            {
                if (LI.Season == SEASON_Winter)
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
    Stages(0)=(Progress=0)
    ProgressMax=10
    SupplyCost=750
}

