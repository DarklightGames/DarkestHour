//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_G43Weapon extends DHProjectileWeapon;

defaultproperties
{
    ItemName="Gewehr 43"
    FireModeClass(0)=class'DH_Weapons.DH_G43Fire'
    FireModeClass(1)=class'DH_Weapons.DH_G43MeleeFire'
    PickupClass=class'DH_Weapons.DH_G43Pickup'
    AttachmentClass=class'DH_Weapons.DH_G43Attachment'

    Mesh=SkeletalMesh'DH_G43_1st.G-43-Mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.Rifles.G43_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    IronSightDisplayFOV=55.0
    DisplayFOV=85.0

    MaxNumPrimaryMags=10
    InitialNumPrimaryMags=10

    IronBringUp="iron_in_g43"
    IronPutDown="iron_out_g43"
    IronIdleAnim="Iron_idle_g43"

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
