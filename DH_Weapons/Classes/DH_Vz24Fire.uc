//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Vz24Fire extends DHBoltFire;

defaultproperties
{
    ProjectileClass=Class'DH_Vz24Bullet'
    AmmoClass=Class'DH_Kar98Ammo'
    FireRate=2.6
    FAProjSpawnOffset=(X=-30.0)
    Spread=30.0
    FireSounds(0)=SoundGroup'DH_CC_Inf_Weapons.vz24.vz24_shootA'
    FireSounds(1)=SoundGroup'DH_CC_Inf_Weapons.vz24.vz24_shootB'

    FlashEmitterClass=Class'MuzzleFlash1stKar'
    ShellEjectClass=Class'ShellEject1st762x54mm'
    ShellRotOffsetIron=(Pitch=14000)
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-5000)
    FireAnim="shoot_last"
    FireIronAnim="Iron_shootrest"
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=7500.0)
}