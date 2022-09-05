//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_SVT38Weapon extends DHBoltActionWeapon;

simulated function int GetStripperClipSize() //modified from 5
{
    return 10;   // TODO: make it a normal property
}

defaultproperties
{
    ItemName="SVT-38"
    SwayModifyFactor=0.7 //heavier than SVT-40
    SwayBayonetModifier=1.26
    FireModeClass(0)=class'DH_Weapons.DH_SVT38Fire'
    FireModeClass(1)=class'DH_Weapons.DH_SVT38MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_SVT38Attachment'
    PickupClass=class'DH_Weapons.DH_SVT38Pickup'

    Mesh=SkeletalMesh'DH_Svt40_1st.svt38_1st'
    HighDetailOverlay=Shader'Weapons1st_tex.Rifles.SVT40_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
    Skins(4)=Shader'Weapons1st_tex.Bullets.mn_stripper_s'

    IronSightDisplayFOV=48.0
    DisplayFOV=90.0

    MaxNumPrimaryMags=10
    InitialNumPrimaryMags=10

    //NumRoundsToLoad=10

    BayonetBoneName="bayonet"

    bShouldSkipBolt=true  //is semi-auto
    bHasBayonet=true
    bPlusOneLoading=false
    bCanUseUnfiredRounds=false
    PreReloadAnim="reload_start"
    PostReloadAnim="reload_end"
    SingleReloadAnim="reload_single"
    FullReloadAnim="reload_stripper1"

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
