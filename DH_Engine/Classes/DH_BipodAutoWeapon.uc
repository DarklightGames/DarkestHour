//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BipodAutoWeapon extends DH_AutoWeapon;

var     name    SightUpIronBringUp;
var     name    SightUpIronPutDown;
var     name    SightUpIronIdleAnim;
var     name    SightUpMagEmptyReloadAnim;
var     name    SightUpMagPartialReloadAnim;

var     name            IdleToBipodDeployEmpty;     // anim for bipod rest state to deployed empty state
var     name            BipodDeployToIdleEmpty;     // anim for bipod deployed state to rest empty state

replication
{
    reliable if (Role < ROLE_Authority)
        ServerBipodDeploy;
}

simulated state Idle
{
    // This is to stop players from using crouch while deployed, as that allows an exploit
    // where a player can see and shoot over obstacles whilst being invisible to their targets.
    // Players can still use crouch to undeploy instantly while proned however - PsYcH0_CH!cKeN
    simulated function bool WeaponAllowCrouchChange()
    {
        if (Instigator.bBipodDeployed && !Instigator.bIsCrawling)
            return false;
        else
            return true;
    }
}

// Overridden to prevent melee attacks while deployed - PsYcH0_Ch!cKeN
//// client only ////
simulated event ClientStartFire(int Mode)
{
    if (Pawn(Owner).Controller.IsInState('GameEnded') || Pawn(Owner).Controller.IsInState('RoundEnded'))
        return;
    if (FireMode[Mode].bMeleeMode && Instigator.bBipodDeployed)
        return;

    if (Role < ROLE_Authority)
    {
        if (StartFire(Mode))
        {
            ServerStartFire(Mode);
        }
    }
    else
    {
        StartFire(Mode);
    }
}

// This is to stop players from using crouch while deployed, as that allows an exploit
// where a player can see and shoot over obstacles whilst being invisible to their targets.
// Players can still use crouch to undeploy instantly while proned however
simulated function bool WeaponAllowCrouchChange()
{
    if (Instigator.bBipodDeployed && !Instigator.bIsCrawling)
        return false;
    else
        return true;
}

simulated function AnimEnd(int channel)
{
        local   name    anim;
        local   float   frame, rate;

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
                else if (anim== FireMode[1].FireAnim && HasAnim(FireMode[1].FireEndAnim))
                {
                        PlayAnim(FireMode[1].FireEndAnim, FireMode[1].FireEndAnimRate, 0.0);
                }
                else if ((FireMode[0] == none || !FireMode[0].bIsFiring) && (FireMode[1] == none || !FireMode[1].bIsFiring))
                {
                        PlayIdle();
                }
        }
}

// Overriden to handle the stop firing anims especially for the STG
simulated event StopFire(int Mode)
{
    if (FireMode[Mode].bIsFiring)
            FireMode[Mode].bInstantStop = true;

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
                ZeroFlashCount(Mode);
}

//=============================================================================
// overridden to make ironsights key undeploy bipod instead, if bipod deployed
//=============================================================================

simulated function ROIronSights()
{
 if (!Instigator.bBipodDeployed)
 {
    if (bUsingSights)
    {
        PerformZoom(false);
    }
    else
    {
        PerformZoom(true);
    }
 }
 else
 {
     ForceUndeploy();
 }
}


// returns true if this weapon should use free-aim in this particular state
simulated function bool ShouldUseFreeAim()
{
    if (FireMode[1].bMeleeMode && FireMode[1].IsFiring())
    {
        return false;
    }

    if (bUsesFreeAim && !(bUsingSights || Instigator.bBipodDeployed))
    {
        return true;
    }

    return false;
}

