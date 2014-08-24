class DH_JagdpanzerIVL70Destroyer_CamoOne extends DH_JagdpanzerIVL70Destroyer;


static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_body_camo2');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_armor_camo2');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_wheels_camo2');

}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_body_camo2');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_armor_camo2');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_wheels_camo2');

    Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_JagdpanzerIVL70CannonPawn_CamoOne')
     DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc4.Jagdpanzer4.jagdpanzer4_dest702'
     Skins(0)=Texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_body_camo2'
     Skins(1)=Texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_armor_camo2'
     Skins(2)=Texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_wheels_camo2'
}
