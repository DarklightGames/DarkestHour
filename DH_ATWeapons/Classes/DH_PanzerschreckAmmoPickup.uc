//=============================================================================
// DH_PanzerschreckAmmoPickup
//=============================================================================

class DH_PanzerschreckAmmoPickup extends ROAmmoPickup;

defaultproperties
{
     TouchMessage="Pick Up: Panzerschreck rocket"
     AmmoAmount=1
     MaxDesireability=0.300000
     InventoryType=Class'DH_ATWeapons.DH_PanzerschreckAmmo'
     PickupMessage="You picked up a Panzerschreck rocket."
     PickupForce="MinigunAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.Panzerschreck_shell'
     PrePivot=(Z=4.000000)
     CollisionRadius=10.000000
     CollisionHeight=3.000000
}
