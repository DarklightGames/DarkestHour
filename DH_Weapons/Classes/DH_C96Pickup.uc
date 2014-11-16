//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_C96Pickup extends DHWeaponPickup
   notplaceable;

defaultproperties
{
     TouchMessage="Pick Up: Mauser C96 pistol"
     MaxDesireability=0.780000
     InventoryType=class'DH_Weapons.DH_C96Weapon'
     PickupMessage="You got the Mauser C96 pistol."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.c96'
     PrePivot=(Z=5.000000)
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
