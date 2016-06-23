//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_TT33Pickup extends DHWeaponPickup
   notplaceable;

// This needed?
static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.tt33');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.tt33pouch');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.Soviet.tt33_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Pistols.TT33_S');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.tt33_ammo');
}

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_TT33Weapon'
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.tt33'
    PrePivot=(X=0.0,Y=0.0,Z=3.0)
    CollisionRadius=15.0
    CollisionHeight=3.0
}
