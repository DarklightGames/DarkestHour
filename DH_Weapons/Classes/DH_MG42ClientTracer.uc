//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_MG42ClientTracer extends ROClientTracer;

defaultproperties
{
     mTracerClass=class'DH_Weapons.DH_GermanYellowOrangeTracer'
     DeflectedMesh=StaticMesh'DH_Tracers.Ger_Tracer_Ball'
     BallisticCoefficient=0.515000
     SpeedFudgeScale=0.750000
     Speed=47678.000000
     LightHue=30
     LightSaturation=128
     LightRadius=10.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_Tracers.Ger_Tracer'
     DrawScale=2.000000
}
