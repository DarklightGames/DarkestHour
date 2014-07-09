//=============================================================================
// DH_PanzerschreckPickup
//=============================================================================

class DH_PanzerschreckPickup extends ROWeaponPickup
   notplaceable;

//=============================================================================
// Functions
//=============================================================================

static function StaticPrecache(LevelInfo L)
{
/*	L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.Panzerfaust');
	L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Ammo.Warhead3rd');
	L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Ammo.Warhead1st');
	L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.Panzerfaust_world');
	L.AddPrecacheMaterial(Material'Weapons1st_tex.Grenades.Panzerfaust_S');
	L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.panzerfaust_ammo'); */
}

defaultproperties
{
     TouchMessage="Pick Up: Panzerschreck"
     MaxDesireability=0.780000
     InventoryType=Class'DH_ATWeapons.DH_PanzerschreckWeapon'
     PickupMessage="You got the Panzerschreck."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.Panzerschreck'
     PrePivot=(Z=3.000000)
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
