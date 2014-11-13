//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_MP40Pickup extends DHWeaponPickup
   notplaceable;

//=============================================================================
// Functions
//=============================================================================

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.mp40');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.mp40pouch');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.mp40_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.SMG.MP40_S');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.mg40_ammo');
}

defaultproperties
{
     TouchMessage="Pick Up: Maschinenpistole 40"
     MaxDesireability=0.780000
     InventoryType=class'DH_Weapons.DH_MP40Weapon'
     PickupMessage="You got the Maschinenpistole 40."
     PickupForce="AssaultRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponPickupSM.Weapons.mp40'
     PrePivot=(Z=3.000000)
     CollisionRadius=25.000000
     CollisionHeight=3.000000
}
