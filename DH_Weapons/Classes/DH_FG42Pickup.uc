//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_FG42Pickup extends DHWeaponPickup
   notplaceable;

defaultproperties
{
     TouchMessage="Pick Up: Fallschirmjägergewehr 42"
     MaxDesireability=0.900000
     InventoryType=class'DH_Weapons.DH_FG42Weapon'
     PickupMessage="You got the Fallschirmjägergewehr 42."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.FG42'
     DrawScale=1.100000
     PrePivot=(Z=3.000000)
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
