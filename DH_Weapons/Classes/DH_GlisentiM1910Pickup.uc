//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_GlisentiM1910Pickup extends DHWeaponPickup;

defaultproperties
{
    InventoryType=Class'DH_GlisentiM1910Weapon'
    StaticMesh=StaticMesh'DH_BerettaM1934_stc.beretta_m1934_pickup' // TODO: replace
    CollisionRadius=15.0 // as is a pistol, which is small
}
