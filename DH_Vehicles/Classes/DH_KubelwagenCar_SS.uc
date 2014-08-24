//===================================================================
// VWType82_SS (Mid to Late War - DunkelGelb Camo scheme for SS)
//
//  Models and textures by Peter "Foo'Bar" Schaller - 2007/2008
//  Coding and sounds by Eric "Shurek" Parris - 2008
//
// Volkswagen Type 82 military scout car
//===================================================================
class DH_KubelwagenCar_SS extends DH_KubelwagenCar_WH;


static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_body_dunkelgelb');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_glass_FB');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_body_dunkelgelb');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_glass_FB');

    Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Kubelwagen.Kubelwagen_ss_dest'
     Skins(1)=Texture'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_body_dunkelgelb'
     HighDetailOverlay=Texture'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_body_dunkelgelb'
}
