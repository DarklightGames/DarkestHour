//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_AchillesTank extends DH_WolverineTank;

defaultproperties
{
    VehicleNameString="Achilles Mk.IC"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_AchillesCannonPawn')
    Skins(0)=Texture'DH_VehiclesUK_tex.ext_vehicles.Achilles_body_ext'
    Skins(1)=Texture'DH_VehiclesUK_tex.ext_vehicles.Achilles_turret_ext'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.M10.Achilles_dest'
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.achilles'
}
