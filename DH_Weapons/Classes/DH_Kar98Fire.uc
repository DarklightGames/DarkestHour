//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_Kar98Fire extends DHBoltFire;

defaultproperties
{
    ProjSpawnOffset=(X=25.0)
    FAProjSpawnOffset=(X=-30.0)
    FireIronAnim="Iron_shootrest"
    FireSounds(0)=SoundGroup'DH_WeaponSounds.kar98.kar98_fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.kar98.kar98_fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.kar98.kar98_fire03'
    maxVerticalRecoilAngle=1000
    maxHorizontalRecoilAngle=100
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellIronSightOffset=(X=10.0,Y=3.0,Z=-5.0)
    ShellRotOffsetIron=(Pitch=14000)
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-5000)
    bWaitForRelease=true
    FireAnim="shoot_last"
    TweenTime=0.0
    FireForce="RocketLauncherFire"
    FireRate=2.6
    AmmoClass=class'ROAmmo.Kar792x57Ammo'
    ShakeRotMag=(X=50.0,Y=50.0,Z=300.0)
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=7500.0)
    ShakeRotTime=2.0
    ShakeOffsetMag=(X=3.0,Y=1.0,Z=5.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ProjectileClass=class'DH_Weapons.DH_Kar98Bullet'
    BotRefireRate=0.5
    WarnTargetPct=0.9
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stKar'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    aimerror=800.0
    Spread=50.0
    SpreadStyle=SS_Random
}
