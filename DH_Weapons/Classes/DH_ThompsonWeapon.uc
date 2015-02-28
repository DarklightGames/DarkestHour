//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ThompsonWeapon extends DH_AutoWeapon;

#exec OBJ LOAD FILE=..\Animations\DH_Thompson_1st.ukx

var   name      SelectFireAnim;
var   name      SelectFireIronAnim;

replication
{
    reliable if (Role < ROLE_Authority)
        ServerChangeFireMode;
}

simulated exec function SwitchFireMode()
{
    if (IsBusy() || FireMode[0].bIsFiring || FireMode[1].bIsFiring)
    {
        return;
    }

    GotoState('SwitchingFireMode');
}

function ServerChangeFireMode()
{
    FireMode[0].bWaitForRelease = !FireMode[0].bWaitForRelease;
}

simulated state SwitchingFireMode extends Busy
{
    simulated function bool ReadyToFire(int Mode)
    {
        return false;
    }

    simulated function bool ShouldUseFreeAim()
    {
        return false;
    }

    simulated function Timer()
    {
        GotoState('Idle');
    }

    simulated function BeginState()
    {
        local name Anim;

        if (bUsingSights)
        {
            Anim = SelectFireIronAnim;
        }
        else
        {
            Anim = SelectFireAnim;
        }

        if (Instigator.IsLocallyControlled())
        {
            PlayAnim(Anim, 1.0, FastTweenTime);
        }

        SetTimer(GetAnimDuration(SelectAnim, 1.0) + FastTweenTime, false);

        ServerChangeFireMode();

        if (Role < ROLE_Authority)
        {
            FireMode[0].bWaitForRelease = !FireMode[0].bWaitForRelease;
        }
    }
}

// used by the hud icons for select fire
simulated function bool UsingAutoFire()
{
    return !FireMode[0].bWaitForRelease;
}

simulated function AnimEnd(int channel)
{
    local name anim;
    local float frame, rate;

    GetAnimParams(0, anim, frame, rate);

    if (ClientState == WS_ReadyToFire)
    {
        if (anim == FireMode[0].FireAnim && HasAnim(FireMode[0].FireEndAnim) && (!FireMode[0].bIsFiring || !UsingAutoFire()))
        {
            PlayAnim(FireMode[0].FireEndAnim, FireMode[0].FireEndAnimRate, FastTweenTime);
        }
        else if (anim == DH_ProjectileFire(FireMode[0]).FireIronAnim && (!FireMode[0].bIsFiring || !UsingAutoFire()))
        {
            PlayIdle();
        }
        else if (anim == FireMode[1].FireAnim && HasAnim(FireMode[1].FireEndAnim))
        {
            PlayAnim(FireMode[1].FireEndAnim, FireMode[1].FireEndAnimRate, 0.0);
        }
        else if ((FireMode[0] == none || !FireMode[0].bIsFiring) && (FireMode[1] == none || !FireMode[1].bIsFiring))
        {
            PlayIdle();
        }
    }
}

// Overridden to handle the stop firing anims especially for the STG
simulated event StopFire(int Mode)
{
    if (FireMode[Mode].bIsFiring)
    {
        FireMode[Mode].bInstantStop = true;
    }

    if (Instigator.IsLocallyControlled() && !FireMode[Mode].bFireOnRelease && !IsAnimating(0))
    {
        PlayIdle();
    }

    FireMode[Mode].bIsFiring = false;
    FireMode[Mode].StopFiring();

    if (!FireMode[Mode].bFireOnRelease)
    {
        ZeroFlashCount(Mode);
    }
}

defaultproperties
{
    SelectFireAnim="switch_fire"
    SelectFireIronAnim="Iron_switch_fire"
    MagEmptyReloadAnim="reload_empty"
    MagPartialReloadAnim="reload_half"
    IronIdleAnim="Iron_idle"
    IronBringUp="iron_in"
    IronPutDown="iron_out"
    MaxNumPrimaryMags=7
    InitialNumPrimaryMags=7
    bPlusOneLoading=true
    PlayerIronsightFOV=65.0
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IronSightDisplayFOV=30.0
    ZoomInTime=0.4
    ZoomOutTime=0.2
    bHasSelectFire=true
    FireModeClass(0)=class'DH_Weapons.DH_ThompsonFire'
    FireModeClass(1)=class'DH_Weapons.DH_ThompsonMeleeFire'
    SelectAnim="Draw"
    PutDownAnim="putaway"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.7
    CurrentRating=0.7
    DisplayFOV=70.0
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_ThompsonPickup'
    BobDamping=1.6
    AttachmentClass=class'DH_Weapons.DH_ThompsonAttachment'
    ItemName="M1A1 Thompson"
    Mesh=SkeletalMesh'DH_Thompson_1st.M1A1_Thompson'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
