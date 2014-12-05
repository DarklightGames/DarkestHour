//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_30calPickup extends DHWeaponPickup
   notplaceable;

defaultproperties
{
    TouchMessage="Pick Up: M1919A4 Browning Machine Gun"
    MaxDesireability=0.400000
    InventoryType=class'DH_Weapons.DH_30calWeapon'
    PickupMessage="You got the M1919A4 Browning Machine Gun."
    PickupForce="AssaultRiflePickup"
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.30Cal'
    PrePivot=(Z=3.000000)
    CollisionRadius=25.000000
    CollisionHeight=3.000000
}
