//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_SpringfieldScopedPickup extends DHWeaponPickup
   notplaceable;

defaultproperties
{
     TouchMessage="Pick Up: M1903 Springfield sniper"
     DropLifeTime=10.000000
     MaxDesireability=0.400000
     InventoryType=Class'DH_Weapons.DH_SpringfieldScopedWeapon'
     PickupMessage="You got the M1903 Springfield sniper."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.M1903A4_Springfield'
     PrePivot=(Z=3.000000)
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
