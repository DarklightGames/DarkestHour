//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_PIATWeapon extends DHRocketWeapon;

// Modified to prevent reloading unless prone or rested (with message) or if weapon is not empty
simulated function bool AllowReload()
{
    if (Instigator == none || (!Instigator.bIsCrawling && !Instigator.bRestingWeapon))
    {
        if (Instigator.IsHumanControlled())
        {
            WarningMessageClass.static.ClientReceive(PlayerController(Instigator.Controller), 5,,, self); // can't reload unless prone or rested
        }

        return false;
    }

    if (!IsLoaded())
    {
        return super(DHProjectileWeapon).AllowReload();
    }
}

// Modified to prevent crouching while reloading
simulated state Reloading
{
    simulated function bool WeaponAllowCrouchChange()
    {
        return false;
    }
}

// Modified as PIAT can only be fired when player is prone or weapon is rested
simulated function bool CanFire(optional bool bShowFailureMessage)
{
    if (!bUsingSights)
    {
        if (bShowFailureMessage && InstigatorIsHumanControlled())
        {
            WarningMessageClass.static.ClientReceive(PlayerController(Instigator.Controller), 1,,, self); // can't fire from hip
        }

        return false;
    }

    if (Instigator == none || (!Instigator.bIsCrawling && !Instigator.bRestingWeapon))
    {
        if (bShowFailureMessage && InstigatorIsHumanControlled())
        {
            WarningMessageClass.static.ClientReceive(PlayerController(Instigator.Controller), 3,,, self); // can't fire unless prone or rested
        }

        return false;
    }

    return true;
}

defaultproperties
{
    ItemName="PIAT"
    TeamIndex=1
    FireModeClass(0)=class'DH_Weapons.DH_PIATFire'
    FireModeClass(1)=class'DH_Weapons.DH_PIATMeleeFire'
    AttachmentClass=class'DH_Weapons.DH_PIATAttachment'
    PickupClass=class'DH_Weapons.DH_PIATPickup'

    Mesh=SkeletalMesh'DH_PIAT_1st.PIAT_1st' // TODO: there is no specularity mask for this weapon

    IronSightDisplayFOV=45.0 //25.0

    RocketAttachmentClass=class'DH_Weapons.DH_PIATAmmoRound'
    MuzzleBone="rocket"
    InitialNumPrimaryMags=2
    NumMagsToResupply=2
    IronIdleAnim="idel_loop"
    MagEmptyReloadAnims(0)="Reload 2"
    MagPartialReloadAnims(0)="Reload 2"

    CrawlForwardAnim="crawl_f"
    CrawlBackwardAnim="crawl_b"

    SprintStartAnim="sprint_start"
    SprintLoopAnim="sprint_middle"
    SprintEndAnim="sprint_out"

    FirstSelectAnim="first_draw"

    RangeSettings(0)=(FirePitch=85,IronIdleAnim="iron_loop_50",FireIronAnim="shoot_50")
    RangeSettings(1)=(FirePitch=325,IronIdleAnim="iron_loop_100",FireIronAnim="shoot_100")
    RangeSettings(2)=(FirePitch=500,IronIdleAnim="iron_loop_150",FireIronAnim="shoot_150")
}
