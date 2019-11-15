//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_MN9130Weapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Mosin-Nagant M91/30"
	SwayModifyFactor=6.5 // +0.5 
    SwayBayonetModifier=1.15
    FireModeClass(0)=class'DH_Weapons.DH_MN9130Fire'
    FireModeClass(1)=class'DH_Weapons.DH_MN9130MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_MN9130Attachment'
    PickupClass=class'DH_Weapons.DH_MN9130Pickup'

    Mesh=SkeletalMesh'DH_Nagant_1st.Mosin-Nagant-9130-mesh'
    HighDetailOverlay=shader'Weapons1st_tex.Rifles.MN9130_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=25.0
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
