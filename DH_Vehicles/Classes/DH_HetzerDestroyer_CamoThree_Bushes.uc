class DH_HetzerDestroyer_CamoThree_Bushes extends DH_HetzerDestroyer;

static function StaticPrecache(LevelInfo L)
{
    Super(ROTreadCraft).StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.hetzer_body_camo3');
   	L.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.Stug3_treads');
   	L.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.hetzer_int');
   	L.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.Hetzer_driver_glass');
    L.AddPrecacheMaterial(Material'VegetationSMT.WildBushes.WildBush_C');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.hetzer_body_camo3');
   	Level.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.Stug3_treads');
   	Level.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.hetzer_int');
   	Level.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.Hetzer_driver_glass');
    Level.AddPrecacheMaterial(Material'VegetationSMT.WildBushes.WildBush_C');

	Super(ROTreadCraft).UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_HetzerCannonPawn_CamoThree')
     PassengerWeapons(1)=(WeaponPawnClass=Class'DH_Vehicles.DH_HetzerMountedMGPawn_CamoThree')
     Skins(0)=Texture'DH_Hetzer_tex_V1.hetzer_body_camo3'
     Skins(3)=Texture'VegetationSMT.WildBushes.WildBush_C'
}
