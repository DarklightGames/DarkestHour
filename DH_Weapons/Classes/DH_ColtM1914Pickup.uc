//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ColtM1914Pickup extends DHWeaponPickup;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_ColtM1914Weapon'
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.Colt1914'
    CollisionRadius=15.0 // as is a pistol, which is small
}
