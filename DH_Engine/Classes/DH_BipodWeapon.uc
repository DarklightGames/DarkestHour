//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_BipodWeapon extends DH_ProjectileWeapon
    abstract;

// Animations for bipod mounted weapon hipped and deployed states
var     name            IdleToBipodDeploy;          // anim for bipod rest state to deployed state
var     name            BipodDeployToIdle;          // anim for bipod deployed state to rest state
var     name            BipodIdleToHip;             // anim for bipod rest state to hip state
var     name            BipodHipToIdle;             // anim for bipod hip state to rest state
var     name            BipodHipIdle;               // anim for idle bipod hip state
var     name            BipodHipToDeploy;           // anim for bipod hip state to deployed state
var     name            BipodDeployToHip;           // anim for bipod deployed state to hip state

var     name            IdleToBipodDeployEmpty;     // anim for bipod rest state to deployed empty state
var     name            BipodDeployToIdleEmpty;     // anim for bipod deployed state to rest empty state

replication
{
    reliable if (Role < ROLE_Authority)
        ServerBipodDeploy;
}

simulated state Idle
{
    // This is to stop players from using crouch while deployed, as that allows exploit where player can see & shoot over obstacles whilst being invisible to their targets
    // Players can still use crouch to undeploy instantly while proned however - PsYcH0_CH!cKeN
    simulated function bool WeaponAllowCrouchChange()
    {
        if (Instigator.bBipodDeployed && !Instigator.bIsCrawling)
        {
            return false;
        }
        else
        {
            return true;
        }
    }
}

simulated function Fire(float F)
{
    if (Instigator != none)
    {
        if (!(bUsingSights || Instigator.bBipodDeployed) && Instigator.Controller != none && PlayerController(Instigator.Controller) != none)
        {
            class'ROBipodWarningMsg'.Static.ClientReceive(PlayerController(Instigator.Controller), 0);
        }
        else
        {
            super.Fire(F);
        }
    }
    else
    {
        super.Fire(F);
    }
}

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
            {
                ServerBipodDeploy(false);
            }
        }
    }
}

// Switch deployment status
simulated exec function Deploy()
{
    if (IsBusy())
    {
        return;
    }

    if (Instigator.bBipodDeployed)
    {
        BipodDeploy(false);

        if (Role < ROLE_Authority)
        {
            ServerBipodDeploy(false);
        }
    }
    else if (Instigator.bCanBipodDeploy)
    {
        BipodDeploy(true);

        if (Role < ROLE_Authority)
        {
            ServerBipodDeploy(true);
        }
    }
}

// Forces the bipod to undeploy when needed
simulated function ForceUndeploy()
{
    if (IsBusy())
    {
        return;
    }

    if (Instigator.bBipodDeployed)
    {
        BipodDeploy(false);

        if (Role < ROLE_Authority)
        {
            ServerBipodDeploy(false);
        }
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
        GotoState('UnDeployingBipod');
    }
}

function ServerBipodDeploy(bool bNewDeployedStatus)
{
    if (Instigator.bCanBipodDeploy)
    {
        BipodDeploy(bNewDeployedStatus);
    }
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

    // This is to stop players from using crouch while deployed, as that allows exploit where player can see & shoot over obstacles whilst being invisible to their targets
    // Players can still use crouch to undeploy instantly while proned however - PsYcH0_CH!cKeN
    simulated function bool WeaponAllowCrouchChange()
    {
        if (Instigator.bBipodDeployed && !Instigator.bIsCrawling)
        {
            return false;
        }
        else
        {
            return true;
        }
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
            Anim = BipodHipToDeploy;
        }
        else if (AmmoAmount(0) < 1 && HasAnim(IdleToBipodDeployEmpty))
        {
            Anim = IdleToBipodDeployEmpty;
        }
        else
        {
            Anim = IdleToBipodDeploy;
        }

        if (Instigator.IsLocallyControlled())
        {
            PlayAnim(Anim, IronSwitchAnimRate, FastTweenTime);
        }

        AnimTimer = GetAnimDuration(Anim, IronSwitchAnimRate) + FastTweenTime;

        if (Level.NetMode == NM_DedicatedServer || (Level.NetMode == NM_ListenServer && !Instigator.IsLocallyControlled()))
        {
            SetTimer(AnimTimer - (AnimTimer * 0.1), false);
        }
        else
        {
            SetTimer(AnimTimer, false);
        }

        SetPlayerFOV(PlayerDeployFOV);
    }

    simulated function EndState()
    {
        local float  TargetDisplayFOV;
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
        {
            ServerZoomOut(false);
        }
        else
        {
            ZoomOut(false);
        }
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
        local name  Anim;
        local float AnimTimer;

        if (AmmoAmount(0) < 1 && HasAnim(BipodDeployToIdleEmpty))
        {
            Anim = BipodDeployToIdleEmpty;
        }
        else
        {
            Anim = BipodDeployToIdle;
        }

        if (Instigator.IsLocallyControlled())
        {
            PlayAnim(Anim, IronSwitchAnimRate, FastTweenTime);
        }

        AnimTimer = GetAnimDuration(Anim, IronSwitchAnimRate) + FastTweenTime;

        if (Level.NetMode == NM_DedicatedServer || (Level.NetMode == NM_ListenServer && !Instigator.IsLocallyControlled()))
        {
            SetTimer(AnimTimer - (AnimTimer * 0.1), false);
        }
        else
        {
            SetTimer(AnimTimer, false);
        }

        ResetPlayerFOV();
    }

    simulated function EndState()
    {
        if (Instigator.bIsCrawling && VSizeSquared(Instigator.Velocity) > 1.0)
        {
            NotifyCrawlMoving();
        }

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

simulated function PlayIdle()
{
    if (Instigator.bBipodDeployed)
    {
        LoopAnim(IronIdleAnim, IdleAnimRate, 0.2);
    }
    else if (bUsingSights)
    {
        LoopAnim(BipodHipIdle, IdleAnimRate, 0.2);
    }
    else
    {
        LoopAnim(IdleAnim, IdleAnimRate, 0.2);
    }
}

//=============================================================================
// Rendering
//=============================================================================
// Don't need to do the special rendering for bipod weapons since they won't really sway while deployed
simulated event RenderOverlays(Canvas Canvas)
{
    local int      m;
    local rotator  RollMod;
    local ROPlayer Playa;
    local ROPawn   RPawn;
    local int      LeanAngle;

    if (Instigator == none)
    {
        return;
    }

    // Lets avoid having to do multiple casts every tick - Ramm
    Playa = ROPlayer(Instigator.Controller);

    // Draw muzzleflashes/smoke for all fire modes so idle state won't cause emitters to just disappear
    Canvas.DrawActor(none, false, true);

    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if (FireMode[m] != none)
        {
            FireMode[m].DrawMuzzleFlash(Canvas);
        }
    }

    // Adjust weapon position for lean
    RPawn = ROPawn(Instigator);

    if (RPawn != none && RPawn.LeanAmount != 0.0)
    {
        LeanAngle += RPawn.LeanAmount;
    }

    SetLocation(Instigator.Location + Instigator.CalcDrawOffset(self));

    RollMod = Instigator.GetViewRotation();
    RollMod.Roll += LeanAngle;

    if (IsCrawling())
    {
        RollMod.Pitch = CrawlWeaponPitch;
    }

    SetRotation(RollMod);

    bDrawingFirstPerson = true;
    Canvas.DrawActor(self, false, false, DisplayFOV);
    bDrawingFirstPerson = false;
}

