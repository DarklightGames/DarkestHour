//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_GreyhoundArmoredCar_Snow extends DH_GreyhoundArmoredCar;

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_GreyhoundCannonPawn_Snow')
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc3.M8_Greyhound.M8_Destroyed_Snow'
    Skins(0)=texture'DH_VehiclesUS_tex4.ext_vehicles.Greyhound_body_snow'
    Skins(1)=texture'DH_VehiclesUS_tex4.ext_vehicles.Greyhound_turret_snow'
    Skins(2)=texture'DH_VehiclesUS_tex4.ext_vehicles.Greyhound_wheels_snow'
}
