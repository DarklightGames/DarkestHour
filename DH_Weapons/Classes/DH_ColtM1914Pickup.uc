//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ColtM1914Pickup extends DHWeaponPickup;

defaultproperties
{
    InventoryType=Class'DH_ColtM1914Weapon'
    StaticMesh=StaticMesh'DH_WeaponPickups.Colt1914'
    CollisionRadius=15.0 // as is a pistol, which is small
}
