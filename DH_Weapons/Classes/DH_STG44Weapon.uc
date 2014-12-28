//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_STG44Weapon extends DH_AutoWeapon;

#exec OBJ LOAD FILE=..\Animations\Axis_Stg44_1st.ukx

var name SelectFireAnim;     // Animation for selecting the firing mode
var name SelectFireIronAnim; // Animation for selecting the firing mode in ironsights

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

    if (Instigator.IsLocallyControlled() && !FireMode[Mode].bFireOnRelease)
    {
        if (!IsAnimating(0))
        {
            PlayIdle();
        }
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
    SelectFireAnim="select_fire"
    SelectFireIronAnim="Iron_select_fire"
    MagEmptyReloadAnim="reload_empty"
    MagPartialReloadAnim="reload_half"
    IronIdleAnim="Iron_idle"
    IronBringUp="iron_in"
    IronPutDown="iron_out"
    MaxNumPrimaryMags=7
    InitialNumPrimaryMags=7
    bPlusOneLoading=true
    PlayerIronsightFOV=65.000000
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IronSightDisplayFOV=25.000000
    ZoomInTime=0.400000
    ZoomOutTime=0.100000
    FreeAimRotationSpeed=7.000000
    bHasSelectFire=true
    FireModeClass(0)=class'DH_Weapons.DH_STG44Fire'
    FireModeClass(1)=class'DH_Weapons.DH_STG44MeleeFire'
    SelectAnim="Draw"
    PutDownAnim="Put_away"
    SelectAnimRate=1.000000
    PutDownAnimRate=1.000000
    AIRating=0.700000
    CurrentRating=0.700000
    bSniping=true
    DisplayFOV=70.000000
    bCanRestDeploy=true
    PickupClass=class'DH_Weapons.DH_STG44Pickup'
    BobDamping=1.600000
    AttachmentClass=class'DH_Weapons.DH_STG44Attachment'
    ItemName="Sturmgewehr 44"
    Mesh=SkeletalMesh'Axis_Stg44_1st.STG44-Mesh'
    HighDetailOverlay=Shader'Weapons1st_tex.SMG.STG44_S'
    bUseHighDetailOverlayIndex=true
    HighDetailOverlayIndex=2
}
