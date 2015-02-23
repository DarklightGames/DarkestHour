//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_EnfieldNo2Pickup extends DHWeaponPickup
   notplaceable;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_EnfieldNo2Weapon'
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.EnfieldNo2'
    PrePivot=(Z=3.0)
    CollisionRadius=15.0
    CollisionHeight=3.0
}
