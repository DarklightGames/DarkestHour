//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ViSPickup extends DHWeaponPickup;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_ViSWeapon'
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.ViS'
    CollisionRadius=15.0 // as is a pistol, which is small
}
