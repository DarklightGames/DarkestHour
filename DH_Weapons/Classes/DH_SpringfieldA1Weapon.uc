//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SpringfieldA1Weapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Springfield M1903A1"
    FireModeClass(0)=class'DH_Weapons.DH_SpringfieldA1Fire'
    FireModeClass(1)=class'DH_Weapons.DH_SpringfieldA1MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_SpringfieldA1Attachment'
    PickupClass=class'DH_Weapons.DH_SpringfieldA1Pickup'

    Mesh=SkeletalMesh'DH_Springfield_1st.Springfield_A1'
    Skins(0)=Texture'DH_Springfield_tex.Rifle.Springfield_tex'
    Skins(4)=Texture'DH_Weapon_tex.AlliedSmallArms.BARAmmo'
    HighDetailOverlay=Shader'DH_Springfield_tex.Rifle.Springfield_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=0
    sleevenum=1
    handnum=2

    IronSightDisplayFOV=45.0
    DisplayFOV=85.0

    MaxNumPrimaryMags=13
    InitialNumPrimaryMags=13

    bHasBayonet=true
    BayonetBoneName="bayonet"
    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"
    IronBringUpRest="iron_inrest"
    SingleReloadAnim="single_insert"
    SingleReloadHalfAnim="single_insert_half"
    PreReloadAnim="single_open"
    PreReloadHalfAnim="single_open_half"
    PostReloadAnim="single_close"
    FullReloadAnim="reload"
}

