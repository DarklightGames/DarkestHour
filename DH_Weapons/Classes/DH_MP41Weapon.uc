//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
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
    HighDetailOverlay=shader'Weapons1st_tex.SMG.MP41_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

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
	
    bPlusOneLoading=false

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
