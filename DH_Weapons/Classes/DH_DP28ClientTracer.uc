//=============================================================================
// DP28ClientTracer
//=============================================================================
// Client side DP28 bullet with a tracer effect
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 John Ramm-Jaeger" Gibson
//=============================================================================

class DH_DP28ClientTracer extends ROClientTracer;


//Theel: Do I need to change the tracer classes?  why green tracers?
defaultproperties
{
     LightHue=80
     LightSaturation=128
     LightRadius=10.000000
     Bounces=1
     //compile error  StaticMesh=StaticMesh'DH_ROTracers.Russ_Tracer'
     //compile error  DeflectedMesh=StaticMesh'DH_ROTracers.Russ_Tracer_Ball'
     SpeedFudgeScale=0.500000
     BallisticCoefficient=0.511
     Speed=50696 // 840 m/s
     DrawType=DT_StaticMesh
     //compile error  mTracerClass=class'DH_ROEffects.DH_SovietGreenTracer'
     DrawScale=2.000000
}
