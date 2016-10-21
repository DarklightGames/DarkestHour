//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PPSh41Weapon extends DHFastAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\Allies_Ppsh_1st.ukx

defaultproperties
{
    ItemName="PPSh-41"
    FireModeClass(0)=class'DH_Weapons.DH_PPSH41Fire'
    FireModeClass(1)=class'DH_Weapons.DH_PPSH41MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_PPSH41Attachment'
    PickupClass=class'DH_Weapons.DH_PPSH41Pickup'

    Mesh=SkeletalMesh'Allies_Ppsh_1st.PPSH-41-mesh'
    HighDetailOverlay=shader'Weapons1st_tex.SMG.PPSH41_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=30.0

    MaxNumPrimaryMags=3
    InitialNumPrimaryMags=3
}
