//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Nagant1895Pickup extends DHWeaponPickup;

defaultproperties
{
    InventoryType=Class'DH_Nagant1895Weapon'
    StaticMesh=StaticMesh'DH_WeaponPickups.m1895'
    CollisionRadius=15.0 // as is a pistol, which is small
}
