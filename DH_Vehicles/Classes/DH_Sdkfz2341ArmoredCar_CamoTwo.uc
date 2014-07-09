//==============================================================================
// DH_Sdkfz2341ArmoredCar_CamoTwo
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// Sdkfz 234/1 German Armored Reconnaisance Car
//==============================================================================
class DH_Sdkfz2341ArmoredCar_CamoTwo extends DH_Sdkfz2341ArmoredCar;



static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_body_camo2');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_wheels_camo2');
    L.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_extras_camo2');

}

simulated function UpdatePrecacheMaterials()
{

    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_body_camo2');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_wheels_camo2');
    Level.AddPrecacheMaterial(Material'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_extras_camo2');

	Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_Sdkfz2341CannonPawn_CamoTwo')
     DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc3.234.234_dest2'
     Skins(0)=Texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_body_camo2'
     Skins(1)=Texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_wheels_camo2'
     Skins(2)=Texture'DH_VehiclesGE_tex6.ext_vehicles.sdkfz2341_extras_camo2'
}
