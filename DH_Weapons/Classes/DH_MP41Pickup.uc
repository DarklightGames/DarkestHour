//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_MP41Pickup extends DH_MP40Pickup
   notplaceable;

//=============================================================================
// Functions
//=============================================================================

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.mp41');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.mp40pouch');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.German.mp41_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.SMG.MP41_S');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.mg40_ammo');
}

defaultproperties
{
     TouchMessage="Pick Up: MP41 smg"
     InventoryType=Class'DH_Weapons.DH_MP41Weapon'
     PickupMessage="You got the MP41 smg."
     StaticMesh=StaticMesh'WeaponPickupSM.Weapons.mp41'
}
