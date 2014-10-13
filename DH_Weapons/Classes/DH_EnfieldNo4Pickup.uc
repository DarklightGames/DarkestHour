class DH_EnfieldNo4Pickup extends DHWeaponPickup
   notplaceable;

//=============================================================================
// Functions
//=============================================================================

static function StaticPrecache(LevelInfo L)
{
/*  L.AddPrecacheStaticMesh(StaticMesh'DH_WeaponPickups.Weapons.EnfieldNo4');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.kar98pouch');
    L.AddPrecacheMaterial(Material'DH_Weapon_tex.AlliedSmallArms.EnfieldNo4Main');
    L.AddPrecacheMaterial(Material'DH_Weapon_tex.AlliedSmallArms.EnfieldNo4Bayo');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.kar98_ammo'); */
}

defaultproperties
{
     TouchMessage="Pick Up: Lee Enfield No. 4"
     MaxDesireability=0.780000
     InventoryType=Class'DH_Weapons.DH_EnfieldNo4Weapon'
     PickupMessage="You got the Lee Enfield No. 4."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.EnfieldNo4'
     PrePivot=(Z=3.000000)
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
