//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_P38Pickup extends DHWeaponPickup;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_P38Weapon'
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.p38'
    CollisionRadius=15.0 // as is a pistol, which is small
}
