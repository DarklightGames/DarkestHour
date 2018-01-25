//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHConstruction_Resupply_Vehicles extends DHConstruction_Resupply;

#exec OBJ LOAD FILE=../StaticMeshes/DH_Construction_stc.usx

// TODO: isn't this just getconstructedSM?
function UpdateAppearance()
{
    switch (GetTeamIndex())
    {
        case AXIS_TEAM_INDEX:
            SetStaticMesh(StaticMesh'DH_Construction_stc.Ammo.GER_AT_Ammo_Box');
        case ALLIES_TEAM_INDEX:
            SetStaticMesh(StaticMesh'DH_Construction_stc.Ammo.USA_AT_Ammo_Box');
        default:
            break;
    }
}

function static StaticMesh GetProxyStaticMesh(DHConstruction.Context Context)
{
    switch (Context.TeamIndex)
    {
        case AXIS_TEAM_INDEX:
            return StaticMesh'DH_Construction_stc.Ammo.GER_AT_Ammo_Box';
        case ALLIES_TEAM_INDEX:
            return StaticMesh'DH_Construction_stc.Ammo.USA_AT_Ammo_Box';
        default:
            break;
    }

    return super.GetProxyStaticMesh(Context);
}

defaultproperties
{
    ResupplyType=RT_Vehicles
    StaticMesh=StaticMesh'DH_Construction_stc.Ammo.GER_AT_Ammo_Box'
    ResupplyAttachmentCollisionRadius=600.0
    MenuName="Ammo Crate (Vehicles)"
}
