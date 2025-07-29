//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHSemiAutoFire extends DHProjectileFire
    abstract;

defaultproperties
{
    bWaitForRelease=true
    FireRate=0.2
    FAProjSpawnOffset=(X=-30.0)
    FlashEmitterClass=Class'MuzzleFlash1stSVT'
    SmokeEmitterClass=Class'ROMuzzleSmoke'
    FireForce="RocketLauncherFire"
    ShellIronSightOffset=(X=15.0,Y=0.0,Z=0.0)

    HipSpreadModifier=6.5
    bDelayedRecoil=true
    DelayedRecoilTime=0.05

    MaxVerticalRecoilAngle=1000
    MaxHorizontalRecoilAngle=150
    AimError=1500.0

    ShakeOffsetMag=(X=3.0,Y=1.0,Z=3.0)
    ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
    ShakeOffsetTime=1.0
    ShakeRotMag=(X=50.0,Y=50.0,Z=200.0)
    ShakeRotRate=(X=12500.0,Y=10000.0,Z=10000.0)
    ShakeRotTime=2.0
}
