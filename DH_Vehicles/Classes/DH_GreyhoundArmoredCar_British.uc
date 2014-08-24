//==============================================================================
// DH_GreyhoundArmoredCar_British
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// British M8 'Greyhound' Armored Car
//==============================================================================
class DH_GreyhoundArmoredCar_British extends DH_GreyhoundArmoredCar;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUK_tex2.utx

static function StaticPrecache(LevelInfo L)
{
    Super.StaticPrecache(L);

    L.AddPrecacheMaterial(Material'DH_VehiclesUK_tex2.ext_vehicles.Greyhound_body_brit');
    L.AddPrecacheMaterial(Material'DH_VehiclesUK_tex2.ext_vehicles.Greyhound_turret_brit');
    L.AddPrecacheMaterial(Material'DH_VehiclesUK_tex2.ext_vehicles.Greyhound_wheels_brit');
}

simulated function UpdatePrecacheMaterials()
{
    Level.AddPrecacheMaterial(Material'DH_VehiclesUK_tex2.ext_vehicles.Greyhound_body_brit');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUK_tex2.ext_vehicles.Greyhound_turret_brit');
    Level.AddPrecacheMaterial(Material'DH_VehiclesUK_tex2.ext_vehicles.Greyhound_wheels_brit');

    Super.UpdatePrecacheMaterials();
}

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=Class'DH_Vehicles.DH_GreyhoundCannonPawn_British')
     DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc3.M8_Greyhound.M8_Destroyed_Brit'
     VehiclePositionString="in an Greyhound Armoured Car"
     VehicleNameString="Greyhound Armoured Car"
     Skins(0)=Texture'DH_VehiclesUK_tex2.ext_vehicles.Greyhound_body_brit'
     Skins(1)=Texture'DH_VehiclesUK_tex2.ext_vehicles.Greyhound_turret_brit'
     Skins(2)=Texture'DH_VehiclesUK_tex2.ext_vehicles.Greyhound_wheels_brit'
}
