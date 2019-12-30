//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_KorovinWeapon extends DHFastAutoWeapon;

defaultproperties
{
    ItemName="Korovin 1941"
    SwayModifyFactor=0.67 // -0.13 because its a light SMG
    FireModeClass(0)=class'DH_Weapons.dh_korovinFire'
    FireModeClass(1)=class'DH_Weapons.dh_korovinMeleeFire'
    AttachmentClass=class'DH_Weapons.dh_korovinAttachment'
    PickupClass=class'DH_Weapons.dh_korovinPickup'

    Mesh=SkeletalMesh'DH_korovin_1st.korovin_mesh'

    bUseHighDetailOverlayIndex=false
	HandNum=0
    SleeveNum=3
	HighDetailOverlayIndex=2

    IronSightDisplayFOV=50.0

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
