//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_50CalVehicleTracerBullet extends DH_50CalVehicleBullet;

defaultproperties
{
    bHasTracer=true
    TracerEffectClass=class'DH_Effects.DHBulletTracer_RedLarge'
    StaticMesh=StaticMesh'DH_Tracers.US_Tracer_Ball'
    DeflectedMesh=StaticMesh'DH_Tracers.US_Tracer_Ball'
    SpeedFudgeScale=0.50
    TracerHue=0
}
