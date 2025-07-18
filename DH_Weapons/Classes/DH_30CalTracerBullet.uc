//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_30CalTracerBullet extends DH_30calBullet;

defaultproperties
{
    bIsTracerBullet=true
    TracerEffectClass=Class'DHBulletTracer_Red'
    StaticMesh=StaticMesh'DH_Tracers.US_Tracer_Ball'
    DeflectedMesh=StaticMesh'DH_Tracers.US_Tracer_Ball'
    SpeedFudgeScale=0.50
    TracerHue=0
}
