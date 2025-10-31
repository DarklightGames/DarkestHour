//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_UFOBubbleBlue extends DH_GeratPIIBullet;

defaultproperties
{
    Damage=5000000
    Speed=20000.0  
    BallisticCoefficient=2.675
    ShellDiameter=400 
    //bIsTracerBullet=true
    TracerEffectClass=none
    StaticMesh=StaticMesh'DH_UFO_stc.BubbleBlue'
    DeflectedMesh=none
    SpeedFudgeScale=1.0
    TracerHue=0

    WhizSoundEffect=Class'DHBulletWhizUFO'
}
