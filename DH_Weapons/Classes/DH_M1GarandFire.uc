//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_M1GarandFire extends DH_SemiAutoFire;

var()           array<sound>    FirePingSounds;     // An array of the last round firing sound with ping
var(FireAnims)  name            FireLastAnim;       //last round animation
var(FireAnims)  name            FireIronlastAnim;   //iron last round animation

var             bool            NextShotIsLast;     // Set on the second last shot to facilitate clip eject

function ServerPlayFiring()
{
    local DH_M1GarandWeapon Gun;

    Gun = DH_M1GarandWeapon(Weapon);

    if (Gun.WasLastRound())     // adds last round clip eject sound
    {
        if (FirePingSounds.Length > 0)
        {
            Weapon.PlayOwnedSound(FirePingSounds[Rand(FirePingSounds.Length)], SLOT_None, FireVolume,,,, false);
        }
    }
    else
    {
        if (FireSounds.Length > 0)
        {
            Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)], SLOT_None, FireVolume,,,, false);
        }
    }
}

function PlayFiring()   // overridden to make last round eject clip & add audible ping
{
    local DH_M1GarandWeapon Gun;
    local bool IsLastRound;

    Gun = DH_M1GarandWeapon(Weapon);
    IsLastRound = Gun.bIsLastRound;

    if (Weapon.Mesh != none)
    {
        if (IsLastRound)
        {
            if (Weapon.bUsingSights)
            {
                Weapon.PlayAnim(FireIronLastAnim, FireAnimRate, FireTweenTime);
            }
            else
            {
                Weapon.PlayAnim(FireLastAnim, FireAnimRate, FireTweenTime);
            }
        }
        else
        {
            if (Weapon.bUsingSights)
            {
                Weapon.PlayAnim(FireIronAnim, FireAnimRate, FireTweenTime);
            }
            else
            {
                Weapon.PlayAnim(FireAnim, FireAnimRate, FireTweenTime);
            }
        }
    }

    if (Instigator.IsHumanControlled() && Instigator.IsLocallyControlled())
    {
        if (IsLastRound)
        {
            if (FirePingSounds.Length > 0)
            {
                Weapon.PlayOwnedSound(FirePingSounds[Rand(FirePingSounds.Length)], SLOT_None, FireVolume,,,, false);
            }
        }
        else
        {
            if (FireSounds.Length > 0)
            {
                Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)], SLOT_None, FireVolume,,,, false);
            }
        }
    }
    else
    {
        if (Gun.WasLastRound())
        {
            if (FirePingSounds.Length > 0)
            {
                Weapon.PlayOwnedSound(FirePingSounds[Rand(FirePingSounds.Length)], SLOT_None, FireVolume,,,, false);
            }
        }
        else
        {
            if (FireSounds.Length > 0)
            {
                Weapon.PlayOwnedSound(FireSounds[Rand(FireSounds.Length)], SLOT_None, FireVolume,,,, false);
            }
        }
    }

    ClientPlayForceFeedback(FireForce);

    FireCount++;
}

defaultproperties
{
    FirePingSounds(0)=SoundGroup'DH_WeaponSounds.M1Garand.garand_firePing01'
    FirePingSounds(1)=SoundGroup'DH_WeaponSounds.M1Garand.garand_firePing02'
    FirePingSounds(2)=SoundGroup'DH_WeaponSounds.M1Garand.garand_firePing03'
    FireLastAnim="shoot_last"
    FireIronLastAnim="Iron_Shoot_Last"
    ProjSpawnOffset=(X=25.000000)
    FAProjSpawnOffset=(X=-30.000000)
    FireIronAnim="iron_shoot"
    FireSounds(0)=SoundGroup'DH_WeaponSounds.M1Garand.garand_fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.M1Garand.garand_fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.M1Garand.garand_fire03'
    maxVerticalRecoilAngle=1600
    maxHorizontalRecoilAngle=150
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellIronSightOffset=(X=15.000000)
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-5000)
    bWaitForRelease=true
    FireAnim="shoot"
    TweenTime=0.000000
    FireForce="RocketLauncherFire"
    FireRate=0.200000
    AmmoClass=class'DH_Weapons.DH_M1GarandAmmo'
    ShakeRotMag=(X=50.000000,Y=50.000000,Z=200.000000)
    ShakeRotRate=(X=12500.000000,Y=10000.000000,Z=10000.000000)
    ShakeRotTime=2.000000
    ShakeOffsetMag=(X=3.000000,Y=1.000000,Z=3.000000)
    ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
    ShakeOffsetTime=1.000000
    ProjectileClass=class'DH_Weapons.DH_M1GarandBullet'
    BotRefireRate=0.500000
    WarnTargetPct=0.900000
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stSVT'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    aimerror=800.000000
    Spread=100.000000
    SpreadStyle=SS_Random
}
