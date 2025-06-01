//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_BerettaM1934Pickup extends DHWeaponPickup;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_BerettaM1934Weapon'
    StaticMesh=StaticMesh'DH_BerettaM1934_stc.Pickup.beretta_m1934_pickup'
    CollisionRadius=15.0 // as is a pistol, which is small
}
