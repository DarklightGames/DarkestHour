//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_MN9130Weapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Mosin M91/30"
    SwayModifyFactor=0.63 // +0.03
    SwayBayonetModifier=1.28
    FireModeClass(0)=class'DH_Weapons.DH_MN9130Fire'
    FireModeClass(1)=class'DH_Weapons.DH_MN9130MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_MN9130Attachment'
    PickupClass=class'DH_Weapons.DH_MN9130Pickup'

    Mesh=SkeletalMesh'DH_Nagant_1st.Mosin-Nagant-9130-mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.Rifles.MN9130_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=47.0
    DisplayFOV=85.0
    ZoomOutTime=0.35

    MaxNumPrimaryMags=10
    InitialNumPrimaryMags=10

    bHasBayonet=true
    BayonetBoneName="bayonet"
    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"

    PreReloadAnim="single_open"
    FullReloadAnim="reload"
    SingleReloadAnim="single_insert"
    PostReloadAnim="single_close"
}
