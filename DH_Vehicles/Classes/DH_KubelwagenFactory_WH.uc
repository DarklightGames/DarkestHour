//===================================================================
// VWType82Factory_WH (Early War - Panzer Grau scheme for Wehrmacht Heer)
//
//  Models and textures by Peter "Foo'Bar" Schaller - 2007/2008
//  Coding and sounds by Eric "Shurek" Parris - 2008
//
// Volkswagen Type 82 military scout car
//===================================================================
class DH_KubelwagenFactory_WH extends DH_GermanVehicles;

defaultproperties
{
     RespawnTime=1.000000
     VehicleClass=Class'DH_Vehicles.DH_KubelwagenCar_WH'
     Mesh=SkeletalMesh'DH_Kubelwagen_anm.kubelwagen_body_ext'
     Skins(0)=FinalBlend'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_glass_FB'
     Skins(1)=Texture'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_body_grau'
}
