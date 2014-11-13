//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ThompsonPickup extends DHWeaponPickup
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
     TouchMessage="Pick Up: M1A1 Thompson"
     MaxDesireability=0.780000
     InventoryType=Class'DH_Weapons.DH_ThompsonWeapon'
     PickupMessage="You got the M1A1 Thompson."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.M1A1_Thompson'
     PrePivot=(Z=3.000000)
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
