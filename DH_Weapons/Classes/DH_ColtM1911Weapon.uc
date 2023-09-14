//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ColtM1911Weapon extends DHPistolWeapon;

defaultproperties
{
    ItemName="Colt M1911A1"
    FireModeClass(0)=class'DH_Weapons.DH_ColtM1911Fire'
    FireModeClass(1)=class'DH_Weapons.DH_ColtM1911MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_ColtM1911Attachment'
    PickupClass=class'DH_Weapons.DH_ColtM1911Pickup'

    Mesh=SkeletalMesh'DH_Colt1911_1st.Colt45'
    HighDetailOverlay=Shader'DH_ColtM1911_tex.ColtM1911.ColtM1911_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
    HandNum=0
    SleeveNum=1

    Skins(2)=Shader'DH_ColtM1911_tex.ColtM1911.ColtM1911_S'

    DisplayFOV=85.0
    IronSightDisplayFOV=75.0

    MaxNumPrimaryMags=5
    InitialNumPrimaryMags=5

    SelectEmptyAnim="Draw_empty"
    PutDownAnim="put_away"
    PutDownEmptyAnim="put_away_empty"
    IdleEmptyAnim="idle_empty"
    IronIdleEmptyAnim="iron_idle_empty"
    IronBringUpEmpty="Iron_In_empty"
    IronPutDownEmpty="Iron_Out_empty"
    CrawlForwardEmptyAnim="crawlF_empty"
    CrawlBackwardEmptyAnim="crawlB_empty"
    CrawlStartEmptyAnim="crawl_in_empty"
    CrawlEndEmptyAnim="crawl_out_empty"
    SprintStartEmptyAnim="Sprint_Start_Empty"
    SprintLoopEmptyAnim="Sprint_Middle_Empty"
    SprintEndEmptyAnim="Sprint_End_Empty"

    FirstSelectAnim="Draw2"
}
