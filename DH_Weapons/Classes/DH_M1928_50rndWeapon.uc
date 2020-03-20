//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_M1928_50rndWeapon extends DHAutoWeapon;

defaultproperties
{
    ItemName="M1928 Thompson /50rnd"
	SwayModifyFactor=0.94 // +0.14 
    FireModeClass(0)=class'DH_Weapons.DH_M1928_50rndFire'
    FireModeClass(1)=class'DH_Weapons.DH_ThompsonMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_M1928_50rndAttachment'
    PickupClass=class'DH_Weapons.DH_M1928_50rndPickup'

    Mesh=SkeletalMesh'DH_Thompson_1st.M1928_50rnd'

    PlayerIronsightFOV=75.0
    IronSightDisplayFOV=60.0

    MaxNumPrimaryMags=3
    InitialNumPrimaryMags=3

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_ThompsonBarrel'
    BarrelSteamBone="Muzzle"

    bHasSelectFire=true
    SelectFireAnim="fire_select"
    SelectFireIronAnim="Iron_fire_select"
    PutDownAnim="put_away"

    MagEmptyReloadAnim="reload_empty"
    MagPartialReloadAnim="reload_half"

    HandNum=1
    SleeveNum=0
    HighDetailOverlayIndex=2

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
}
