//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_HetzerDestroyer_Bushes extends DH_HetzerDestroyer;

static function StaticPrecache(LevelInfo L)
{
    super(ROTreadCraft).StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.hetzer_body');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.Stug3_treads');
    L.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.hetzer_int');
    L.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.Hetzer_driver_glass');
    L.AddPrecacheMaterial(Material'VegetationSMT.WildBushesFall.WildBush_A_FallB');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.hetzer_body');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.Stug3_treads');
    Level.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.hetzer_int');
    Level.AddPrecacheMaterial(Material'DH_Hetzer_tex_V1.Hetzer_driver_glass');
    Level.AddPrecacheMaterial(Material'VegetationSMT.WildBushesFall.WildBush_A_FallB');

    super(ROTreadCraft).UpdatePrecacheMaterials();
}

defaultproperties
{
    Skins(3)=Texture'VegetationSMT.WildBushesFall.WildBush_A_FallB'
}
