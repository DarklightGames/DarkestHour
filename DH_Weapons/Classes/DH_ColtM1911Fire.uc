//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ColtM1911Fire extends DH_PistolFire;

defaultproperties
{
     FireLastAnim="shoot_last"
     FireIronLastAnim="Iron_Shoot_Last"
     ProjSpawnOffset=(X=25.000000)
     FAProjSpawnOffset=(X=-15.000000)
     FireIronAnim="iron_shoot"
     FireSounds(0)=SoundGroup'DH_WeaponSounds.Colt45.Colt45_Fire01'
     maxVerticalRecoilAngle=600
     maxHorizontalRecoilAngle=75
     ShellEjectClass=class'ROAmmo.ShellEject1st762x25mm'
     ShellIronSightOffset=(X=10.000000)
     ShellHipOffset=(Y=3.000000)
     ShellRotOffsetHip=(Pitch=2500,Yaw=4000)
     bReverseShellSpawnDirection=true
     bWaitForRelease=true
     FireAnim="shoot"
     TweenTime=0.000000
     FireRate=0.200000
     AmmoClass=class'DH_Weapons.DH_ColtM1911Ammo'
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=50.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=1.000000
     ShakeOffsetMag=(X=3.000000,Y=1.000000,Z=3.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.000000
     ProjectileClass=class'DH_Weapons.DH_ColtM1911Bullet'
     BotRefireRate=0.500000
     WarnTargetPct=0.900000
     FlashEmitterClass=class'ROEffects.MuzzleFlash1stPistol'
     aimerror=800.000000
     Spread=430.000000
     SpreadStyle=SS_Random
}
