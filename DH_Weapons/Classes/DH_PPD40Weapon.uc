//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_PPD40Weapon extends DHFastAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\Allies_Ppd40_1st.ukx

defaultproperties
{
    ItemName="PPD-40"
    FireModeClass(0)=class'DH_Weapons.DH_PPD40Fire'
    FireModeClass(1)=class'DH_Weapons.DH_PPD40MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_PPD40Attachment'
    PickupClass=class'DH_Weapons.DH_PPD40Pickup'

    Mesh=SkeletalMesh'Allies_Ppd40_1st.PPD-40-Mesh'

    IronSightDisplayFOV=35.0

    MaxNumPrimaryMags=3
    InitialNumPrimaryMags=3
}
