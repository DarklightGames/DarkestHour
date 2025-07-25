//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Nagant1895BramitFire extends DHPistolFire;

defaultproperties
{
    ProjectileClass=Class'DH_Nagant1895BramitBullet'
    AmmoClass=Class'DH_Nagant1895BramitAmmo'
    FireRate=0.3

    Spread=220
    MaxVerticalRecoilAngle=700
    MaxHorizontalRecoilAngle=200

    FireSounds(0)=SoundGroup'DH_MN_InfantryWeapons_sound.m1895Bramit'
    FireSounds(1)=SoundGroup'DH_MN_InfantryWeapons_sound.m1895Bramit'
    FireSounds(2)=SoundGroup'DH_MN_InfantryWeapons_sound.m1895Bramit'
}
