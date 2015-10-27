//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WolverineFactory_British extends DH_BritishVehicles;

defaultproperties
{
    RespawnTime=1.0
    bFactoryActive=true
    VehicleClass=class'DH_Vehicles.DH_WolverineTank_British'
    Mesh=SkeletalMesh'DH_Wolverine_anm.M10_body_ext'
    Skins(0)=texture'DH_VehiclesUK_tex.ext_vehicles.Achilles_body_ext'
    Skins(1)=texture'DH_VehiclesUK_tex.ext_vehicles.Achilles_turret_ext'
}