simulated function PlayIdle()
{

    if (Instigator.bBipodDeployed)
    {
        LoopAnim(SightUpIronIdleAnim, IdleAnimRate, 0.2);
    }
    else if (bUsingSights)
    {
        if (bWaitingToBolt && HasAnim(PostFireIronIdleAnim))
        {
            LoopAnim(PostFireIronIdleAnim, IdleAnimRate, 0.2);
        }
        else if (AmmoAmount(0) < 1 && HasAnim(IronIdleEmptyAnim))
        {
            LoopAnim(IronIdleEmptyAnim, IdleAnimRate, 0.2);
        }
        else
        {
            LoopAnim(IronIdleAnim, IdleAnimRate, 0.2);
        }
    }
    else
    {
        if (bWaitingToBolt && HasAnim(PostFireIdleAnim))
        {
            LoopAnim(PostFireIdleAnim, IdleAnimRate, 0.2);
        }
        else if (AmmoAmount(0) < 1 && HasAnim(IdleEmptyAnim))
        {
            LoopAnim(IdleEmptyAnim, IdleAnimRate, 0.2);
        }
        else
        {
            LoopAnim(IdleAnim, IdleAnimRate, 0.2);
        }
    }
}

// Take the weapon out of iron sights if you jump
simulated function NotifyOwnerJumped()
{
    if (!Instigator.bBipodDeployed)
    {
        super.NotifyOwnerJumped();
    }
    else if (!IsBusy() || IsInState('DeployingBipod'))
    {
        if (Instigator.bBipodDeployed)
        {
            BipodDeploy(false);

            if (Role < ROLE_Authority)
                ServerBipodDeploy(false);
        }
    }
}

function ServerRequestReload()
{
    if (AllowReload())
    {
        if (Instigator.bBipodDeployed)
        {
            GotoState('ReloadingBipod');
            ClientDoReload();
        }
        else
        {
            super.ServerRequestReload();
        }
    }
    else
    {
        // if we can't reload
        ClientCancelReload();
    }
}

simulated function ClientDoReload(optional int NumRounds)
{
    if (Instigator.bBipodDeployed)
    {
        GotoState('ReloadingBipod');
    }
    else
    {
        super.ClientDoReload();
    }
}

