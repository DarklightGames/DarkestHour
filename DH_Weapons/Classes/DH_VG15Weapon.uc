//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_VG15Weapon extends DHProjectileWeapon;

defaultproperties
{
    ItemName="VG 1-5"
    NativeItemName="Volkssturmgewehr 1-5"
    FireModeClass(0)=Class'DH_VG15Fire'
    FireModeClass(1)=Class'DH_VG15MeleeFire'
    PickupClass=Class'DH_VG15Pickup'
    AttachmentClass=Class'DH_VG15Attachment'

    Mesh=SkeletalMesh'DH_G43_1st.VG15_1st'
    bUseHighDetailOverlayIndex=false
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=40.0
    DisplayFOV=90.0

    MaxNumPrimaryMags=5
    InitialNumPrimaryMags=5

    MagEmptyReloadAnims(0)="reload_empty_vg"
    MagPartialReloadAnims(0)="reload_half_vg"
    MuzzleBone="MuzzleNew"

    bPlusOneLoading=true
    FreeAimRotationSpeed=6.0
}
