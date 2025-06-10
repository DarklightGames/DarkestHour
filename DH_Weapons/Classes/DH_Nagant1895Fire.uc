//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Nagant1895Fire extends DHPistolFire;

defaultproperties
{
    ProjectileClass=Class'DH_Nagant1895Bullet'
    AmmoClass=Class'DH_Nagant1895Ammo'
    FireRate=0.3

    Spread=220
    MaxVerticalRecoilAngle=700
    MaxHorizontalRecoilAngle=200

   FireSounds(0)=SoundGroup'DH_MN_InfantryWeapons_sound.Webley.m1895'
   FireSounds(1)=SoundGroup'DH_MN_InfantryWeapons_sound.Webley.m1895'
   FireSounds(2)=SoundGroup'DH_MN_InfantryWeapons_sound.Webley.m1895'
}
