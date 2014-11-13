//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_GreyhoundArmoredCar_Snow extends DH_GreyhoundArmoredCar;


static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex4.ext_vehicles.Greyhound_body_snow');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex4.ext_vehicles.Greyhound_turret_snow');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex4.ext_vehicles.Greyhound_wheels_snow');
    L.AddPrecacheMaterial(Material'DH_VehiclesUS_tex4.int_vehicles.Greyhound_body_int');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex4.ext_vehicles.Greyhound_body_snow');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex4.ext_vehicles.Greyhound_turret_snow');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex4.ext_vehicles.Greyhound_wheels_snow');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUS_tex4.int_vehicles.Greyhound_body_int');

    Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_GreyhoundCannonPawn_Snow')
     DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc3.M8_Greyhound.M8_Destroyed_Snow'
     Skins(0)=Texture'DH_VehiclesUS_tex4.ext_vehicles.Greyhound_body_snow'
     Skins(1)=Texture'DH_VehiclesUS_tex4.ext_vehicles.Greyhound_turret_snow'
     Skins(2)=Texture'DH_VehiclesUS_tex4.ext_vehicles.Greyhound_wheels_snow'
}
