//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_M1GrenadePickup extends DHOneShotWeaponPickup
   notplaceable;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_M1GrenadeWeapon'
    PickupSound=sound'Inf_Weapons_Foley.Misc.ammopickup'
    StaticMesh=StaticMesh'DH_WeaponPickups.Weapons.M1_Grenade'
    PrePivot=(Z=3.000000)
    CollisionRadius=15.000000
    CollisionHeight=3.000000
}
