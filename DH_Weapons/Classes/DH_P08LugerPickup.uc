//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_P08LugerPickup extends DHWeaponPickup
   notplaceable;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.luger');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.pistolpouch');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.luger_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Pistols.luger_s');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.luger_ammo');
}

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_P08LugerWeapon'
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.luger'
    PrePivot=(Z=3.0)
    CollisionRadius=15.0
    CollisionHeight=3.0
}
