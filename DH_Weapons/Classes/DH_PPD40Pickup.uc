//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PPD40Pickup extends DHWeaponPickup
   notplaceable;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.ppd40');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.ppshpouch');
    L.AddPrecacheMaterial(material'Weapons3rd_tex.Soviet.ppd40_world');
    L.AddPrecacheMaterial(material'Weapons1st_tex.SMG.PPD40_1_S');
    L.AddPrecacheMaterial(material'InterfaceArt_tex.HUD.ppsh_ammo');
}

defaultproperties
{
    MaxDesireability=0.9
    InventoryType=class'DH_Weapons.DH_PPD40Weapon'
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.ppd40'
    PrePivot=(Z=3.0)
    CollisionRadius=25.0
    CollisionHeight=3.0
}
