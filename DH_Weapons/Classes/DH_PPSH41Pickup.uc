//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PPSh41Pickup extends DHWeaponPickup
   notplaceable;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.ppsh41');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.ppshpouch');
    L.AddPrecacheMaterial(material'Weapons3rd_tex.Soviet.ppsh41_world');
    L.AddPrecacheMaterial(material'Weapons1st_tex.SMG.PPSH41_S');
    L.AddPrecacheMaterial(material'InterfaceArt_tex.HUD.ppsh_ammo');
}

defaultproperties
{
    MaxDesireability=0.9
    InventoryType=class'DH_Weapons.DH_PPSH41Weapon'
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.ppsh41'
    PrePivot=(Z=3.0)
    CollisionRadius=25.0
    CollisionHeight=3.0
}
