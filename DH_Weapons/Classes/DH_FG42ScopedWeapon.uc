//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Scoped version of the FG42 with the ZFG42 sight.
//==============================================================================

class DH_FG42ScopedWeapon extends DH_FG42Weapon;

defaultproperties
{   
    ItemName="FG 42 (ZFG42)"
    NativeItemName="Fallschirmjägergewehr 42 (ZFG42)"
    FireModeClass(0)=class'DH_Weapons.DH_FG42ScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_FG42MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_FG42ScopedAttachment'
    PickupClass=class'DH_Weapons.DH_FG42ScopedPickup'

    Mesh=SkeletalMesh'DH_Fallschirmgewehr42_1st.FG42_scoped'

    // Deploy
    IdleToBipodDeploy="deploy_scoped"
    BipodDeployToIdle="undeploy_scoped"
    BipodIdleAnim="deploy_idle_scoped"
    BipodMagEmptyReloadAnim="deploy_reload_scoped"
    BipodMagPartialReloadAnim="deploy_reload_scoped"

    // Iron
    IronBringUp="iron_in_scoped"
    IronIdleAnim="iron_idle_scoped"
    IronPutDown="iron_out_scoped"

    // Crawl
    CrawlStartAnim="crawl_in_scoped"
    CrawlForwardAnim="crawlf_scoped"
    CrawlBackwardAnim="crawlb_scoped"
    CrawlEndAnim="crawl_out_scoped"

    // Sprint
    SprintStartAnim="sprint_start_scoped"
    SprintLoopAnim="sprint_middle_scoped"
    SprintEndAnim="sprint_end_scoped"
    
    // Select Fire
    SelectFireIronAnim="iron_switchfiremode_scoped"
    SelectFireBipodIronAnim="deploy_switchfiremode_scoped"

    // Scope
    bHasScope=true
    ScopeOverlay=Texture'DH_Weapon_tex.Scopes.Textured_GerScope'
    ScriptedScopeTexture=Texture'DH_Weapon_tex.Scopes.Ger_sniperscope_overlay'
    ScopeOverlaySize=0.32
    IronSightDisplayFOV=47.0
    IronSightDisplayFOVHigh=47.0
    LensMaterialID=6

    PlayerFOVZoom=15.0
    ScopePortalFOV=5.7  //4.5 degrees, the value is higher than that because for some reason 3d scope appears with lower FOV than what is determined here
    ScopePortalFOVHigh=5.7
    PlayerIronsightFOV=60.0
    bUsesIronsightFOV=true
}
