//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_FG42Pickup extends DHWeaponPickup
   notplaceable;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_FG42Weapon'
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.FG42'
    PrePivot=(Z=3.0)
    CollisionRadius=25.0
    CollisionHeight=3.0
    DrawScale=1.1
}
