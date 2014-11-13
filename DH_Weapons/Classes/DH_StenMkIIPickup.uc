//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_StenMkIIPickup extends DHWeaponPickup
   notplaceable;

//=============================================================================
// Functions
//=============================================================================

static function StaticPrecache(LevelInfo L)
{
//  L.AddPrecacheMaterial(Material'DH_Weapon_tex.AlliedSmallArms.Sten');

}

defaultproperties
{
     TouchMessage="Pick Up: Sten MkII"
     MaxDesireability=0.780000
     InventoryType=class'DH_Weapons.DH_StenMkIIWeapon'
     PickupMessage="You got the Sten MkII."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.StenMkII'
     PrePivot=(Z=3.000000)
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
