//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ThompsonPickup extends DHWeaponPickup
   notplaceable;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_ThompsonWeapon'
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.M1A1_Thompson'
    PrePivot=(Z=3.000000)
    CollisionRadius=25.000000
    CollisionHeight=3.000000
}
