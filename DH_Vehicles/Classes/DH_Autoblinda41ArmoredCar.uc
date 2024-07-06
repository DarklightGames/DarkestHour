//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Autoblinda41ArmoredCar extends DH_AutoblindaArmoredCar;

defaultproperties
{
    // Vehicle properties
    VehicleNameString="Autoblinda 41"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_Autoblinda41CannonPawn',WeaponBone="turret_attachment")
    DestroyedVehicleMesh=StaticMesh'DH_German_vehicles_stc3.234.234_dest'
    VehicleHudTurret=TexRotator'DH_Autoblinda_tex.interface.ab41_turret_rot'
    VehicleHudTurretLook=TexRotator'DH_Autoblinda_tex.interface.ab41_turret_look'
    SpawnOverlay(0)=Material'DH_Autoblinda_tex.interface.ab41_icon'
}
