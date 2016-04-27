//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHAutoWeapon extends DHProjectileWeapon
    abstract;

var     name    SelectFireAnim;            // animation for selecting the firing mode
var     name    SelectFireIronAnim;        // animation for selecting the firing mode in ironsights
var     name    SightUpSelectFireIronAnim; // animation for selecting the firing mode in ironsights

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerChangeFireMode;
}

// New function to toggle between semi-auto & full auto fire
simulated exec function SwitchFireMode()
{
    if (bHasSelectFire && !IsBusy() && !FireMode[0].bIsFiring && !FireMode[1].bIsFiring)
    {
        GotoState('SwitchingFireMode');
    }
}

simulated state SwitchingFireMode extends WeaponBusy
{
    simulated function BeginState()
    {
        local name Anim;

        if (bUsingSights || Instigator.bBipodDeployed)
        {
            if (Instigator.bBipodDeployed && HasAnim(SightUpSelectFireIronAnim))
            {
                Anim = SightUpSelectFireIronAnim;
            }
            else
            {
                Anim = SelectFireIronAnim;
            }
        }
        else
        {
            Anim = SelectFireAnim;
        }

        PlayAnimAndSetTimer(Anim, 1.0);

        ToggleFireMode();

        if (Role < ROLE_Authority)
        {
            ServerChangeFireMode();
        }
    }
}

// New function to toggle the fire mode - allows subclassing for weapons that do something different, e.g. BAR toggles between slow/fast fire mode
simulated function ToggleFireMode()
{
    if (bHasSelectFire)
    {
        FireMode[0].bWaitForRelease = !FireMode[0].bWaitForRelease;
    }
}

// Client to server function to toggle the fire mode
function ServerChangeFireMode()
{
    ToggleFireMode();
}

// Modified so the HUD weapon/ammo icon can display whether weapon is in semi-auto or full auto fire mode
simulated function bool UsingAutoFire()
{
    return !FireMode[0].bWaitForRelease;
}

// Modified to handle the stop firing animations
simulated event StopFire(int Mode)
{
    if (FireMode[Mode].bIsFiring)
    {
        FireMode[Mode].bInstantStop = true;
    }

    if (InstigatorIsLocallyControlled() && !FireMode[Mode].bFireOnRelease && !IsAnimating(0))
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

// Modified to check for FireLoop state instead of bIsFiring
simulated function ZoomIn(optional bool bAnimateTransition)
{
    // Make the player stop firing when they go to ironsights
    if (FireMode[0].IsInState('FireLoop'))
    {
        FireMode[0].GotoState('');
    }

    // Don't allow player to go to ironsights while in melee mode
    if (FireMode[1].bIsFiring || FireMode[1].IsInState('MeleeAttacking'))
    {
        return;
    }

    if (InstigatorIsLocalHuman())
    {
        SetPlayerFOV(PlayerIronsightFOV);
    }

    if (bAnimateTransition)
    {
        GotoState('IronSightZoomIn');
    }

    bUsingSights = true;

    if (ROPawn(Instigator) != none)
    {
        ROPawn(Instigator).SetIronSightAnims(true);
    }
}

// Modified to stop the weapon firing if player transitions from ironsights
simulated function ZoomOut(optional bool bAnimateTransition)
{
    if (FireMode[0].IsInState('FireLoop'))
    {
        FireMode[0].GotoState('');
    }

    super.ZoomOut(bAnimateTransition);
}

// Modified to stop the weapon firing if you jump
simulated function NotifyOwnerJumped()
{
    if (FireMode[0].IsInState('FireLoop'))
    {
        FireMode[0].GotoState('');
    }

    super.NotifyOwnerJumped();
}

// Modified to prevent auto weapons from playing fire end anims while still firing
simulated function AnimEnd(int Channel)
{
    local name  Anim;
    local float Frame, Rate;

    if (ClientState == WS_ReadyToFire)
    {
        GetAnimParams(0, Anim, Frame, Rate);

        // Don't play the idle anim after a bayo strike or bash
        if (FireMode[1].bMeleeMode && ROWeaponFire(FireMode[1]) != none &&
            (Anim == ROWeaponFire(FireMode[1]).BashAnim || Anim == ROWeaponFire(FireMode[1]).BayoStabAnim || Anim == ROWeaponFire(FireMode[1]).BashEmptyAnim))
        {
            // do nothing;
        }
        else if (Anim == FireMode[0].FireAnim && HasAnim(FireMode[0].FireEndAnim) && (!FireMode[0].bIsFiring || !UsingAutoFire()))
        {
            PlayAnim(FireMode[0].FireEndAnim, FireMode[0].FireEndAnimRate, FastTweenTime);
        }
        else if (DHProjectileFire(FireMode[0]) != none && Anim == DHProjectileFire(FireMode[0]).FireIronAnim && (!FireMode[0].bIsFiring || !UsingAutoFire()))
        {
            PlayIdle();
        }
        else if (Anim == FireMode[1].FireAnim && HasAnim(FireMode[1].FireEndAnim))
        {
            PlayAnim(FireMode[1].FireEndAnim, FireMode[1].FireEndAnimRate, 0.0);
        }
        else if ((FireMode[0] == none || !FireMode[0].bIsFiring) && (FireMode[1] == none || !FireMode[1].bIsFiring))
        {
            PlayIdle();
        }
    }
}

// Tells bot whether to charge or back off while using this weapon
function float SuggestAttackStyle()
{
    return 0.5;
}

// Tells bot whether to charge or back off while defending against this weapon
function float SuggestDefenseStyle()
{
    return -0.4;
}

defaultproperties
{
    bCanAttachOnBack=true
}
