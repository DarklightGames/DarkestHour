//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_BHPFire extends DHPistolFire;

defaultproperties
{
    ProjectileClass=Class'DH_BHPBullet'
    AmmoClass=Class'DH_BHPammo'

    Spread=185.0
    MaxVerticalRecoilAngle=380
    MaxHorizontalRecoilAngle=235

    FireSounds(0)=SoundGroup'DH_MN_InfantryWeapons_sound.browninghpfire01'
    FireSounds(1)=SoundGroup'DH_MN_InfantryWeapons_sound.browninghpfire02'
    FireSounds(2)=SoundGroup'DH_MN_InfantryWeapons_sound.browninghpfire03'
    ShellEjectClass=Class'ShellEject1st9x19mm'
}
