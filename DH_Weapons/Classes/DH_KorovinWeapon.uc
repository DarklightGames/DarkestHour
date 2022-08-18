//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_KorovinWeapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="Korovin 1941"
    SwayModifyFactor=0.57 // -0.13 because its a light SMG
    FireModeClass(0)=class'DH_Weapons.DH_KorovinFire'
    FireModeClass(1)=class'DH_Weapons.DH_KorovinMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_KorovinAttachment'
    PickupClass=class'DH_Weapons.DH_KorovinPickup'

    Mesh=SkeletalMesh'DH_Korovin_1st.korovin_mesh'

    bUseHighDetailOverlayIndex=false
    HandNum=0
    SleeveNum=3
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=60
    DisplayFOV=85

    MaxNumPrimaryMags=7
    InitialNumPrimaryMags=7

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
