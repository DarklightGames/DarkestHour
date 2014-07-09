//=============================================================================
// DH_PIATAmmoPickup
//=============================================================================

class DH_PIATAmmoPickup extends ROAmmoPickup;

defaultproperties
{
     TouchMessage="Pick Up: PIAT bomb"
     AmmoAmount=1
     MaxDesireability=0.300000
     InventoryType=Class'DH_ATWeapons.DH_PIATAmmo'
     PickupMessage="You picked up a PIAT bomb."
     PickupForce="MinigunAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.PIATBomb'
     PrePivot=(Z=3.000000)
     CollisionRadius=10.000000
     CollisionHeight=3.000000
}
