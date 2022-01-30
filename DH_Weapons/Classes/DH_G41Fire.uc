//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_G41Fire extends DHSemiAutoFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_G41Bullet'
    AmmoClass=class'DH_Weapons.DH_EnfieldNo4Ammo'
    FireRate=0.25
    Spread=50.0
    MaxVerticalRecoilAngle=700
    MaxHorizontalRecoilAngle=310  //heavy, but very unbalanced with awkward gas automatic system
    FireSounds(0)=SoundGroup'DH_WeaponSounds.g41.g41_fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.g41.g41_fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.g41.g41_fire03'
    ShellEjectClass=class'ROAmmo.ShellEject1st762x54mm'
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-3000)

    FireLastAnim="shoot_last"
    FireIronLastAnim="Iron_Shoot_Last"
}
