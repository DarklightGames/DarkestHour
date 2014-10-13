//=============================================================================
// DH_BazookaPickup
//=============================================================================

class DH_BazookaPickup extends DHWeaponPickup
   notplaceable;

//=============================================================================
// Functions
//=============================================================================

static function StaticPrecache(LevelInfo L)
{
/*  L.AddPrecacheStaticMesh(StaticMesh'DH_WeaponPickups.Weapons.Bazooka');
    L.AddPrecacheStaticMesh(StaticMesh'DH_WeaponPickups.Ammo.Bazooka_shell');
    L.AddPrecacheMaterial(Material'DH_Weapon_tex.AlliedSmallArms_3rdP.Bazooka_3rdP');
    L.AddPrecacheMaterial(Material'DH_Weapon_tex.AlliedSmallArms.BazookaShell');
    L.AddPrecacheMaterial(Material'DH_Weapon_tex.weapon_icons.Bazooka_ammo'); */
}

defaultproperties
{
     TouchMessage="Pick Up: M1A1 Bazooka"
     MaxDesireability=0.780000
     InventoryType=Class'DH_ATWeapons.DH_BazookaWeapon'
     PickupMessage="You got the M1A1 Bazooka."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.Bazooka'
     PrePivot=(Z=3.000000)
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
