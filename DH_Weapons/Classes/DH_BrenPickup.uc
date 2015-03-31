//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_BrenPickup extends DHWeaponPickup
    notplaceable;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_BrenWeapon'
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.Bren'
    PrePivot=(Z=3.0)
    CollisionRadius=25.0
    CollisionHeight=3.0
}
