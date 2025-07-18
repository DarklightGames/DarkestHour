//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_BHPPickup extends DHWeaponPickup;

defaultproperties
{
    InventoryType=Class'DH_BHPWeapon'
    StaticMesh=StaticMesh'DH_WeaponPickups.BHP'
    CollisionRadius=15.0 // as is a pistol, which is small
}
