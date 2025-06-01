//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_TT33Pickup extends DHWeaponPickup;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_TT33Weapon'
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.tt33'
    CollisionRadius=15.0 // as is a pistol, which is small
}
