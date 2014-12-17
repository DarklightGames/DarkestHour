//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_StenMkIIPickup extends DHWeaponPickup
   notplaceable;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_StenMkIIWeapon'
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.StenMkII'
    PrePivot=(Z=3.000000)
    CollisionRadius=25.000000
    CollisionHeight=3.000000
}
