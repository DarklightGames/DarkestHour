//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Kar98NoCoverWeapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Karabiner 98k (w/o sight hood)"
    FireModeClass(0)=class'DH_Weapons.DH_Kar98NoCoverFire'
    FireModeClass(1)=class'DH_Weapons.DH_Kar98NoCoverMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_Kar98NoCoverAttachment'
    PickupClass=class'DH_Weapons.DH_Kar98NoCoverPickup'

    Mesh=SkeletalMesh'DH_Kar98_1st.kar98k_mesh_nocover'
    Skins(5)=Texture'Weapons1st_tex.Rifles.k98'
    HighDetailOverlay=Shader'Weapons1st_tex.Rifles.k98_sniper_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=47.0
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
