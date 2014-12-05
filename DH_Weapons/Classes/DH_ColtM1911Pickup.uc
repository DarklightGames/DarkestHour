//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ColtM1911Pickup extends DHWeaponPickup
   notplaceable;

defaultproperties
{
    TouchMessage="Pick Up: Colt M1911 Pistol"
    MaxDesireability=0.100000
    InventoryType=class'DH_Weapons.DH_ColtM1911Weapon'
    PickupMessage="You got the Colt M1911."
    PickupForce="AssaultRiflePickup"
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.Colt45'
    PrePivot=(Z=3.000000)
    CollisionRadius=15.000000
    CollisionHeight=3.000000
}
