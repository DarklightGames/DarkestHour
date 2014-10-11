//=============================================================================
// MG100Rd792x57AmmoPickup
//=============================================================================
// Ammo pickup for german machine guns that use 100 round belt ammo
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class DHMG250Rd792x57AmmoPickup extends ROAmmoPickup;

defaultproperties
{
     TouchMessage="Pick Up: 250 round 7.92x57mm belt"
     AmmoAmount=250
     MaxDesireability=0.300000
     InventoryType=Class'DH_Weapons.DHMG250Rd792x57Ammo'
     PickupMessage="250 round 7.92x57mm belt added to inventory."
     PickupForce="MinigunAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponPickupSM.Ammo.Mg42magazine'
     PrePivot=(Z=5.000000)
     CollisionRadius=10.000000
     CollisionHeight=3.000000
}
