//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_6PounderGun extends DH_AT57Gun;

defaultproperties
{
    VehicleNameString="6 Pounder Mk.IV AT gun"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Guns.DH_6PounderGunCannonPawn')
    DestroyedVehicleMesh=StaticMesh'DH_Artillery_stc.6pounder.6Pounder_dest'
}
