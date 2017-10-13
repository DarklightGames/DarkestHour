//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
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

    Spread=175.0
    CrouchSpreadModifier=0.85
    ProneSpreadModifier=0.7
    BipodDeployedSpreadModifier=0.5
    RestDeploySpreadModifier=0.75
    RecoilRate=0.05
    MaxVerticalRecoilAngle=450
    MaxHorizontalRecoilAngle=200

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
