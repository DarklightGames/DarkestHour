//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_VG15Weapon extends DHProjectileWeapon;

defaultproperties
{
    ItemName="Volkssturmgewehr 1-5"
    FireModeClass(0)=class'DH_Weapons.DH_VG15Fire'
    FireModeClass(1)=class'DH_Weapons.DH_VG15MeleeFire'
    PickupClass=class'DH_Weapons.DH_VG15Pickup'
    AttachmentClass=class'DH_Weapons.DH_VG15Attachment'

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
