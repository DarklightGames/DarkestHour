//=============================================================================
// DH_Kar98ScopedFire
//=============================================================================
// Bullet firing class for the Scoped Kar98 rifle
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================

class DH_Kar98ScopedFire extends DH_BoltFire;

defaultproperties
{
     ProjSpawnOffset=(X=25.000000)
     FAProjSpawnOffset=(X=-30.000000)
     FireIronAnim="Scope_Shoot"
     FireSounds(0)=SoundGroup'DH_WeaponSounds.kar98.kar98_fire01'
     FireSounds(1)=SoundGroup'DH_WeaponSounds.kar98.kar98_fire02'
     FireSounds(2)=SoundGroup'DH_WeaponSounds.kar98.kar98_fire03'
     maxVerticalRecoilAngle=1000
     maxHorizontalRecoilAngle=100
     PctRestDeployRecoil=0.250000
     ShellEjectClass=Class'ROAmmo.ShellEject1st762x54mm'
     ShellIronSightOffset=(X=10.000000,Y=3.000000,Z=-5.000000)
     ShellRotOffsetIron=(Pitch=14000)
     ShellRotOffsetHip=(Pitch=-3000,Yaw=-5000)
     bWaitForRelease=true
     FireAnim="shoot_last"
     TweenTime=0.000000
     FireForce="RocketLauncherFire"
     FireRate=2.600000
     AmmoClass=Class'ROAmmo.Kar792x57Ammo'
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=400.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     ShakeRotTime=5.000000
     ShakeOffsetMag=(X=3.000000,Y=1.000000,Z=5.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.000000
     ProjectileClass=Class'DH_Weapons.DH_Kar98ScopedBullet'
     BotRefireRate=0.500000
     WarnTargetPct=0.900000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stKar'
     SmokeEmitterClass=Class'ROEffects.ROMuzzleSmoke'
     aimerror=550.000000
     Spread=30.000000
     SpreadStyle=SS_Random
}
