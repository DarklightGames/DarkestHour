//=============================================================================
// DH_BARAmmoPickup
//=============================================================================

class DH_BARAmmoPickup extends ROMultiMagAmmoPickup;

defaultproperties
{
     TouchMessage="Pick Up: BAR mag pouch"
     AmmoAmount=20
     MaxDesireability=0.300000
     InventoryType=Class'DH_Weapons.DH_BARAmmo'
     PickupMessage="You picked up a BAR mag pouch."
     PickupForce="MinigunAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.AmmoPouches.BAR_Ammo_pickup'
     PrePivot=(Z=5.000000)
     CollisionRadius=10.000000
     CollisionHeight=3.000000
}
