//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ColtM1911Pickup extends DHWeaponPickup
    notplaceable;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_ColtM1911Weapon'
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.Colt45'
    PrePivot=(Z=3.0)
    CollisionRadius=15.0
    CollisionHeight=3.0
}
