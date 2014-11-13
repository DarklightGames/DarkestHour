//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerIVGLateTank_CamoTwo extends DH_PanzerIVGLateTank;


static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.PanzerIV_body_camo2');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.PanzerIV_armor_camo2');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.PanzerIV_body_camo2');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.PanzerIV_armor_camo2');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIVGLateCannonPawn_CamoTwo')
     Skins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.PanzerIV_body_camo2'
}
