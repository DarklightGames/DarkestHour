//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_P08LugerWeapon extends DHPistolWeapon;

defaultproperties
{
    ItemName="Luger P08"
    FireModeClass(0)=class'DH_Weapons.DH_P08LugerFire'
    FireModeClass(1)=class'DH_Weapons.DH_P08LugerMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_P08LugerAttachment'
    PickupClass=class'DH_Weapons.DH_P08LugerPickup'

    Mesh=SkeletalMesh'DH_Luger_1st.P08Luger'
    HighDetailOverlay=Shader'Weapons1st_tex.Pistols.luger_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    DisplayFOV=85.0
    IronSightDisplayFOV=75.0
    ZoomOutTime=0.3

    MaxNumPrimaryMags=5
    InitialNumPrimaryMags=5

    IdleEmptyAnim="idle_empty"
    IronIdleEmptyAnim="iron_idle_empty"
    SelectEmptyAnim="Draw_empty"
    PutDownEmptyAnim="put_away_empty"
    IronBringUpEmpty="Iron_In_empty"
    IronPutDownEmpty="Iron_Out_empty"
    SprintStartEmptyAnim="Sprint_Empty_Start"
    SprintLoopEmptyAnim="Sprint_Empty_Middle"
    SprintEndEmptyAnim="Sprint_Empty_End"
    CrawlForwardEmptyAnim="crawlF_empty"
    CrawlBackwardEmptyAnim="crawlB_empty"
    CrawlStartEmptyAnim="crawl_in_empty"
    CrawlEndEmptyAnim="crawl_out_empty"
}
