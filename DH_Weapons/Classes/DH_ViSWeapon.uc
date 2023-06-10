//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ViSWeapon extends DHPistolWeapon;

defaultproperties
{
    ItemName="ViS wz.35"
    FireModeClass(0)=class'DH_Weapons.DH_ViSFire'
    FireModeClass(1)=class'DH_Weapons.DH_ViSMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_ViSAttachment'
    PickupClass=class'DH_Weapons.DH_ViSPickup'

    Mesh=SkeletalMesh'DH_ViS_1st.ViS_Mesh'

    bUseHighDetailOverlayIndex=false

    Skins(1)=Texture'DH_ViS_tex.ViS.ViS_texture'
    Skins(2)=Texture'Weapons1st_tex.Pistols.p38'
    sleevenum=3
    handnum=0

    FirstSelectAnim="draw2"

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
    SprintStartEmptyAnim="Sprint_Start_empty"
    SprintLoopEmptyAnim="Sprint_middle_Empty"
    SprintEndEmptyAnim="Sprint_end_Empty"
    CrawlForwardEmptyAnim="crawlF_empty"
    CrawlBackwardEmptyAnim="crawlB_empty"
    CrawlStartEmptyAnim="crawl_in_empty"
    CrawlEndEmptyAnim="crawl_out_empty"
}
