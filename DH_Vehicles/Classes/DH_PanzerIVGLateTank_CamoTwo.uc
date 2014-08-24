//===================================================================
// DH_PanzerIVGTank
//===================================================================
class DH_PanzerIVGLateTank_CamoTwo extends DH_PanzerIVGLateTank;


static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.PanzerIV_body_camo2');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.PanzerIV_armor_camo2');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.PanzerIV_body_camo2');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.PanzerIV_armor_camo2');

    Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_PanzerIVGLateCannonPawn_CamoTwo')
     Skins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.PanzerIV_body_camo2'
}
