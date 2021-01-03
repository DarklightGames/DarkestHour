//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_G43Fire extends DHSemiAutoFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_G43Bullet'
    AmmoClass=class'ROAmmo.G43Ammo'
    Spread=45.0
    MaxVerticalRecoilAngle=740
    MaxHorizontalRecoilAngle=170
    FireRate=0.22

    FireSounds(0)=SoundGroup'DH_old_inf_Weapons.g43.g43shot1'
    FireSounds(1)=SoundGroup'DH_old_inf_Weapons.g43.g43shot2'
    FireSounds(2)=SoundGroup'DH_old_inf_Weapons.g43.g43shot3'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-3000)
}
