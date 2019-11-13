//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_PPD40Weapon extends DH_PPSh41Weapon;

defaultproperties
{
    ItemName="PPD-40"

    FireModeClass(0)=class'DH_Weapons.DH_PPD40Fire'
    FireModeClass(1)=class'DH_Weapons.DH_PPD40MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_PPD40Attachment'
    PickupClass=class'DH_Weapons.DH_PPD40Pickup'

    Mesh=SkeletalMesh'DH_Ppd40_1st.PPD-40-Meshnew'
    HighDetailOverlay=shader'Weapons1st_tex.SMG.PPD40_1_S'

    IronSightDisplayFOV=50.0
}
