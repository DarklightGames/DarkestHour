//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PIATFire extends DHRocketFire;

defaultproperties
{
    ProjectileClass=Class'DH_PIATRocket'
    AmmoClass=Class'DH_PIATAmmo'
    Spread=500.0
    MaxVerticalRecoilAngle=2500
    MaxHorizontalRecoilAngle=1000
    bCausesExhaustDamage=false
    MuzzleBone=muzzle

    ShakeRotRate=(X=12500.0,Y=12500.0,Z=12500.0)
    ShakeRotTime=7.0
    ShakeOffsetMag=(X=6.0,Y=2.0,Z=10.0)
    ShakeOffsetTime=4.0
    AimError=1200.0

    //** Effects **//
    FlashEmitterClass=Class'DHMuzzleFlash1stPIAT'
    SmokeEmitterClass = Class'ROMuzzleSmoke'

    //Sounds
    FireSounds(0)=SoundGroup'DH_WeaponSounds.PIAT_Fire01'
    FireSounds(1)=SoundGroup'DH_WeaponSounds.PIAT_Fire01'
    FireSounds(2)=SoundGroup'DH_WeaponSounds.PIAT_Fire01'
}
