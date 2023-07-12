//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHAutomaticFire extends DHProjectileFire
    abstract;

// Firing animations when player has a bipod deployed
// For weapons that can be fired three ways - from the hip, from ironsights, or from bipod deployed, e.g. Bren gun
var     name    BipodDeployFireAnim;
var     name    BipodDeployFireLoopAnim;
var     name    BipodDeployFireEndAnim;
var     name    BipodDeployFireLastAnim;

var     bool    bHasSemiAutoFireRate;
var     float   SemiAutoFireRate;

// Modified to make the player stop firing if they are sprinting or switching to or from ironsights
simulated function bool AllowFire()
{
    if ((Instigator != none && Instigator.bIsSprinting) || (Weapon != none &&
        (Weapon.IsInState('IronSightZoomIn') ||
        Weapon.IsInState('IronSightZoomOut') ||
        Weapon.IsInState('TweenDown'))))
    {
        return false;
    }

    return super.AllowFire();
}

// Implemented to stop weapon firing if it is no longer allowed to
function ModeTick(float DeltaTime)
{
    super.ModeTick(DeltaTime);

    if (bIsFiring && !AllowFire())
    {
        Weapon.StopFire(ThisModeNum);
    }
}

// Modified to handle different bipod firing animations
function PlayFiring()
{
    // TODO: there is a HUGE amount of redundancy here, we should be able to roll all of this into DHProjectileFire at some point
    local name Anim;
    local bool bIsLastShot;

    bIsLastShot = Weapon.AmmoAmount(ThisModeNum) < 1;

    if (Weapon != none)
    {
        if (Weapon.Mesh != none)
        {
            // Weapon is auto-firing, so get an appropriate fire loop animation
            if (FireCount > 0)
            {
                if (!IsPlayerHipFiring())
                {
                    if (IsInstigatorBipodDeployed())
                    {
                        if (bIsLastShot && Weapon.HasAnim(BipodDeployFireLastAnim))
                        {
                            Anim = BipodDeployFireLastAnim;
                        }
                        else if (Weapon.HasAnim(BipodDeployFireLoopAnim))
                        {
                            Anim = BipodDeployFireLoopAnim;
                        }
                    }
                    else if (bIsLastShot && Weapon.HasAnim(FireIronLastAnim))
                    {
                        Anim = FireIronLastAnim;
                    }
                    else if (Weapon.HasAnim(FireIronLoopAnim))
                    {
                        Anim = FireIronLoopAnim;
                    }
                }
                else
                {
                    if (bIsLastShot && Weapon.HasAnim(FireLastAnim))
                    {
                        Anim = FireLastAnim;
                    }
                }

                if (Anim == '' && Weapon.HasAnim(FireLoopAnim))
                {
                    Anim = FireLoopAnim;
                }
            }

            // If we've identified a auto-fire loop anim then play it
            if (Anim != '')
            {
                Weapon.PlayAnim(Anim, FireLoopAnimRate, 0.0);
            }
            // Otherwise get a suitable single fire anim
            else
            {
                if (!IsPlayerHipFiring())
                {
                    if (IsInstigatorBipodDeployed() && Weapon.HasAnim(BipodDeployFireAnim))
                    {
                        Anim = BipodDeployFireAnim;
                    }
                    else if (bIsLastShot && Weapon.HasAnim(FireIronLastAnim))
                    {
                        Anim = FireIronLastAnim;
                    }
                    else if (Weapon.HasAnim(FireIronAnim))
                    {
                        Anim = FireIronAnim;
                    }
                }
                else
                {
                    if (bIsLastShot && Weapon.HasAnim(FireLastAnim))
                    {
                        Anim = FireLastAnim;
                    }
                }

                if (Anim == '' && Weapon.HasAnim(FireAnim))
                {
                    Anim = FireAnim;
                }

                if (Anim != '')
                {
                    Weapon.PlayAnim(Anim, FireAnimRate, FireTweenTime);
                }
            }
        }

        if (FireSounds.Length > 0)
        {
            Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)], SLOT_None, FireVolume,,, GetFiringSoundPitch(), false);
        }
    }

    ClientPlayForceFeedback(FireForce);
    FireCount++;
}

// Modified to handle different bipod fire end animation
function PlayFireEnd()
{
    local name Anim;
    local bool bIsLastShot;

    if (Weapon == none || Weapon.Mesh == none)
    {
        return;
    }

    bIsLastShot = Weapon.AmmoAmount(ThisModeNum) < 1;

    if (Weapon.GetFireMode(ThisModeNum).bWaitForRelease)
    {
        // The weapon is firing in single-fire mode, so do not play this end-fire animation.
        return;
    }

    if (!IsPlayerHipFiring())
    {
        if (IsInstigatorBipodDeployed())
        {
            if (bIsLastShot && Weapon.HasAnim(BipodDeployFireLastAnim))
            {
                Anim = BipodDeployFireLastAnim;
            }
            else if (Weapon.HasAnim(BipodDeployFireEndAnim))
            {
                Anim = BipodDeployFireEndAnim;
            }
        }
        else if (bIsLastShot && Weapon.HasAnim(FireIronLastAnim))
        {
            Anim = FireIronLastAnim;
        }
        else if (Weapon.HasAnim(FireIronEndAnim))
        {
            Anim = FireIronEndAnim;
        }
    }
    else
    {
        if (bIsLastShot && Weapon.HasAnim(FireLastAnim))
        {
            Anim = FireLastAnim;
        }
    }

    if (Anim == '')
    {
        if (bIsLastShot && Weapon.HasAnim(FireLastAnim))
        {
            Anim = FireLastAnim;
        }
        else if (Weapon.HasAnim(FireEndAnim))
        {
            Anim = FireEndAnim;
        }
    }

    if (Anim != '')
    {
        Weapon.PlayAnim(Anim, FireEndAnimRate, FireTweenTime);
    }
}

function float MaxRange()
{
    return 9000.0; // about 150 meters
}

defaultproperties
{
    bPawnRapidFireAnim=true
    FAProjSpawnOffset=(X=-20.0)
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stSTG'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    ShellIronSightOffset=(X=15.0,Y=0.0,Z=0.0)

    // Recoil
    MaxVerticalRecoilAngle=600
    MaxHorizontalRecoilAngle=120

    FireAnim="Shoot_Loop"
    FireLoopAnim="Shoot_Loop"
    FireEndAnim="Shoot_End"
    FireIronAnim="Iron_Shoot_Loop"
    FireIronLoopAnim="Iron_Shoot_Loop"
    FireIronEndAnim="Iron_Shoot_End"

    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ShakeRotMag=(X=50.0,Y=50.0,Z=150.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=0.5

    AimError=1200.0
    BotRefireRate=0.99

    SemiAutoFireRate=0.18
}

