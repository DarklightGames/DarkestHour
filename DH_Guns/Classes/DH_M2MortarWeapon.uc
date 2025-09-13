//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M2MortarWeapon extends DHStationaryWeapon;

defaultproperties
{
    VehicleClass=Class'DH_M2Mortar'
    AttachmentClass=Class'DH_M2MortarAttachment'
    PickupClass=Class'DH_M2MortarPickup'
    Mesh=SkeletalMesh'DH_M2Mortar_anm.M2MORTAR_WEAPON'
    DisplayFOV=90.0
    FreeAimRotationSpeed=2.0
    bUsesFreeAim=true
    HudAmmoIconMaterial=Texture'DH_M2Mortar_tex.M2MORTAR_AMMO_ICON'
    bShouldAlignToGround=false
}
