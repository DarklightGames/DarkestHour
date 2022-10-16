//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_SVT40Weapon extends DHProjectileWeapon;

defaultproperties
{
    ItemName="SVT-40"
    SwayModifyFactor=0.66 // -0.04
    FireModeClass(0)=class'DH_Weapons.DH_SVT40Fire'
    FireModeClass(1)=class'DH_Weapons.DH_SVT40MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_SVT40Attachment'
    PickupClass=class'DH_Weapons.DH_SVT40Pickup'

    Mesh=SkeletalMesh'DH_Svt40_1st.svt40_1st'
    HighDetailOverlay=Shader'Weapons1st_tex.Rifles.SVT40_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=48.0
    DisplayFOV=90.0

    MaxNumPrimaryMags=8
    InitialNumPrimaryMags=8

    MagEmptyReloadAnims(0)="reload_empty"
    MagEmptyReloadAnims(1)="reload_emptyB"
    MagEmptyReloadAnims(2)="reload_emptyC"
    MagEmptyReloadAnims(3)="reload_empty"
    MagPartialReloadAnims(0)="reload_half"
    MagPartialReloadAnims(1)="reload_halfB"
    MagPartialReloadAnims(2)="reload_halfC"

    bHasBayonet=true
    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"
    BayoAttachEmptyAnim="bayonet_on_empty"
    BayoDetachEmptyAnim="bayonet_off_empty"

    BayonetBoneName="bayonet"

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

    bPlusOneLoading=true
    FreeAimRotationSpeed=6.0
}
