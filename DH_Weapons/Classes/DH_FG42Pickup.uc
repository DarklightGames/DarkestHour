//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_FG42Pickup extends DHWeaponPickup
   notplaceable;

//=============================================================================
// Functions
//=============================================================================

static function StaticPrecache(LevelInfo L)
{
/*  L.AddPrecacheStaticMesh(StaticMesh'DH_WeaponPickups.Weapons.BAR');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.stg44pouch');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.stg44_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.SMG.STG44_S');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.stg44_ammo'); */
}

defaultproperties
{
     TouchMessage="Pick Up: Fallschirmjägergewehr 42"
     MaxDesireability=0.900000
     InventoryType=Class'DH_Weapons.DH_FG42Weapon'
     PickupMessage="You got the Fallschirmjägergewehr 42."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.FG42'
     DrawScale=1.100000
     PrePivot=(Z=3.000000)
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
