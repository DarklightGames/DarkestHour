//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M1A1CarbineFire extends DHSemiAutoFire;

defaultproperties
{
    ProjectileClass=Class'DH_M1A1CarbineBullet'
    AmmoClass=Class'DH_M1CarbineAmmo'
    Spread=75.0
    MaxVerticalRecoilAngle=450
    MaxHorizontalRecoilAngle=107
    RecoilRate=0.06
    RecoilCurve=(Points=((InVal=0.0,OutVal=1.0),(InVal=4.0,OutVal=1.37),(InVal=12.0,OutVal=1.6),(InVal=10000000000.0,OutVal=1.0)))
    RecoilFallOffFactor=18.0
    
    
    FireSounds(0)=SoundGroup'DH_WeaponSounds.CarbineFire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.CarbineFire02'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.CarbineFire03'
    ShellEjectClass=Class'ShellEject1st556mm'
    ShellRotOffsetHip=(Pitch=-3000,Yaw=-3000)

    MuzzleBone="MuzzleNew"

    FireRate=0.18
}
