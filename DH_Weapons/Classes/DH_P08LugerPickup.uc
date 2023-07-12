//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_P08LugerPickup extends DHWeaponPickup;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_P08LugerWeapon'
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.luger'
    CollisionRadius=15.0 // as is a pistol, which is small
}