simulated state ReloadingBipod extends Busy
{
    simulated function bool ReadyToFire(int Mode)
    {
        return false;
    }

    simulated function bool ShouldUseFreeAim()
    {
        return false;
    }

    simulated function bool WeaponAllowSprint()
    {
        return false;
    }

    simulated function bool CanStartCrawlMoving()
    {
        return false;
    }

    simulated function bool WeaponAllowProneChange()
    {
        return false;
    }

    simulated function bool WeaponAllowCrouchChange()
    {
        return false;
    }

    simulated function Timer()
    {
        GotoState('Idle');
    }

        simulated function BeginState()
        {
        if (Role == ROLE_Authority)
        {
            ROPawn(Instigator).HandleStandardReload();
        }
        PlayReload();

        ResetPlayerFOV();
        }

        simulated function EndState()
        {
            if (Role == ROLE_Authority)
               PerformReload();

            bWaitingToBolt = false;

            if (Instigator.bBipodDeployed && Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
            {
                DisplayFOV = IronSightDisplayFOV;
//              bUsingSights=true;
            }

            if (Role == ROLE_Authority)
            {
                if (CurrentMagCount != (MaxNumPrimaryMags - 1))
                {
                    ROPawn(Instigator).bWeaponNeedsResupply = true;
                }
                else
                {
                    ROPawn(Instigator).bWeaponNeedsResupply = false;
                }
            }

            SetPlayerFOV(PlayerIronsightFOV);
        }

// Take the player out of iron sights if they are in ironsights
Begin:
    if (Instigator.bBipodDeployed && Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
    {
        if (DisplayFOV != default.DisplayFOV)
        {
            SmoothZoom(false);
        }

        if (AmmoAmount(0) < 1 && HasAnim(MagEmptyReloadAnim))
        {
            Sleep(((GetAnimDuration(SightUpMagEmptyReloadAnim, 1.0)) * 1.0) - (default.ZoomInTime + default.ZoomOutTime));
        }
        else
        {
            Sleep(((GetAnimDuration(SightUpMagPartialReloadAnim, 1.0)) * 1.0) - (default.ZoomInTime + default.ZoomOutTime));
        }

        SetPlayerFOV(PlayerIronsightFOV);

        SmoothZoom(true);
    }
}

simulated function PlayReload()
{
    local name Anim;
    local float AnimTimer;

    if (AmmoAmount(0) > 0)
        {
        if (Instigator.bBipodDeployed && HasAnim(SightUpMagPartialReloadAnim))
        {
            Anim = SightUpMagPartialReloadAnim;
        }
        else
        {
            Anim = MagPartialReloadAnim;
        }
    }
    else
    {
        if (Instigator.bBipodDeployed && HasAnim(SightUpMagEmptyReloadAnim))
        {
        Anim = SightUpMagEmptyReloadAnim;
        }
        else
        {
        Anim = MagEmptyReloadAnim;
        }
    }

        AnimTimer = GetAnimDuration(Anim, 1.0) + FastTweenTime;

    if (Level.NetMode == NM_DedicatedServer || (Level.NetMode == NM_ListenServer && !Instigator.IsLocallyControlled()))
        SetTimer(AnimTimer - (AnimTimer * 0.1), false);
    else
        SetTimer(AnimTimer, false);

    if (Instigator.IsLocallyControlled())
    {
        PlayAnim(Anim, 1.0, FastTweenTime);
    }
}

// Overridden to allow resupply after a non-regular reload
simulated state Reloading
{
    simulated function EndState()
    {
        super.EndState();

        if (Role == ROLE_Authority)
        {
            if (CurrentMagCount != (MaxNumPrimaryMags - 1))
            {
                ROPawn(Instigator).bWeaponNeedsResupply = true;
            }
            else
            {
                ROPawn(Instigator).bWeaponNeedsResupply = false;
            }
        }
    }
}

// Following functions borrowed and modified from ROBipodDeploy to allow
// normal bipod behaviour on a regular auto weapon - PsYcH0_Ch!cKeN

simulated exec function Deploy()
{
    if (IsBusy())
        return;

    if (Instigator.bBipodDeployed)
    {
        BipodDeploy(false);

        if (Role < ROLE_Authority)
            ServerBipodDeploy(false);
    }
    else if (Instigator.bCanBipodDeploy)
    {
        BipodDeploy(true);

        if (Role < ROLE_Authority)
            ServerBipodDeploy(true);
    }
}

// Forces the bipod to undeploy when needed
simulated function ForceUndeploy()
{
    if (IsBusy())
        return;

    if (Instigator.bBipodDeployed)
    {
        BipodDeploy(false);

        if (Role < ROLE_Authority)
            ServerBipodDeploy(false);
    }
}

// Called by the client on the server
simulated function BipodDeploy(bool bNewDeployedStatus)
{
    ROPawn(Instigator).SetBipodDeployed(bNewDeployedStatus);

    if (bNewDeployedStatus)
    {
        GotoState('DeployingBipod');
    }
    else
    {
        GotoState('UndeployingBipod');
    }
}

function ServerBipodDeploy(bool bNewDeployedStatus)
{
    if (Instigator.bCanBipodDeploy)
        BipodDeploy(bNewDeployedStatus);
}

simulated state DeployingBipod extends Busy
{
    simulated function bool ReadyToFire(int Mode)
    {
        return false;
    }

    simulated function bool ShouldUseFreeAim()
    {
        return false;
    }

    simulated function bool WeaponAllowSprint()
    {
        return false;
    }

    // This is to stop players from using crouch while deployed, as that allows an exploit
    // where a player can see and shoot over obstacles whilst being invisible to their targets.
    // Players can still use crouch to undeploy instantly while proned however - PsYcH0_CH!cKeN
    simulated function bool WeaponAllowCrouchChange()
    {
        if (Instigator.bBipodDeployed && !Instigator.bIsCrawling)
            return false;
        else
            return true;
    }

    simulated function Timer()
    {
        GotoState('Idle');
    }

    simulated function BeginState()
    {
        local name Anim;
        local float AnimTimer;

        if (bUsingSights)
        {
            Anim = SightUpIronBringUp;
        }
        else if (AmmoAmount(0) < 1 && HasAnim(IdleToBipodDeployEmpty))
        {
            Anim = IdleToBipodDeployEmpty;
        }
        else
        {
            Anim = SightUpIronBringUp;
        }

        if (Instigator.IsLocallyControlled())
        {
            PlayAnim(Anim, IronSwitchAnimRate, FastTweenTime);
        }

        AnimTimer = GetAnimDuration(Anim, IronSwitchAnimRate) + FastTweenTime;

        if (Level.NetMode == NM_DedicatedServer || (Level.NetMode == NM_ListenServer && !Instigator.IsLocallyControlled()))
            SetTimer(AnimTimer - (AnimTimer * 0.1), false);
        else
            SetTimer(AnimTimer, false);

        SetPlayerFOV(PlayerIronsightFOV);
    }

    simulated function EndState()
    {
        local float TargetDisplayFOV;
        local vector TargetPVO;

        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            if (ScopeDetail == RO_ModelScopeHigh)
            {
                TargetDisplayFOV = default.IronSightDisplayFOVHigh;
                TargetPVO = default.XoffsetHighDetail;
            }
            else if (ScopeDetail == RO_ModelScope)
            {
                TargetDisplayFOV = default.IronSightDisplayFOV;
                TargetPVO = default.XoffsetScoped;
            }
            else
            {
                TargetDisplayFOV = default.IronSightDisplayFOV;
                TargetPVO = default.PlayerViewOffset;
            }

            DisplayFOV = TargetDisplayFOV;
            PlayerViewOffset = TargetPVO;

        }
    }

Begin:
    if (bUsingSights)
    {
        if (Role == ROLE_Authority)
            ServerZoomOut(false);
        else
        {
            ZoomOut(false);
        }

        SetPlayerFOV(PlayerIronsightFOV);
    }

    if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
    {
        // Later this will be a latent function to zoom
        SmoothZoom(true);
        //DisplayFOV = IronSightDisplayFOV;
    }
}

simulated state UndeployingBipod extends Busy
{
    simulated function bool ReadyToFire(int Mode)
    {
        return false;
    }

    simulated function bool ShouldUseFreeAim()
    {
        return false;
    }

    simulated function bool WeaponAllowSprint()
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
        local float AnimTimer;

        if (AmmoAmount(0) < 1 && HasAnim(BipodDeployToIdleEmpty))
        {
            Anim = BipodDeployToIdleEmpty;
        }
        else
        {
            Anim = SightUpIronPutDown;
        }

        if (Instigator.IsLocallyControlled())
        {
            PlayAnim(Anim, IronSwitchAnimRate, FastTweenTime);
        }

        AnimTimer = GetAnimDuration(Anim, IronSwitchAnimRate) + FastTweenTime;

        if (Level.NetMode == NM_DedicatedServer || (Level.NetMode == NM_ListenServer && !Instigator.IsLocallyControlled()))
            SetTimer(AnimTimer - (AnimTimer * 0.1), false);
        else
            SetTimer(AnimTimer, false);

        ResetPlayerFOV();
    }

    simulated function EndState()
    {
        if (Instigator.bIsCrawling && VSizeSquared(Instigator.Velocity) > 1.0)
            NotifyCrawlMoving();

        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            DisplayFOV = default.DisplayFOV;
            PlayerViewOffset = default.PlayerViewOffset;
        }
    }
