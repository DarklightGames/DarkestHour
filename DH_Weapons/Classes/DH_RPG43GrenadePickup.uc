//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RPG43GrenadePickup extends DHOneShotWeaponPickup
   notplaceable;

#exec OBJ LOAD File=DH_WeaponPickups.usx

static function StaticPrecache(LevelInfo L)
{
    L.AddPrecacheStaticMesh(StaticMesh'DH_WeaponPickups.Weapons.RPG43');
    L.AddPrecacheStaticMesh(StaticMesh'DH_WeaponPickups.Weapons.RPG43_Tossed');
}

defaultproperties
{
    MaxDesireability=0.8
    InventoryType=class'DH_Weapons.DH_RPG43GrenadeWeapon'
    PickupSound=sound'Inf_Weapons_Foley.Misc.ammopickup'
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.RPG43'
    PrePivot=(Z=3.0)
    CollisionRadius=15.0
    CollisionHeight=3.0
}
