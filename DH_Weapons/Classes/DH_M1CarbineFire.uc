//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_M1CarbineFire extends DH_SemiAutoFire;

defaultproperties
{
     ProjSpawnOffset=(X=25.000000)
     FAProjSpawnOffset=(X=-30.000000)
     FireIronAnim="iron_shoot"
     FireSounds(0)=SoundGroup'DH_WeaponSounds.Carbine.CarbineFire01'
     FireSounds(1)=SoundGroup'DH_WeaponSounds.Carbine.CarbineFire02'
     FireSounds(2)=SoundGroup'DH_WeaponSounds.Carbine.CarbineFire03'
     maxVerticalRecoilAngle=600
     maxHorizontalRecoilAngle=150
     ShellEjectClass=Class'ROAmmo.ShellEject1st556mm'
     ShellIronSightOffset=(X=15.000000)
     ShellRotOffsetHip=(Pitch=-3000,Yaw=-3000)
     bWaitForRelease=true
     FireAnim="shoot"
     TweenTime=0.000000
     FireForce="RocketLauncherFire"
     FireRate=0.200000
     AmmoClass=Class'DH_Weapons.DH_M1CarbineAmmo'
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=200.000000)
     ShakeRotRate=(X=12500.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=3.000000,Y=1.000000,Z=3.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.000000
     ProjectileClass=Class'DH_Weapons.DH_M1CarbineBullet'
     BotRefireRate=0.500000
     WarnTargetPct=0.900000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stSVT'
     SmokeEmitterClass=Class'ROEffects.ROMuzzleSmoke'
     aimerror=1200.000000
     Spread=165.000000
     SpreadStyle=SS_Random
}
