//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PanzerFaustPickup extends DHOneShotWeaponPickup;

defaultproperties
{
    InventoryType=Class'DH_PanzerFaustWeapon'
    StaticMesh=StaticMesh'WeaponPickupSM.Panzerfaust'
    PickupSound=Sound'Inf_Weapons_Foley.WeaponPickup'
    CollisionRadius=25.0 // as is larger than other 'one shot' pickups that are ammo (this reverts to radius for a weapon)
}
