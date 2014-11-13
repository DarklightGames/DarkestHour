//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_GreaseGunFire extends DH_AutomaticFire;

defaultproperties
{
     ProjSpawnOffset=(X=25.000000)
     FAProjSpawnOffset=(X=-20.000000)
     FireIronAnim="Iron_Shoot_Loop"
     FireIronLoopAnim="Iron_Shoot_Loop"
     FireIronEndAnim="Iron_Shoot_End"
     FireSounds(0)=SoundGroup'DH_WeaponSounds.GreaseGun.greasegun_fire01'
     FireSounds(1)=SoundGroup'DH_WeaponSounds.GreaseGun.greasegun_fire02'
     FireSounds(2)=SoundGroup'DH_WeaponSounds.GreaseGun.greasegun_fire03'
     maxVerticalRecoilAngle=585
     maxHorizontalRecoilAngle=75
     PctProneIronRecoil=0.500000
     RecoilRate=0.075000
     ShellEjectClass=class'ROAmmo.ShellEject1st762x25mm'
     ShellIronSightOffset=(X=15.000000)
     ShellRotOffsetIron=(Pitch=1000)
     PreFireAnim="Shoot1_start"
     FireAnim="Shoot_Loop"
     FireLoopAnim="Shoot_Loop"
     FireEndAnim="Shoot_End"
     TweenTime=0.000000
     NoAmmoSound=Sound'Inf_Weapons_Foley.Misc.dryfire_smg'
     FireRate=0.150000
     AmmoClass=class'DH_Weapons.DH_GreaseGunAmmo'
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=150.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=0.500000
     ShakeOffsetMag=(X=3.000000,Y=1.000000,Z=3.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.000000
     ProjectileClass=class'DH_Weapons.DH_GreaseGunBullet'
     BotRefireRate=0.990000
     WarnTargetPct=0.900000
     FlashEmitterClass=class'ROEffects.MuzzleFlash1stPistol'
     SmokeEmitterClass=class'ROEffects.ROMuzzleSmoke'
     aimerror=1200.000000
     Spread=345.000000
     SpreadStyle=SS_Random
}
