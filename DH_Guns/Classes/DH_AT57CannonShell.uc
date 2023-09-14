//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_AT57CannonShell extends DHCannonShell;

defaultproperties
{
    Speed=50152.0
    MaxSpeed=50152.0
    ShellDiameter=5.7
    BallisticCoefficient=1.19 //TODO: find correct BC

    //Damage
    ImpactDamage=390  //solid shell
    ShellImpactDamage=class'DH_Engine.DHShellAPGunImpactDamageType'
    HullFireChance=0.25
    EngineFireChance=0.45

    bShatterProne=true

    //Effects
    ShellShatterEffectClass=class'DH_Effects.DHShellShatterEffect_Small'
    CoronaClass=class'DH_Effects.DHShellTracer_Red'

    //Penetration
    DHPenetrationTable(0)=11.5
    DHPenetrationTable(1)=11.0
    DHPenetrationTable(2)=10.3
    DHPenetrationTable(3)=9.6
    DHPenetrationTable(4)=9.0
    DHPenetrationTable(5)=8.4
    DHPenetrationTable(6)=7.8
    DHPenetrationTable(7)=7.3
    DHPenetrationTable(8)=6.8
    DHPenetrationTable(9)=6.0
    DHPenetrationTable(10)=5.2
}
