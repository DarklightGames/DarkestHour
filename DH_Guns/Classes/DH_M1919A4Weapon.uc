//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M1919A4Weapon extends DHMountedWeapon;

defaultproperties
{
    ConstructionClasses(0)=Class'DH_M1919A4GunConstruction'
    ConstructionClasses(1)=Class'DH_M1919A4_M1917_Gun'
    AttachmentClass=Class'DH_M1919A4Attachment'
    PickupClass=Class'DH_M1919A4Pickup'
    Mesh=SkeletalMesh'DH_M2Mortar_anm.M2MORTAR_WEAPON'
}
