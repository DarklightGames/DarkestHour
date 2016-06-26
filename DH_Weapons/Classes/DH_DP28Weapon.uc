//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_DP28Weapon extends DHMGWeapon;

#exec OBJ LOAD FILE=..\Animations\Allies_Dp28_1st.ukx

defaultproperties
{
    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_DP28Barrel'
    BarrelSteamBone="bipod"
    NumMagsToResupply=1
    IdleToBipodDeploy="Rest_2_Bipod"
    BipodDeployToIdle="Bipod_2_Rest"
    BipodHipIdle="Hip_Idle"
    BipodHipToDeploy="Hip_2_Bipod"
    MagEmptyReloadAnim="Bipod_Reload"
    MagPartialReloadAnim="Bipod_Reload_Half"
    IronIdleAnim="Bipod_Idle"
    IronBringUp="Rest_2_Hipped"
    IronPutDown="Hip_2_Rest"
    MaxNumPrimaryMags=3
    InitialNumPrimaryMags=3
    bPlusOneLoading=true
    SprintStartAnim="Rest_Sprint_Start"
    SprintLoopAnim="Rest_Sprint_Middle"
    SprintEndAnim="Rest_Sprint_End"
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IronSightDisplayFOV=45.000000
    ZoomInTime=0.400000
    ZoomOutTime=0.200000
    FireModeClass(0)=class'DH_Weapons.DH_DP28Fire'
    FireModeClass(1)=class'ROInventory.ROEmptyFireClass'
    IdleAnim="Rest_Idle"
    SelectAnim="Draw"
    PutDownAnim="Put_away"
    SelectAnimRate=1.000000
    PutDownAnimRate=1.000000
    AIRating=0.400000
    CurrentRating=0.400000
    bSniping=true
    DisplayFOV=70.000000
    PickupClass=class'DH_Weapons.DH_DP28Pickup'
    BobDamping=1.600000
    AttachmentClass=class'DH_Weapons.DH_DP28Attachment'
    ItemName="DP28 Machine Gun"
    Mesh=SkeletalMesh'Allies_Dp28_1st.DP28_Mesh'
    PlayerIronsightFOV=90.0
}
