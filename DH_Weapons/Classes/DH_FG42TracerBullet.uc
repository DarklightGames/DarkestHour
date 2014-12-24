//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_FG42TracerBullet extends DH_FG42Bullet;

defaultproperties
{
    bIsTracerBullet=true
    TracerEffectClass=class'DH_Effects.DH_GermanYellowOrangeTracer'
    StaticMesh=StaticMesh'DH_Tracers.Ger_Tracer'
    DeflectedMesh=StaticMesh'DH_Tracers.Ger_Tracer_Ball'
    SpeedFudgeScale=0.9
    LightHue=30
}
