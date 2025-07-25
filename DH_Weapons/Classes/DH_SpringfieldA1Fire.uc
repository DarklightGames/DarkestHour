//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_SpringfieldA1Fire extends DHBoltFire;

defaultproperties
{
    ProjectileClass=Class'DH_SpringfieldA1Bullet'
    AmmoClass=Class'DH_SpringfieldA1Ammo'
    Spread=30.0
    FlashEmitterClass=Class'MuzzleFlash1stNagant'
    ShellEjectClass=Class'ShellEject1st762x54mm'
    FireSounds(0)=SoundGroup'DH_WeaponSounds.Springfield_Fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.Springfield_Fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.Springfield_Fire03'
    FireRate=2.6
    FAProjSpawnOffset=(X=-30.0)

    ShellRotOffsetIron=(Pitch=14000)
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-5000)
    FireAnim="shoot_last"
    FireIronAnim="Iron_shootrest"
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=7500.0)


}
