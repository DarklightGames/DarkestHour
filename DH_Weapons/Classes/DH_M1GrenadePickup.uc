//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_M1GrenadePickup extends ROOneShotWeaponPickup
   notplaceable;

defaultproperties
{
    TouchMessage="Pick Up: Mk II Grenade"
    MaxDesireability=0.780000
    InventoryType=class'DH_Weapons.DH_M1GrenadeWeapon'
    PickupMessage="You got the Mk II Grenade."
    PickupSound=sound'Inf_Weapons_Foley.Misc.ammopickup'
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.M1_Grenade'
    PrePivot=(Z=3.000000)
    CollisionRadius=15.000000
    CollisionHeight=3.000000
}
