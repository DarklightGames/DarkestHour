//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_P38Pickup extends DHWeaponPickup;

defaultproperties
{
    InventoryType=Class'DH_P38Weapon'
    StaticMesh=StaticMesh'WeaponPickupSM.p38'
    CollisionRadius=15.0 // as is a pistol, which is small
}
