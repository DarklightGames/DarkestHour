//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M1GarandWeapon extends DHSemiAutoWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Garand_1st.ukx

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
    MagEmptyReloadAnim="reload_empty"
    MagPartialReloadAnim="reload_half"
    IronIdleAnim="Iron_idle"
    IronIdleEmptyAnim="iron_idle_empty"
    IronBringUp="iron_in"
    IronBringUpEmpty="Iron_In_empty"
    IronPutDown="iron_out"
    IronPutDownEmpty="Iron_Out_empty"
    BayoAttachAnim="Bayonet_on"
    BayoDetachAnim="Bayonet_off"
    BayonetBoneName="bayonet"
    bHasBayonet=true
    IdleEmptyAnim="idle_empty"
    MaxNumPrimaryMags=11
    InitialNumPrimaryMags=11
    bDiscardMagOnReload=true
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IronSightDisplayFOV=20.0
    ZoomInTime=0.4
    ZoomOutTime=0.2
    FreeAimRotationSpeed=7.5
    FireModeClass(0)=class'DH_Weapons.DH_M1GarandFire'
    FireModeClass(1)=class'DH_Weapons.DH_M1GarandMeleeFire'
    SelectAnim="Draw"
    PutDownAnim="putaway"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.4
    CurrentRating=0.4
    DisplayFOV=70.0
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_M1GarandPickup'
    AttachmentClass=class'DH_Weapons.DH_M1GarandAttachment'
    ItemName="M1 Garand"
    Mesh=SkeletalMesh'DH_Garand_1st.M1_Garand'
}
