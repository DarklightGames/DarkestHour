//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M38Fire extends DH_M44Fire;

defaultproperties
{
    ProjectileClass=Class'DH_M38Bullet'
    AmmoClass=Class'DH_MN9130Ammo'
    FAProjSpawnOffset=(X=-30.0)
    Spread=55.0
    MaxVerticalRecoilAngle=1550
    MaxHorizontalRecoilAngle=200
    FlashEmitterClass=Class'MuzzleFlash1stKar'
    ShellRotOffsetHip=(Pitch=5000)
    ShakeRotMag=(X=50.0,Y=50.0,Z=350.0)
    ShakeRotTime=2.5
}
