//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_M1GarandFire extends DHSemiAutoFire;

var     array<sound>    FirePingSounds;   // an array of the last round firing sound with ping
var     name            FireLastAnim;     // last round animation
var     name            FireIronlastAnim; // iron last round animation
var     bool            NextShotIsLast;   // set on the second last shot to facilitate clip eject

// Modified to add clip eject ping to firing sound after firing last round
function ServerPlayFiring()
{
    if (DH_M1GarandWeapon(Weapon) != none && DH_M1GarandWeapon(Weapon).WasLastRound())
    {
        Weapon.PlayOwnedSound(FirePingSounds[Rand(FirePingSounds.Length)], SLOT_None, FireVolume,,,, false);
    }
    else
    {
        super.ServerPlayFiring();
    }
}

// Modified to make last round eject clip & add audible ping
function PlayFiring()
{
    local DH_M1GarandWeapon Garand;
    local name              FiringAnim;
    local sound             FiringSound;
    local bool              bLastRound;

    Garand = DH_M1GarandWeapon(Weapon);

    if (Weapon != none && Weapon.Mesh != none)
    {
        if (Garand != none && Garand.bIsLastRound)
        {
            if (Weapon.bUsingSights)
            {
                FiringAnim = FireIronLastAnim;
            }
            else
            {
                FiringAnim = FireLastAnim;
            }
        }
        else
        {
            if (Weapon.bUsingSights)
            {
                FiringAnim = FireIronAnim;
            }
            else
            {
                FiringAnim = FireAnim;
            }
        }

        if (Weapon.HasAnim(FiringAnim))
        {
            Weapon.PlayAnim(FiringAnim, FireAnimRate, FireTweenTime);
        }
    }

    if (Instigator != none && Instigator.IsHumanControlled() && Instigator.IsLocallyControlled())
    {
        bLastRound = Garand != none && Garand.bIsLastRound;
    }
    else
    {
        bLastRound = Garand != none && Garand.WasLastRound();
    }

    if (bLastRound)
    {
        FiringSound = FirePingSounds[Rand(FirePingSounds.Length)];
    }
    else
    {
        FiringSound = FireSounds[Rand(FireSounds.Length)];
    }

    if (FiringSound != none && Weapon != none)
    {
        Weapon.PlayOwnedSound(FiringSound, SLOT_None, FireVolume,,,, false);
    }

    ClientPlayForceFeedback(FireForce);

    FireCount++;
}

defaultproperties
{
    MaxVerticalRecoilAngle=1600
    MaxHorizontalRecoilAngle=200
    FirePingSounds(0)=SoundGroup'DH_WeaponSounds.M1Garand.garand_firePing01'
    FirePingSounds(1)=SoundGroup'DH_WeaponSounds.M1Garand.garand_firePing02'
    FirePingSounds(2)=SoundGroup'DH_WeaponSounds.M1Garand.garand_firePing03'
    FireLastAnim="shoot_last"
    FireIronLastAnim="Iron_Shoot_Last"
    ProjSpawnOffset=(X=25.0)
    FAProjSpawnOffset=(X=-30.0)
    FireIronAnim="iron_shoot"
    FireSounds(0)=SoundGroup'DH_WeaponSounds.M1Garand.garand_fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.M1Garand.garand_fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.M1Garand.garand_fire03'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellIronSightOffset=(X=15.0)
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-5000)
    bWaitForRelease=true
    FireAnim="shoot"
    TweenTime=0.0
    FireForce="RocketLauncherFire"
    FireRate=0.27
    AmmoClass=class'DH_Weapons.DH_M1GarandAmmo'
    ShakeRotMag=(X=50.0,Y=50.0,Z=200.0)
    ShakeRotRate=(X=12500.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=2.0
    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ProjectileClass=class'DH_Weapons.DH_M1GarandBullet'
    BotRefireRate=0.5
    WarnTargetPct=0.9
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stSVT'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    AimError=800.0
    Spread=75.0
    SpreadStyle=SS_Random
}
