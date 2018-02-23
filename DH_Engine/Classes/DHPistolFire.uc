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
    if (Weapon != none)
    {
        if (Weapon.Mesh != none)
        {
            if (!IsPlayerHipFiring() && Weapon.HasAnim(FireIronAnim))
            {
                if (Weapon.AmmoAmount(ThisModeNum) < 1 && Weapon.HasAnim(FireIronLastAnim))
                {
                    Weapon.PlayAnim(FireIronLastAnim, FireAnimRate, FireTweenTime);
                }
                else
                {
                    Weapon.PlayAnim(FireIronAnim, FireAnimRate, FireTweenTime);
                }
            }
            else if (Weapon.AmmoAmount(ThisModeNum) < 1 && Weapon.HasAnim(FireLastAnim))
            {
                Weapon.PlayAnim(FireLastAnim, FireAnimRate, FireTweenTime);
            }
            else if (Weapon.HasAnim(FireAnim))
            {
                Weapon.PlayAnim(FireAnim, FireAnimRate, FireTweenTime);
            }
        }

        Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)], SLOT_None, FireVolume,,,, false);
    }

    ClientPlayForceFeedback(FireForce);
    FireCount++;
}

// Modified so if remaining ammo is low, we immediately consume ammo on a net client, without waiting for a reduced ammo count to replicate
// This could be dangerous (old RO comment) but should ensure the proper anims play for pistol firing in laggy situations
event ModeDoFire()
{
    super.ModeDoFire();

    if (Weapon != none && Weapon.Role < ROLE_Authority && Instigator != none && Instigator.IsLocallyControlled())
    {
        Weapon.ConsumeAmmo(ThisModeNum, Load);
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

    Spread=350.0
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
