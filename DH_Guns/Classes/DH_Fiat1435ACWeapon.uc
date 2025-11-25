//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// TODO: separate the WC and AC into separate constructions since we don't
// want to be able to arbitrarily change variants after it's placed.
//==============================================================================

class DH_Fiat1435ACWeapon extends DHMountedWeapon;

defaultproperties
{
    ConstructionClass=Class'DH_Fiat1435GunConstruction'
    AttachmentClass=Class'DH_Fiat1435ACAttachment'
    PickupClass=Class'DH_Fiat1435ACPickup'
    Mesh=SkeletalMesh'DH_M2Mortar_anm.M2MORTAR_WEAPON'
}
