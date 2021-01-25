//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_SVT40Weapon extends DHSemiAutoWeapon;

defaultproperties
{
    ItemName="SVT-40"
    SwayModifyFactor=0.72 // -0.08 
    FireModeClass(0)=class'DH_Weapons.DH_SVT40Fire'
    FireModeClass(1)=class'DH_Weapons.DH_SVT40MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_SVT40Attachment'
    PickupClass=class'DH_Weapons.DH_SVT40Pickup'

    Mesh=SkeletalMesh'DH_Svt40_1st.svt40_1st'
    HighDetailOverlay=shader'Weapons1st_tex.Rifles.SVT40_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=32.0
	DisplayFOV=85.0

    MaxNumPrimaryMags=8
    InitialNumPrimaryMags=8

    bHasBayonet=true
    BayonetBoneName="bayonet"
    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"
}
