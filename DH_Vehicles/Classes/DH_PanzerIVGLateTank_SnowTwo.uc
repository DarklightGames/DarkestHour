//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_PanzerIVGLateTank_SnowTwo extends DH_PanzerIVGLateTank;

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.PanzerIV_body_snow2');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.PanzerIV_armor_snow2');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.PanzerIV_body_snow2');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.PanzerIV_armor_snow2');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_PanzerIVGLateCannonPawn_SnowTwo')
    Skins(0)=texture'DH_VehiclesGE_tex3.ext_vehicles.PanzerIV_body_snow2'
}
