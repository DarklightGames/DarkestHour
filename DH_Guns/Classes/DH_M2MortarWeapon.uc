//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M2MortarWeapon extends DHStationaryWeapon;

defaultproperties
{
    VehicleClass=class'DH_M2Mortar'
    AttachmentClass=class'DH_M2MortarAttachment'
    PickupClass=class'DH_M2MortarPickup'
    Mesh=SkeletalMesh'DH_M2Mortar_anm.M2MORTAR_WEAPON'
    DisplayFOV=90.0
    FreeAimRotationSpeed=2.0
    bUsesFreeAim=true
    HudAmmoIconMaterial=Texture'DH_M2Mortar_tex.M2MORTAR_AMMO_ICON'
}
