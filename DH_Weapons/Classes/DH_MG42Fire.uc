//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_MG42Fire extends DHMGAutomaticFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_MG42Bullet'
    TracerProjectileClass=class'DH_Weapons.DH_MG42TracerBullet'
    AmmoClass=class'DH_Weapons.DH_MG42Ammo'
    FireRate=0.055 // ~1250 rpm (value had to be found experimentally due to an engine bug)
    TracerFrequency=7
    Spread=90.0
    RecoilRate=0.03125
    PctHipMGPenalty=1.25

    // Recoil
    MaxVerticalRecoilAngle=475
    MaxHorizontalRecoilAngle=315
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.3),(InVal=12.0,OutVal=1.4),(InVal=32.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
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
    
    FireEndAnim="hip_Shoot_End"
    FireLoopAnim="Hip_Shoot_loop"

    ShakeOffsetMag=(X=2.0,Y=1.0,Z=2.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ShakeRotMag=(X=50.0,Y=50.0,Z=90.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=1.2
}
