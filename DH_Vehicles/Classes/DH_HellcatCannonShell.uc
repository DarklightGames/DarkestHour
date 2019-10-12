//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_HellcatCannonShell extends DHCannonShell;

defaultproperties
{
    Speed=47799.0
    MaxSpeed=47799.0
    ShellDiameter=7.62
    BallisticCoefficient=1.627 //TODO: pls find correct BC

    //Damage
    ImpactDamage=580
    ShellImpactDamage=class'DH_Vehicles.DH_ShermanM4A176WCannonShellDamageAP'
    HullFireChance=0.4
    EngineFireChance=0.6

    //Effects
    bShatterProne=true

    //Penetration
    DHPenetrationTable(0)=12.5
    DHPenetrationTable(1)=12.1
    DHPenetrationTable(2)=11.6
    DHPenetrationTable(3)=11.1
    DHPenetrationTable(4)=10.6
    DHPenetrationTable(5)=10.1
    DHPenetrationTable(6)=9.7
    DHPenetrationTable(7)=9.3
    DHPenetrationTable(8)=8.9
    DHPenetrationTable(9)=8.7
    DHPenetrationTable(10)=7.4
}
