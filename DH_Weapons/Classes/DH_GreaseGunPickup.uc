//=============================================================================
// GreaseGunPickup
//=============================================================================

class DH_GreaseGunPickup extends ROWeaponPickup
   notplaceable;

//=============================================================================
// Functions
//=============================================================================

static function StaticPrecache(LevelInfo L)
{
//	L.AddPrecacheMaterial(Material'DH_Weapon_tex.AlliedSmallArms_3rdP.M3GreaseGun_3rdP');

}

defaultproperties
{
     TouchMessage="Pick Up: Grease Gun"
     MaxDesireability=0.780000
     InventoryType=Class'DH_Weapons.DH_GreaseGunWeapon'
     PickupMessage="You got the Grease Gun."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.M3_GreaseGun'
     PrePivot=(Z=3.000000)
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
