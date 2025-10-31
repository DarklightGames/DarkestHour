//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_UFOSnake extends DH_GeratPIIBullet;

defaultproperties
{
    Damage=5000000
    Speed=6000.0  //very slow
    ShellDiameter=100 
    //bIsTracerBullet=true
    TracerEffectClass=none
    StaticMesh=StaticMesh'DH_UFO_stc.Snake'
    DeflectedMesh=none
    SpeedFudgeScale=1.0
    TracerHue=64

    WhizSoundEffect=Class'DHBulletWhizUFO'
}
