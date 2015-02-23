//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ColtM1911Weapon extends DH_PistolWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Colt1911_1st.ukx

defaultproperties
{
    MagEmptyReloadAnim="reload_empty"
    MagPartialReloadAnim="reload_half"
    IronIdleAnim="Iron_idle"
    IronBringUp="iron_in"
    IronPutDown="iron_out"
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
    SelectEmptyAnim="Draw_empty"
    PutDownEmptyAnim="putaway_empty"
    MaxNumPrimaryMags=5
    InitialNumPrimaryMags=5
    bPlusOneLoading=true
    PlayerIronsightFOV=70.0
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IronSightDisplayFOV=40.0
    ZoomInTime=0.4
    ZoomOutTime=0.2
    FireModeClass(0)=class'DH_Weapons.DH_ColtM1911Fire'
    FireModeClass(1)=class'DH_Weapons.DH_ColtM1911MeleeFire'
    SelectAnim="Draw"
    PutDownAnim="putaway"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.35
    CurrentRating=0.35
    DisplayFOV=70.0
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_ColtM1911Pickup'
    BobDamping=1.6
    AttachmentClass=class'DH_Weapons.DH_ColtM1911Attachment'
    ItemName="Colt M1911"
    Mesh=SkeletalMesh'DH_Colt1911_1st.Colt45'
}
