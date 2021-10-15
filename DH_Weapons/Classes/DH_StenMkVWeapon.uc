//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_StenMkVWeapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="Sten MkV"
    FireModeClass(0)=class'DH_Weapons.DH_StenMkVFire'
    FireModeClass(1)=class'DH_Weapons.DH_StenMkVMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_StenMkVAttachment'
    PickupClass=class'DH_Weapons.DH_StenMkVPickup'

    Mesh=SkeletalMesh'DH_Sten_1st.StenMk5_mesh'
    //HighDetailOverlay=shader'DH_Weapon_tex.Spec_Maps.SMG.Sten_s'
    bUseHighDetailOverlayIndex=false
    HighDetailOverlayIndex=2
    
    Skins(2)=Texture'DH_Sten_tex.Sten.StenMk5_tex'
    HandNum=0
    SleeveNum=1

    SwayModifyFactor=0.72 // -0.08
    
    DisplayFOV=86.0
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
    
    bHasBayonet=true
    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"
    BayoAttachEmptyAnim="bayonet_on_empty"
    BayoDetachEmptyAnim="bayonet_off_empty"
    
    BayonetBoneName="bayonet"

    SelectFireAnim="fireswitch"
    SelectFireIronAnim="Iron_fireswitch"
    SelectFireEmptyAnim="fireswitch_empty"
    SelectFireIronEmptyAnim="Iron_fireswitch_empty"
}
