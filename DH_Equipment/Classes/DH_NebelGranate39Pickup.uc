//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_NebelGranate39Pickup extends DHOneShotWeaponPickup
   notplaceable;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Projectile.gersmokenade');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Projectile.gersmokenade_throw');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.gersmokenade_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Grenades.StielGranate_smokenade'); // replaceme
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.gersmokenade_ammo');
}

defaultproperties
{
    InventoryType=class'DH_Equipment.DH_NebelGranate39Weapon'
    PickupSound=sound'Inf_Weapons_Foley.Misc.ammopickup'
    StaticMesh=StaticMesh'WeaponPickupSM.Projectile.gersmokenade'
    PrePivot=(Z=3.000000)
    CollisionRadius=15.000000
    CollisionHeight=3.000000
}
