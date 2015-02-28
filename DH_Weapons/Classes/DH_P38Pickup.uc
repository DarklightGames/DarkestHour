//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_P38Pickup extends DHWeaponPickup
   notplaceable;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.p38');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.pistolpouch');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.p38_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Pistols.p38_S');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.p38_ammo');
}

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_P38Weapon'
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.p38'
    PrePivot=(Z=3.0)
    CollisionRadius=15.0
    CollisionHeight=3.0
}
