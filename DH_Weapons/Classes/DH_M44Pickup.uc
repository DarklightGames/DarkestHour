//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M44Pickup extends DHWeaponPickup
   notplaceable;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.M44');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.nagantpouch');
    L.AddPrecacheMaterial(material'Weapons3rd_tex.Soviet.Nagant9138_world');
    L.AddPrecacheMaterial(material'Weapons3rd_tex.Soviet.nagant9130bay_world');
    L.AddPrecacheMaterial(material'Weapons3rd_tex.Soviet.nagantstripper_world');
    L.AddPrecacheMaterial(material'Weapons1st_tex.Rifles.MN9138_s');
    L.AddPrecacheMaterial(material'Weapons1st_tex.Rifles.NagantForearm_S');
    L.AddPrecacheMaterial(material'Weapons1st_tex.Bullets.mn_stripper_s');
    L.AddPrecacheMaterial(material'Weapons1st_tex.Rifles.m44stuff');
    L.AddPrecacheMaterial(material'InterfaceArt_tex.HUD.nagant_ammo');
}

defaultproperties
{
    MaxDesireability=0.4
    InventoryType=class'DH_Weapons.DH_M44Weapon'
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.M44'
    PrePivot=(Z=3.0)
    CollisionRadius=25.0
    CollisionHeight=3.0
}
