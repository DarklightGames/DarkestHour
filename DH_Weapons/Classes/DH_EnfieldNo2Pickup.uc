//=============================================================================
// DH_EnfieldNo2Pickup
//=============================================================================

class DH_EnfieldNo2Pickup extends ROWeaponPickup
   notplaceable;

//=============================================================================
// Functions
//=============================================================================

static function StaticPrecache(LevelInfo L)
{
/*	L.AddPrecacheStaticMesh(StaticMesh'DH_WeaponPickups.Weapons.colt45');
	L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.tt33pouch');
	L.AddPrecacheMaterial(Material'Weapons3rd_tex.Soviet.tt33_world');
	L.AddPrecacheMaterial(Material'Weapons1st_tex.Pistols.TT33_S');
	L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.tt33_ammo'); */
}

defaultproperties
{
     TouchMessage="Pick Up: Enfield No2 Revolver"
     MaxDesireability=0.100000
     InventoryType=Class'DH_Weapons.DH_EnfieldNo2Weapon'
     PickupMessage="You got the Enfield No2 Revolver."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.EnfieldNo2'
     PrePivot=(Z=3.000000)
     CollisionRadius=15.000000
     CollisionHeight=3.000000
}
