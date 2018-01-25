//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_Resupply_Players extends DHConstruction_Resupply;

#exec OBJ LOAD FILE=../StaticMeshes/DH_Construction_stc.usx

function UpdateAppearance()
{
    switch (GetTeamIndex())
    {
        case AXIS_TEAM_INDEX:
            SetStaticMesh(StaticMesh'DH_Construction_stc.Ammo.DH_Ger_ammo_box');
            break;
        case ALLIES_TEAM_INDEX:
            switch (LevelInfo.AlliedNation)
            {
            case NATION_USA:
                SetStaticMesh(StaticMesh'DH_Construction_stc.Ammo.DH_USA_ammo_box');
                break;
            case NATION_Britain:
            case NATION_Canada:
                SetStaticMesh(StaticMesh'DH_Construction_stc.Ammo.DH_Commonwealth_ammo_box');
                break;
            case NATION_USSR:
                SetStaticMesh(StaticMesh'DH_Construction_stc.Ammo.DH_Soviet_ammo_box');
                break;
            }
            break;
    }
}

function static StaticMesh GetProxyStaticMesh(DHConstruction.Context Context)
{
    switch (Context.TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            return StaticMesh'DH_Construction_stc.Ammo.DH_Ger_ammo_box';
        case ALLIES_TEAM_INDEX:
            switch (Context.LevelInfo.AlliedNation)
            {
            case NATION_USA:
                return StaticMesh'DH_Construction_stc.Ammo.DH_USA_ammo_box';
            case NATION_Britain:
            case NATION_Canada:
                return StaticMesh'DH_Construction_stc.Ammo.DH_Commonwealth_ammo_box';
            case NATION_USSR:
                return StaticMesh'DH_Construction_stc.Ammo.DH_Soviet_ammo_box';
            }
        default:
            break;
    }

    return super.GetProxyStaticMesh(Context);
}

defaultproperties
{
    ResupplyType=RT_Players
    MenuName="Ammo Crate (Infantry)"
}

