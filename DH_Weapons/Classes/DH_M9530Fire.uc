//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M9530Fire extends DHBoltFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_M9530Bullet'
    AmmoClass=class'DH_Weapons.DH_M9530Ammo'
    Spread=45.0
    MaxVerticalRecoilAngle=1550
    MaxHorizontalRecoilAngle=200
    FireSounds(0)=SoundGroup'DH_CC_Inf_Weapons.M95.M95_fire_01'
    FireSounds(1)=SoundGroup'DH_CC_Inf_Weapons.M95.M95_fire_02'
    FireSounds(2)=SoundGroup'DH_CC_Inf_Weapons.M95.M95_fire_03'
    FlashEmitterClass=class'ROEffects.MuzzleFlash1stNagant'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    FireAnim="shoot_last"
    FireIronAnim="Iron_shootrest"
}
