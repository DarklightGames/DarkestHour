//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_P08LugerPickup extends DHWeaponPickup;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_P08LugerWeapon'
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.luger'
    CollisionRadius=15.0 // as is a pistol, which is small
}
