//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_SpringfieldAmmoPickup extends ROMultiMagAmmoPickup;

defaultproperties
{
     TouchMessage="Pick Up: Springfield ammo pouch"
     DropLifeTime=10.000000
     AmmoAmount=5
     MaxDesireability=0.300000
     InventoryType=class'DH_Weapons.DH_SpringfieldAmmo'
     PickupMessage="You picked up a .30-06 ammo pouch."
     PickupForce="MinigunAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.AmmoPouches.Garand_Ammo_pickup'
     PrePivot=(Z=5.000000)
     CollisionRadius=10.000000
     CollisionHeight=3.000000
}
