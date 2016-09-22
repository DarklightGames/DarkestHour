//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_SVT40Weapon extends DHSemiAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\Allies_Svt40_1st.ukx

var     bool    bJammed;

replication
{
    reliable if (Role == ROLE_Authority)
        bJammed;
}

defaultproperties
{
    ItemName="SVT-40"
    Mesh=SkeletalMesh'Allies_Svt40_1st.svt40_mesh'
    DrawScale=1.0
    DisplayFOV=70.0
    IronSightDisplayFOV=25.0
    BobDamping=1.6
    BayonetBoneName="bayonet"
    HighDetailOverlay=material'Weapons1st_tex.Rifles.SVT40_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
    FireModeClass(0)=class'DH_Weapons.DH_SVT40Fire'
    FireModeClass(1)=class'DH_Weapons.DH_SVT40MeleeFire'
    InitialNumPrimaryMags=8
    MaxNumPrimaryMags=8
    CurrentMagIndex=0
    bPlusOneLoading=true
    bHasBayonet=true
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_SVT40Pickup'
    AttachmentClass=class'DH_Weapons.DH_SVT40Attachment'
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    SelectAnim="Draw"
    PutDownAnim="Put_Away"
    MagEmptyReloadAnim="reload_empty"
    MagPartialReloadAnim="reload_half"
    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"
    IronBringUp="iron_in"
    IronIdleAnim="Iron_idle"
    IronPutDown="iron_out"
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    ZoomInTime=0.4
    ZoomOutTime=0.2
    AIRating=0.4
    CurrentRating=0.4
    bSniping=true
}
