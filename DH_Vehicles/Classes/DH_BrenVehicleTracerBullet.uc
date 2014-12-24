//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BrenVehicleTracerBullet extends DH_BrenVehicleBullet;

defaultproperties
{
    bIsTracerBullet=true
    TracerEffectClass=class'DH_Effects.DH_AmericanRedTracer' // Matt: changed from DH_30CalVehicleRedTracer as vehicle version was identical (that class now deprecated)
    StaticMesh=StaticMesh'DH_Tracers.US_Tracer'
    DeflectedMesh=StaticMesh'DH_Tracers.US_Tracer_Ball' // Matt: changed from 'US_TracerVehicle_Ball' as no reason for vehicle to differ & standard tracer ball matches size of German ball
    SpeedFudgeScale=0.75 // Matt: changed from 0.5 to match infantry bren & other MGs
    LightHue=0
}
