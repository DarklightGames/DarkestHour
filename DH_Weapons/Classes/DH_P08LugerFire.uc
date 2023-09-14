//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_P08LugerFire extends DHPistolFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_P08LugerBullet'
    AmmoClass=class'ROAmmo.P08LugerAmmo'

    Spread=190.0
    MaxVerticalRecoilAngle=500
    MaxHorizontalRecoilAngle=250

    FireSounds(0)=SoundGroup'Inf_Weapons.lugerp08.lugerp08_fire01'
    FireSounds(1)=SoundGroup'Inf_Weapons.lugerp08.lugerp08_fire02'
    FireSounds(2)=SoundGroup'Inf_Weapons.lugerp08.lugerp08_fire03'
    ShellEjectClass=class'ROAmmo.ShellEject1st9x19mm'
    ShellHipOffset=(X=0.0,Y=-7.0,Z=0.0)
}
