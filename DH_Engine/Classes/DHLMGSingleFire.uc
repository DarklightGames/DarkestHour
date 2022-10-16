//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHLMGSingleFire extends DHProjectileFire  //This fire class is made for the new mg34 w/ box, since the older DHMGSingleFire doesnt work on a weapon that isn't a "machinegun" (new mg34 is like bren)
    abstract;
    
// Firing animations when player has a bipod deployed
// For weapons that can be fired three ways - from the hip, from ironsights, or from bipod deployed, e.g. Bren gun
var     name    BipodDeployFireAnim;
var     name    BipodDeployFireLoopAnim;
var     name    BipodDeployFireEndAnim;
var     name    BipodDeployFireLastAnim;

var     bool    bHasSemiAutoFireRate;
var     float   SemiAutoFireRate;

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
    bWaitForRelease=true
    bUsesTracers=true
    FireRate=0.2
    FAProjSpawnOffset=(X=-20.0)
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stMG'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    BlurTime=0.04
    BlurTimeIronsight=0.04

    CrouchSpreadModifier=1.0
    ProneSpreadModifier=1.0
    BipodDeployedSpreadModifier=1.0
    RestDeploySpreadModifier=1.0
    MaxVerticalRecoilAngle=500
    MaxHorizontalRecoilAngle=250
    AimError=1800.0

    FireAnim="Shoot_single"
    FireLoopAnim="Shoot_Loop"
    FireEndAnim="hip_idle"
    FireIronAnim="Bipod_shoot_single"
    FireIronLoopAnim="Bipod_Shoot_Loop"
    FireIronEndAnim="Bipod_Shoot_End"
}
