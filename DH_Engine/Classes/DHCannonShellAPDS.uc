//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHCannonShellAPDS extends DHCannonShell
    abstract;

defaultproperties
{
    RoundType=RT_APDS
    bShatterProne=true
    SpeedFudgeScale=0.4
    ShellImpactDamage=class'DH_Engine.DHShellSubCalibreImpactDamageType'
    CoronaClass=class'DH_Effects.DHShellTracer_Red'
}
