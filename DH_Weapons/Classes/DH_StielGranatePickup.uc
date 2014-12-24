//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_StielGranatePickup extends DHOneShotWeaponPickup;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Projectile.Stielhandgranate');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Projectile.Stielhandgranate_throw');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.Stielhandgranate');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Grenades.Stiel_S');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.sticknade_ammo');
}

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_StielGranateWeapon'
    StaticMesh=StaticMesh'WeaponPickupSM.Projectile.Stielhandgranate'
}
