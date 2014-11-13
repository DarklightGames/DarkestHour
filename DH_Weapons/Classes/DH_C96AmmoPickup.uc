//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_C96AmmoPickup extends ROMultiMagAmmoPickup;

defaultproperties
{
     TouchMessage="Pick Up: C96 magazine pouch"
     AmmoAmount=20
     MaxDesireability=0.300000
     InventoryType=class'DH_Weapons.DH_C96Ammo'
     PickupMessage="You picked up a C96 magazine pouch."
     PickupForce="MinigunAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.AmmoPouches.C96_Ammo_pickup'
     PrePivot=(Z=8.000000)
     CollisionRadius=10.000000
     CollisionHeight=3.000000
}
