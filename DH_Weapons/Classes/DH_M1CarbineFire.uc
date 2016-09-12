//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_M1CarbineFire extends DHSemiAutoFire;

defaultproperties
{
    ProjSpawnOffset=(X=25.0)
    FAProjSpawnOffset=(X=-30.0)
    FireIronAnim="iron_shoot"
    FireSounds(0)=SoundGroup'DH_WeaponSounds.Carbine.CarbineFire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.Carbine.CarbineFire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.Carbine.CarbineFire03'
    MaxVerticalRecoilAngle=550
    MaxHorizontalRecoilAngle=150
    ShellEjectClass=class'ROAmmo.ShellEject1st556mm'
    ShellIronSightOffset=(X=15.0)
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-3000)
    bWaitForRelease=true
    FireAnim="shoot"
    TweenTime=0.0
    FireForce="RocketLauncherFire"
    FireRate=0.2
    AmmoClass=class'DH_Weapons.DH_M1CarbineAmmo'
    ShakeRotMag=(X=50.0,Y=50.0,Z=200.0)
    ShakeRotRate=(X=12500.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=2.0
    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ProjectileClass=class'DH_Weapons.DH_M1CarbineBullet'
    BotRefireRate=0.5
    WarnTargetPct=0.9
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stSVT'
    SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
    AimError=1200.0
    Spread=170.0
    SpreadStyle=SS_Random
}
