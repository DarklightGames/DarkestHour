//=============================================================================
// G41AmmoPickup
//=============================================================================
// Ammo pickup for the G41
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_M1CarbineAmmoPickup extends ROMultiMagAmmoPickup;

defaultproperties
{
     TouchMessage="Pick Up: M1 Carbine mag pouch"
     AmmoAmount=15
     MaxDesireability=0.300000
     InventoryType=Class'DH_Weapons.DH_M1CarbineAmmo'
     PickupMessage="You picked up a M1 Carbine mag pouch."
     PickupForce="MinigunAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.AmmoPouches.Carbine_Ammo_pickup'
     PrePivot=(Z=5.000000)
     CollisionRadius=10.000000
     CollisionHeight=3.000000
}
