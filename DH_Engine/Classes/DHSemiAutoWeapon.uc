//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DHSemiAutoWeapon extends DHProjectileWeapon
    abstract;

// Modified to prevent the exploit of freezing your animations after firing
simulated function AnimEnd(int Channel)
{
    local name  Anim;
    local float Frame, Rate;

    if (ClientState == WS_ReadyToFire)
    {
        GetAnimParams(0, Anim, Frame, Rate);

//      // Don't play the idle anim after a bayo strike or bash (this, from the ROWeapon Super, is omitted here)
//      if (FireMode[1].bMeleeMode && ROWeaponFire(FireMode[1]) != none &&
//          (Anim == ROWeaponFire(FireMode[1]).BashAnim || Anim == ROWeaponFire(FireMode[1]).BayoStabAnim || Anim == ROWeaponFire(FireMode[1]).BashEmptyAnim))
//      {
//          // do nothing;
//      }
//      else

        if (Anim == FireMode[0].FireAnim && HasAnim(FireMode[0].FireEndAnim) && !FireMode[0].bIsFiring) // adds checks that isn't firing
        {
            PlayAnim(FireMode[0].FireEndAnim, FireMode[0].FireEndAnimRate, FastTweenTime); // uses FastTweenTime instead of 0.0
        }
        else if (DHProjectileFire(FireMode[0]) != none && Anim == DHProjectileFire(FireMode[0]).FireIronAnim && !FireMode[0].bIsFiring)
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

// Modified to prevent the exploit of freezing your animations after firing
simulated event StopFire(int Mode)
{
    if (FireMode[Mode].bIsFiring)
    {
        FireMode[Mode].bInstantStop = true;
    }

    if (InstigatorIsLocallyControlled() && !FireMode[Mode].bFireOnRelease && !IsAnimating(0)) // adds check that isn't animating
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

defaultproperties
{
    bPlusOneLoading=true
    FreeAimRotationSpeed=6.0
    IronIdleAnim="Iron_idle"
    MagEmptyReloadAnim="reload_empty"
    MagPartialReloadAnim="reload_half"

    bSniping=true
    AIRating=0.4
    CurrentRating=0.4
}
