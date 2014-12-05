//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_KubelwagenCar_Snow extends DH_KubelwagenCar_WH;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesGE_tex3.utx


static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.kubelwagen_body_snow');

}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.kubelwagen_body_snow');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    Skins(1)=Texture'DH_VehiclesGE_tex3.ext_vehicles.kubelwagen_body_snow'
    HighDetailOverlay=Texture'DH_VehiclesGE_tex3.ext_vehicles.kubelwagen_body_snow'
}
