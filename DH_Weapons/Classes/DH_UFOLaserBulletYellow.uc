//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_UFOLaserBulletYellow extends DH_MG34Bullet;

defaultproperties
{
    Damage=500
    Speed=7000.0  //very slow
    bIsTracerBullet=true
    TracerEffectClass=Class'DHBulletTracerUFO_YellowOrange'
    StaticMesh=StaticMesh'DH_Tracers.Ger_Tracer_Ball'
    DeflectedMesh=StaticMesh'DH_Tracers.Ger_Tracer_Ball'
    SpeedFudgeScale=1.0
    TracerHue=40
}
