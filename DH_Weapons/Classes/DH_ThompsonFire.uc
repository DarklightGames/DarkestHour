//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ThompsonFire extends DH_AutomaticFire;

defaultproperties
{
     ProjSpawnOffset=(X=25.000000)
     FAProjSpawnOffset=(X=-20.000000)
     FireIronAnim="Iron_Shoot_Loop"
     FireIronLoopAnim="Iron_Shoot_Loop"
     FireIronEndAnim="Iron_Shoot_End"
     FireSounds(0)=SoundGroup'DH_WeaponSounds.Thompson.Thompson_Fire01'
     maxVerticalRecoilAngle=600
     maxHorizontalRecoilAngle=75
     RecoilRate=0.050000
     ShellEjectClass=Class'ROAmmo.ShellEject1st762x25mm'
     ShellIronSightOffset=(X=15.000000)
     ShellRotOffsetIron=(Pitch=5000)
     PreFireAnim="Shoot1_start"
     FireAnim="Shoot_Loop"
     FireLoopAnim="Shoot_Loop"
     FireEndAnim="Shoot_End"
     TweenTime=0.000000
     FireRate=0.092307  //650rpm
     AmmoClass=Class'DH_Weapons.DH_ThompsonAmmo'
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=150.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=0.500000
     ShakeOffsetMag=(X=3.000000,Y=1.000000,Z=3.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.000000
     ProjectileClass=Class'DH_Weapons.DH_ThompsonBullet'
     BotRefireRate=0.990000
     WarnTargetPct=0.900000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stPistol'
     SmokeEmitterClass=Class'ROEffects.ROMuzzleSmoke'
     aimerror=1200.000000
     Spread=290.000000
     SpreadStyle=SS_Random
}
