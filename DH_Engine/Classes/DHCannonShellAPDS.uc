//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCannonShellAPDS extends DHCannonShell
    abstract;

defaultproperties
{
    RoundType=RT_APDS
    bShatterProne=true //set false in individual shell classes for APCR rounds
    SpeedFudgeScale=0.4
    ShellImpactDamage=Class'DHShellSubCalibreImpactDamageType'
    CoronaClass=Class'DHShellTracer_Red'
    ShellShatterEffectClass=Class'DHShellShatterEffect'
}
