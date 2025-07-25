//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_StielGranateWeapon extends DHExplosiveWeapon;

defaultproperties
{
    ItemName="StG 24 Grenade"
    NativeItemName="Stielhandgranate 24"
    FireModeClass(0)=Class'DH_StielGranateFire'
    FireModeClass(1)=Class'DH_StielGranateTossFire'
    AttachmentClass=Class'DH_StielGranateAttachment'
    PickupClass=Class'DH_StielGranatePickup'

    DisplayFOV=80.0
    Mesh=SkeletalMesh'Axis_Granate_1st.German-Grenade-Mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.stiel_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    GroupOffset=3
}
