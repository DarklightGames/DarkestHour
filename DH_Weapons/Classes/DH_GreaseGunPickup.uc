//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_GreaseGunPickup extends DHWeaponPickup
   notplaceable;

defaultproperties
{
     TouchMessage="Pick Up: Grease Gun"
     MaxDesireability=0.780000
     InventoryType=class'DH_Weapons.DH_GreaseGunWeapon'
     PickupMessage="You got the Grease Gun."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.M3_GreaseGun'
     PrePivot=(Z=3.000000)
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
