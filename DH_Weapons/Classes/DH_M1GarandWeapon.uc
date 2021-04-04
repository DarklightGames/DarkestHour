//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_M1GarandWeapon extends DHBoltActionWeapon;

var     bool    bIsLastRound;

// Modified to support garand last round clip eject for client only
simulated function Fire(float F)
{
    super.Fire(F);

    bIsLastRound = AmmoAmount(0) == 1;
}

// New function to support garand last round clip eject for server only
simulated function bool WasLastRound()
{
    return AmmoAmount(0) == 0;
}

// Modified to add hint about garand's ping noise on clip ejection
simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    if (Instigator != none && DHPlayer(Instigator.Controller) != none)
    {
        DHPlayer(Instigator.Controller).QueueHint(20, true);
    }
}

defaultproperties
{
    ItemName="M1 Garand"
    FireModeClass(0)=class'DH_Weapons.DH_M1GarandFire'
    FireModeClass(1)=class'DH_Weapons.DH_M1GarandMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_M1GarandAttachment'
    PickupClass=class'DH_Weapons.DH_M1GarandPickup'

    Mesh=SkeletalMesh'DH_Garand_1st.Garand_1st'
    bUseHighDetailOverlayIndex=false
    //HighDetailOverlayIndex=2

    Skins(1)=Texture'DH_Weapon_tex.AlliedSmallArms.M1Garand'
    Skins(2)=Texture'DH_Weapon_tex.AlliedSmallArms.M1Garand_extra'
    HandNum=0
    SleeveNum=3

    IronSightDisplayFOV=57.0
    DisplayFOV=82.0
    FreeAimRotationSpeed=7.5

    MaxNumPrimaryMags=11
    InitialNumPrimaryMags=11
    bPlusOneLoading=false
    bCanUseUnfiredRounds=false

    bShouldSkipBolt=true  //is semi-auto
    PreReloadAnim="reload_half1"
    PostReloadAnim="reload_half2"
    SingleReloadAnim="reload_half_moment"
    FullReloadAnim="reload"
    //reload_sticky

    bHasBayonet=true

    BayonetBoneName="Muzzle_Slave"

    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"

    IdleEmptyAnim="idle_empty"
    IronIdleEmptyAnim="iron_idle_empty"
    IronBringUpEmpty="iron_in_empty"
    IronPutDownEmpty="iron_out_empty"
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
