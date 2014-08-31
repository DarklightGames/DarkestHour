//===================================================================
// DH_Hetzer Factory
//
// German Hetzer tank destroyer factory class
//===================================================================
class DH_HetzerFactory extends DH_GermanVehicles;

defaultproperties
{
     RespawnTime=1.000000
     bFactoryActive=True
     VehicleClass=Class'DH_Vehicles.DH_HetzerDestroyer'
     Mesh=SkeletalMesh'DH_Hetzer_anm_V1.hetzer_body_ext'
     Skins(0)=Texture'DH_Hetzer_tex_V1.hetzer_body'
     Skins(1)=Texture'axis_vehicles_tex.Treads.Stug3_treads'
     Skins(2)=Texture'axis_vehicles_tex.Treads.Stug3_treads'
     Skins(3)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha'
}
