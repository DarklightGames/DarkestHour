//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_EnfieldNo2Weapon extends DHPistolWeapon;

defaultproperties
{
    ItemName="Enfield No.2"
    FireModeClass(0)=class'DH_Weapons.DH_EnfieldNo2Fire'
    FireModeClass(1)=class'DH_Weapons.DH_EnfieldNo2MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_EnfieldNo2Attachment'
    PickupClass=class'DH_Weapons.DH_EnfieldNo2Pickup'

    Mesh=SkeletalMesh'DH_EnfieldNo2_1st.EnfieldNo2'
    HighDetailOverlay=Shader'DH_EnfieldNo2_tex.EnfieldNo2.EnfieldNo2S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    DisplayFOV=85.0
    IronSightDisplayFOV=75.0

    MaxNumPrimaryMags=9
    InitialNumPrimaryMags=9

    IdleEmptyAnim="Idle"
    IronIdleEmptyAnim="Iron_idle"
    IronBringUpEmpty="iron_in"
    IronPutDownEmpty="iron_out"
    SprintStartAnim="sprint_in"
    SprintLoopAnim="sprint_idle"
    SprintEndAnim="sprint_out"
    SprintStartEmptyAnim="sprint_in"
    SprintLoopEmptyAnim="sprint_idle"
    SprintEndEmptyAnim="sprint_out"
    CrawlForwardEmptyAnim="crawlF"
    CrawlBackwardEmptyAnim="crawlB"
    CrawlStartEmptyAnim="crawl_in"
    CrawlEndEmptyAnim="crawl_out"
    PutDownAnim="putaway"
    SelectEmptyAnim="Draw"
    PutDownEmptyAnim="putaway"

    HandNum=0
    SleeveNum=1

    UnloadedMunitionsPolicy=UMP_Consolidate
}
