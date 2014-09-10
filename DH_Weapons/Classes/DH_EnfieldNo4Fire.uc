//=============================================================================
// DH_EnfieldNo4Fire
//=============================================================================

class DH_EnfieldNo4Fire extends DH_BoltFire;

defaultproperties
{
     ProjSpawnOffset=(X=25.000000)
     FAProjSpawnOffset=(X=-30.000000)
     FireIronAnim="iron_shoot"
     FireSounds(0)=SoundGroup'DH_WeaponSounds.EnfieldNo4.EnfieldRifle_Fire01'
     FireSounds(1)=SoundGroup'DH_WeaponSounds.EnfieldNo4.EnfieldRifle_Fire02'
     FireSounds(2)=SoundGroup'DH_WeaponSounds.EnfieldNo4.EnfieldRifle_Fire03'
     FireVolume=255.000000
     maxVerticalRecoilAngle=1000
     maxHorizontalRecoilAngle=100
     ShellEjectClass=Class'ROAmmo.ShellEject1st762x54mm'
     ShellIronSightOffset=(X=10.000000,Y=3.000000,Z=-5.000000)
     ShellRotOffsetIron=(Pitch=14000)
     ShellRotOffsetHip=(Pitch=-3000,Yaw=-5000)
     bWaitForRelease=true
     FireAnim="shoot"
     TweenTime=0.000000
     FireForce="RocketLauncherFire"
     FireRate=2.600000
     AmmoClass=Class'DH_Weapons.DH_EnfieldNo4Ammo'
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=200.000000)
     ShakeRotRate=(X=12500.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=3.000000,Y=1.000000,Z=3.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.000000
     ProjectileClass=Class'DH_Weapons.DH_EnfieldNo4Bullet'
     BotRefireRate=0.500000
     WarnTargetPct=0.900000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stKar'
     SmokeEmitterClass=Class'ROEffects.ROMuzzleSmoke'
     aimerror=800.000000
     Spread=50.000000
     SpreadStyle=SS_Random
}
