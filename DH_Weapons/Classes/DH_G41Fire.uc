//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_G41Fire extends DHSemiAutoFire;

defaultproperties
{
    ProjSpawnOffset=(X=25.0)
    FAProjSpawnOffset=(X=-30.0)
    FireIronAnim="iron_shoot"
    FireSounds(0)=SoundGroup'DH_WeaponSounds.g41.g41_fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.g41.g41_fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.g41.g41_fire03'
    maxVerticalRecoilAngle=1900
    maxHorizontalRecoilAngle=150
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellIronSightOffset=(X=15.0)
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-3000)
    bWaitForRelease=true
    FireAnim="shoot"
    TweenTime=0.0
    FireForce="RocketLauncherFire"
    FireRate=0.28
    AmmoClass=class'ROAmmo.G41Ammo'
    ShakeRotMag=(X=50.0,Y=50.0,Z=200.0)
    ShakeRotRate=(X=12500.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=2.0
    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ProjectileClass=class'DH_Weapons.DH_G41Bullet'
    BotRefireRate=0.5
    WarnTargetPct=0.9
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stSVT'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    aimerror=1200.0
    Spread=100.0
    SpreadStyle=SS_Random
}
