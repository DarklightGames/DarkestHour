//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_TT33Pickup extends DHWeaponPickup;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_TT33Weapon'
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.tt33'
    CollisionRadius=15.0 // as is a pistol, which is small
}
