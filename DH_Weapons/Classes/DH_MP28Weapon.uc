//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_MP28Weapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="Maschinenpistole 28"
    FireModeClass(0)=class'DH_Weapons.DH_MP28Fire'
    FireModeClass(1)=class'DH_Weapons.DH_MP28MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_MP28Attachment'
    PickupClass=class'DH_Weapons.DH_MP28Pickup'

    Mesh=SkeletalMesh'DH_Mp28_1st.mp28-anim'

    bUseHighDetailOverlayIndex=false

    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=50.0
    ZoomOutTime=0.15

    MaxNumPrimaryMags=9
    InitialNumPrimaryMags=9

    bPlusOneLoading=false

    bHasSelectFire=true
    SelectFireAnim="select_fire"
    SelectFireIronAnim="Iron_select_fire"

    // TO DO:
   // IdleEmptyAnim="idle_empty"
   // IronIdleEmptyAnim="Iron_idle_empty"
   // IronBringUpEmpty="Iron_in_empty"
   // IronPutDownEmpty="Iron_out_empty"
   // SprintStartEmptyAnim="Sprint_Start_Empty"
   // SprintLoopEmptyAnim="Sprint_Middle_Empty"
   // SprintEndEmptyAnim="Sprint_End_Empty"
   // CrawlForwardEmptyAnim="crawlF_empty"
  //  CrawlBackwardEmptyAnim="crawlB_empty"
   // CrawlStartEmptyAnim="crawl_in_empty"
   // CrawlEndEmptyAnim="crawl_out_empty"
   // SelectEmptyAnim="Draw_empty"
   // PutDownEmptyAnim="put_away_empty"
}
