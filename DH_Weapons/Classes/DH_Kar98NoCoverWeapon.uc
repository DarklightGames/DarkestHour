//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Kar98NoCoverWeapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Kar 98k (no sight hood)"
    NativeItemName="Karabiner 98k (no sight hood)"
    FireModeClass(0)=Class'DH_Kar98NoCoverFire'
    FireModeClass(1)=Class'DH_Kar98NoCoverMeleeFire'
    AttachmentClass=Class'DH_Kar98NoCoverAttachment'
    PickupClass=Class'DH_Kar98NoCoverPickup'

    Mesh=SkeletalMesh'DH_Kar98_1st.kar98k_mesh_nocover'
    Skins(5)=Texture'Weapons1st_tex.k98'
    HighDetailOverlay=Shader'Weapons1st_tex.k98_sniper_s'
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
