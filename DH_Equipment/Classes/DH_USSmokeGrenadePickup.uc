//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USSmokeGrenadePickup extends ROOneShotWeaponPickup
   notplaceable;

defaultproperties
{
    TouchMessage="Pick Up: US M15 Smoke Grenade"
    MaxDesireability=0.780000
    InventoryType=class'DH_Equipment.DH_USSmokeGrenadeWeapon'
    PickupMessage="You got the US M15 Smoke Grenade."
    PickupSound=sound'Inf_Weapons_Foley.Misc.ammopickup'
    PickupForce="AssaultRiflePickup"
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.USSmokeGrenade'
    PrePivot=(Z=3.000000)
    CollisionRadius=15.000000
    CollisionHeight=3.000000
}
