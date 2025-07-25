//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_GeratPWeapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="Gerat Potsdam"
    FireModeClass(0)=Class'DH_GeratPFire'
    FireModeClass(1)=Class'DH_GeratPMeleeFire'
    AttachmentClass=Class'DH_GeratPAttachment'
    PickupClass=Class'DH_GeratPPickup'

    Mesh=SkeletalMesh'DH_Sten_1st.GeratP_mesh'
    //HighDetailOverlay=shader'DH_Weapon_tex.Spec_Maps.SMG.Sten_s'
    bUseHighDetailOverlayIndex=false
    HighDetailOverlayIndex=2

    Skins(2)=Texture'DH_Sten_tex.StenMk2_tex'
    HandNum=0
    SleeveNum=1

    SwayModifyFactor=0.59 // -0.11

    DisplayFOV=90.0
    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=65.0

    MaxNumPrimaryMags=6
    InitialNumPrimaryMags=6

    InitialBarrels=1
    BarrelClass=Class'DH_GenericSMGBarrel'
    BarrelSteamBone="Muzzle"

    bHasSelectFire=true
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

    SelectFireAnim="switchfire"
    SelectFireIronAnim="Iron_switchfire"
    SelectFireEmptyAnim="switchfire_empty"
    SelectFireIronEmptyAnim="Iron_switchfire_empty"
}
