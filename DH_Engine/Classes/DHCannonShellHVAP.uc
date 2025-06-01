//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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
