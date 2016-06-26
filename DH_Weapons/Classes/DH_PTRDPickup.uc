//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PTRDPickup extends DHWeaponPickup
   notplaceable;

#exec OBJ LOAD FILE=InterfaceArt_tex.utx

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.ptrd');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.ptrdpouch');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.Soviet.ptrd_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.Rifles.PTRD_S');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.PTRD_ammo');
}

defaultproperties
{
    TouchMessage="Pick Up: PTRD AT Rifle"
    MaxDesireability=0.400000
    InventoryType=Class'DH_Weapons.DH_PTRDWeapon'
    PickupMessage="You got the PTRD."
    PickupForce="AssaultRiflePickup"
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.PTRD'
    PrePivot=(Z=3.000000)
    CollisionRadius=25.000000
    CollisionHeight=3.000000
}
