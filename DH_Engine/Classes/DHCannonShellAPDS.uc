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
    ShellImpactDamage=class'DH_Engine.DHShellSubCalibreImpactDamageType'
    CoronaClass=class'DH_Effects.DHShellTracer_Red'
}
