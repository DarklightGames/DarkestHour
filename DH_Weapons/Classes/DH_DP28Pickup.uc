//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_DP28Pickup extends DHWeaponPickup
   notplaceable;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.DP28');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.dp27pouch');
    L.AddPrecacheMaterial(Material'Gear_tex.equipment.rus_equipment');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.Soviet.DP28_World');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.MG.dp28_s');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.DP27_ammo');
}

defaultproperties
{
    MaxDesireability=0.400000
    InventoryType=class'DH_Weapons.DH_DP28Weapon'
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.DP28'
    PrePivot=(Z=3.000000)
    CollisionRadius=25.000000
    CollisionHeight=3.000000
}
