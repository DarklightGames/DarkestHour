//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Kar98Weapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Kar 98k"
    NativeItemName="Karabiner 98k"
    FireModeClass(0)=Class'DH_Kar98Fire'
    FireModeClass(1)=Class'DH_Kar98MeleeFire'
    AttachmentClass=Class'DH_Kar98Attachment'
    PickupClass=Class'DH_Kar98Pickup'

    Mesh=SkeletalMesh'DH_Kar98_1st.DH_kar98k_mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.k98_s'
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

