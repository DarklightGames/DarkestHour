//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_DP28TracerBullet extends DH_DP28Bullet;

defaultproperties
{
    bIsTracerBullet=true
    TracerEffectClass=class'DH_Effects.DHBulletTracer_Green'
    StaticMesh=StaticMesh'DH_Tracers.Soviet_Tracer_Ball'
    DeflectedMesh=StaticMesh'DH_Tracers.Soviet_Tracer_Ball'
    SpeedFudgeScale=0.5
    TracerHue=64
}
