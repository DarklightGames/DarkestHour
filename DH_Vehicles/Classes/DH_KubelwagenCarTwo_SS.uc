//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_KubelwagenCarTwo_SS extends DH_KubelwagenCar_WH;

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_body_dunkelgelb2');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_glass_FB');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_body_dunkelgelb2');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_glass_FB');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc2.Kubelwagen.Kubelwagen_ss_dest'
    Skins(1)=texture'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_body_dunkelgelb'
    HighDetailOverlay=texture'DH_VehiclesGE_tex.ext_vehicles.kubelwagen_body_dunkelgelb2'
}
