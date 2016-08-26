//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_MN9130Pickup extends DHWeaponPickup
   notplaceable;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.Nagant9130');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.nagantpouch');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.Soviet.Nagant9130_world');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.Soviet.nagantstripper_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Rifles.MN9130_S');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Rifles.NagantForearm_S');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Bullets.mn_stripper_s');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Bayonet.MNBayonet_s');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.nagant_ammo');
}

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_MN9130Weapon'
    PickupMessage="You got the MN 91/30."
    TouchMessage="Pick Up: MN 91/30"
    PickupForce="AssaultRiflePickup"
    MaxDesireability=+0.4
    StaticMesh=StaticMesh'WeaponPickupSM.nagant9130'
    DrawType=DT_StaticMesh
    DrawScale=1.0
    CollisionRadius=25.0
    CollisionHeight=3.0
    PrePivot=(X=0.0,Y=0.0,Z=3.0)
}
