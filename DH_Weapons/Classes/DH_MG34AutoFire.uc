//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_MG34AutoFire extends DHMGAutomaticFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_MG34Bullet'
    TracerProjectileClass=class'DH_Weapons.DH_MG34TracerBullet'
    AmmoClass=class'ROAmmo.MG50Rd792x57DrumAmmo'
    FireRate=0.070588
    TracerFrequency=7
    RecoilRate=0.04
    PctHipMGPenalty=0.66 // TODO: doesn't seem to make sense as is supposed to be a penalty & so must be > 1 (was originally 1.5) (same in semi auto fire class)
    MaxVerticalRecoilAngle=600

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
