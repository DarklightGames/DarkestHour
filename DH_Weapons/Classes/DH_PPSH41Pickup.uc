//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PPSh41Pickup extends DHWeaponPickup
   notplaceable;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.ppsh41');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.ppshpouch');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.Soviet.ppsh41_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.SMG.PPSH41_S');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.ppsh_ammo');
}

defaultproperties
{
    TouchMessage="Pick Up: PPSh41 SMG"
    MaxDesireability=0.900000
    InventoryType=Class'DH_Weapons.DH_PPSH41Weapon'
    PickupMessage="You got the PPSh41 SMG."
    PickupForce="AssaultRiflePickup"
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.ppsh41'
    PrePivot=(Z=3.000000)
    CollisionRadius=25.000000
    CollisionHeight=3.000000
}
