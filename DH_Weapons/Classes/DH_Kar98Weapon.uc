//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_Kar98Weapon extends DHBoltActionWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Kar98_1st.ukx

defaultproperties
{
    MagEmptyReloadAnim="Reload"
    IronIdleAnim="Iron_idle"
    IronBringUp="iron_in"
    IronBringUpRest="iron_inrest"
    IronPutDown="iron_out"
    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"
    BayonetBoneName="bayonet"
    bHasBayonet=true
    BoltHipAnim="bolt"
    BoltIronAnim="iron_boltrest"
    PostFireIronIdleAnim="Iron_idlerest"
    PostFireIdleAnim="Idle"
    MaxNumPrimaryMags=13
    InitialNumPrimaryMags=13
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IronSightDisplayFOV=25.0
    ZoomInTime=0.4
    ZoomOutTime=0.4
    FireModeClass(0)=class'DH_Weapons.DH_Kar98Fire'
    FireModeClass(1)=class'DH_Weapons.DH_Kar98MeleeFire'
    SelectAnim="Draw"
    PutDownAnim="Put_away"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.4
    CurrentRating=0.4
    DisplayFOV=70.0
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_Kar98Pickup'
    AttachmentClass=class'DH_Weapons.DH_Kar98Attachment'
    ItemName="Karabiner 98k"
    Mesh=SkeletalMesh'DH_Kar98_1st.kar98k_mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.Rifles.k98_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
