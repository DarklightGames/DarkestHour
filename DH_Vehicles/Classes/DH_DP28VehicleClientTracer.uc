//=============================================================================
// DP28ClientTracer
//=============================================================================
// Client side DP28 bullet with a tracer effect
//=============================================================================
// Red Orchestra Source
// Copyright (C) 2005 John Ramm-Jaeger" Gibson
//=============================================================================
class DH_DP28VehicleClientTracer extends ROClientTracer;

defaultproperties
{
    BallisticCoefficient=0.511
    Speed=50696
    SpeedFudgeScale=0.50
    mTracerClass=class'DH_Effects.DHShellTracer_Green'
    LightHue=80
    LightSaturation=128
    LightRadius=10.000000
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DH_Tracers.Russ_Tracer'
    DeflectedMesh=StaticMesh'DH_Tracers.Russ_Tracer_Ball'
    DrawScale=2.0
}
