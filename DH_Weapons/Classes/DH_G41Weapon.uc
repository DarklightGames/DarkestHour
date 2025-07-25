//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_G41Weapon extends DHBoltActionWeapon;

defaultproperties
{
    ItemName="G 41(W)"
    NativeItemName="Gewehr 41(W)"
    SwayModifyFactor=0.83 // +0.13 because it was a heavy, disbalanced and awkward rifle
    FireModeClass(0)=Class'DH_G41Fire'
    FireModeClass(1)=Class'DH_G41MeleeFire'
    AttachmentClass=Class'DH_G41Attachment'
    PickupClass=Class'DH_G41Pickup'

    Mesh=SkeletalMesh'DH_G41_1st.G41_mesh'
    HighDetailOverlay=Shader'Weapons1st_tex2.G41_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    Skins(4)=Shader'Weapons1st_tex.KarBayonet_S'

    IronSightDisplayFOV=53.0
    DisplayFOV=82.0
    FreeAimRotationSpeed=7.5

    MaxNumPrimaryMags=11
    InitialNumPrimaryMags=11

    bShouldSkipBolt=true  //is semi-auto
    bHasBayonet=true
    bPlusOneLoading=false
    bCanUseUnfiredRounds=false
    PreReloadAnim="reload_start"
    PreReloadEmptyAnim="reload_start_empty"
    PostReloadAnim="reload_end"
    SingleReloadAnim="reload_single"
    StripperReloadAnim="reload_stripper"

    BayonetBoneName="Muzzle_Slave"

    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"
    BayoAttachEmptyAnim="bayonet_on_empty"
    BayoDetachEmptyAnim="bayonet_off_empty"

    IdleEmptyAnim="idle_empty"
    IronIdleEmptyAnim="iron_idle_empty"
    IronBringUpEmpty="iron_in_empty"
    IronPutDownEmpty="iron_out_empty"
    SprintStartEmptyAnim="sprint_start_empty"
    SprintLoopEmptyAnim="sprint_middle_empty"
    SprintEndEmptyAnim="sprint_end_empty"

    CrawlForwardEmptyAnim="crawlF_empty"
    CrawlBackwardEmptyAnim="crawlB_empty"
    CrawlStartEmptyAnim="crawl_in_empty"
    CrawlEndEmptyAnim="crawl_out_empty"

    SelectEmptyAnim="draw_empty"
    PutDownEmptyAnim="put_away_empty"
}
