//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_VK98Weapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="VK 98"
    NativeItemName="Volkssturmkarabiner 98"
    FireModeClass(0)=Class'DH_VK98Fire'
    FireModeClass(1)=Class'DH_VK98MeleeFire'
    AttachmentClass=Class'DH_VK98Attachment'
    PickupClass=Class'DH_VK98Pickup'

    Mesh=SkeletalMesh'DH_Kar98_1st.VK98_mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.k98_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=47.0
    DisplayFOV=85.0

    MaxNumPrimaryMags=8
    InitialNumPrimaryMags=8

    bHasBayonet=false
    //BayonetBoneName="bayonet"
    //BayoAttachAnim="Bayonet_on"
    //BayoDetachAnim="Bayonet_off"
    IronBringUpRest="iron_inrest"
    SingleReloadAnim="single_insert"
    SingleReloadHalfAnim="single_insert_half"
    PreReloadAnim="single_open"
    PreReloadHalfAnim="single_open_half"
    PostReloadAnim="single_close"
    FullReloadAnim="reload"
}

