//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_EnfieldNo4AmmoPickup extends ROMultiMagAmmoPickup;

defaultproperties
{
     TouchMessage="Pick Up: Lee Enfield No. 4 ammunition pouch"
     AmmoAmount=5
     MaxDesireability=0.300000
     InventoryType=class'DH_Weapons.DH_EnfieldNo4Ammo'
     PickupMessage="You picked up a Lee Enfield No. 4 ammunition pouch."
     PickupForce="MinigunAmmoPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.AmmoPouches.brit_ammo_pouches'
     PrePivot=(Z=5.000000)
     CollisionRadius=10.000000
     CollisionHeight=3.000000
}
