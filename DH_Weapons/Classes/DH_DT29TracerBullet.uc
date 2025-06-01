//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_DT29TracerBullet extends DH_DT29Bullet;

defaultproperties
{
    bIsTracerBullet=true
    TracerEffectClass=class'DH_Effects.DHBulletTracer_Green'
    StaticMesh=StaticMesh'DH_Tracers.Soviet_Tracer_Ball'
    DeflectedMesh=StaticMesh'DH_Tracers.Soviet_Tracer_Ball'
    SpeedFudgeScale=0.5
    TracerHue=64
}
