//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DHCannonShellHVAP extends DHCannonShell
    abstract;

defaultproperties
{
    RoundType=RT_HVAP
    bShatterProne=true
    ShellImpactDamage=class'DH_Engine.DHShellSubCalibreImpactDamageType'
}
