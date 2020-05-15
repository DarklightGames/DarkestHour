//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_ZB30Weapon extends DHBipodAutoWeapon;

// Modified to play the click sound that would usually be played in the select animation (we don't have a select anim for the Bren)
simulated function ToggleFireMode()
{
    super.ToggleFireMode();

    PlaySound(Sound'Inf_Weapons_Foley.stg44.stg44_firemodeswitch01',, 2.0);
}

defaultproperties
{
    ItemName="ZB30 Machine Gun"
    TeamIndex=0
    FireModeClass(0)=class'DH_Weapons.DH_ZB30AutoFire'
    FireModeClass(1)=class'DH_Weapons.DH_ZB30MeleeFire'
    AttachmentClass=class'DH_Weapons.DH_ZB30Attachment'
    PickupClass=class'DH_Weapons.DH_ZB30Pickup'

    Mesh=SkeletalMesh'DH_ZB30_1st.ZB30'
    HighDetailOverlay=material'DH_Weapon_CC_tex.Spec_Maps.ZB30_s'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2

    DisplayFOV=110.0
    IronSightDisplayFOV=110.0

    MaxNumPrimaryMags=11
    InitialNumPrimaryMags=11
    NumMagsToResupply=1
    bHasSelectFire=true

    InitialBarrels=1
    BarrelClass=class'DH_Weapons.DH_ZB30Barrel'
    BarrelSteamBone="Handle"

    MagEmptyReloadAnim="Bipod_Reload"
    MagPartialReloadAnim="Bipod_Reload"
    IronIdleAnim="Bipod_Idle"
    IronBringUp="hip2is"
    IronPutDown="is2hip"
    SprintStartAnim="Hip_Sprint_Start"
    SprintLoopAnim="hip_sprint_mid"
    SprintEndAnim="Hip_Sprint_End"
    CrawlForwardAnim="crawl_F"
    CrawlBackwardAnim="crawl_B"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IdleAnim="Hip_Idle"
    SelectAnim="Draw"
    PutDownAnim="Put_away"
}







