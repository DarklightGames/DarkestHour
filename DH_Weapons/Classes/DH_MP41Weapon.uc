//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_MP41Weapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="Maschinenpistole 41"
    FireModeClass(0)=class'DH_Weapons.DH_MP41Fire'
    FireModeClass(1)=class'DH_Weapons.DH_MP41MeleeFire'
    PickupClass=class'DH_Weapons.DH_MP41Pickup'
    AttachmentClass=class'DH_Weapons.DH_MP41Attachment'

    Mesh=SkeletalMesh'DH_Mp40_1st.mp41_Mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.SMG.MP41_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    SwayModifyFactor=0.66 // -0.04, slightly better than mp40
    PlayerIronsightFOV=65.0
    IronSightDisplayFOV=55.0
    DisplayFOV=85.0
    FreeAimRotationSpeed=7.5
    ZoomOutTime=0.15

    MaxNumPrimaryMags=9
    InitialNumPrimaryMags=9

    bHasSelectFire=true
    SelectFireAnim="select_fire"
    SelectFireIronAnim="Iron_select_fire"

    SelectFireSound=Sound'Inf_Weapons_Foley.stg44.stg44_firemodeswitch01'

    bPlusOneLoading=false

    //alternative reload
    MagEmptyReloadAnims(1)="reload_emptyB"

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
    BarrelClass=class'DH_Weapons.DH_GenericSMGBarrel'
    BarrelSteamBone="Muzzle"
}
