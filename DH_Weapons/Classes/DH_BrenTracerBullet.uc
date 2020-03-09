//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_BrenTracerBullet extends DH_BrenBullet;

defaultproperties
{
    bIsTracerBullet=true
    TracerEffectClass=class'DH_Effects.DHBulletTracer_Red'
    StaticMesh=StaticMesh'DH_Tracers.US_Tracer_Ball'//'DH_Tracers.US_Tracer'
    DeflectedMesh=StaticMesh'DH_Tracers.US_Tracer_Ball'
    SpeedFudgeScale=0.50
    LightHue=0
    LightSaturation=0
}
