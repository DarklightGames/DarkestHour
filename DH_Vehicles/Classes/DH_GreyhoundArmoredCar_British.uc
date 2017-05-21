//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_GreyhoundArmoredCar_British extends DH_GreyhoundArmoredCar;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUK_tex.utx

defaultproperties
{
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc3.M8_Greyhound.M8_Destroyed_Brit'
    VehicleNameString="Greyhound Armoured Car"
    Skins(0)=texture'DH_VehiclesUK_tex.ext_vehicles.Greyhound_body_brit'
    Skins(1)=texture'DH_VehiclesUK_tex.ext_vehicles.Greyhound_turret_brit'
    Skins(2)=texture'DH_VehiclesUK_tex.ext_vehicles.Greyhound_wheels_brit'
    CannonSkins(0)=texture'DH_VehiclesUK_tex.ext_vehicles.Greyhound_turret_brit'
}
