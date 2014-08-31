class DH_HetzerDestroyer_SnowOne_Bushes extends DH_HetzerDestroyer;

static function StaticPrecache(LevelInfo L)
{
    Super(ROTreadCraft).StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.hetzer_body_snow1');
   	L.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.Stug3_treadsnow');
   	L.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.hetzer_int');
   	L.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.Hetzer_driver_glass');
    L.AddPrecacheMaterial(Material'VegetationSMT.WildBushes.WildBush_A');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.hetzer_body_snow1');
   	Level.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.Stug3_treadsnow');
   	Level.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.hetzer_int');
   	Level.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.Hetzer_driver_glass');
    Level.AddPrecacheMaterial(Material'VegetationSMT.WildBushes.WildBush_A');

	Super(ROTreadCraft).UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_HetzerCannonPawn_SnowOne')
     PassengerWeapons(1)=(WeaponPawnClass=Class'DH_Vehicles.DH_HetzerMountedMGPawn_SnowOne')
     Skins(0)=Texture'DH_Hetzer_tex_V1.hetzer_body_snow1'
     Skins(1)=Texture'axis_vehicles_tex.Treads.Stug3_treadsnow'
     Skins(2)=Texture'axis_vehicles_tex.Treads.Stug3_treadsnow'
     Skins(3)=Texture'VegetationSMT.WildBushes.WildBush_A'
}
