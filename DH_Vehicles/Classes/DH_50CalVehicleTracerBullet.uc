//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_50CalVehicleTracerBullet extends DH_50CalVehicleBullet;

defaultproperties
{
    bHasTracer=true
    TracerEffectClass=class'DH_Effects.DH_AmericanRedTracer'
    StaticMesh=StaticMesh'DH_Tracers.US_Tracer'
    DeflectedMesh=StaticMesh'DH_Tracers.US_Tracer_Ball'
    SpeedFudgeScale=0.75
    LightHue=0
}
