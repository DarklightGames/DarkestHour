//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_MP40Pickup extends DHWeaponPickup
   notplaceable;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.mp40');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.mp40pouch');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.mp40_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.SMG.MP40_S');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.mg40_ammo');
}

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_MP40Weapon'
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.mp40'
    PrePivot=(Z=3.0)
    CollisionRadius=25.0
    CollisionHeight=3.0
}
