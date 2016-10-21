//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PanzerFaustPickup extends DHOneShotWeaponPickup;

defaultproperties
{
    InventoryType=class'DH_Weapons.DH_PanzerFaustWeapon'
    StaticMesh=StaticMesh'WeaponPickupSM.Weapons.Panzerfaust'
    PickupSound=sound'Inf_Weapons_Foley.WeaponPickup'
    CollisionRadius=25.0 // as is larger than other 'one shot' pickups that are ammo (this reverts to radius for a weapon)
}
