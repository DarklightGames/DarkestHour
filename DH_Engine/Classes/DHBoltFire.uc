//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHBoltFire extends DHProjectileFire
    abstract;

// Modified to call PostFire() on the weapon to handling working the bolt before next shot, & to omit setting NextFireTime
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

    // Server
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

    // Client
    if (Instigator != none && Instigator.IsLocallyControlled())
    {
        if (!bDelayedRecoil)
        {
            HandleRecoil();
        }
        else
        {
            SetTimer(DelayedRecoilTime, false);
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
    // Server
    else
    {
        ServerPlayFiring();
    }

    Weapon.IncrementFlashCount(ThisModeNum);

    // Setting NextFireTime is OMITTED here

    Weapon.PostFire(); // ADDED here

    Load = AmmoPerFire;
    HoldTime = 0;

    if (Instigator != none && Instigator.PendingWeapon != Weapon && Instigator.PendingWeapon != none)
    {
        bIsFiring = false;
        Weapon.PutDown();
    }
}

defaultproperties
{
    PctRestDeployRecoil=0.65
    bDelayedRecoil=true
    DelayedRecoilTime=0.05
    bAnimNotifiedShellEjects=true
}
