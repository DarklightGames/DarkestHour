//=================================================================================
// DH_PantherDeco_SchurzenOne - undamaged schurzen
//
// A Schurzen decorative attachment for panthers or jagdpanthers
//=================================================================================
class DH_PantherDeco_SchurzenOne extends DH_VehicleDecoAttachment;

#exec OBJ LOAD FILE=..\StaticMeshes\DH_VehicleDecoGE_stc.usx

defaultproperties
{
	StaticMesh=StaticMesh'DH_VehicleDecoGE_stc.Panther.schurzen01'
	DrawType=DT_StaticMesh
	CullDistance=80000.0
}
