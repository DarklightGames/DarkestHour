//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHConstruction_Resupply_Vehicles extends DHConstruction_Resupply;

#exec OBJ LOAD FILE=../StaticMeshes/DH_Construction_stc.usx

static function StaticMesh GetConstructedStaticMesh(DHActorProxy.Context Context)
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

    return super.GetConstructedStaticMesh(Context);
}

defaultproperties
{
    ResupplyType=RT_Vehicles
    StaticMesh=StaticMesh'DH_Construction_stc.Ammo.GER_AT_Ammo_Box'
    ResupplyAttachmentCollisionRadius=600.0
    MenuName="Ammo Crate (Vehicles)"
    MenuDescription="Provides a resupply point for vehicles and guns."
}
