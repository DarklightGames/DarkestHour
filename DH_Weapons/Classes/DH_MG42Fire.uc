//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_MG42Fire extends DHMGAutomaticFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_MG42Bullet'
    TracerProjectileClass=class'DH_Weapons.DH_MG42TracerBullet'
    AmmoClass=class'DH_Weapons.DH_MG42Ammo'
    FireRate=0.05
    TracerFrequency=7
    Spread=70.0
    RecoilRate=0.03125

    // Recoil
    maxVerticalRecoilAngle=460
    maxHorizontalRecoilAngle=260
    PctBipodDeployRecoil=0.1
    PctRestDeployRecoil=0.1
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.3),(InVal=10.0,OutVal=0.6),(InVal=25.0,OutVal=1.25),(InVal=50.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffExponent=4.0
    RecoilFallOffFactor=32.0

    AmbientFireSound=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireLoop01'
    FireEndSound=SoundGroup'DH_WeaponSounds.mg42.Mg42_FireEnd01'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellIronSightOffset=(X=15.0,Y=0.0,Z=-6.0)
    ShellRotOffsetIron=(Pitch=-1500)

    BipodDeployFireAnim="Shoot_Loop"
    BipodDeployFireLoopAnim="Shoot_Loop"
    BipodDeployFireEndAnim="Shoot_End"

    ShakeOffsetMag=(X=1.0,Y=1.0,Z=1.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=2.0
    ShakeRotMag=(X=20.0,Y=20.0,Z=20.0)
    ShakeRotRate=(X=5000.0,Y=5000.0,Z=5000.0)
    ShakeRotTime=0.75
}
