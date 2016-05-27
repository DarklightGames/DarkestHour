//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHBipodAutoWeapon extends DHAutoWeapon
    abstract;

var     name    SightUpIronBringUp;
var     name    SightUpIronPutDown;
var     name    SightUpIronIdleAnim;
var     name    SightUpMagEmptyReloadAnim;
var     name    SightUpMagPartialReloadAnim;

var     name    IdleToBipodDeployEmpty; // anim for bipod rest state to deployed empty state
var     name    BipodDeployToIdleEmpty; // anim for bipod deployed state to rest empty state

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerBipodDeploy;
}

// Modified to prevent melee attacks while deployed
simulated event ClientStartFire(int Mode)
{
    if (!FireMode[Mode].bMeleeMode || !(Instigator != none && Instigator.bBipodDeployed))
    {
        super.ClientStartFire(Mode);
    }
}

// Stop players from using crouch while deployed, as that allows exploit where player can see & shoot over obstacles whilst being invisible to their targets
// Players can still use crouch to undeploy instantly while proned however
simulated function bool WeaponAllowCrouchChange()
{
    return Instigator == none || !Instigator.bBipodDeployed || Instigator.bIsCrawling;
}

// Overridden to make ironsights key undeploy bipod instead, if bipod deployed
simulated function ROIronSights()
{
    if (Instigator != none && Instigator.bBipodDeployed)
    {
        ForceUndeploy();
    }
    else
    {
        PerformZoom(!bUsingSights);
    }
}

// Modified so no free aim if bipod is deployed
simulated function bool ShouldUseFreeAim()
{
    return super.ShouldUseFreeAim() && !(Instigator != none && Instigator.bBipodDeployed);
}

// Modified to add bipod deployed animation
simulated function PlayIdle()
{
    if (Instigator != none && Instigator.bBipodDeployed && HasAnim(SightUpIronIdleAnim))
    {
        LoopAnim(SightUpIronIdleAnim, IdleAnimRate, 0.2);
    }
    else
    {
        super.PlayIdle();
    }
}

// Modified to take the weapon out of bipod deployed if you jump
simulated function NotifyOwnerJumped()
{
    if (Instigator != none && Instigator.bBipodDeployed)
    {
        if (!IsBusy() || IsInState('DeployingBipod'))
        {
            BipodDeploy(false);

            if (Role < ROLE_Authority)
            {
                ServerBipodDeploy(false);
            }
        }
    }
    else
    {
        super.NotifyOwnerJumped();
    }
}

// Modified to use special ReloadingBipod state if bipod deployed
function ServerRequestReload()
{
    if (AllowReload())
    {
        if (Instigator != none && Instigator.bBipodDeployed)
        {
            GotoState('ReloadingBipod');
        }
        else
        {
            GotoState('Reloading');
        }

        ClientDoReload();
    }
    else
    {
        ClientCancelReload();
    }
}

// Modified to use special ReloadingBipod state if bipod deployed
simulated function ClientDoReload(optional byte NumRounds)
{
    if (Instigator != none && Instigator.bBipodDeployed)
    {
        GotoState('ReloadingBipod');
    }
    else
    {
        GotoState('Reloading');
    }
}

// New state for reloading with bipod deployed
simulated state ReloadingBipod extends Reloading
{
    simulated function bool WeaponAllowProneChange()
    {
        return false;
    }

    simulated function bool WeaponAllowCrouchChange()
    {
        return false;
    }

    simulated function BeginState()
    {
        super.BeginState();

        ResetPlayerFOV();
    }

    simulated function EndState()
    {
        super.EndState();

        if (InstigatorIsLocalHuman() && Instigator.bBipodDeployed)
        {
            DisplayFOV = IronSightDisplayFOV;
        }
    }

// Take the player out of zoom & then zoom them back in
Begin:
    if (InstigatorIsLocalHuman() && Instigator.bBipodDeployed)
    {
        if (DisplayFOV != default.DisplayFOV)
        {
            SmoothZoom(false);
        }

        if (AmmoAmount(0) < 1 && HasAnim(SightUpMagEmptyReloadAnim))
        {
            Sleep(GetAnimDuration(SightUpMagEmptyReloadAnim, 1.0) - default.ZoomInTime - default.ZoomOutTime);
        }
        else
        {
            Sleep(GetAnimDuration(SightUpMagPartialReloadAnim, 1.0) - default.ZoomInTime - default.ZoomOutTime);
        }

        SetPlayerFOV(PlayerIronsightFOV);
        SmoothZoom(true);
    }
}

