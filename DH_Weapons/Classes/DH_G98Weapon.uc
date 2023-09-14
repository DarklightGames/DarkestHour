//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_G98Weapon extends DHBoltActionWeapon;  //original model creator: Coin-goD

defaultproperties
{
    ItemName="G 98"
    NativeItemName="Gewehr 98"
    SwayModifyFactor=0.64 // +0.04
    SwayBayonetModifier=1.25
    FireModeClass(0)=class'DH_Weapons.DH_G98Fire'
    FireModeClass(1)=class'DH_Weapons.DH_G98MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_G98Attachment'
    PickupClass=class'DH_Weapons.DH_G98Pickup'
    MuzzleBone="MuzzleG98"
    Mesh=SkeletalMesh'DH_Kar98_1st.G98_mesh'
    bUseHighDetailOverlayIndex=false

    IronSightDisplayFOV=47.0
    DisplayFOV=85.0

    MaxNumPrimaryMags=8
    InitialNumPrimaryMags=8 

    bHasBayonet=true
    BayonetBoneName="bayonet"
    BayoAttachAnim="Bayonet_on_G98"
    BayoDetachAnim="Bayonet_off_G98"
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

