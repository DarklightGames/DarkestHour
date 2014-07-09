//=============================================================================
// DH_EnfieldNo2AmmoPickup
//=============================================================================

class DH_EnfieldNo2AmmoPickup extends ROMultiMagAmmoPickup;

defaultproperties
{
     TouchMessage="Pick Up: Enfield No2 ammo pouch"
     AmmoAmount=7
     MaxDesireability=0.300000
     InventoryType=Class'DH_Weapons.DH_EnfieldNo2Ammo'
     PickupMessage="You picked up an Enfield No2 ammo pouch."
     PickupForce="MinigunAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponPickupSM.pouches.tt33pouch'
     PrePivot=(Z=5.000000)
     CollisionRadius=10.000000
     CollisionHeight=3.000000
}
