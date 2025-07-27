//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_P38Fire extends DHPistolFire;

defaultproperties
{
    ProjectileClass=Class'DH_P38Bullet'
    AmmoClass=Class'P38Ammo'

    Spread=185.0
    MaxVerticalRecoilAngle=400
    MaxHorizontalRecoilAngle=225
    FireRate=0.21

    FireSounds(0)=SoundGroup'Inf_Weapons.waltherp38_fire01'
    FireSounds(1)=SoundGroup'Inf_Weapons.waltherp38_fire02'
    FireSounds(2)=SoundGroup'Inf_Weapons.waltherp38_fire03'
    ShellEjectClass=Class'ShellEject1st9x19mm'
}
