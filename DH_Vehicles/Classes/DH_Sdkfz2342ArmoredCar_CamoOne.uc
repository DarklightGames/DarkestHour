//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Sdkfz2342ArmoredCar_CamoOne extends DH_Sdkfz2342ArmoredCar;

static function StaticPrecache(LevelInfo L)
{
    super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_body_camo1');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_wheels_camo1');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_extras_camo1');

}

simulated function UpdatePrecacheMaterials()
{

    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_body_camo1');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_wheels_camo1');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_extras_camo1');

    super.UpdatePrecacheMaterials();
}

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Sdkfz2342CannonPawn_CamoOne')
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc3.Puma.Puma_dest1'
    Skins(0)=texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_body_camo1'
    Skins(1)=texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_wheels_camo1'
    Skins(2)=texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_extras_camo1'
}
