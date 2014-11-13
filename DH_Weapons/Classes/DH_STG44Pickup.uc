//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_STG44Pickup extends DHWeaponPickup
   notplaceable;

//=============================================================================
// Functions
//=============================================================================

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.stg44');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.stg44pouch');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.stg44_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.SMG.STG44_S');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.stg44_ammo');
}

defaultproperties
{
     TouchMessage="Pick Up: STG44"
     MaxDesireability=0.900000
     InventoryType=class'DH_Weapons.DH_STG44Weapon'
     PickupMessage="You got the STG44."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponPickupSM.Weapons.stg44'
     PrePivot=(Z=3.000000)
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
