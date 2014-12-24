//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PlaceablePanzerFaustPickup extends DH_PlaceableWeaponPickup;


static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.Panzerfaust');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Ammo.Warhead3rd');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Ammo.Warhead1st');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.Panzerfaust_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Grenades.Panzerfaust_S');
}

defaultproperties
{
    WeaponType=class'DH_ATWeapons.DH_PanzerFaustWeapon'
    InventoryType=class'DH_ATWeapons.DH_PanzerFaustWeapon'
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.PanzerFaust'
}
