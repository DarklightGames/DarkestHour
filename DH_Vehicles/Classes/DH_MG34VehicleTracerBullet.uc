//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_MG34VehicleTracerBullet extends DH_MG34VehicleBullet;

defaultproperties
{
    bIsTracerBullet=true
    TracerEffectClass=class'DH_Effects.DH_GermanYellowOrangeTracer' // Matt: changed from DH_GermanVehicleMGTracer as vehicle version was identical (that class now deprecated)
    StaticMesh=StaticMesh'DH_Tracers.Ger_Tracer'
    DeflectedMesh=StaticMesh'DH_Tracers.Ger_Tracer_Ball'
    SpeedFudgeScale=0.75
    LightHue=30
}
