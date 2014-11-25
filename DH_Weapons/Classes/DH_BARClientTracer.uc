//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BARClientTracer extends ROClientTracer;

defaultproperties
{
     mTracerClass=class'DH_Effects.DH_AmericanRedTracer'
     DeflectedMesh=StaticMesh'DH_Tracers.US_Tracer_Ball'
     BallisticCoefficient=0.410000
     SpeedFudgeScale=0.900000
     Speed=48583.000000
     LightBrightness=45.000000
     LightRadius=10.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_Tracers.US_Tracer'
}
