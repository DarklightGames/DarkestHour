//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DH_P38Fire extends DHPistolFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_P38Bullet'
    AmmoClass=class'ROAmmo.P38Ammo'
    Spread=330.0
    FireSounds(0)=SoundGroup'Inf_Weapons.waltherp38.waltherp38_fire01'
    FireSounds(1)=SoundGroup'Inf_Weapons.waltherp38.waltherp38_fire02'
    FireSounds(2)=SoundGroup'Inf_Weapons.waltherp38.waltherp38_fire03'
    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'
}
