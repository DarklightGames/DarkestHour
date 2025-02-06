//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_EnfieldNo2Pickup extends DHWeaponPickup;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_EnfieldNo2Weapon'
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.EnfieldNo2'
    CollisionRadius=15.0 // as is a pistol, which is small
    DrawScale=0.75
}
