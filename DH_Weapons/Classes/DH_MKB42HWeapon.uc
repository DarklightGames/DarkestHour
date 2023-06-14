//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_MKB42HWeapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="Mkb 42(H)"
    NativeItemName="Maschinenkarabiner 42(H)"
    FireModeClass(0)=class'DH_Weapons.DH_MKB42HFire'
    FireModeClass(1)=class'DH_Weapons.DH_MKB42HMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_MKB42HAttachment'
    PickupClass=class'DH_Weapons.DH_MKB42HPickup'

    Mesh=SkeletalMesh'DH_Stg44_1st.MKB42H-Mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.SMG.STG44_S'

    SwayModifyFactor=0.8 //+0.1

    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=55.0
    DisplayFOV=90.0
    ZoomOutTime=0.1
    FreeAimRotationSpeed=7.0

    MaxNumPrimaryMags=7
    InitialNumPrimaryMags=7

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_GenericSMGBarrel'
    BarrelSteamBone="Muzzle"

    bHasSelectFire=true
    bPlusOneLoading=false

    bSniping=true // for bots (as has longer range than other auto weapons)

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

    SelectFireAnim="select_fire"
    SelectFireIronAnim="Iron_select_fire"
    SelectFireEmptyAnim="select_fire_empty"
    SelectFireIronEmptyAnim="Iron_select_fire_empty"
}

