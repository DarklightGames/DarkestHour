//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ColtM1911Weapon extends DHPistolWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Colt1911_1st.ukx

defaultproperties
{
    ItemName="Colt M1911"
    FireModeClass(0)=class'DH_Weapons.DH_ColtM1911Fire'
    FireModeClass(1)=class'DH_Weapons.DH_ColtM1911MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_ColtM1911Attachment'
    PickupClass=class'DH_Weapons.DH_ColtM1911Pickup'

    Mesh=SkeletalMesh'DH_Colt1911_1st.Colt45'

    IronSightDisplayFOV=40.0

    MaxNumPrimaryMags=5
    InitialNumPrimaryMags=5

    SelectEmptyAnim="Draw_empty"
    PutDownAnim="putaway"
    PutDownEmptyAnim="putaway_empty"
    IdleEmptyAnim="idle_empty"
    IronIdleEmptyAnim="iron_idle_empty"
    IronBringUpEmpty="Iron_In_empty"
    IronPutDownEmpty="Iron_Out_empty"
    SprintStartEmptyAnim="Sprint_Start_Empty"
    SprintLoopEmptyAnim="Sprint_Middle_Empty"
    SprintEndEmptyAnim="Sprint_End_Empty"
    CrawlForwardEmptyAnim="crawlF_empty"
    CrawlBackwardEmptyAnim="crawlB_empty"
    CrawlStartEmptyAnim="crawl_in_empty"
    CrawlEndEmptyAnim="crawl_out_empty"
}
