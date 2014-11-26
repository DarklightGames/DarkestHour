//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_FG42ClientTracer extends DH_ClientTracer;

defaultproperties
{
    mTracerClass=class'DH_Effects.DH_GermanYellowOrangeTracer'
    StaticMesh=StaticMesh'DH_Tracers.Ger_Tracer'         // Matt: changed from 'EffectsSM.Weapons.Ger_Tracer' to match other German tracers
    DeflectedMesh=StaticMesh'DH_Tracers.Ger_Tracer_Ball' // Matt: changed from 'EffectsSM.Weapons.Ger_Tracer_Ball' to match other German tracers
    Speed=45866.000000 // Matt: changed from 45572 to match actual bullet
    SpeedFudgeScale=0.900000
    BallisticCoefficient=0.515000 // Matt: changed from 0.584 to match actual bullet
    LightHue=30
}
