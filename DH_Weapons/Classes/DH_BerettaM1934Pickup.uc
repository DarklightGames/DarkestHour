//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_BerettaM1934Pickup extends DHWeaponPickup;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_BerettaM1934Weapon'
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.tt33'  // TODO: replace
    CollisionRadius=15.0 // as is a pistol, which is small
}
