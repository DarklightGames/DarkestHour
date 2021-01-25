//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_SVT38Weapon extends DHSemiAutoWeapon;

defaultproperties
{
    ItemName="SVT-38"
    //SwayModifyFactor=0.8 //heavier than SVT-40
    SwayBayonetModifier=1.26
    FireModeClass(0)=class'DH_Weapons.DH_SVT38Fire'
    FireModeClass(1)=class'DH_Weapons.DH_SVT38MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_SVT38Attachment'
    PickupClass=class'DH_Weapons.DH_SVT38Pickup'

    Mesh=SkeletalMesh'DH_Svt40_1st.svt38_1st'
    HighDetailOverlay=shader'Weapons1st_tex.Rifles.SVT40_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=32.0
    DisplayFOV=85.0

    MaxNumPrimaryMags=6
    InitialNumPrimaryMags=6 //lower than on SVT-40, mostly because i dont want this weapon to appear superior - realistically it has lower recoil, but there is no way to represent unreliability issues (yet)

    bHasBayonet=true
    BayonetBoneName="bayonet"
    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"
}
