//=============================================================================
// C96AmmoPickup
//=============================================================================

class DH_C96AmmoPickup extends ROMultiMagAmmoPickup;

defaultproperties
{
     TouchMessage="Pick Up: 20 round 7.63mm mag pouch"
     AmmoAmount=20
     MaxDesireability=0.300000
     InventoryType=Class'DH_Weapons.DH_C96Ammo'
     PickupMessage="20 round 7.63mm mag pouch added to inventory."
     PickupForce="MinigunAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.AmmoPouches.C96_Ammo_pickup'
     PrePivot=(Z=8.000000)
     CollisionRadius=10.000000
     CollisionHeight=3.000000
}
