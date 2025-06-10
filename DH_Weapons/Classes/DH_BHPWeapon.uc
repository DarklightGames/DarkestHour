//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_BHPWeapon extends DHPistolWeapon;

defaultproperties
{
    ItemName="Browning High-Power"
    FireModeClass(0)=Class'DH_BHPFire'
    FireModeClass(1)=Class'DH_BHPMeleeFire'
    AttachmentClass=Class'DH_BHPAttachment'
    PickupClass=Class'DH_BHPPickup'

    Mesh=SkeletalMesh'DH_BHP_1st.BHP-Mesh'
    bUseHighDetailOverlayIndex=false

    Skins(0)=Texture'DH_BHP_tex.BHP.BHP'

    HandNum=1
    SleeveNum=2

    DisplayFOV=85.0
    IronSightDisplayFOV=80.0
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

    FirstSelectAnim="Draw2"
}
