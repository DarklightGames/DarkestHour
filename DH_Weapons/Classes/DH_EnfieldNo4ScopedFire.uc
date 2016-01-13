//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_EnfieldNo4ScopedFire extends DHBoltFire;

defaultproperties
{
    PreLaunchTraceDistance=3017.6 //50m
    ProjSpawnOffset=(X=25.0)
    FAProjSpawnOffset=(X=-35.0)
    FireIronAnim="Scope_Shoot"
    FireSounds(0)=SoundGroup'DH_WeaponSounds.EnfieldNo4.EnfieldRifle_Fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.EnfieldNo4.EnfieldRifle_Fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.EnfieldNo4.EnfieldRifle_Fire03'
    maxVerticalRecoilAngle=1000
    maxHorizontalRecoilAngle=100
    PctRestDeployRecoil=0.25
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellIronSightOffset=(X=10.0,Y=3.0,Z=-5.0)
    bWaitForRelease=true
    FireAnim="shoot_last"
    TweenTime=0.0
    FireForce="RocketLauncherFire"
    FireRate=2.4
    AmmoClass=class'DH_Weapons.DH_EnfieldNo4ScopedAmmo'
    ShakeRotMag=(X=50.0,Y=50.0,Z=400.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
    ShakeRotTime=5.0
    ShakeOffsetMag=(X=3.0,Y=1.0,Z=5.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ProjectileClass=class'DH_Weapons.DH_EnfieldNo4ScopedBullet'
    BotRefireRate=0.5
    WarnTargetPct=0.9
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stKar'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    aimerror=500.0
    Spread=30.0
    SpreadStyle=SS_Random
}
