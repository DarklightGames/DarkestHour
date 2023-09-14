//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
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
        HoldTime = 0.0; // if bot decides to stop firing, HoldTime must be reset first

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
    HoldTime = 0.0;

    if (Instigator != none && Instigator.PendingWeapon != Weapon && Instigator.PendingWeapon != none)
    {
        bIsFiring = false;
        Weapon.PutDown();
    }
}

defaultproperties
{
    bWaitForRelease=true
    FireRate=2.4
    FAProjSpawnOffset=(X=-35.0)
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    bAnimNotifiedShellEjects=true
    ShellIronSightOffset=(X=10.0,Y=3.0,Z=-5.0)

    bDelayedRecoil=true
    DelayedRecoilTime=0.05
    MaxVerticalRecoilAngle=1000
    MaxHorizontalRecoilAngle=100
    AimError=800.0

    ShakeOffsetMag=(X=3.0,Y=1.0,Z=5.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ShakeRotMag=(X=50.0,Y=50.0,Z=300.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
    ShakeRotTime=2.0
}
