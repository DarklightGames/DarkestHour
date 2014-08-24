//=============================================================================
// C96Pickup
//=============================================================================

class DH_C96Pickup extends ROWeaponPickup
   notplaceable;

//=============================================================================
// Functions
//=============================================================================

static function StaticPrecache(LevelInfo L)
{
/*  L.AddPrecacheStaticMesh(StaticMesh'DH_WeaponPickups.Weapons.M1A1_Thompson');
    L.AddPrecacheStaticMesh(StaticMesh'DH_WeaponPickups.AmmoPouches.Thompson_Ammo_pickup');
    L.AddPrecacheMaterial(Material'DH_Weapon_tex.AlliedSmallArms.ThompsonA');
    L.AddPrecacheMaterial(Material'DH_Weapon_tex.AlliedSmallArms.ThompsonB');
    L.AddPrecacheMaterial(Material'DH_Weapon_tex.weapon_icons.Thompson_ammo'); */
}

defaultproperties
{
     TouchMessage="Pick Up: Mauser C96 pistol"
     MaxDesireability=0.780000
     InventoryType=Class'DH_Weapons.DH_C96Weapon'
     PickupMessage="You got the Mauser C96 pistol."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.c96'
     PrePivot=(Z=5.000000)
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
