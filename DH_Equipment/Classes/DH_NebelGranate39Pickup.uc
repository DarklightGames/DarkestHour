//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_NebelGranate39Pickup extends ROOneShotWeaponPickup
   notplaceable;

//=============================================================================
// Functions
//=============================================================================

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Projectile.gersmokenade');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Projectile.gersmokenade_throw');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.gersmokenade_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Grenades.StielGranate_smokenade'); // replaceme
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.gersmokenade_ammo');
}

defaultproperties
{
     TouchMessage="Pick Up: Nebelhandgranate 39"
     MaxDesireability=0.780000
     InventoryType=class'DH_Equipment.DH_NebelGranate39Weapon'
     PickupMessage="You got the Nebelhandgranate 39."
     PickupSound=Sound'Inf_Weapons_Foley.Misc.ammopickup'
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponPickupSM.Projectile.gersmokenade'
     PrePivot=(Z=3.000000)
     AmbientGlow=0
     CollisionRadius=15.000000
     CollisionHeight=3.000000
}
