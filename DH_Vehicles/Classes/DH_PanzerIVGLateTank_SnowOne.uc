class DH_PanzerIVGLateTank_SnowOne extends DH_PanzerIVGLateTank;


static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.PanzerIV_body_snow1');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.PanzerIV_armor_snow1');

}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.PanzerIV_body_snow1');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex3.ext_vehicles.PanzerIV_armor_snow1');
	Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_PanzerIVGLateCannonPawn_SnowOne')
     Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.PanzerIV_body_snow1'
}
