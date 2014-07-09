//=============================================================================
// DH_MP40Pickup
//=============================================================================
// MP40 Weapon pickup
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_FlarePickup extends ROWeaponPickup
   notplaceable;

//=============================================================================
// Functions
//=============================================================================

static function StaticPrecache(LevelInfo L)
{
	L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.mp40');
	L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.mp40pouch');
	L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.mp40_world');
	L.AddPrecacheMaterial(Material'Weapons1st_tex.SMG.MP40_S');
	L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.mg40_ammo');
}

defaultproperties
{
     TouchMessage="Pick Up: Flare gun"
     MaxDesireability=0.780000
     InventoryType=Class'DH_Weapons.DH_FlareWeapon'
     PickupMessage="You got the Flare gun."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponPickupSM.Weapons.mp40'
     PrePivot=(Z=3.000000)
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
