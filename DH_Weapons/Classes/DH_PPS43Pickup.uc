//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PPS43Pickup extends DHWeaponPickup
   notplaceable;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.pps43');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.pps43pouch');
    L.AddPrecacheMaterial(material'Weapons3rd_tex.Soviet.pps43_world');
    L.AddPrecacheMaterial(material'Weapons1st_tex.SMG.pps43_s');
    L.AddPrecacheMaterial(material'InterfaceArt_tex.HUD.pps43_ammo');
}

defaultproperties
{
    MaxDesireability=0.9
    InventoryType=class'DH_Weapons.DH_PPS43Weapon'
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.pps43'
    PrePivot=(Z=3.0)
    CollisionRadius=25.0
    CollisionHeight=3.0
}
