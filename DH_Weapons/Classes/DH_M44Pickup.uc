//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M44Pickup extends DHWeaponPickup
   notplaceable;

//-----------------------------------------------------------------------------
// StaticPrecache
//-----------------------------------------------------------------------------

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.M44');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.nagantpouch');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.Soviet.Nagant9138_world');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.Soviet.nagant9130bay_world');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.Soviet.nagantstripper_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Rifles.MN9138_s');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Rifles.NagantForearm_S');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Bullets.mn_stripper_s');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Rifles.m44stuff');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.nagant_ammo');
}

defaultproperties
{
     TouchMessage="Pick Up: M44"
     MaxDesireability=0.400000
     InventoryType=Class'DH_Weapons.DH_M44Weapon'
     PickupMessage="You got the M44."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponPickupSM.Weapons.M44'
     PrePivot=(Z=3.000000)
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
