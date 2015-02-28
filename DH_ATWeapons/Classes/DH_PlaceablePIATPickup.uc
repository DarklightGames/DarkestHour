//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

// Matt: renamed class from DH_PIAT_Pickup (could not find any maps, including custom ones, that have used this actor, so should not break anything)
class DH_PlaceablePIATPickup extends DH_PlaceableWeaponPickup;

#exec OBJ LOAD FILE=..\StaticMeshes\DH_WeaponPickups.usx

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'DH_WeaponPickups.Weapons.PIAT');
    L.AddPrecacheMaterial(Material'DH_Weapon_tex.AlliedSmallArms_3rdP.Piat_3rdP');
}

defaultproperties
{
    WeaponType=class'DH_ATWeapons.DH_PIATWeapon'
    InventoryType=class'DH_ATWeapons.DH_PIATAmmo'
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.PIAT'
}
