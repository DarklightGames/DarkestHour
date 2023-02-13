//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ViSFire extends DHPistolFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_ViSBullet'
    AmmoClass=class'ROAmmo.P38Ammo'

    Spread=185.0
    MaxVerticalRecoilAngle=450
    MaxHorizontalRecoilAngle=205

    FireSounds(0)=SoundGroup'DH_old_inf_Weapons.waltherp38.vis_fire01'
    FireSounds(1)=SoundGroup'DH_old_inf_Weapons.waltherp38.vis_fire02'

    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'
}
