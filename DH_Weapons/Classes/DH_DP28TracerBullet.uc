//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_DP28TracerBullet extends DH_DP28Bullet;

defaultproperties
{
    bIsTracerBullet=true 
    TracerEffectClass=class'ROEffects.RORussianGreenTracer'
    StaticMesh=StaticMesh'DH_Tracers.Soviet_Tracer'
    DeflectedMesh=StaticMesh'DH_Tracers.Soviet_Tracer_Ball'
    SpeedFudgeScale=0.5
}
