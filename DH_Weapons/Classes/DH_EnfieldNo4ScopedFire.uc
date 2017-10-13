//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_EnfieldNo4ScopedFire extends DHBoltFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_EnfieldNo4ScopedBullet'
    AmmoClass=class'DH_Weapons.DH_EnfieldNo4ScopedAmmo'
    Spread=30.0
    PctRestDeployRecoil=0.25
    FireSounds(0)=SoundGroup'DH_WeaponSounds.EnfieldNo4.EnfieldRifle_Fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.EnfieldNo4.EnfieldRifle_Fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.EnfieldNo4.EnfieldRifle_Fire03'
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stKar'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    FireAnim="shoot_last"
    FireIronAnim="Scope_shoot"
    ShakeRotMag=(X=50.0,Y=50.0,Z=400.0)
    ShakeRotTime=5.0
    AimError=500.0
}
