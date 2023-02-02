//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Nagant1895BramitPickup extends DHWeaponPickup;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_Nagant1895BramitWeapon'
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.m1895Bramit'
    CollisionRadius=15.0 // as is a pistol, which is small
    DrawScale=0.35
}
