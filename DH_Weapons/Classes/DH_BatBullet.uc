//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_BatBullet extends DH_GeratPIIBullet;

defaultproperties
{
    Damage=10 // make it more of a spook than an actual killing projectile
    Speed=12000.0  
    ShellDiameter=100 
    //bIsTracerBullet=true
    TracerEffectClass=none
    StaticMesh=StaticMesh'DH_UFO_stc.Bat'
    DeflectedMesh=none
    SpeedFudgeScale=1.0
    //TracerHue=64

    WhizSoundEffect=Class'DHBulletWhizUFO'
}
