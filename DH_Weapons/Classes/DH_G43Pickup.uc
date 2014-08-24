//=============================================================================
// DH_G43Pickup
//=============================================================================
// G43 Weapon pickup
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_G43Pickup extends ROWeaponPickup
   notplaceable;

//=============================================================================
// Functions
//=============================================================================

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.g43');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.g43pouch');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.g43_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Rifles.G43_S');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.G43_ammo');
}

defaultproperties
{
     TouchMessage="Pick Up: Gewehr 43"
     MaxDesireability=0.780000
     InventoryType=Class'DH_Weapons.DH_G43Weapon'
     PickupMessage="You got the Gewehr 43."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponPickupSM.Weapons.g43'
     PrePivot=(Z=3.000000)
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
