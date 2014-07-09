//=============================================================================
// DH_30CalClientVehicleTracer
//=============================================================================
class DH_BesaVehicleClientTracer extends ROClientTracer;

defaultproperties
{
     mTracerClass=Class'DH_Vehicles.DH_30CalVehicleRedTracer'
     DeflectedMesh=StaticMesh'DH_Tracers.US_TracerVehicle_Ball'
     BallisticCoefficient=0.410000
     SpeedFudgeScale=0.500000
     Speed=49670.000000
     LightHue=0
     LightSaturation=128
     LightRadius=10.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DH_Tracers.US_Tracer'
     DrawScale=2.000000
}
