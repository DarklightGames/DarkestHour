//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_M44Fire extends DH_MN9130Fire;

defaultproperties
{
    ProjectileClass=class'DH_Weapons.DH_M44Bullet'
    AmmoClass=class'DH_Weapons.DH_MN9130Ammo'
    Spread=55.0
    MaxVerticalRecoilAngle=1550
    MaxHorizontalRecoilAngle=200
    FireSounds(0)=SoundGroup'DH_WeaponSounds.newMN.newM38_fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.newMN.newM38_fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.newMN.newM38_fire03'

    FlashEmitterClass=class'ROEffects.MuzzleFlash1stKar'
    ShellRotOffsetHip=(Pitch=5000)
    ShakeRotMag=(X=50.0,Y=50.0,Z=350.0)
    ShakeRotTime=2.5
}
