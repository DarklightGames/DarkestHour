//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHAutoWeapon extends DHProjectileWeapon
    abstract;

var     name    SelectFireAnim;
var     name    SelectFireEmptyAnim;
var     name    SelectFireIronAnim;
var     name    SelectFireIronEmptyAnim;
var     name    SelectFireBipodIronAnim;
var     name    SelectFireBipodIronEmptyAnim;

// Sound effect for the fire selector switch (in case it's not handled by the animation).
var     sound   SelectFireSound;
var     float   SelectFireVolume;

// Fire select switch
var     name            FireSelectSwitchBoneName;
var     rotator         FireSelectSemiRotation;
var     rotator         FireSelectAutoRotation;

replication
{
    // Functions a client can call on the server
    reliable if (Role < ROLE_Authority)
        ServerChangeFireMode;
}

// New function to toggle between semi-auto & full auto fire
exec simulated function SwitchFireMode()
{
    if (bHasSelectFire && !IsBusy() && !FireMode[0].bIsFiring && !FireMode[1].bIsFiring)
    {
        GotoState('SwitchingFireMode');
    }
}

simulated function UpdateFireSelectSwitchRotation()
{
    if (FireSelectSwitchBoneName != '')
    {
        if (FireMode[0].bWaitForRelease)
        {
            SetBoneRotation(FireSelectSwitchBoneName, FireSelectSemiRotation);
        }
        else
        {
            SetBoneRotation(FireSelectSwitchBoneName, FireSelectAutoRotation);
        }
    }
}

simulated function BringUp(optional Weapon PrevWeapon)
{
    super.BringUp(PrevWeapon);

    UpdateFireSelectSwitchRotation();
    UpdateFireRate();
}

simulated function UpdateFireRate()
{
    local DHAutomaticFire AF;

    AF = DHAutomaticFire(FireMode[0]);

    if (AF == none)
    {
        return;
    }

    if (UsingAutoFire() || !AF.bHasSemiAutoFireRate)
    {
        FireMode[0].FireRate = FireMode[0].default.FireRate;
    }
    else if (AF.bHasSemiAutoFireRate)
    {
        FireMode[0].FireRate = AF.default.SemiAutoFireRate;
    }
}

simulated event ToggleFireSelectSwitch()
{
    UpdateFireSelectSwitchRotation();
}

simulated state SwitchingFireMode extends WeaponBusy
{
    simulated function BeginState()
    {
        local name Anim;

        if (bUsingSights || Instigator.bBipodDeployed)
        {
            if (Instigator.bBipodDeployed && HasAnim(SelectFireBipodIronAnim))
            {
                Anim = SelectFireBipodIronAnim;
            }
            else
            {
                if (AmmoAmount(0) == 0 && HasAnim(SelectFireIronEmptyAnim))
                {
                    Anim = SelectFireIronEmptyAnim;
                }
                else
                {
                    Anim = SelectFireIronAnim;
                }
            }
        }
        else
        {
            if (AmmoAmount(0) == 0 && HasAnim(SelectFireEmptyAnim))
            {
                Anim = SelectFireEmptyAnim;
            }
            else
            {
                Anim = SelectFireAnim;
            }
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
        if (SelectFireSound != none)
        {
            PlaySound(SelectFireSound,, SelectFireVolume);
        }

        FireMode[0].bWaitForRelease = !FireMode[0].bWaitForRelease;

        UpdateFireRate();
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

    if (InstigatorIsLocallyControlled() && !FireMode[Mode].bFireOnRelease) // adds check that isn't animating
    {
        if (!IsAnimating(0))
        {
            PlayIdle();
        }
        else
        {
            FireMode[Mode].PlayFireEnd();
        }
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
        SetPlayerFOV(GetPlayerIronsightFOV());
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
        else if (Anim == FireMode[0].FireAnim && HasAnim(FireMode[0].FireEndAnim) && (!FireMode[0].bIsFiring || !UsingAutoFire())) // adds checks that isn't firing
        {
            PlayAnim(FireMode[0].FireEndAnim, FireMode[0].FireEndAnimRate, FastTweenTime); // uses FastTweenTime instead of 0.0
        }
        else if (DHProjectileFire(FireMode[0]) != none && Anim == DHProjectileFire(FireMode[0]).FireIronAnim && (!FireMode[0].bIsFiring || !UsingAutoFire())) // adds check that isn't auto firing
        {
            PlayIdle();
        }
        else if (Anim == FireMode[1].FireAnim && HasAnim(FireMode[1].FireEndAnim))
        {
            PlayAnim(FireMode[1].FireEndAnim, FireMode[1].FireEndAnimRate, 0.0);
        }
        else if (!FireMode[0].bIsFiring && !FireMode[1].bIsFiring)
        {
            PlayIdle();
        }
    }
}

// Overridden so we don't play idle empty anims after a reload
simulated state Reloading
{
    simulated function PlayIdle()
    {
        if (bUsingSights && HasAnim(IronIdleEmptyAnim))
        {
            LoopAnim(IronIdleEmptyAnim, IdleAnimRate, 0.2);
        }
        else if (HasAnim(IdleAnim))
        {
            LoopAnim(IdleAnim, IdleAnimRate, 0.2);
        }
    }
}

defaultproperties
{
    bPlusOneLoading=true
    SelectFireVolume=2.0

    IronIdleAnim="Iron_idle"
    MagEmptyReloadAnims(0)="reload_empty"
    MagPartialReloadAnims(0)="reload_half"

    AIRating=0.7
    CurrentRating=0.7
}
