//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_STG44Fire extends DH_AutomaticFire;

defaultproperties
{
     ProjSpawnOffset=(X=25.000000)
     FAProjSpawnOffset=(X=-28.000000)
     PreLaunchTraceDistance=1836.000000
     FireIronAnim="Iron_Shoot_Loop"
     FireIronLoopAnim="Iron_Shoot_Loop"
     FireIronEndAnim="Iron_Shoot_End"
     FireSounds(0)=SoundGroup'DH_WeaponSounds.stg44.stg44_fire01'
     FireSounds(1)=SoundGroup'DH_WeaponSounds.stg44.stg44_fire02'
     FireSounds(2)=SoundGroup'DH_WeaponSounds.stg44.stg44_fire03'
     maxVerticalRecoilAngle=700
     maxHorizontalRecoilAngle=200
     RecoilRate=0.075000
     ShellEjectClass=Class'ROAmmo.ShellEject1st556mm'
     ShellIronSightOffset=(X=10.000000,Z=-5.000000)
     ShellRotOffsetIron=(Pitch=2000)
     bReverseShellSpawnDirection=true
     FireAnim="Shoot_Loop"
     FireLoopAnim="Shoot_Loop"
     FireEndAnim="Shoot_End"
     TweenTime=0.000000
     FireRate=0.110000
     AmmoClass=Class'ROAmmo.STG44Ammo'
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=175.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=3.000000,Y=1.000000,Z=3.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.000000
     ProjectileClass=Class'DH_Weapons.DH_STG44Bullet'
     BotRefireRate=0.990000
     WarnTargetPct=0.900000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stSTG'
     SmokeEmitterClass=Class'ROEffects.ROMuzzleSmoke'
     aimerror=1200.000000
     Spread=150.000000
     SpreadStyle=SS_Random
}
