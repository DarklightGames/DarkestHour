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
    TouchMessage="Pick Up: Russian RPG-43 Anti-Tank Grenade"
    MaxDesireability=0.80000
    InventoryType=class'DH_Weapons.DH_RPG43GrenadeWeapon'
    PickupMessage="You got the Russian RPG-43 Anti-Tank Grenade."
    PickupSound=Sound'Inf_Weapons_Foley.Misc.ammopickup'
    PickupForce="AssaultRiflePickup"
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.RPG43'
    PrePivot=(Z=3.000000)
    CollisionRadius=15.000000
    CollisionHeight=3.000000
}
