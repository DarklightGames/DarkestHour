//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_MG42Pickup extends DHWeaponPickup
    notplaceable;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_MG42Weapon'
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.mg42'
    PrePivot=(Z=3.0)
    CollisionRadius=25.0
    CollisionHeight=3.0
}
