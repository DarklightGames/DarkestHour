//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHCannonShellHVAP extends DHCannonShell
    abstract;

defaultproperties
{
    RoundType=RT_HVAP
    bShatterProne=true
    SpeedFudgeScale=0.4
    ShellImpactDamage=class'DH_Engine.DHShellSubCalibreImpactDamageType'
    CoronaClass=class'DH_Effects.DHShellTracer_Red'
}
