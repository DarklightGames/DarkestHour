//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CarcanoM38Fire extends DHBoltFire;

defaultproperties
{
    ProjectileClass=Class'DH_CarcanoM91Bullet'
    AmmoClass=Class'DH_CarcanoM91Ammo'
    Spread=41.5
    AddedPitch=15
    MaxVerticalRecoilAngle=825
    FireSounds(0)=SoundGroup'DH_MN_InfantryWeapons_sound.CarcanoFire01'
    FireSounds(1)=SoundGroup'DH_MN_InfantryWeapons_sound.CarcanoFire02'
    FireSounds(2)=SoundGroup'DH_MN_InfantryWeapons_sound.CarcanoFire03'
    FlashEmitterClass=Class'ROEffects.MuzzleFlash1stNagant'
    ShellEjectClass=Class'ROAmmo.ShellEject1st762x54mm'
    FireAnim="shoot_last"
    FireIronAnim="Iron_shootrest"
}
