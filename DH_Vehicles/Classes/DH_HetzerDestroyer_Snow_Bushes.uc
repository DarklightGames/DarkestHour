//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_HetzerDestroyer_Snow_Bushes extends DH_HetzerDestroyer;

static function StaticPrecache(LevelInfo L)
{
    super(ROTreadCraft).StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.hetzer_body_snow');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.Stug3_treadsnow');
    L.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.hetzer_int');
    L.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.Hetzer_driver_glass');
    L.AddPrecacheMaterial(Material'VegetationSMT.WildBushesFall.WildBush_A_FallE');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.hetzer_body_snow');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.Stug3_treadsnow');
    Level.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.hetzer_int');
    Level.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.Hetzer_driver_glass');
    Level.AddPrecacheMaterial(Material'VegetationSMT.WildBushesFall.WildBush_A_FallE');

    super(ROTreadCraft).UpdatePrecacheMaterials();
}

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_HetzerCannonPawn_Snow')
    PassengerWeapons(1)=(WeaponPawnClass=class'DH_Vehicles.DH_HetzerMountedMGPawn_Snow')
    Skins(0)=Texture'DH_Hetzer_tex_V1.hetzer_body_snow'
    Skins(1)=Texture'axis_vehicles_tex.Treads.Stug3_treadsnow'
    Skins(2)=Texture'axis_vehicles_tex.Treads.Stug3_treadsnow'
    Skins(3)=Texture'VegetationSMT.WildBushesFall.WildBush_A_FallE'
}
