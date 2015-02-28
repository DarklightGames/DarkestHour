//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_GreyhoundArmoredCarFactory_British extends DH_BritishVehicles;

defaultproperties
{
    RespawnTime=1.0
    bFactoryActive=true
    VehicleClass=class'DH_Vehicles.DH_GreyhoundArmoredCar_British'
    Mesh=SkeletalMesh'DH_Greyhound_anm.Greyhound_body_ext'
    Skins(0)=texture'DH_VehiclesUK_tex2.ext_vehicles.Greyhound_body_brit'
    Skins(1)=texture'DH_VehiclesUK_tex2.ext_vehicles.Greyhound_turret_brit'
    Skins(2)=texture'DH_VehiclesUK_tex2.ext_vehicles.Greyhound_wheels_brit'
}
