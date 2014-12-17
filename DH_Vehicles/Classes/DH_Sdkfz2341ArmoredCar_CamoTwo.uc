//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Sdkfz2341ArmoredCar_CamoTwo extends DH_Sdkfz2341ArmoredCar;

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_body_camo2');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_wheels_camo2');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_extras_camo2');

}

simulated function UpdatePrecacheMaterials()
{

    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_body_camo2');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_wheels_camo2');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_extras_camo2');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Sdkfz2341CannonPawn_CamoTwo')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc3.234.234_dest2'
    Skins(0)=texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_body_camo2'
    Skins(1)=texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_wheels_camo2'
    Skins(2)=texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_extras_camo2'
}
