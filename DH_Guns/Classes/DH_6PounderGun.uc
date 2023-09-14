//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_6PounderGun extends DH_AT57Gun;

defaultproperties
{
    VehicleNameString="6 Pounder Mk.IV AT gun"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_6PounderGunCannonPawn')
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.6pounder.6Pounder_dest'
}
