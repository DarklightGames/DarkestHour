//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SVT40ScopedWeapon extends DHSniperWeapon;

defaultproperties
{
    ItemName="SVT-40 (PU)"
    FireModeClass(0)=class'DH_Weapons.DH_SVT40ScopedFire'
    FireModeClass(1)=class'DH_Weapons.DH_SVT40ScopedMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_SVT40ScopedAttachment'
    PickupClass=class'DH_Weapons.DH_SVT40ScopedPickup'

    Mesh=SkeletalMesh'DH_Svt40_1st.svt40_scoped_1st'
    HighDetailOverlay=Shader'Weapons1st_tex.Rifles.svt40_sniper_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    ScopeOverlaySize=0.266

    bHasScope=true
    ScopeOverlay=Texture'DH_Weapon_tex.Scopes.USSR_PU_Scope_Overlay'
    //ScriptedScopeTexture=Texture'DH_Weapon_tex.Scopes.USSR_PU_Scope_Overlay'  //to do: proper 3d scope texture

    IronSightDisplayFOV=48.2
    IronSightDisplayFOVHigh=48.2
    DisplayFOV=85.0
    PlayerIronsightFOV=60.0
    PlayerFOVZoom=17.143 // 3.5x
    ScopePortalFOV=5.8  //4.5 degrees, the value is higher than that because for some reason 3d scope appears with lower FOV than what is determined here
    ScopePortalFOVHigh=5.8
    bUsesIronsightFOV=true

    LensMaterialID=4

    InitialNumPrimaryMags=7
    MaxNumPrimaryMags=7

    MagEmptyReloadAnims(0)="reload_empty"
    MagEmptyReloadAnims(1)="reload_emptyB"
    MagEmptyReloadAnims(2)="reload_emptyC"
    MagPartialReloadAnims(0)="reload_half"
    MagPartialReloadAnims(1)="reload_halfB"
    MagPartialReloadAnims(2)="reload_halfC"

    IdleEmptyAnim="idle_empty"
    IronIdleEmptyAnim="scope_idle_empty"
    IronBringUpEmpty="scope_in_empty"
    IronPutDownEmpty="scope_out_empty"
    SprintStartEmptyAnim="sprint_start_empty"
    SprintLoopEmptyAnim="sprint_middle_empty"
    SprintEndEmptyAnim="sprint_end_empty"

    CrawlForwardEmptyAnim="crawlF_empty"
    CrawlBackwardEmptyAnim="crawlB_empty"
    CrawlStartEmptyAnim="crawl_in_empty"
    CrawlEndEmptyAnim="crawl_out_empty"

    SelectEmptyAnim="draw_empty"
    PutDownEmptyAnim="put_away_empty"
}
