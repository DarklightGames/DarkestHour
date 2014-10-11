//=============================================================================
// DH_BrenAmmoPickup
//=============================================================================

class DH_BrenAmmoPickup extends ROMultiMagAmmoPickup;

defaultproperties
{
     TouchMessage="Pick Up: Bren magazine pouch"
     AmmoAmount=30
     MaxDesireability=0.300000
     InventoryType=Class'DH_Weapons.DH_BrenAmmo'
     PickupMessage="You picked up a Bren magazine pouch."
     PickupForce="MinigunAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.AmmoPouches.brit_ammo_pouches'
     PrePivot=(Z=5.000000)
     CollisionRadius=10.000000
     CollisionHeight=3.000000
}
