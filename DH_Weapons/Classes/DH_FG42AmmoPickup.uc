//=============================================================================
// DH_FG42AmmoPickup
//=============================================================================

class DH_FG42AmmoPickup extends ROMultiMagAmmoPickup;

defaultproperties
{
     TouchMessage="Pick Up: Fallschirmjägergewehr 42 ammunition"
     AmmoAmount=20
     MaxDesireability=0.300000
     InventoryType=Class'DH_Weapons.DH_FG42Ammo'
     PickupMessage="You picked up Fallschirmjägergewehr 42 ammunition."
     PickupForce="MinigunAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponPickupSM.pouches.stg44pouch'
     PrePivot=(Z=5.000000)
     CollisionRadius=10.000000
     CollisionHeight=3.000000
}
