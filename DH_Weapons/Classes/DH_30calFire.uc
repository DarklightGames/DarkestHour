//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_30calFire extends DHMGAutomaticFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_30calBullet'
    TracerProjectileClass=class'DH_Weapons.DH_30CalTracerBullet'
    AmmoClass=class'DH_Weapons.DH_30CalAmmo'
    FireRate=0.12
    TracerFrequency=5
    Spread=70.0
    RecoilRate=0.04

    AmbientFireSound=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireLoop01'
    FireEndSound=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireEnd01'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellIronSightOffset=(X=15.0,Y=0.0,Z=-6.0)
    ShellRotOffsetIron=(Pitch=-1500)

    BipodDeployFireAnim="Shoot_Loop"
    BipodDeployFireLoopAnim="Shoot_Loop"
    BipodDeployFireEndAnim="Shoot_End"

    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=2.0
    ShakeRotMag=(X=25.0,Y=25.0,Z=25.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)
    ShakeRotTime=1.75
}
