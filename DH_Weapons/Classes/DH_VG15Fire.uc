//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_VG15Fire extends DHSemiAutoFire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_VG15Bullet'
    AmmoClass=class'ROAmmo.STG44Ammo'
    Spread=85.0
    MaxVerticalRecoilAngle=340
    MaxHorizontalRecoilAngle=150
    FireRate=0.21

    FireSounds(0)=SoundGroup'DH_old_inf_Weapons.g43.vg15shot1'
    FireSounds(1)=SoundGroup'DH_old_inf_Weapons.g43.vg15shot2'
    FireSounds(2)=SoundGroup'DH_old_inf_Weapons.g43.vg15shot3'
    ShellEjectClass=class'ROAmmo.ShellEject1st556mm'
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-3000)
    MuzzleBone="MuzzleNew"
}
