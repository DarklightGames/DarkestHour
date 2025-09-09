//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MaximM191030TracerBullet extends DH_MaximM191030Bullet;

defaultproperties
{
    bIsTracerBullet=true
    TracerEffectClass=Class'DHBulletTracer_Green'
    StaticMesh=StaticMesh'DH_Tracers.Soviet_Tracer_Ball'
    DeflectedMesh=StaticMesh'DH_Tracers.Soviet_Tracer_Ball'
    SpeedFudgeScale=0.5
    TracerHue=64
}
