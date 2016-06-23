//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_SVT40Weapon extends DHSemiAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\Allies_Svt40_1st.ukx

var bool bJammed;

replication
{
    reliable if( Role==ROLE_Authority )
        bJammed;
}

defaultproperties
{
    //** Info **//
    ItemName="SVT40 Semi Auto Rifle"

    //** Display **//
    Mesh=mesh'Allies_Svt40_1st.svt40_mesh'
    DrawScale=1.0
    DisplayFOV=70
    IronSightDisplayFOV=25
    BobDamping=1.6
    BayonetBoneName=Bayonet
    HighDetailOverlay=Material'Weapons1st_tex.Rifles.SVT40_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    //** Weapon Firing **//
    FireModeClass(0)=class'DH_Weapons.DH_SVT40Fire'
    FireModeClass(1)=class'DH_Weapons.DH_SVT40MeleeFire'
    InitialNumPrimaryMags=5
    MaxNumPrimaryMags=5
    CurrentMagIndex=0
    bPlusOneLoading=true
    bHasBayonet=true

    //** Weapon Functionality **//
    bCanRestDeploy=true

    //** Inventory/Ammo **//
    PickupClass=class'DH_Weapons.DH_SVT40Pickup'
    AttachmentClass=class'DH_Weapons.DH_SVT40Attachment'

    //** Animation **//
    // Rates
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    // Draw/Put Away
    SelectAnim=Draw
    PutDownAnim=Put_Away
    // Reloading
    MagEmptyReloadAnim=reload_empty
    MagPartialReloadAnim=reload_half
    // Bayo attach/detach
    BayoAttachAnim=Bayonet_on
    BayoDetachAnim=Bayonet_off
    // Ironsites
    IronBringUp=iron_in
    IronIdleAnim=Iron_idle
    IronPutDown=iron_out
    // Crawling
    CrawlForwardAnim=crawlF
    CrawlBackwardAnim=crawlB
    CrawlStartAnim=crawl_in
    CrawlEndAnim=crawl_out

     //** Zooming **//
    ZoomInTime=0.4
    ZoomOutTime=0.2

    //** Bot/AI **//
    AIRating=+0.4
    CurrentRating=0.4
    bSniping=true // So bots will use this weapon to take long range shots

    //** Misc **//
    SelectForce="SwitchToAssaultRifle"
}
