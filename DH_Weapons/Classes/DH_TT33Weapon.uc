//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_TT33Weapon extends DHPistolWeapon;

defaultproperties
{
    ItemName="TT-33"
    FireModeClass(0)=Class'DH_TT33Fire'
    FireModeClass(1)=Class'DH_TT33MeleeFire'
    AttachmentClass=Class'DH_TT33Attachment'
    PickupClass=Class'DH_TT33Pickup'

    Mesh=SkeletalMesh'DH_Tt33_1st.TT-33-Mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.TT33_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    DisplayFOV=85.0
    IronSightDisplayFOV=75.0

    InitialNumPrimaryMags=3
    MaxNumPrimaryMags=3

    IdleEmptyAnim="idle-empty"
    IronIdleEmptyAnim="iron_idle_empty"
    IronBringUpEmpty="iron_in_empty"
    IronPutDownEmpty="iron_out_empty"
    CrawlForwardEmptyAnim="crawlF_empty"
    CrawlBackwardEmptyAnim="crawlB_empty"
    CrawlStartEmptyAnim="crawl_in_empty"
    CrawlEndEmptyAnim="crawl_out_empty"
    SprintStartEmptyAnim="Sprint_Empty_Start"
    SprintLoopEmptyAnim="Sprint_Empty_Middle"
    SprintEndEmptyAnim="Sprint_Empty_End"
    SelectEmptyAnim="Draw_Empty"
    PutDownEmptyAnim="Put_Away_empty"

    FirstSelectAnim="Draw2"
}
