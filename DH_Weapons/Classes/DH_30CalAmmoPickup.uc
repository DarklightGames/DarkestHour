//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_30CalAmmoPickup extends ROMultiMagAmmoPickup;

defaultproperties
{
     TouchMessage="Pick Up: .30 caliber ammunition box"
     AmmoAmount=250
     MaxDesireability=0.300000
     InventoryType=class'DH_Weapons.DH_30CalAmmo'
     PickupMessage="You picked up a .30 caliber ammunition box."
     PickupForce="MinigunAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.AmmoPouches.30CalAmmo_pickup'
     PrePivot=(Z=5.000000)
     CollisionRadius=10.000000
     CollisionHeight=3.000000
}
