//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_MP41Pickup extends DH_MP40Pickup
   notplaceable;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.mp41');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.mp40pouch');
    L.AddPrecacheMaterial(material'Weapons3rd_tex.German.mp41_world');
    L.AddPrecacheMaterial(material'Weapons1st_tex.SMG.MP41_S');
    L.AddPrecacheMaterial(material'InterfaceArt_tex.HUD.mg40_ammo');
}

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_MP41Weapon'
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.mp41'
}
