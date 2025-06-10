//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_EnfieldNo4Fire extends DHBoltFire;

defaultproperties
{
    ProjectileClass=Class'DH_EnfieldNo4Bullet'
    AmmoClass=Class'DH_EnfieldNo4Ammo'
    FireRate=2.6
    Spread=30.0
    FAProjSpawnOffset=(X=-30.0)
    FireSounds(0)=SoundGroup'DH_WeaponSounds.EnfieldNo4.EnfieldRifle_Fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.EnfieldNo4.EnfieldRifle_Fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.EnfieldNo4.EnfieldRifle_Fire03'
    FlashEmitterClass=Class'MuzzleFlash1stKar'
    ShellEjectClass=Class'ShellEject1st762x54mm'
    ShellIronSightOffset=(X=12.0,Y=2.0,Z=-3.0)
    ShellRotOffsetIron=(Pitch=11000)
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-5000)
    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeRotMag=(X=50.0,Y=50.0,Z=200.0)
    ShakeRotRate=(X=12500.0,Y=10000.0,Z=10000.0)
    FireAnim="shoot_last"
    FireIronAnim="Iron_shootrest"
}