//=============================================================================
// Reloading/Ammunition
//=============================================================================
simulated function bool AllowReload()
{
    if (!Instigator.bBipodDeployed && Instigator.Controller != none && PlayerController(Instigator.Controller) != none)
    {
        class'ROBipodWarningMsg'.Static.ClientReceive(PlayerController(Instigator.Controller), 1);
    }

    if (IsFiring() || IsBusy() || !Instigator.bBipodDeployed)
    {
        return false;
    }

    // Can't reload if we don't have a mag to put in
    if (CurrentMagCount < 1)
    {
        return false;
    }

    return true;
}

// Overridden to support bipod weapon firing functionality
simulated function bool ReadyToFire(int Mode)
{
    if (!bUsingSights && !Instigator.bBipodDeployed)
    {
        return false;
    }

    return super.ReadyToFire(Mode);
}

simulated state Reloading
{
    simulated function bool WeaponAllowProneChange()
    {
        return false;
    }

    simulated function bool WeaponAllowCrouchChange()
    {
        return false;
    }

// Take the player out of zoom and then zoom them back in
Begin:
    if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
    {
        if (DisplayFOV != default.DisplayFOV)
        {
            SmoothZoom(false);
        }

        if (AmmoAmount(0) < 1 && HasAnim(MagEmptyReloadAnim))
        {
            Sleep(((GetAnimDuration(MagEmptyReloadAnim, 1.0)) * 1.0) - (default.ZoomInTime + default.ZoomOutTime));
        }
        else
        {
            Sleep(((GetAnimDuration(MagPartialReloadAnim, 1.0)) * 1.0) - (default.ZoomInTime + default.ZoomOutTime));
        }

        SetPlayerFOV(PlayerDeployFOV);

        SmoothZoom(true);
    }
}

// Client gets sent to this state when the client has requested an action that needs verified by the server
// Once the server verifies they can start the action, the server will take the client out of this state
simulated state PendingAction
{
    simulated function bool WeaponAllowProneChange()
    {
        return false;
    }

    simulated function bool WeaponAllowCrouchChange()
    {
        return false;
    }
}

//=============================================================================
// Sprinting
//=============================================================================
simulated state StartSprinting
{
// Take the player out of iron sights if they are in ironsights
Begin:
    if (bUsingSights)
    {
        if (Role == ROLE_Authority)
        {
            ServerZoomOut(false);
        }
        else
        {
            ZoomOut(false);
        }

        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }

            SmoothZoom(false);
        }
    }
    else if (DisplayFOV != default.DisplayFOV && Instigator.IsLocallyControlled())
    {
        SmoothZoom(false);
    }
}

simulated state StartCrawling
{
// Take the player out of iron sights if they are in ironsights
Begin:
    if (bUsingSights)
    {
        if (Role == ROLE_Authority)
        {
            ServerZoomOut(false);
        }
        else
        {
            ZoomOut(false);
        }

        if (Instigator.IsLocallyControlled() && Instigator.IsHumanControlled())
        {
            if (bPlayerFOVZooms)
            {
                PlayerViewZoom(false);
            }

            SmoothZoom(false);
        }
    }
    else if (DisplayFOV != default.DisplayFOV && Instigator.IsLocallyControlled())
    {
        SmoothZoom(false);
    }
}

defaultproperties
{
    PlayerDeployFOV=60.0
    Priority=10
    bCanBipodDeploy=true
}
