//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BrenClientTracer extends DH_ClientTracer;

defaultproperties
{
    mTracerClass=class'DH_Effects.DH_AmericanRedTracer'
    StaticMesh=StaticMesh'DH_Tracers.US_Tracer'
    DeflectedMesh=StaticMesh'DH_Tracers.US_Tracer_Ball' // Matt: changed from 'US_TracerVehicle_Ball' as this isn't a vehicle MG
    Speed=44117.000000
    SpeedFudgeScale=0.750000
    BallisticCoefficient=0.390000
    LightHue=0
}
