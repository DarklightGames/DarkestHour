//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M44Weapon extends DHBoltActionWeapon;

#exec OBJ LOAD FILE=..\Animations\Allies_Nagant_1st.ukx

simulated exec function Deploy()
{
}

defaultproperties
{
    MagEmptyReloadAnim="Reload"
    IronIdleAnim="Iron_idle"
    IronBringUp="iron_in"
    IronBringUpRest="iron_inrest"
    IronPutDown="iron_out"
    BayonetBoneName="bayonet"
    bHasBayonet=true
    BoltHipAnim="bolt"
    BoltIronAnim="iron_boltrest"
    PostFireIronIdleAnim="Iron_idlerest"
    PostFireIdleAnim="Idle"
    MaxNumPrimaryMags=10
    InitialNumPrimaryMags=10
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IronSightDisplayFOV=25.0
    ZoomInTime=0.4
    ZoomOutTime=0.35
    FreeAimRotationSpeed=7.0
    FireModeClass(0)=class'DH_Weapons.DH_M44Fire'
    FireModeClass(1)=class'DH_Weapons.DH_M44MeleeFire'
    SelectAnim="Draw"
    PutDownAnim="Put_away"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.4
    CurrentRating=0.4
    bSniping=true
    DisplayFOV=70.0
    bBayonetMounted=true
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_M44Pickup'
    BobDamping=1.6
    AttachmentClass=class'DH_Weapons.DH_M44Attachment'
    ItemName="Mosin–Nagant M44 Carbine"
    Mesh=SkeletalMesh'Allies_Nagant_1st.Mosin_Nagant_M44'
    HighDetailOverlay=Shader'Weapons1st_tex.Rifles.MN9138_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
