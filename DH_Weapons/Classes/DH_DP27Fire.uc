//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_DP27Fire extends DHFastAutoFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_DP27Bullet'
    TracerProjectileClass=class'DH_Weapons.DH_DP27TracerBullet'
    AmmoClass=class'DH_Weapons.DH_DP27Ammo'
    FireRate=0.105 // 632 rpm (value had to be found experimentally due to an engine bug)
    TracerFrequency=5
    FAProjSpawnOffset=(X=-20.0)
    Spread=70.0

    // Recoil
    RecoilRate=0.05
    MaxVerticalRecoilAngle=630
    MaxHorizontalRecoilAngle=260
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.6),(InVal=6.0,OutVal=1.0),(InVal=10.0,OutVal=1.3),(InVal=16.0,OutVal=0.8),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffExponent=4.0
    RecoilFallOffFactor=24.0

    AmbientFireSound=SoundGroup'DH_WeaponSounds.DP28.DP28_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.DP28.DP28_fire_end'
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stDP'
    BipodDeployFireAnim="Deploy_shoot_loop"
    BipodDeployFireLoopAnim="Deploy_Shoot_Loop"
    BipodDeployFireEndAnim="Deploy_Shoot_End"
    FireAnim="shoot_loop"
    FireLoopAnim="shoot_loop"
    FireEndAnim="Shoot_End"

    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mmGreen'
    //ShellIronSightOffset=(X=15.0,Y=0.0,Z=-5.0)   ejector bone was repositioned, so outcommented those
    //ShellHipOffset=(X=-20.0,Y=0.0,Z=0.0)
    //ShellRotOffsetIron=(Pitch=0)
    //ShellRotOffsetHip=(Yaw=10000)

    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ShakeRotMag=(X=75.0,Y=50.0,Z=150.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=0.5
}
