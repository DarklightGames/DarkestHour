//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_StuH42CannonShellSmoke extends DH_Stug3GCannonShellSmoke;

defaultproperties
{
    Speed=29874.0 // same as 105mm HE or HEAT shells
    MaxSpeed=29874.0
    ShellDiameter=10.5
    DrawScale=1.5
    BallisticCoefficient=2.96 // same as 105mm HE or HEAT shells
    ImpactDamage=175 // 75mm smoke shells are 125, so increased as this is a larger, heavier shell

    SmokeEmitterClass=Class'DHSmokeEffect_LargeShell'
}
