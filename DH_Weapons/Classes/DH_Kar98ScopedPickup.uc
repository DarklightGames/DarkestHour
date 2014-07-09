//=============================================================================
// DH_Kar98ScopedPickup
//=============================================================================
// Kar98 Scoped Weapon pickup
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_Kar98ScopedPickup extends ROWeaponPickup
   notplaceable;

//-----------------------------------------------------------------------------
// StaticPrecache
//-----------------------------------------------------------------------------

static function StaticPrecache(LevelInfo L)
{
	L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.k98scoped');
	L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.kar98pouch');
	L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.Kar98_world');
	L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.Kars98_scope_world');
	L.AddPrecacheMaterial(Material'Weapons1st_tex.Rifles.Kar98k_2_S');
	L.AddPrecacheMaterial(Material'Weapons1st_tex.Bullets.kar98k_stripper_s');
	L.AddPrecacheMaterial(Material'Weapons1st_tex.SniperScopes.KarScope_S');
	L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.kar98_ammo');
	L.AddPrecacheMaterial(Material'Weapon_overlays.Scopes.Ger_sniperscope_overlay');
}

defaultproperties
{
     TouchMessage="Pick Up: Karabiner 98k"
     DropLifeTime=10.000000
     MaxDesireability=0.400000
     InventoryType=Class'DH_Weapons.DH_Kar98ScopedWeapon'
     PickupMessage="You got the Karabiner 98k."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponPickupSM.Weapons.k98scoped'
     PrePivot=(Z=3.000000)
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
