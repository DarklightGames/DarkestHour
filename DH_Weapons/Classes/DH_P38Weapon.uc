//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_P38Weapon extends DHPistolWeapon;

defaultproperties
{
    ItemName="Walther P38"
    FireModeClass(0)=Class'DH_P38Fire'
    FireModeClass(1)=Class'DH_P38MeleeFire'
    AttachmentClass=Class'DH_P38Attachment'
    PickupClass=Class'DH_P38Pickup'

    Mesh=SkeletalMesh'DH_P38_1st.P-38-Mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.p38_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    DisplayFOV=85.0
    IronSightDisplayFOV=75.0
    ZoomOutTime=0.4

    MaxNumPrimaryMags=3
    InitialNumPrimaryMags=3
    bCanHaveInitialNumMagsChanged=false

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
