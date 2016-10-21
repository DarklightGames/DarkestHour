//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_C96Weapon extends DHFastAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_C96_1st.ukx

defaultproperties
{
    ItemName="Mauser C96"
    FireModeClass(0)=class'DH_Weapons.DH_C96Fire'
    FireModeClass(1)=class'DH_Weapons.DH_C96MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_C96Attachment'
    PickupClass=class'DH_Weapons.DH_C96Pickup'

    Mesh=SkeletalMesh'DH_C96_1st.c96'

    PlayerIronsightFOV=70.0
    IronSightDisplayFOV=45.0

    MaxNumPrimaryMags=5
    InitialNumPrimaryMags=5
    bHasSelectFire=true

    SelectEmptyAnim="Draw_empty"
    PutDownAnim="putaway"
    PutDownEmptyAnim="putaway_empty"
    IdleEmptyAnim="idle_empty"
    IronIdleEmptyAnim="iron_idle_empty"
    IronBringUpEmpty="Iron_In_empty"
    IronPutDownEmpty="Iron_Out_empty"
    SelectFireAnim="switch_fire"
    SelectFireIronAnim="Iron_switch_fire"
    SprintStartEmptyAnim="Sprint_Start_Empty"
    SprintLoopEmptyAnim="Sprint_Middle_Empty"
    SprintEndEmptyAnim="Sprint_End_Empty"
    CrawlForwardEmptyAnim="crawlF_empty"
    CrawlBackwardEmptyAnim="crawlB_empty"
    CrawlStartEmptyAnim="crawl_in_empty"
    CrawlEndEmptyAnim="crawl_out_empty"
}
