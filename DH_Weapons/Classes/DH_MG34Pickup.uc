//=============================================================================
// MG34Pickup
//=============================================================================
// MG34 Weapon pickup
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================
class DH_MG34Pickup extends DH_MGWeaponPickup
   notplaceable;

//-----------------------------------------------------------------------------
// StaticPrecache
//-----------------------------------------------------------------------------

static function StaticPrecache(LevelInfo L)
{
	L.AddPrecacheMaterial(Material'Weapons1st_tex.Arms.hands_gergloves');

	L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.mg34');
	L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Ammo.mg34magazine');
//	L.AddPrecacheStaticMesh(StaticMesh'EffectsSM.Ger_Tracer');
	L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.MG34_World');
	L.AddPrecacheMaterial(Material'Weapons1st_tex.MG.MG42_S');
	L.AddPrecacheMaterial(Material'Weapons1st_tex.MG.MGbipod_S');
	L.AddPrecacheMaterial(Material'Weapons1st_tex.MG.MGBelt_S');
	L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.MG34_ammo');
}

defaultproperties
{
     TouchMessage="Pick Up: Maschinengewehr 34"
     MaxDesireability=0.400000
     InventoryType=Class'DH_Weapons.DH_MG34Weapon'
     PickupMessage="You got the Maschinengewehr 34."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponPickupSM.Weapons.mg34'
     PrePivot=(Z=3.000000)
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
