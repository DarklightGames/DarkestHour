//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Breda38BulletTracer extends DH_Breda38Bullet;

defaultproperties
{
    bIsTracerBullet=true
    TracerEffectClass=class'DH_Effects.DHBulletTracer_White'
    StaticMesh=StaticMesh'DH_Tracers.IT_Tracer_Ball'
    DeflectedMesh=StaticMesh'DH_Tracers.IT_Tracer_Ball'
    SpeedFudgeScale=0.50
    TracerHue=0
    TracerSaturation=255
}
