//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_JagdpanzerIVL70Destroyer_Snow extends DH_JagdpanzerIVL70Destroyer;

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex5.ext_vehicles.jagdpanzeriv_body_snow');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex5.ext_vehicles.jagdpanzeriv_armor_snow');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex5.ext_vehicles.jagdpanzeriv_wheels_snow');
    L.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.panzer4F2_treadsnow');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.int_vehicles.jagdpanzeriv_body_int');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex5.ext_vehicles.jagdpanzeriv_body_snow');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex5.ext_vehicles.jagdpanzeriv_armor_snow');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex5.ext_vehicles.jagdpanzeriv_wheels_snow');
    Level.AddPrecacheMaterial(Material'axis_vehicles_tex.Treads.panzer4F2_treadsnow');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex4.int_vehicles.jagdpanzeriv_body_int');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_JagdpanzerIVL70CannonPawn_Snow')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc4.Jagdpanzer4.Jagdpanzer4_dest70_snow'
    Skins(0)=texture'DH_VehiclesGE_tex5.ext_vehicles.jagdpanzeriv_body_snow'
    Skins(1)=texture'DH_VehiclesGE_tex5.ext_vehicles.jagdpanzeriv_armor_snow'
    Skins(2)=texture'DH_VehiclesGE_tex5.ext_vehicles.jagdpanzeriv_wheels_snow'
    Skins(3)=texture'axis_vehicles_tex.Treads.Panzer4F2_treadsnow'
    Skins(4)=texture'axis_vehicles_tex.Treads.Panzer4F2_treadsnow'
}
