//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_VG15Fire extends DHSemiAutoFire;

defaultproperties
{
    ProjectileClass=Class'DH_VG15Bullet'
    AmmoClass=Class'STG44Ammo'
    Spread=85.0
    MaxVerticalRecoilAngle=340
    MaxHorizontalRecoilAngle=150
    FireRate=0.21

    FireSounds(0)=SoundGroup'DH_old_inf_Weapons.vg15shot1'
    FireSounds(1)=SoundGroup'DH_old_inf_Weapons.vg15shot2'
    FireSounds(2)=SoundGroup'DH_old_inf_Weapons.vg15shot3'
    ShellEjectClass=Class'ShellEject1st556mm'
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-3000)
    MuzzleBone="MuzzleNew"
}
