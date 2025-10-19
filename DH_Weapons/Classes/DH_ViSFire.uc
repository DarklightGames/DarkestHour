//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_ViSFire extends DHPistolFire;

defaultproperties
{
    ProjectileClass=Class'DH_ViSBullet'
    AmmoClass=Class'P38Ammo'

    Spread=185.0
    MaxVerticalRecoilAngle=450
    MaxHorizontalRecoilAngle=205

    FireSounds(0)=SoundGroup'DH_old_inf_Weapons.vis_fire01'
    FireSounds(1)=SoundGroup'DH_old_inf_Weapons.vis_fire02'

    ShellEjectClass=Class'ShellEject1st9x19mm'
}
