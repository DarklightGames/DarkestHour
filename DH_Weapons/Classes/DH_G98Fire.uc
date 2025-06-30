//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_G98Fire extends DHBoltFire;

defaultproperties
{
    ProjectileClass=Class'DH_G98Bullet'
    AmmoClass=Class'DH_Kar98Ammo'
    FireRate=2.6
    FAProjSpawnOffset=(X=-30.0)
    Spread=45.0   //worn-out barrel
    FireSounds(0)=SoundGroup'DH_CC_Inf_Weapons.G98_shootA'
    FireSounds(1)=SoundGroup'DH_CC_Inf_Weapons.G98_shootB'
    
    MuzzleBone="MuzzleG98"

    FlashEmitterClass=Class'MuzzleFlash1stKar'
    ShellEjectClass=Class'ShellEject1st762x54mm'
    ShellRotOffsetIron=(Pitch=14000)
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-5000)
    FireAnim="shoot_last"
    FireIronAnim="Iron_shootrest"
    ShakeRotRate=(X=12500.0,Y=12500.0,Z=7500.0)
}