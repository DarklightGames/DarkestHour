//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_FG42TracerBullet extends DH_FG42Bullet;

defaultproperties
{
    bIsTracerBullet=true
    TracerEffectClass=Class'DHBulletTracer_YellowOrange'
    StaticMesh=StaticMesh'DH_Tracers.Ger_Tracer_Ball'
    DeflectedMesh=StaticMesh'DH_Tracers.Ger_Tracer_Ball'
    SpeedFudgeScale=0.50
    TracerHue=40
}
