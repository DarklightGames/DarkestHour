//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_M1CarbineFire extends DHSemiAutoFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_M1CarbineBullet'
    AmmoClass=class'DH_Weapons.DH_M1CarbineAmmo'
    Spread=100.0
    MaxVerticalRecoilAngle=410
    FireSounds(0)=SoundGroup'DH_WeaponSounds.Carbine.CarbineFire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.Carbine.CarbineFire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.Carbine.CarbineFire03'
    ShellEjectClass=class'ROAmmo.ShellEject1st556mm'
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-3000)
}
