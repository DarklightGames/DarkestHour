//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_MG34AutoFire extends DHMGAutomaticFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_MG34Bullet'
    TracerProjectileClass=class'DH_Weapons.DH_MG34TracerBullet'
    AmmoClass=class'ROAmmo.MG50Rd792x57DrumAmmo'
    FireRate=0.070588     //FireRate=0.075 // 913 rpm (value had to be found experimentally due to an engine bug)
    TracerFrequency=7
    Spread=88.0
    RecoilRate=0.04
    PctHipMGPenalty=1.0

    // Recoil
    MaxVerticalRecoilAngle=400
    MaxHorizontalRecoilAngle=210
    RecoilCurve=(Points=((InVal=0.0,OutVal=0.4),(InVal=6.0,OutVal=0.6),(InVal=12.0,OutVal=1.15),(InVal=50.0,OutVal=1.0),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffExponent=4.0
    RecoilFallOffFactor=34.0

    AmbientFireSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_loop'
    FireEndSound=SoundGroup'DH_WeaponSounds.mg34.mg34_fire_end'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellIronSightOffset=(X=25.0,Y=0.0,Z=-10.0)
    ShellRotOffsetIron=(Pitch=3000)
    FireEndAnim="Hip_Shoot_End"

    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=2.0
    ShakeRotMag=(X=50.0,Y=50.0,Z=50.0)
    ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=2.0
}
