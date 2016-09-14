//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RDG1GrenadePickup extends DHOneShotWeaponPickup
   notplaceable;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Projectile.rgd1');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Projectile.rgd1_throw');
    L.AddPrecacheMaterial(material'Weapons3rd_tex.RDG1_world');
    L.AddPrecacheMaterial(material'Weapons1st_tex.Grenades.RDG_1'); // replaceme
    L.AddPrecacheMaterial(material'InterfaceArt_tex.HUD.RDG1_ammo');
}

defaultproperties
{
    MaxDesireability=0.78
    InventoryType=class'DH_Weapons.DH_RDG1GrenadeWeapon'
    PickupSound=sound'Inf_Weapons_Foley.Misc.ammopickup'
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'WeaponPickupSM.Projectile.RGD1'
    PrePivot=(Z=3.0)
    CollisionRadius=15.0
    CollisionHeight=3.0
}
