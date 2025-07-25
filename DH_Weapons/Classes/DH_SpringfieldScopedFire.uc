//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_SpringfieldScopedFire extends DHBoltFire;

defaultproperties
{
    ProjectileClass=Class'DH_SpringfieldScopedBullet'
    AmmoClass=Class'DH_SpringfieldAmmo'
    Spread=20.0
    AddedPitch=15
    FireSounds(0)=SoundGroup'DH_WeaponSounds.Springfield_Fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.Springfield_Fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.Springfield_Fire03'
    FlashEmitterClass=Class'MuzzleFlash1stNagant'
    ShellEjectClass=Class'ShellEject1st762x54mm'
    FireAnim="shoot_last"
    FireIronAnim="Scope_Shoot"
    PctRestDeployRecoil=0.25
    ShakeRotMag=(X=50.0,Y=50.0,Z=400.0)
    ShakeRotTime=5.0
    AimError=500.0
}
