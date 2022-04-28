//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHBipodWeapon extends DHProjectileWeapon
    abstract;

// Animations for bipod mounted weapon hipped and deployed states
var     name    IdleToBipodDeploy;      // anim for bipod rest state to deployed state
var     name    BipodDeployToIdle;      // anim for bipod deployed state to rest state
var     name    BipodIdleToHip;         // anim for bipod rest state to hip state
var     name    BipodHipToIdle;         // anim for bipod hip state to rest state
var     name    BipodHipIdle;           // anim for idle bipod hip state
var     name    BipodHipToDeploy;       // anim for bipod hip state to deployed state
var     name    BipodDeployToHip;       // anim for bipod deployed state to hip state
var     name    IdleToBipodDeployEmpty; // anim for bipod rest state to deployed empty state
var     name    BipodDeployToIdleEmpty; // anim for bipod deployed state to rest empty state

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerBipodDeploy;
}

// Modified to play BipodHipIdle animation on a server, instead of the usual IdleAnim, so that weapon will be in the right position for hip hire calculations
simulated function PostBeginPlay()
{
    super(DHWeapon).PostBeginPlay();

    if (Role == ROLE_Authority && !InstigatorIsLocallyControlled() && HasAnim(BipodHipIdle))
    {
        PlayAnim(BipodHipIdle, IdleAnimRate, 0.0);
    }
}

// Modified to prevent firing (with message) if neither ironsighted or bipod deployed
simulated function Fire(float F)
{
    if (!bUsingSights && InstigatorIsHumanControlled() && !Instigator.bBipodDeployed)
    {
        class'ROBipodWarningMsg'.static.ClientReceive(PlayerController(Instigator.Controller), 0);
    }
    else
    {
        super.Fire(F);
    }
}

// Stop players from using crouch while deployed, as that allows exploit where player can see & shoot over obstacles whilst being invisible to their targets
// Players can still use crouch to undeploy instantly while proned however
simulated function bool WeaponAllowCrouchChange()
{
    return Instigator == none || !Instigator.bBipodDeployed || Instigator.bIsCrawling;
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

// Modified to deploy/undeploy bipod, instead of the usual bayonet stuff
simulated exec function Deploy()
{
    local DHPlayer PC;
    local bool bNewDeployedStatus;

    // Bipod is either deployed or player can deploy the bipod
    if (!IsBusy() && Instigator != none && (Instigator.bBipodDeployed || Instigator.bCanBipodDeploy))
    {
        if (Instigator.IsLocallyControlled())
        {
            PC = DHPlayer(Instigator.Controller);

            if (PC == none || Level.TimeSeconds < PC.NextToggleDuckTimeSeconds)
            {
                return;
            }
        }

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
        GotoState('UnDeployingBipod');
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

    simulated function bool WeaponAllowCrouchChange()
    {
        return false;
    }

    simulated function BeginState()
    {
        local name Anim;

        if (bUsingSights)
        {
            ZoomOut();
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

        PlayAnimAndSetTimer(Anim, IronSwitchAnimRate, 0.1);

        SetPlayerFOV(PlayerDeployFOV);
    }

    simulated function EndState()
    {
        SetIronSightFOV();
    }

Begin:
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
            PlayAnimAndSetTimer(BipodDeployToIdle, IronSwitchAnimRate, 0.1);
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

// Modified to handle animations for bipod deployed & firing from the hip
simulated function PlayIdle()
{
    if (Instigator != none && Instigator.bBipodDeployed)
    {
        if (AmmoAmount(0) < 1 && HasAnim(IronIdleEmptyAnim))
        {
            LoopAnim(IronIdleEmptyAnim, IdleAnimRate, 0.2);
        }
        else if (HasAnim(IronIdleAnim))
        {
            LoopAnim(IronIdleAnim, IdleAnimRate, 0.2);
        }
    }
    else if (bUsingSights && HasAnim(BipodHipIdle))
    {
        LoopAnim(BipodHipIdle, IdleAnimRate, 0.2);
    }
    else
    {
        if (AmmoAmount(0) < 1 && HasAnim(IdleEmptyAnim))
        {
            LoopAnim(IdleEmptyAnim, IdleAnimRate, 0.2);
        }
        else if (HasAnim(IdleAnim))
        {
            LoopAnim(IdleAnim, IdleAnimRate, 0.2);
        }
    }
}

// Modified to remove the special rendering for bipod weapons since they won't really sway while deployed
simulated event RenderOverlays(Canvas Canvas)
{
    local ROPawn   RPawn;
    local rotator  RollMod;
    local int      LeanAngle, i;

    if (Instigator == none)
    {
        return;
    }

    // Draw muzzle flashes/smoke for all fire modes so idle state won't cause emitters to just disappear
    Canvas.DrawActor(none, false, true);

    for (i = 0; i < NUM_FIRE_MODES; ++i)
    {
        FireMode[i].DrawMuzzleFlash(Canvas);
    }

    // Adjust weapon position for lean
    RPawn = ROPawn(Instigator);

    if (RPawn != none && RPawn.LeanAmount != 0.0)
    {
        LeanAngle += RPawn.LeanAmount;
    }

    SetLocation(Instigator.Location + Instigator.CalcDrawOffset(self));

    // Remove the roll component so the weapon doesn't tilt with the terrain
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

// Modified to prevent reload (with message) if bipod not deployed
simulated function bool AllowReload()
{
    if (Instigator == none || !Instigator.bBipodDeployed)
    {
        if (InstigatorIsHumanControlled())
        {
            class'ROBipodWarningMsg'.static.ClientReceive(PlayerController(Instigator.Controller), 1);
        }

        return false;
    }

    return super.AllowReload();
}

// Modified to prevent firing unless ironsighted or bipod deployed
simulated function bool ReadyToFire(int Mode)
{
    if (bUsingSights || (Instigator != none && Instigator.bBipodDeployed))
    {
        return super.ReadyToFire(Mode);
    }
}

// Modified to stop player from changing prone or crouch state while reloading & to take player out of ironsights & back in afterwards
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

    simulated function BeginState()
    {
        super.BeginState();

        ResetPlayerFOV();
    }

// Take the player out of zoom & then zoom them back in
Begin:
    if (InstigatorIsLocalHuman())
    {
        if (DisplayFOV != default.DisplayFOV)
        {
            SmoothZoom(false);
        }

        if (AmmoAmount(0) < 1 && HasAnim(MagEmptyReloadAnims[0]))
        {
            Sleep(GetAnimDuration(MagEmptyReloadAnims[Rand(MagEmptyReloadAnims.Length)], 1.0) - default.ZoomInTime - default.ZoomOutTime);
        }
        else
        {
            Sleep(GetAnimDuration(MagPartialReloadAnims[Rand(MagPartialReloadAnims.Length)], 1.0) - default.ZoomInTime - default.ZoomOutTime);
        }

        SetPlayerFOV(PlayerDeployFOV);

        SmoothZoom(true);
    }
}

// Modified to stop player from changing prone or crouch state (while client is waiting for an action to be verified by the server)
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

defaultproperties
{
    Priority=10
    bCanBipodDeploy=true
    bCanRestDeploy=false
    PlayerDeployFOV=60.0

    IronBringUp="Rest_2_Bipod"
    IronPutDown="Bipod_2_Rest"
    IdleAnim="Rest_Idle"
    IronIdleAnim="Bipod_Idle"
    IdleToBipodDeploy="Rest_2_Bipod"
    BipodDeployToIdle="Bipod_2_Rest"
    MagEmptyReloadAnims(0)="Reload"

    AIRating=0.4
    CurrentRating=0.4
    bSniping=true
}
