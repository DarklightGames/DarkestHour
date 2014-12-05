//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BARPickup extends DHWeaponPickup
   notplaceable;

defaultproperties
{
    TouchMessage="Pick Up: M1918A2 Browning Automatic Rifle"
    MaxDesireability=0.900000
    InventoryType=class'DH_Weapons.DH_BARWeapon'
    PickupMessage="You got the M1918A2 Browning Automatic Rifle."
    PickupForce="AssaultRiflePickup"
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.BAR'
    PrePivot=(Z=3.000000)
    CollisionRadius=25.000000
    CollisionHeight=3.000000
}

