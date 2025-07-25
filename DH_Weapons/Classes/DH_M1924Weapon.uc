//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M1924Weapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="M1924 Rifle"
    NativeItemName="M1924 Puska"
    FireModeClass(0)=Class'DH_M1924Fire'
    FireModeClass(1)=Class'DH_M1924MeleeFire'
    AttachmentClass=Class'DH_M1924Attachment'
    PickupClass=Class'DH_M1924Pickup'

    Mesh=SkeletalMesh'DH_Kar98_1st.m24_mesh'
    bUseHighDetailOverlayIndex=false

    IronSightDisplayFOV=53.0
    DisplayFOV=85.0

    MaxNumPrimaryMags=13
    InitialNumPrimaryMags=13

    bHasBayonet=true
    BayonetBoneName="bayonet"
    BayoAttachAnim="Bayonet_on_Vz24"
    BayoDetachAnim="Bayonet_off_Vz24"
    IronBringUpRest="iron_inrest"
    SingleReloadAnim="reload_middle_st"
    SingleReloadHalfAnim="reload_single_st"
    PreReloadAnim="reload_start_st"
    PreReloadHalfAnim="reload_start_st"
    PostReloadAnim="reload_end_st"
    FullReloadAnim="reload_st"
    
    BoltHipAnim="bolt_st"
    BoltIronAnim="iron_boltrest_st"
}

