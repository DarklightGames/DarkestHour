//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BARClientTracer extends DH_ClientTracer;

defaultproperties
{
    mTracerClass=class'DH_Effects.DH_AmericanRedTracer'
    StaticMesh=StaticMesh'DH_Tracers.US_Tracer'
    DeflectedMesh=StaticMesh'DH_Tracers.US_Tracer_Ball'
    Speed=48583.000000
    SpeedFudgeScale=0.900000
    BallisticCoefficient=0.410000
    LightHue=0
}
