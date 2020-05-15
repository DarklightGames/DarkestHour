//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_M44Fire extends DH_MN9130Fire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_M44Bullet'
    AmmoClass=class'DH_Weapons.DH_MN9130Ammo'
    Spread=75.0
    MaxHorizontalRecoilAngle=125
    FireSounds(0)=SoundGroup'Inf_Weapons.nagant9138.nagant9138_fire01'
    FireSounds(1)=SoundGroup'Inf_Weapons.nagant9138.nagant9138_fire02'
    FireSounds(2)=SoundGroup'Inf_Weapons.nagant9138.nagant9138_fire03'
}
