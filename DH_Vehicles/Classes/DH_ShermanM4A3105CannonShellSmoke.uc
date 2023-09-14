//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanM4A3105CannonShellSmoke extends DH_ShermanCannonShellSmoke;

defaultproperties
{
    Speed=28486.0 // same as 105mm HE shell
    MaxSpeed=28486.0
    ShellDiameter=10.5
    DrawScale=1.5
    ImpactDamage=175 // 75mm smoke shells are 125, so increased as this is a larger, heavier shell
    BallisticCoefficient=2.96 // same as 105mm HE or HEAT shells

    //Effects
    SmokeEmitterClass=class'DH_Effects.DHSmokeEffect_LargeShellWP'

    GasRadius=1100.0
}
