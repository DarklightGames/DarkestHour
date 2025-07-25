//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Vz24Weapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="Vz.24 Rifle"
    NativeItemName="ZB vz.24 Puska"
    FireModeClass(0)=Class'DH_Vz24Fire'
    FireModeClass(1)=Class'DH_Vz24MeleeFire'
    AttachmentClass=Class'DH_Vz24Attachment'
    PickupClass=Class'DH_Vz24Pickup'

    Mesh=SkeletalMesh'DH_Kar98_1st.Vz24_mesh'
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

