//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PlaceableGenericPickup extends DHPlaceableWeaponPickup;

// The purpose of this class is to act as a catchall placeable pickup actor so levelers aren't confused by seeing...
// tons of 'DH_PlaceablePanzerFaustPickups` when in reality they've been edited to various weapons

// Usage:
// You'll want to change 2 things for changing the weapon type:
// 1) The static mesh, this is mostly for the editor, the meshes for RO weapons can be found in "WeaponPickupsSM" package DH in "DH_WeaponPickups"
// 2) The `WeaponType` which can be found in `DHPlaceableWeaponPickup`

// Notes:
// This weapon will not respawn by default, to enable respawning and set respawn time look under `Pickup` section after placing the actor
// InventoryType can be none, because WeaponType is actually replicated and sets InventoryType to the WeaponType

defaultproperties
{
    InventoryType=none

    WeaponType=class'DH_Weapons.DH_Kar98Weapon'
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.k98'
}
