//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_DP28Fire extends DHMGAutomaticFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_DP28Bullet'
    TracerProjectileClass=class'DH_Weapons.DH_DP28TracerBullet'
    AmmoClass=class'ROAmmo.DP28Ammo'
    FireRate=0.1
    TracerFrequency=5
    FAProjSpawnOffset=(X=-20.0)
    Spread=70.0

    // Recoil
    RecoilRate=0.05
    MaxVerticalRecoilAngle=510
    MaxHorizontalRecoilAngle=240
    PctStandIronRecoil=0.25 // hipfire recoil is very high, this will make it more controlable
    PctCrouchIronRecoil=0.33 // hipfire recoil is very high, this will make it more controlable
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.4),(InVal=9.0,OutVal=1.0),(InVal=14.0,OutVal=1.5),(InVal=20.0,OutVal=0.9),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffExponent=4.0
    RecoilFallOffFactor=24.0

    AmbientFireSound=SoundGroup'DH_WeaponSounds.DP28.DP28_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.DP28.DP28_fire_end'
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stDP'
    BipodDeployFireAnim="Bipod_Shoot_Loop"

    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mmGreen'
    ShellIronSightOffset=(X=15.0,Y=0.0,Z=-5.0)
    ShellHipOffset=(X=-20.0,Y=0.0,Z=0.0)
    ShellRotOffsetIron=(Pitch=0)
    ShellRotOffsetHip=(Yaw=10000)

    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ShakeRotMag=(X=75.0,Y=50.0,Z=150.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=0.5
}
