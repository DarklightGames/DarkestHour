//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_30calFire extends DHMGAutomaticFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_30calBullet'
    TracerProjectileClass=class'DH_Weapons.DH_30CalTracerBullet'
    AmmoClass=class'DH_Weapons.DH_30CalAmmo'
    FireRate=0.135 // ~500 rpm (value had to be found experimentally due to an engine bug)
    TracerFrequency=5
    Spread=75.0
    RecoilRate=0.06

    // Recoil
    MaxVerticalRecoilAngle=500
    MaxHorizontalRecoilAngle=225
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.3),(InVal=6.0,OutVal=0.4),(InVal=12.0,OutVal=0.8),(InVal=50.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffExponent=4.0
    RecoilFallOffFactor=30.0

    AmbientFireSound=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireLoop01'
    FireEndSound=SoundGroup'DH_WeaponSounds.30Cal.30cal_FireEnd01'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellIronSightOffset=(X=15.0,Y=0.0,Z=-6.0)
    ShellRotOffsetIron=(Pitch=-1500)

    BipodDeployFireAnim="Shoot_Loop"
    BipodDeployFireLoopAnim="Shoot_Loop"
    BipodDeployFireEndAnim="Shoot_End"

    ShakeOffsetMag=(X=2.0,Y=1.0,Z=2.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ShakeRotMag=(X=50.0,Y=50.0,Z=50.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=1.2
}
