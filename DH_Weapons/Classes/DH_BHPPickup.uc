//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_BHPPickup extends DHWeaponPickup;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_BHPWeapon'
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.BHP'
    CollisionRadius=15.0 // as is a pistol, which is small
}
