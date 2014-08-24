//===================================================================
// VWType82_WH (Early War - Panzer Grau scheme for Wehrmacht Heer)
//
//  Models and textures by Peter "Foo'Bar" Schaller - 2007/2008
//  Coding and sounds by Eric "Shurek" Parris - 2008
//
// Volkswagen Type 82 military scout car
//===================================================================
class DH_KubelwagenCar_Snow extends DH_KubelwagenCar_WH;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex3.utx


static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.kubelwagen_body_snow');

}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.kubelwagen_body_snow');

    Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     Skins(1)=Texture'DH_VehiclesGE_tex3.ext_vehicles.kubelwagen_body_snow'
     HighDetailOverlay=Texture'DH_VehiclesGE_tex3.ext_vehicles.kubelwagen_body_snow'
}
