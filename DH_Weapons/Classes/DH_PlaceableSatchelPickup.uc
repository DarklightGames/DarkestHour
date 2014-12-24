//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PlaceableSatchelPickup extends DH_PlaceableWeaponPickup;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Projectile.satchel');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Projectile.satchel_throw');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.satchel_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Grenades.SatchelCharge');
}

defaultproperties
{
    WeaponType=class'DH_Weapons.DH_SatchelCharge10lb10sWeapon'
    InventoryType=class'DH_Weapons.DH_SachelChargeAmmo'
    StaticMesh=StaticMesh'WeaponPickupSM.Projectile.satchel'
}
