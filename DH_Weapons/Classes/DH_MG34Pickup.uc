//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_MG34Pickup extends DHWeaponPickup
   notplaceable;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Arms.hands_gergloves');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.mg34');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Ammo.mg34magazine');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.MG34_World');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.MG.MG42_S');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.MG.MGbipod_S');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.MG.MGBelt_S');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.MG34_ammo');
}

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_MG34Weapon'
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.mg34'
    PrePivot=(Z=3.0)
    CollisionRadius=25.0
    CollisionHeight=3.0
}
