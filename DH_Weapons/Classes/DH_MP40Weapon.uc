//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MP40Weapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="MP 40"
    NativeItemName="Maschinenpistole 40"
    FireModeClass(0)=Class'DH_MP40Fire'
    FireModeClass(1)=Class'DH_MP40MeleeFire'
    AttachmentClass=Class'DH_MP40Attachment'
    PickupClass=Class'DH_MP40Pickup'

    Mesh=SkeletalMesh'DH_Mp40_1st.mp40-mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.MP40_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=55.0
    DisplayFOV=85.0
    ZoomOutTime=0.15

    MaxNumPrimaryMags=9
    InitialNumPrimaryMags=9

    bPlusOneLoading=false

    //alternative reload
    MagEmptyReloadAnims(1)="reload_emptyB"
    MagEmptyReloadAnims(2)="reload_empty"
    MagEmptyReloadAnims(3)="reload_empty"

    IdleEmptyAnim="idle_empty"
    IronIdleEmptyAnim="Iron_idle_empty"
    IronBringUpEmpty="Iron_in_empty"
    IronPutDownEmpty="Iron_out_empty"
    SprintStartEmptyAnim="Sprint_Start_Empty"
    SprintLoopEmptyAnim="Sprint_Middle_Empty"
    SprintEndEmptyAnim="Sprint_End_Empty"
    CrawlForwardEmptyAnim="crawlF_empty"
    CrawlBackwardEmptyAnim="crawlB_empty"
    CrawlStartEmptyAnim="crawl_in_empty"
    CrawlEndEmptyAnim="crawl_out_empty"
    SelectEmptyAnim="Draw_empty"
    PutDownEmptyAnim="put_away_empty"

    InitialBarrels=1
    BarrelClass=Class'DH_GenericSMGBarrel'
    BarrelSteamBone="Muzzle"
}
