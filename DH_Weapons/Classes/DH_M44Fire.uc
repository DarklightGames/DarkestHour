//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M44Fire extends DH_MN9130Fire;

defaultproperties
{
    ProjectileClass=Class'DH_M44Bullet'
    AmmoClass=Class'DH_MN9130Ammo'
    Spread=55.0
    MaxVerticalRecoilAngle=1550
    MaxHorizontalRecoilAngle=200
    FireSounds(0)=SoundGroup'DH_WeaponSounds.newM38_fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.newM38_fire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.newM38_fire03'

    FlashEmitterClass=Class'MuzzleFlash1stKar'
    ShellRotOffsetHip=(Pitch=5000)
    ShakeRotMag=(X=50.0,Y=50.0,Z=350.0)
    ShakeRotTime=2.5
}
