//=============================================================================
// DH_RedSmokePickup
//=============================================================================

class DH_RedSmokePickup extends ROOneShotWeaponPickup
   notplaceable;

//=============================================================================
// Functions
//=============================================================================

defaultproperties
{
     TouchMessage="Pick Up: M16 Red Smoke Grenade"
     MaxDesireability=0.780000
     InventoryType=Class'DH_Equipment.DH_RedSmokeWeapon'
     PickupMessage="You got the M16 Red Smoke Grenade."
     PickupSound=Sound'Inf_Weapons_Foley.Misc.ammopickup'
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.USRedSmokeGrenade'
     PrePivot=(Z=3.000000)
     AmbientGlow=0
     CollisionRadius=15.000000
     CollisionHeight=3.000000
}
