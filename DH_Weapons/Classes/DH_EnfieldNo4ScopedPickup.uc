//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_EnfieldNo4ScopedPickup extends DHWeaponPickup
   notplaceable;

defaultproperties
{
     TouchMessage="Pick Up: Enfield No. 4 sniper"
     DropLifeTime=10.000000
     MaxDesireability=0.400000
     InventoryType=Class'DH_Weapons.DH_EnfieldNo4ScopedWeapon'
     PickupMessage="You got the Enfield No. 4 sniper."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.EnfieldNo4_Scoped'
     PrePivot=(Z=3.000000)
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
