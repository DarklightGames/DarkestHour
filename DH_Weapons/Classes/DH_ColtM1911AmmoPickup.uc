//=============================================================================
// DH_ColtM1911AmmoPickup
//=============================================================================

class DH_ColtM1911AmmoPickup extends ROMultiMagAmmoPickup;

defaultproperties
{
     TouchMessage="Pick Up: Colt M1911 magazine pouch"
     AmmoAmount=7
     MaxDesireability=0.300000
     InventoryType=Class'DH_Weapons.DH_ColtM1911Ammo'
     PickupMessage="You picked up a Colt M1911 magazine pouch."
     PickupForce="MinigunAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponPickupSM.pouches.tt33pouch'
     PrePivot=(Z=5.000000)
     CollisionRadius=10.000000
     CollisionHeight=3.000000
}
