//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_P08LugerPickup extends DHWeaponPickup
    notplaceable;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_P08LugerWeapon'
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.luger'
    PrePivot=(Z=3.0)
    CollisionRadius=15.0
    CollisionHeight=3.0
}
