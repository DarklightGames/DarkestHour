//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_C96Pickup extends DHWeaponPickup
   notplaceable;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_C96Weapon'
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.c96'
    PrePivot=(Z=5.0)
    CollisionRadius=25.0
    CollisionHeight=3.0
}
