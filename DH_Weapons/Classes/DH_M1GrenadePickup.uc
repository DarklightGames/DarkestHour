//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_M1GrenadePickup extends ROOneShotWeaponPickup
   notplaceable;

//=============================================================================
// Functions
//=============================================================================

static function StaticPrecache(LevelInfo L)
{
/*  L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Projectile.F1Grenade');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Projectile.F1Grenade-throw');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.Soviet.f1grenade_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Grenades.F1grenade_S');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.F1nade_ammo'); */
}

defaultproperties
{
     TouchMessage="Pick Up: Mk II Grenade"
     MaxDesireability=0.780000
     InventoryType=Class'DH_Weapons.DH_M1GrenadeWeapon'
     PickupMessage="You got the Mk II Grenade."
     PickupSound=Sound'Inf_Weapons_Foley.Misc.ammopickup'
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.M1_Grenade'
     PrePivot=(Z=3.000000)
     CollisionRadius=15.000000
     CollisionHeight=3.000000
}
