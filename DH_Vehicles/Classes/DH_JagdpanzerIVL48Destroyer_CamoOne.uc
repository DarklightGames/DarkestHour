//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_JagdpanzerIVL48Destroyer_CamoOne extends DH_JagdpanzerIVL48Destroyer;

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_body_camo2');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_armor_camo2');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_wheels_camo2');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.panzer4F2_treads');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.int_vehicles.jagdpanzeriv_body_int');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_body_camo2');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_armor_camo2');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_wheels_camo2');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.panzer4F2_treads');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.int_vehicles.jagdpanzeriv_body_int');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdpanzerIVL48CannonPawn_CamoOne')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc4.Jagdpanzer4.jagdpanzer4_dest482'
    Skins(0)=texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_body_camo2'
    Skins(1)=texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_armor_camo2'
    Skins(2)=texture'DH_VehiclesGE_tex4.ext_vehicles.jagdpanzeriv_wheels_camo2'
}
