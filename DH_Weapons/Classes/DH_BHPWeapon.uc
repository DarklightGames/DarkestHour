//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_BHPWeapon extends DHPistolWeapon;

defaultproperties
{
    ItemName="Browning High-Power"
    FireModeClass(0)=class'DH_Weapons.DH_BHPFire'
    FireModeClass(1)=class'DH_Weapons.DH_BHPMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_BHPAttachment'
    PickupClass=class'DH_Weapons.DH_BHPPickup'

    Mesh=SkeletalMesh'DH_BHP_1st.BHP-Mesh'
    bUseHighDetailOverlayIndex=false

    Skins(0)=Texture'DH_BHP_tex.BHP.BHP'

    HandNum=1
    SleeveNum=2

    IronSightDisplayFOV=70.0
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

    FirstSelectAnim="Draw2"
}
