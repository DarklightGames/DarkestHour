//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ColtM1911Pickup extends DHWeaponPickup
   notplaceable;

//=============================================================================
// Functions
//=============================================================================

static function StaticPrecache(LevelInfo L)
{
/*  L.AddPrecacheStaticMesh(StaticMesh'DH_WeaponPickups.Weapons.colt45');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.tt33pouch');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.Soviet.tt33_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Pistols.TT33_S');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.tt33_ammo'); */
}

defaultproperties
{
     TouchMessage="Pick Up: Colt M1911 Pistol"
     MaxDesireability=0.100000
     InventoryType=class'DH_Weapons.DH_ColtM1911Weapon'
     PickupMessage="You got the Colt M1911."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.Colt45'
     PrePivot=(Z=3.000000)
     CollisionRadius=15.000000
     CollisionHeight=3.000000
}
