//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_G43Fire extends DHSemiAutoFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_G43Bullet'
    AmmoClass=class'ROAmmo.G43Ammo'
    FireRate=0.26
    Spread=70.0
    MaxHorizontalRecoilAngle=200
    FireSounds(0)=SoundGroup'Inf_Weapons.g43.g43_fire01'
    FireSounds(1)=SoundGroup'Inf_Weapons.g43.g43_fire02'
    FireSounds(2)=SoundGroup'Inf_Weapons.g43.g43_fire03'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-3000)
}
