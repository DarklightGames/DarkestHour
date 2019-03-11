//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_PPD40Weapon extends DHFastAutoWeapon;

defaultproperties
{
    ItemName="PPD-40"
    FireModeClass(0)=class'DH_Weapons.DH_PPD40Fire'
    FireModeClass(1)=class'DH_Weapons.DH_PPD40MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_PPD40Attachment'
    PickupClass=class'DH_Weapons.DH_PPD40Pickup'

    Mesh=SkeletalMesh'DH_Ppd40_1st.PPD-40-Meshnew'
    HighDetailOverlay=shader'Weapons1st_tex.SMG.PPD40_1_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=35.0

    MaxNumPrimaryMags=3
    InitialNumPrimaryMags=3

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
