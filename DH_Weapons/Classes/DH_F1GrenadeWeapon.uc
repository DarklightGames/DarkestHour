//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_F1GrenadeWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="F1 Grenade"
    NativeItemName="F1 Granata"
    FireModeClass(0)=Class'DH_F1GrenadeFire'
    FireModeClass(1)=Class'DH_F1GrenadeTossFire'
    AttachmentClass=Class'DH_F1GrenadeAttachment'
    PickupClass=Class'DH_F1GrenadePickup'

    Mesh=SkeletalMesh'Allies_F1nade_1st.F1-Grenade-Mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.f1grenade_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    FuzeLengthRange=(Min=4.0,Max=4.0)
    bHasReleaseLever=true
    LeverReleaseSound=Sound'Inf_Weapons_Foley.f1_handle'
    LeverReleaseVolume=1.0
    LeverReleaseRadius=200.0
    DisplayFOV=80.0

    GroupOffset=0
}