Begin:
    if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
    {
        SmoothZoom(false);
        //DisplayFOV = default.DisplayFOV;
    }
}

defaultproperties
{
    SightUpIronBringUp="SightUp_iron_in"
    SightUpIronPutDown="SightUp_iron_out"
    SightUpIronIdleAnim="SightUp_iron_idle"
    SightUpMagEmptyReloadAnim="sightup_reload_empty"
    SightUpMagPartialReloadAnim="sightup_reload_half"
    MagEmptyReloadAnim="reload_empty"
    MagPartialReloadAnim="reload_half"
    IronIdleAnim="Iron_idle"
    IronBringUp="iron_in"
    IronPutDown="iron_out"
    bPlusOneLoading=true
    CrawlForwardAnim="crawlF"
    CrawlBackwardAnim="crawlB"
    CrawlStartAnim="crawl_in"
    CrawlEndAnim="crawl_out"
    IronSightDisplayFOV=35.000000
    ZoomInTime=0.400000
    ZoomOutTime=0.100000
    SelectAnim="Draw"
    PutDownAnim="putaway"
    SelectAnimRate=1.000000
    PutDownAnimRate=1.000000
    SelectForce="SwitchToAssaultRifle"
    AIRating=0.700000
    CurrentRating=0.700000
    bSniping=true
    DisplayFOV=70.000000
    bCanRestDeploy=true
    bCanBipodDeploy=true
    BobDamping=1.600000
}
