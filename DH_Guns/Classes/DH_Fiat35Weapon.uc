//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// TODO: separate the WC and AC into separate constructions since we don't
// want to be able to arbitrarily change variants after it's placed.
//==============================================================================

class DH_Fiat35Weapon extends DHMountedWeapon;

defaultproperties
{
    ConstructionClasses(0)=Class'DH_Fiat35GunConstruction'
    AttachmentClass=Class'DH_Fiat35Attachment'
    PickupClass=Class'DH_Fiat35Pickup'
    Mesh=SkeletalMesh'DH_M2Mortar_anm.M2MORTAR_WEAPON'
}
