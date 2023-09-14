//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_AAGun_Medium extends DHConstruction_Vehicle;

function static class<DHVehicle> GetVehicleClass(DHActorProxy.Context Context)
{
    switch (Context.TeamIndex)
    {
        case ALLIES_TEAM_INDEX:
            if (Context.LevelInfo != none && Context.LevelInfo.AlliedNation == NATION_Canada || Context.LevelInfo.AlliedNation == NATION_Britain)
            {
                return class'DH_Guns.DH_Bofors40mmGun';
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
    ProgressMax=9
}

