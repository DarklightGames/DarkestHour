//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BazookaAmmoPickup extends ROAmmoPickup;

defaultproperties
{
     TouchMessage="Pick Up: Bazooka rocket"
     AmmoAmount=1
     MaxDesireability=0.300000
     InventoryType=Class'DH_ATWeapons.DH_BazookaAmmo'
     PickupMessage="You picked up a Bazooka rocket."
     PickupForce="MinigunAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.Ammo.Bazooka_shell'
     PrePivot=(Z=5.000000)
     CollisionRadius=10.000000
     CollisionHeight=3.000000
}
