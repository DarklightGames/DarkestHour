//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_KubelwagenCar_SS extends DH_KubelwagenCar_WH;

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_body_dunkelgelb');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_glass_FB');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_body_dunkelgelb');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_glass_FB');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Kubelwagen.Kubelwagen_ss_dest'
    Skins(1)=Texture'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_body_dunkelgelb'
    HighDetailOverlay=Texture'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_body_dunkelgelb'
}
