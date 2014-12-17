//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BazookaPickup extends DHWeaponPickup
   notplaceable;

defaultproperties
{
    InventoryType=class'DH_ATWeapons.DH_BazookaWeapon'
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.Bazooka'
    PrePivot=(Z=3.000000)
    CollisionRadius=25.000000
    CollisionHeight=3.000000
}
