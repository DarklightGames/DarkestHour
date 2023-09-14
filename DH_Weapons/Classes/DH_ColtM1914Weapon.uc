//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ColtM1914Weapon extends DHPistolWeapon;

defaultproperties
{
    ItemName="Kongsberg Colten M/1914"
    FireModeClass(0)=class'DH_Weapons.DH_ColtM1914Fire'
    FireModeClass(1)=class'DH_Weapons.DH_ColtM1914MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_ColtM1914Attachment'
    PickupClass=class'DH_Weapons.DH_ColtM1914Pickup'

    Mesh=SkeletalMesh'DH_Colt1911_1st.Colt1914'
    bUseHighDetailOverlayIndex=false
    HighDetailOverlayIndex=2
    HandNum=0
    SleeveNum=1

    Skins(0)=Texture'DH_ColtM1911_tex.ColtM1911.1914_Colt'

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
