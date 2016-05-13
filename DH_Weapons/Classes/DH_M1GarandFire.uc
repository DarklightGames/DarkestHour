//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M1GarandFire extends DHSemiAutoFire;

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
    maxVerticalRecoilAngle=1600
    maxHorizontalRecoilAngle=200
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
    aimerror=800.0
    Spread=75.0
    SpreadStyle=SS_Random
}
