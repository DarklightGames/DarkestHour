//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_30CalVehicleClientTracer extends ROClientTracer;

defaultproperties
{
     mTracerClass=class'DH_Vehicles.DH_30CalVehicleRedTracer'
     DeflectedMesh=StaticMesh'DH_Tracers.US_TracerVehicle_Ball'
     BallisticCoefficient=0.410000
     SpeedFudgeScale=0.750000
     Speed=51299.000000
     LightHue=0
     LightSaturation=128
     LightRadius=10.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_Tracers.US_Tracer'
     DrawScale=2.000000
}
