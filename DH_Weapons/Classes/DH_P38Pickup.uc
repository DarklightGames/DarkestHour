//=============================================================================
// DH_P38Pickup
//=============================================================================
// P38 Weapon pickup
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_P38Pickup extends DHWeaponPickup
   notplaceable;

//=============================================================================
// Functions
//=============================================================================

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.p38');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.pistolpouch');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.p38_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Pistols.p38_S');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.p38_ammo');
}

defaultproperties
{
     TouchMessage="Pick Up: Walther P38"
     MaxDesireability=0.100000
     InventoryType=Class'DH_Weapons.DH_P38Weapon'
     PickupMessage="You got the Walther P38."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponPickupSM.Weapons.p38'
     PrePivot=(Z=3.000000)
     CollisionRadius=15.000000
     CollisionHeight=3.000000
}
