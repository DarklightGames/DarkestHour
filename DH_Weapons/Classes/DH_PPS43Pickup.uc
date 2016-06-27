//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PPS43Pickup extends DHWeaponPickup
   notplaceable;

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.Weapons.pps43');
    L.AddPrecacheStaticMesh(StaticMesh'WeaponPickupSM.pouches.pps43pouch');
    L.AddPrecacheMaterial(Material'Weapons3rd_tex.Soviet.pps43_world');
    L.AddPrecacheMaterial(Material'Weapons1st_tex.SMG.pps43_s');
    L.AddPrecacheMaterial(Material'InterfaceArt_tex.HUD.pps43_ammo');
}

defaultproperties
{
    TouchMessage="Pick Up: PPS43 SMG"
    MaxDesireability=0.900000
    InventoryType=class'DH_Weapons.DH_PPS43Weapon'
    PickupMessage="You got the PPS43 SMG."
    PickupForce="AssaultRiflePickup"
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.pps43'
    PrePivot=(Z=3.000000)
    CollisionRadius=25.000000
    CollisionHeight=3.000000
}
