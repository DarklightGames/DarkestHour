//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHPistolFire extends DHProjectileFire
    abstract;

// Different firing animations if pistol is firing its last round
var     name    FireLastAnim;
var     name    FireIronLastAnim;

// Modified to use different firing animations if pistol is firing its last round
function PlayFiring()
{
    if (Weapon.Mesh != none)
    {
        if (FireCount > 0)
        {
            if (Weapon.bUsingSights && Weapon.HasAnim(FireIronLoopAnim))
            {
                Weapon.PlayAnim(FireIronLoopAnim, FireAnimRate, 0.0);
            }
            else
            {
                if (Weapon.HasAnim(FireLoopAnim))
                {
                    Weapon.PlayAnim(FireLoopAnim, FireLoopAnimRate, 0.0);
                }
                else
                {
                    Weapon.PlayAnim(FireAnim, FireAnimRate, FireTweenTime);
                }
            }
        }
        else
        {
            if (Weapon.bUsingSights)
            {
                if (Weapon.AmmoAmount(ThisModeNum) < 1)
                {
                    Weapon.PlayAnim(FireIronLastAnim, FireAnimRate, FireTweenTime);
                }
                else
                {
                    Weapon.PlayAnim(FireIronAnim, FireAnimRate, FireTweenTime);
                }
            }
            else
            {
                if (Weapon.AmmoAmount(ThisModeNum) < 1)
                {
                    Weapon.PlayAnim(FireLastAnim, FireAnimRate, FireTweenTime);
                }
                else
                {
                    Weapon.PlayAnim(FireAnim, FireAnimRate, FireTweenTime);
                }
            }
        }
    }

    Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)], SLOT_None, FireVolume,,,, false);

    ClientPlayForceFeedback(FireForce);

    FireCount++;
}

// Overridden to keep better track of ammo client side for pistol animations
event ModeDoFire()
{
    if (!AllowFire())
    {
        return;
    }

    if (MaxHoldTime > 0.0)
    {
        HoldTime = FMin(HoldTime, MaxHoldTime);
    }

    // server
    if (Weapon.Role == ROLE_Authority)
    {
        Weapon.ConsumeAmmo(ThisModeNum, Load);

        DoFireEffect();

        HoldTime = 0;   // if bot decides to stop firing, HoldTime must be reset first

        if (Instigator == none || Instigator.Controller == none)
        {
            return;
        }

        if (AIController(Instigator.Controller) != none)
        {
            AIController(Instigator.Controller).WeaponFireAgain(BotRefireRate, true);
        }

        Instigator.DeactivateSpawnProtection();
    }

    // client
    if (Instigator.IsLocallyControlled())
    {
        // This could be dangerous. if we are low on ammo, go ahead and
        // decrement the ammo client side. This will ensure the proper
        // anims play for weapon firing in laggy situations.
        if (Weapon.Role < ROLE_Authority)
        {
            Weapon.ConsumeAmmo(ThisModeNum, Load);
        }

        if (!bDelayedRecoil)
        {
            HandleRecoil();
        }

        ShakeView();
        PlayFiring();

        if (!bMeleeMode)
        {
            if (Instigator.IsFirstPerson() && !bAnimNotifiedShellEjects)
            {
                EjectShell();
            }

            FlashMuzzleFlash();
            StartMuzzleSmoke();
        }
    }
    else // server
    {
        ServerPlayFiring();
    }

    Weapon.IncrementFlashCount(ThisModeNum);

    // set the next firing time. must be careful here so client and server do not get out of sync
    if (bFireOnRelease)
    {
        if (bIsFiring)
        {
            NextFireTime += MaxHoldTime + FireRate;
        }
        else
        {
            NextFireTime = Level.TimeSeconds + FireRate;
        }
    }
    else
    {
        NextFireTime += FireRate;
        NextFireTime = FMax(NextFireTime, Level.TimeSeconds);
    }

    Load = AmmoPerFire;
    HoldTime = 0;

    if (Instigator.PendingWeapon != Weapon && Instigator.PendingWeapon != none)
    {
        bIsFiring = false;

        Weapon.PutDown();
    }
}

defaultproperties
{
    bWaitForRelease=true
    FireRate=0.25
    FAProjSpawnOffset=(X=-15.0)
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stPistol'
    SmokeEmitterClass=class'ROEffects.ROPistolMuzzleSmoke'
    ShellIronSightOffset=(X=10.0,Y=0.0,Z=0.0)
    NoAmmoSound=Sound'Inf_Weapons_Foley.Misc.dryfire_pistol'

    Spread=450.0
    MaxVerticalRecoilAngle=600
    MaxHorizontalRecoilAngle=75
    AimError=800.0

    FireLastAnim="shoot_empty"
    FireIronLastAnim="iron_shoot_empty"

    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ShakeRotMag=(X=50.0,Y=50.0,Z=50.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=1.0
}
