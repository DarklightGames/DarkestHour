//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CarcanoM9138CarbineFire extends DHBoltFire;

defaultproperties
{
    ProjectileClass=Class'DH_CarcanoM9138CarbineBullet'
    AmmoClass=Class'DH_CarcanoM91Ammo'
    Spread=48.0
    AddedPitch=15
    MaxVerticalRecoilAngle=850
    FireSounds(0)=SoundGroup'DH_MN_InfantryWeapons_sound.CarcanoCarbineFire01'
    FireSounds(1)=SoundGroup'DH_MN_InfantryWeapons_sound.CarcanoCarbineFire02'
    FireSounds(2)=SoundGroup'DH_MN_InfantryWeapons_sound.CarcanoCarbineFire03'
    FlashEmitterClass=Class'MuzzleFlash1stNagant'
    ShellEjectClass=Class'ShellEject1st762x54mm'
    FireAnim="shoot_last"
    FireIronAnim="Iron_shootrest"
}
