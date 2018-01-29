//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_SpringfieldScopedFire extends DHBoltFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_SpringfieldScopedBullet'
    AmmoClass=class'DH_Weapons.DH_SpringfieldAmmo'
    Spread=30.0
    PctRestDeployRecoil=0.25
    FireSounds(0)=SoundGroup'DH_WeaponSounds.Springfield.Springfield_Fire01'
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stNagant'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    FireAnim="shoot_last"
    FireIronAnim="Scope_Shoot"
    ShakeRotMag=(X=50.0,Y=50.0,Z=400.0)
    ShakeRotTime=5.0
    AimError=500.0
}
