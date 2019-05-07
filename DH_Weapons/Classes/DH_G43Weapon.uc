//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_G43Weapon extends DHSemiAutoWeapon;

defaultproperties
{
    ItemName="Gewehr 43"
    FireModeClass(0)=class'DH_Weapons.DH_G43Fire'
    FireModeClass(1)=class'DH_Weapons.DH_G43MeleeFire'
    PickupClass=class'DH_Weapons.DH_G43Pickup'
    AttachmentClass=class'DH_Weapons.DH_G43Attachment'

    Mesh=SkeletalMesh'DH_G43_1st.G-43-Mesh'
    HighDetailOverlay=shader'Weapons1st_tex.Rifles.G43_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=21.0

    MaxNumPrimaryMags=10
    InitialNumPrimaryMags=10
}
