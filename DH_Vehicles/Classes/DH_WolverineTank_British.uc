//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WolverineTank_British extends DH_WolverineTank;

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_WolverineCannonPawn_British')
    VehicleNameString="Wolverine SP"
    Skins(0)=texture'DH_VehiclesUK_tex.ext_vehicles.Achilles_body_ext'
    Skins(1)=texture'DH_VehiclesUK_tex.ext_vehicles.Achilles_turret_ext'
    DestroyedMeshSkins(0)=material'DH_VehiclesUK_tex.Destroyed.Achilles_body_dest'
    DestroyedMeshSkins(1)=material'DH_VehiclesUK_tex.Destroyed.Achilles_turret_dest'
}
