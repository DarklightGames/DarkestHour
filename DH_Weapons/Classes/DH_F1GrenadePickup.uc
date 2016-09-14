//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_F1GrenadePickup extends DHOneShotWeaponPickup
   notplaceable;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Projectile.F1Grenade');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Projectile.F1Grenade-throw');
    L.AddPrecacheMaterial(material'Weapons3rd_tex.Soviet.f1grenade_world');
    L.AddPrecacheMaterial(material'Weapons1st_tex.Grenades.F1grenade_S');
    L.AddPrecacheMaterial(material'InterfaceArt_tex.HUD.F1nade_ammo');
}

defaultproperties
{
    MaxDesireability=0.78
    InventoryType=class'DH_Weapons.DH_F1GrenadeWeapon'
    PickupSound=sound'Inf_Weapons_Foley.Misc.ammopickup'
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'WeaponPickupSM.Projectile.F1Grenade'
    PrePivot=(Z=3.0)
    CollisionRadius=15.0
    CollisionHeight=3.0
}
