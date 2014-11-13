//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BrenPickup extends DHWeaponPickup
   notplaceable;

//=============================================================================
// Functions
//=============================================================================

static function StaticPrecache(LevelInfo L)
{
/*  L.AddPrecacheStaticMesh(StaticMesh'DH_WeaponPickups.Weapons.Bren');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.stg44pouch');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.stg44_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.SMG.STG44_S');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.stg44_ammo');*/
}

defaultproperties
{
     TouchMessage="Pick Up: Bren"
     MaxDesireability=0.900000
     InventoryType=Class'DH_Weapons.DH_BrenWeapon'
     PickupMessage="You got the Bren."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.Bren'
     PrePivot=(Z=3.000000)
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
