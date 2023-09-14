//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_StenMkIICWeapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="STEN Mk.II"
    FireModeClass(0)=class'DH_Weapons.DH_StenMkIICFire'
    FireModeClass(1)=class'DH_Weapons.DH_StenMkIICMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_StenMkIICAttachment'
    PickupClass=class'DH_Weapons.DH_StenMkIICPickup'

    Mesh=SkeletalMesh'DH_Sten_1st.StenMk2C_mesh'
    //HighDetailOverlay=Shader'DH_Weapon_tex.Spec_Maps.SMG.Sten_s'
    bUseHighDetailOverlayIndex=false
    HighDetailOverlayIndex=2

    Skins(2)=Texture'DH_Sten_tex.Sten.StenMk2_tex'
    HandNum=0
    SleeveNum=1

    SwayModifyFactor=0.55 // -0.15

    DisplayFOV=90.0
    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=65.0

    MaxNumPrimaryMags=8
    InitialNumPrimaryMags=8

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_GenericSMGBarrel'
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
