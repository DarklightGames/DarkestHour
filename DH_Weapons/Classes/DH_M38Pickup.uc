//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M38Pickup extends DHWeaponPickup
   notplaceable;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.Nagant9138');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.nagantpouch');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.Soviet.Nagant9138_world');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.Soviet.nagantstripper_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Rifles.MN9138_s');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Rifles.NagantForearm_S');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Bullets.mn_stripper_s');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.nagant_ammo');
}

defaultproperties
{
    TouchMessage="Pick Up: M38"
    MaxDesireability=0.400000
    InventoryType=Class'DH_Weapons.DH_M38Weapon'
    PickupMessage="You got the M38."
    PickupForce="AssaultRiflePickup"
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.nagant9138'
    PrePivot=(Z=3.000000)
    CollisionRadius=25.000000
    CollisionHeight=3.000000
}
