//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_BrenWeapon extends DHAutoWeapon; //TO DO: add bipod physics (tried on zb30 and failed)

defaultproperties
{
    SwayModifyFactor=1.15 // Increased sway (0.8 is default otherwise)

    ItemName="Bren Mk.II"
    TeamIndex=1
    FireModeClass(0)=class'DH_Weapons.DH_BrenFire'
    //FireModeClass(1)=class'DH_Weapons.DH_BrenMeleeFire'  /no melee!
    AttachmentClass=class'DH_Weapons.DH_BrenAttachment'
    PickupClass=class'DH_Weapons.DH_BrenPickup'
    
    Mesh=SkeletalMesh'DH_ZB_1st.BrenMk2_1st'
    bUseHighDetailOverlayIndex=false
    Skins(0)=Texture'DH_Bren_tex.one.Bren_D'
    HandNum=1
    SleeveNum=2
    
    DisplayFOV=85.0
    IronSightDisplayFOV=65.0
    PlayerDeployFOV=65

    bHasSelectFire=true
    SelectFireAnim="fireswitch"
    SelectFireIronAnim="iron_fireswitch"
    SelectFireBipodIronAnim="deploy_fireswitch"

    InitialBarrels=2
    BarrelClass=class'DH_Weapons.DH_BrenBarrel'
    BarrelSteamBone="Barrel"

    PlayerIronsightFOV=65.0

    MaxNumPrimaryMags=9
    InitialNumPrimaryMags=9


    IdleToBipodDeploy="deploy"
    BipodDeployToIdle="undeploy"
    BipodIdleAnim="deploy_idle"
    BipodMagEmptyReloadAnim="bipod_reload"
    BipodMagPartialReloadAnim="bipod_reload"
    
    MagEmptyReloadAnims(0)="reload"
    MagPartialReloadAnims(0)="reload"

    IronBipodDeployAnim="iron_deploy"

    IronIdleAnim="iron_Idle"
    IronBringUp="iron_in"
    IronPutDown="iron_out"
    IronIdleAnim_"iron_idle"
    SprintStartAnim="Sprint_Start"
    SprintLoopAnim="sprint_middle"
    SprintEndAnim="Sprint_End"
    //CrawlForwardAnim="crawl_F"
    //CrawlBackwardAnim="crawl_B"
    //CrawlStartAnim="crawl_in"
    //CrawlEndAnim="crawl_out"
    IdleAnim="Idle"
    SelectAnim="Draw"
    PutDownAnim="Putaway"
    
    FirstSelectAnim="draw1"
    BarrelChangeAnim="BarrelChange"

    bCanBipodDeploy=true
    bCanBeResupplied=true
    NumMagsToResupply=2
    ZoomOutTime=0.1
}
