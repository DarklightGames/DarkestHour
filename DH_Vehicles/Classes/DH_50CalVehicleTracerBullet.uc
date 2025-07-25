//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_50CalVehicleTracerBullet extends DH_50CalVehicleBullet;

defaultproperties
{
    bHasTracer=true
    TracerEffectClass=Class'DHBulletTracer_RedLarge'
    StaticMesh=StaticMesh'DH_Tracers.US_Tracer_Ball'
    DeflectedMesh=StaticMesh'DH_Tracers.US_Tracer_Ball'
    SpeedFudgeScale=0.50
    TracerHue=0
}
