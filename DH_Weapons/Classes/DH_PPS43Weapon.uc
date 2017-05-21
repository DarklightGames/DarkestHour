//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_PPS43Weapon extends DHFastAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\Allies_Pps43_1st.ukx

defaultproperties
{
    ItemName="PPS-43"
    FireModeClass(0)=class'DH_Weapons.DH_PPS43Fire'
    FireModeClass(1)=class'DH_Weapons.DH_PPS43MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_PPS43Attachment'
    PickupClass=class'DH_Weapons.DH_PPS43Pickup'

    Mesh=SkeletalMesh'Allies_Pps43_1st.PPS-43-Mesh'
    HighDetailOverlay=shader'Weapons1st_tex.SMG.PPS43_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=35.0

    MaxNumPrimaryMags=8
    InitialNumPrimaryMags=8
}
