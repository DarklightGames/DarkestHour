//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_G43Fire extends DHSemiAutoFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_G43Bullet'
    AmmoClass=class'ROAmmo.G43Ammo'
    Spread=70.0
    MaxVerticalRecoilAngle=840
    MaxHorizontalRecoilAngle=300
	FireRate=0.22
	
    FireSounds(0)=Sound'DH_WeaponSounds.g43.newg43fire'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-3000)
}
