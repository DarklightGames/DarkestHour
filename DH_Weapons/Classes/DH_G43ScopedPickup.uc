//=============================================================================
// DH_G43ScopedPickup
//=============================================================================
// G43 Sniper Weapon pickup
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_G43ScopedPickup extends ROWeaponPickup
   notplaceable;

//=============================================================================
// Functions
//=============================================================================

static function StaticPrecache(LevelInfo L)
{
	L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.g43scope');
	L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.g43pouch');
	L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.g43_world');
	L.AddPrecacheMaterial(Material'Weapons1st_tex.Rifles.g43_sniper_s');
	L.AddPrecacheMaterial(Material'Weapons1st_tex.Bullets.kar98k_stripper_s');
	L.AddPrecacheMaterial(Material'Weapons1st_tex.SniperScopes.g43_scope_s');
	L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.G43_ammo');
	L.AddPrecacheMaterial(Material'Weapon_overlays.Scopes.Ger_sniperscope_overlay');
}

defaultproperties
{
     TouchMessage="Pick Up: Gewehr 43"
     DropLifeTime=10.000000
     MaxDesireability=0.780000
     InventoryType=Class'DH_Weapons.DH_G43ScopedWeapon'
     PickupMessage="You got the Gewehr 43."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponPickupSM.Weapons.g43scope'
     PrePivot=(Z=3.000000)
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
