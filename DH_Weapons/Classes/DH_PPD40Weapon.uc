//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_PPD40Weapon extends DH_PPSh41Weapon;

defaultproperties
{
    ItemName="PPD-40"

    FireModeClass(0)=class'DH_Weapons.DH_PPD40Fire'
    FireModeClass(1)=class'DH_Weapons.DH_PPD40MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_PPD40Attachment'
    PickupClass=class'DH_Weapons.DH_PPD40Pickup'

    Mesh=SkeletalMesh'DH_Ppd40_1st.PPD-40-1st'
    HighDetailOverlay=shader'Weapons1st_tex.SMG.PPD40_1_S'

    IronSightDisplayFOV=60.0
    DisplayFOV=85.0
}
