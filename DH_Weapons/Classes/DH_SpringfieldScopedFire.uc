//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_SpringfieldScopedFire extends DHBoltFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_SpringfieldScopedBullet'
    AmmoClass=class'DH_Weapons.DH_SpringfieldAmmo'
    Spread=20.0
    AddedPitch=15
    FireSounds(0)=SoundGroup'DH_WeaponSounds.Springfield.Springfield_Fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.Springfield.Springfield_Fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.Springfield.Springfield_Fire03'
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stNagant'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    FireAnim="shoot_last"
    FireIronAnim="Scope_Shoot"
    PctRestDeployRecoil=0.25
    ShakeRotMag=(X=50.0,Y=50.0,Z=400.0)
    ShakeRotTime=5.0
    AimError=500.0
}
