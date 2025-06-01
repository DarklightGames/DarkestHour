//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_DP27LateTracerBullet extends DH_DP27LateBullet;

defaultproperties
{
    bIsTracerBullet=true
    TracerEffectClass=class'DH_Effects.DHBulletTracer_Green'
    StaticMesh=StaticMesh'DH_Tracers.Soviet_Tracer_Ball'
    DeflectedMesh=StaticMesh'DH_Tracers.Soviet_Tracer_Ball'
    SpeedFudgeScale=0.5
    TracerHue=64
}
