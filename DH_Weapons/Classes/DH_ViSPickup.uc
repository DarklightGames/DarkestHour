//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ViSPickup extends DHWeaponPickup;

defaultproperties
{
    InventoryType=Class'DH_ViSWeapon'
    StaticMesh=StaticMesh'DH_WeaponPickups.ViS'
    CollisionRadius=15.0 // as is a pistol, which is small
}
