//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_DT29TracerBullet extends DH_DT29Bullet;

defaultproperties
{
    bIsTracerBullet=true
    TracerEffectClass=class'DH_Effects.DHBulletTracer_Green'
    StaticMesh=StaticMesh'DH_Tracers.Soviet_Tracer_Ball'
    DeflectedMesh=StaticMesh'DH_Tracers.Soviet_Tracer_Ball'
    SpeedFudgeScale=0.5
    TracerHue=64
}
