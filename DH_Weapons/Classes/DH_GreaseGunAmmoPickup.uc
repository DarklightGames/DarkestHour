//=============================================================================
// GreaseGunAmmoPickup
//=============================================================================

class DH_GreaseGunAmmoPickup extends ROMultiMagAmmoPickup;

defaultproperties
{
     TouchMessage="Pick Up: 30 round .45in mag pouch"
     AmmoAmount=30
     MaxDesireability=0.300000
     InventoryType=Class'DH_Weapons.DH_GreaseGunAmmo'
     PickupMessage="30 round .45in mag pouch added to inventory."
     PickupForce="MinigunAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.AmmoPouches.Thompson_Ammo_pickup'
     PrePivot=(Z=5.000000)
     CollisionRadius=10.000000
     CollisionHeight=3.000000
}
