//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_AchillesTank extends DH_WolverineTank;

defaultproperties
{
    VehicleNameString="Achilles Mk.IC"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_AchillesCannonPawn')
    Skins(0)=texture'DH_VehiclesUK_tex.ext_vehicles.Achilles_body_ext'
    Skins(1)=texture'DH_VehiclesUK_tex.ext_vehicles.Achilles_turret_ext'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.M10.Achilles_dest'
    SpawnOverlay(0)=material'DH_InterfaceArt_tex.Vehicles.achilles'
}
