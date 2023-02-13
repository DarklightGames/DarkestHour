//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WolverineTank_British extends DH_WolverineTank;

defaultproperties
{
    VehicleNameString="Wolverine SP"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_WolverineCannonPawn_British')
    Skins(0)=Texture'DH_VehiclesUK_tex.ext_vehicles.Achilles_body_ext'
    Skins(1)=Texture'DH_VehiclesUK_tex.ext_vehicles.Achilles_turret_ext'
    DestroyedMeshSkins(0)=Material'DH_VehiclesUK_tex.Destroyed.Achilles_body_dest'
    DestroyedMeshSkins(1)=Material'DH_VehiclesUK_tex.Destroyed.Achilles_turret_dest'
}
