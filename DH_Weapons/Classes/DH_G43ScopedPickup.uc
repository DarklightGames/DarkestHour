//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_G43ScopedPickup extends DHWeaponPickup
   notplaceable;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.g43scope');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.g43pouch');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.g43_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Rifles.g43_sniper_s');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Bullets.kar98k_stripper_s');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.SniperScopes.g43_scope_s');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.G43_ammo');
    //L.AddPrecacheMaterial(Material'DH_Weapon_tex.AxisSmallArms.Ger_sniperscope_overlay');
}

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_G43ScopedWeapon'
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.g43scope'
    PrePivot=(Z=3.0)
    CollisionRadius=25.0
    CollisionHeight=3.0
}
