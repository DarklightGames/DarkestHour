//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PIATPickup extends DHWeaponPickup
   notplaceable;

defaultproperties
{
     TouchMessage="Pick Up: PIAT"
     MaxDesireability=0.780000
     InventoryType=Class'DH_ATWeapons.DH_PIATWeapon'
     PickupMessage="You got the PIAT."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.PIAT'
     DrawScale=1.230000
     PrePivot=(Z=3.000000)
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
