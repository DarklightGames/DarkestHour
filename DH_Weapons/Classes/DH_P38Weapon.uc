//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_P38Weapon extends DHPistolWeapon;

defaultproperties
{
    ItemName="Walther P38"
    FireModeClass(0)=class'DH_Weapons.DH_P38Fire'
    FireModeClass(1)=class'DH_Weapons.DH_P38MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_P38Attachment'
    PickupClass=class'DH_Weapons.DH_P38Pickup'

    Mesh=SkeletalMesh'DH_P38_1st.P-38-Mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.Pistols.p38_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    DisplayFOV=85.0
    IronSightDisplayFOV=75.0
    ZoomOutTime=0.4

    MaxNumPrimaryMags=5
    InitialNumPrimaryMags=5

    SelectEmptyAnim="Draw_empty"
    PutDownEmptyAnim="put_away_empty"
    IdleEmptyAnim="idle_empty"
    IronIdleEmptyAnim="iron_idle_empty"
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
