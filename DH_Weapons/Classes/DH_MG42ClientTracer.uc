//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_MG42ClientTracer extends DH_ClientTracer;

defaultproperties
{
    mTracerClass=class'DH_Effects.DH_GermanYellowOrangeTracer'
    StaticMesh=StaticMesh'DH_Tracers.Ger_Tracer'
    DeflectedMesh=StaticMesh'DH_Tracers.Ger_Tracer_Ball'
    Speed=46772.000000 // Matt: was 47678 but that doesn't match MG42 bullets or vehicle tracer
    SpeedFudgeScale=0.750000
    BallisticCoefficient=0.515000
    LightHue=30
}
