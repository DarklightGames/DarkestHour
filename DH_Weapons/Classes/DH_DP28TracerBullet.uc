//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_DP28TracerBullet extends DH_DP28Bullet;

defaultproperties
{
    bIsTracerBullet=true
    TracerEffectClass=class'DH_Effects.DHBulletTracer_Green'
    StaticMesh=StaticMesh'DH_Tracers.Soviet_Tracer_Ball'//'EffectsSM.Russ_Tracer'
    DeflectedMesh=StaticMesh'DH_Tracers.Soviet_Tracer_Ball'//StaticMesh'EffectsSM.Russ_Tracer_Ball'
    //StaticMesh=StaticMesh'DH_Tracers.Soviet_Tracer'
    //DeflectedMesh=StaticMesh'DH_Tracers.Soviet_Tracer_Ball'
    SpeedFudgeScale=0.5 //0.75
    LightHue=64 //casts a greenish glow on objects/terrain
    LightSaturation=0
    LightRadius=6
    DrawScale=2.0
}
