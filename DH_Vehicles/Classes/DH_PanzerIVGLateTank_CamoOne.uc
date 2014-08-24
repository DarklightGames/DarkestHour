//===================================================================
// DH_PanzerIVJTank
//===================================================================
class DH_PanzerIVGLateTank_CamoOne extends DH_PanzerIVGLateTank;


static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.PanzerIV_body_camo1');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.PanzerIV_armor_camo1');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.PanzerIV_body_camo1');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex.ext_vehicles.PanzerIV_armor_camo1');

    Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_PanzerIVGLateCannonPawn_CamoOne')
     Skins(0)=Texture'DH_VehiclesGE_tex.ext_vehicles.PanzerIV_body_camo1'
}
