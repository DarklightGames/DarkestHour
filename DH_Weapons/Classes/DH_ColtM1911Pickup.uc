//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ColtM1911Pickup extends DHWeaponPickup;

defaultproperties
{
    InventoryType=Class'DH_ColtM1911Weapon'
    StaticMesh=StaticMesh'DH_WeaponPickups.Colt45'
    CollisionRadius=15.0 // as is a pistol, which is small
}
