//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_SpringfieldScopedFire extends DH_BoltFire;

defaultproperties
{
     ProjSpawnOffset=(X=25.000000)
     FAProjSpawnOffset=(X=-35.000000)
     FireIronAnim="Scope_Shoot"
     FireSounds(0)=SoundGroup'DH_WeaponSounds.Springfield.Springfield_Fire01'
     maxVerticalRecoilAngle=1000
     maxHorizontalRecoilAngle=100
     PctRestDeployRecoil=0.250000
     ShellEjectClass=Class'ROAmmo.ShellEject1st762x54mm'
     ShellIronSightOffset=(X=10.000000,Y=3.000000,Z=-5.000000)
     bWaitForRelease=true
     FireAnim="shoot_last"
     TweenTime=0.000000
     FireForce="RocketLauncherFire"
     FireRate=2.400000
     AmmoClass=Class'DH_Weapons.DH_SpringfieldAmmo'
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=400.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     ShakeRotTime=5.000000
     ShakeOffsetMag=(X=3.000000,Y=1.000000,Z=5.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.000000
     ProjectileClass=Class'DH_Weapons.DH_SpringfieldScopedBullet'
     BotRefireRate=0.500000
     WarnTargetPct=0.900000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stNagant'
     SmokeEmitterClass=Class'ROEffects.ROMuzzleSmoke'
     aimerror=500.000000
     Spread=30.000000
     SpreadStyle=SS_Random
}
