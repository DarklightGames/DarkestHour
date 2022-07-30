//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHConstruction_Resupply_Players extends DHConstruction_Resupply;

#exec OBJ LOAD FILE=../StaticMeshes/DH_Construction_stc.usx

static function StaticMesh GetConstructedStaticMesh(DHActorProxy.Context Context)
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
            case NATION_Poland:
            case NATION_Czechoslovakia:
                return StaticMesh'DH_Construction_stc.Ammo.DH_Soviet_ammo_box';
            default:
                break;
            }
        default:
            break;
    }

    return super.GetConstructedStaticMesh(Context);
}

defaultproperties
{
    ResupplyType=RT_Players
    MenuName="Ammo Crate (Infantry)"
    MenuDescription="Provides a resupply point for infantry."
}

