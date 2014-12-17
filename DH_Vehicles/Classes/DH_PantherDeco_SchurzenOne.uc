//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PantherDeco_SchurzenOne extends DH_VehicleDecoAttachment;

#exec OBJ LOAD FILE=..\StaticMeshes\DH_VehicleDecoGE_stc.usx

defaultproperties
{
    StaticMesh=StaticMesh'DH_VehicleDecoGE_stc.Panther.schurzen01'
    DrawType=DT_StaticMesh
    CullDistance=80000.0
}
