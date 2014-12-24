//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_PanzerFaustPickup extends DHOneShotWeaponPickup; // Matt: originally extended PanzerFaustPickup

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.Panzerfaust');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Ammo.Warhead3rd');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Ammo.Warhead1st');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.Panzerfaust_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Grenades.Panzerfaust_S');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.panzerfaust_ammo');
}

defaultproperties
{
    InventoryType=class'DH_ATWeapons.DH_PanzerFaustWeapon'
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.Panzerfaust'
    PickupSound=Sound'Inf_Weapons_Foley.WeaponPickup'
    CollisionRadius=25.0
}
