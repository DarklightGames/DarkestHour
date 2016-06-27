//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PPD40Pickup extends DHWeaponPickup
   notplaceable;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.ppd40');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.ppshpouch');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.Soviet.ppd40_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.SMG.PPD40_1_S');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.ppsh_ammo');
}

defaultproperties
{
    TouchMessage="Pick Up: PPD40 SMG"
    MaxDesireability=0.900000
    InventoryType=class'DH_Weapons.DH_PPD40Weapon'
    PickupMessage="You got the PPD40 SMG."
    PickupForce="AssaultRiflePickup"
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.ppd40'
    PrePivot=(Z=3.000000)
    CollisionRadius=25.000000
    CollisionHeight=3.000000
}