simulated function PlayReload()
{
    local name Anim;

    if (AmmoAmount(0) > 0)
    {
        if (Instigator != none && Instigator.bBipodDeployed && HasAnim(SightUpMagPartialReloadAnim))
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
        if (Instigator != none && Instigator.bBipodDeployed && HasAnim(SightUpMagEmptyReloadAnim))
        {
            Anim = SightUpMagEmptyReloadAnim;
        }
        else
        {
            Anim = MagEmptyReloadAnim;
        }
    }

    PlayAnimAndSetTimer(Anim, 1.0, 0.1);
}

// Modified to deploy/undeploy bipod, instead of the usual bayonet stuff
simulated exec function Deploy()
{
    local bool bNewDeployedStatus;

    // Bipod is either deployed or player can deploy the bipod
    if (!IsBusy() && Instigator != none && (Instigator.bBipodDeployed || Instigator.bCanBipodDeploy))
    {
        bNewDeployedStatus = !Instigator.bBipodDeployed;

        BipodDeploy(bNewDeployedStatus); // toggle whether bipod is deployed

        if (Role < ROLE_Authority)
        {
            ServerBipodDeploy(bNewDeployedStatus);
        }
    }
}

// Forces the bipod to undeploy when needed
simulated function ForceUndeploy()
{
    if (!IsBusy() && Instigator != none && Instigator.bBipodDeployed)
    {
        BipodDeploy(false);

        if (Role < ROLE_Authority)
        {
            ServerBipodDeploy(false);
        }
    }
}

// Sets the deployed or undeployed state
simulated function BipodDeploy(bool bNewDeployedStatus)
{
    if (ROPawn(Instigator) != none)
    {
        ROPawn(Instigator).SetBipodDeployed(bNewDeployedStatus);
    }

    if (bNewDeployedStatus)
    {
        GotoState('DeployingBipod');
    }
    else
    {
        GotoState('UndeployingBipod');
    }
}

// Client-to-server function to set the deployed or undeployed state
function ServerBipodDeploy(bool bNewDeployedStatus)
{
    if (Instigator != none && Instigator.bCanBipodDeploy)
    {
        BipodDeploy(bNewDeployedStatus);
    }
}

simulated state DeployingBipod extends WeaponBusy
{
    simulated function bool WeaponAllowSprint()
    {
        return false;
    }

    simulated function BeginState()
    {
        local name Anim;

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

        PlayAnimAndSetTimer(Anim, IronSwitchAnimRate, 0.1);

        SetPlayerFOV(PlayerIronsightFOV);
    }

    simulated function EndState()
    {
        SetIronSightFOV();
    }

Begin:
    if (bUsingSights)
    {
        ZoomOut();
        SetPlayerFOV(PlayerIronsightFOV);
    }

    if (InstigatorIsLocalHuman())
    {
        SmoothZoom(true);
    }
}

simulated state UndeployingBipod extends WeaponBusy
{
    simulated function bool WeaponAllowSprint()
    {
        return false;
    }

    simulated function BeginState()
    {
        if (AmmoAmount(0) < 1 && HasAnim(BipodDeployToIdleEmpty))
        {
            PlayAnimAndSetTimer(BipodDeployToIdleEmpty, IronSwitchAnimRate, 0.1);
        }
        else
        {
            PlayAnimAndSetTimer(SightUpIronPutDown, IronSwitchAnimRate, 0.1);
        }

        ResetPlayerFOV();
    }

    simulated function EndState()
    {
        if (Instigator != none && Instigator.bIsCrawling && VSizeSquared(Instigator.Velocity) > 1.0)
        {
            NotifyCrawlMoving();
        }

        if (InstigatorIsLocalHuman())
        {
            DisplayFOV = default.DisplayFOV;
            PlayerViewOffset = default.PlayerViewOffset;
        }
    }
Begin:
    if (InstigatorIsLocalHuman())
    {
        SmoothZoom(false);
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
    IronSightDisplayFOV=35.0
    ZoomInTime=0.4
    ZoomOutTime=0.1
    SelectAnim="Draw"
    PutDownAnim="putaway"
    SelectAnimRate=1.0
    PutDownAnimRate=1.0
    AIRating=0.7
    CurrentRating=0.7
    bSniping=true
    DisplayFOV=70.0
    bCanRestDeploy=true
    bCanBipodDeploy=true
    BobDamping=1.6
}
