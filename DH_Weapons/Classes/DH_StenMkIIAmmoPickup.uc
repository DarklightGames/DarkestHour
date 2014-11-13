//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_StenMkIIAmmoPickup extends ROMultiMagAmmoPickup;

defaultproperties
{
     TouchMessage="Pick Up: 32 round 9mm mag pouch"
     AmmoAmount=32
     MaxDesireability=0.300000
     InventoryType=Class'DH_Weapons.DH_StenMkIIAmmo'
     PickupMessage="32 round 9mm mag pouch added to inventory."
     PickupForce="MinigunAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.AmmoPouches.brit_ammo_pouches'
     PrePivot=(Z=5.000000)
     CollisionRadius=10.000000
     CollisionHeight=3.000000
}
