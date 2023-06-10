//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHCannonShellAPDS extends DHCannonShell
    abstract;

defaultproperties
{
    RoundType=RT_APDS
    bShatterProne=true //set false in individual shell classes for APCR rounds
    SpeedFudgeScale=0.4
    ShellImpactDamage=class'DH_Engine.DHShellSubCalibreImpactDamageType'
    CoronaClass=class'DH_Effects.DHShellTracer_Red'
    ShellShatterEffectClass=class'DH_Effects.DHShellShatterEffect'
}
