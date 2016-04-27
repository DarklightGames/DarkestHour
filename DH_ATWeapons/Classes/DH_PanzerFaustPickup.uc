//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PanzerFaustPickup extends DHOneShotWeaponPickup
    notplaceable;

defaultproperties
{
    InventoryType=class'DH_ATWeapons.DH_PanzerFaustWeapon'
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.Panzerfaust'
    PickupSound=Sound'Inf_Weapons_Foley.WeaponPickup'
    CollisionRadius=25.0
}
