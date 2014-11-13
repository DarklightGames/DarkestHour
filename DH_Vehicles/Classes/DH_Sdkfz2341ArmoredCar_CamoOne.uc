//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_Sdkfz2341ArmoredCar_CamoOne extends DH_Sdkfz2341ArmoredCar;



static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_body_camo1');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_wheels_camo1');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_extras_camo1');

}

simulated function UpdatePrecacheMaterials()
{

    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_body_camo1');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_wheels_camo1');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_extras_camo1');

    Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_Sdkfz2341CannonPawn_CamoOne')
     DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc3.234.234_dest1'
     Skins(0)=Texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_body_camo1'
     Skins(1)=Texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_wheels_camo1'
     Skins(2)=Texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_extras_camo1'
}
