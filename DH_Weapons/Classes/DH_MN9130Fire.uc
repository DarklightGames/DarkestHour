//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MN9130Fire extends DHBoltFire;

defaultproperties
{
    ProjectileClass=Class'DH_MN9130Bullet'
    AmmoClass=Class'DH_MN9130Ammo'
    Spread=40.0
    MaxVerticalRecoilAngle=1500
    FireSounds(0)=SoundGroup'Inf_Weapons.nagant9130.nagant9130_fire01'
    FireSounds(1)=SoundGroup'Inf_Weapons.nagant9130.nagant9130_fire02'
    FireSounds(2)=SoundGroup'Inf_Weapons.nagant9130.nagant9130_fire03'
    FlashEmitterClass=Class'MuzzleFlash1stNagant'
    ShellEjectClass=Class'ShellEject1st762x54mmGreen'
    FireAnim="shoot_last"
    FireIronAnim="Iron_shootrest"
}
