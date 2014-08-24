//=============================================================================
// DH_Kar98Pickup
//=============================================================================
// Kar98 Weapon pickup
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_Kar98Pickup extends ROWeaponPickup
   notplaceable;

//-----------------------------------------------------------------------------
// StaticPrecache
//-----------------------------------------------------------------------------

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.k98');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.kar98pouch');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.Kar98_world');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.kar98_bayammo_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Rifles.Kar98k_1_S');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Bullets.kar98k_stripper_s');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Bayonet.KarBayonet_S');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.kar98_ammo');
}

defaultproperties
{
     TouchMessage="Pick Up: Karabiner 98k"
     MaxDesireability=0.400000
     InventoryType=Class'DH_Weapons.DH_Kar98Weapon'
     PickupMessage="You got the Karabiner 98k."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponPickupSM.Weapons.k98'
     PrePivot=(Z=3.000000)
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
