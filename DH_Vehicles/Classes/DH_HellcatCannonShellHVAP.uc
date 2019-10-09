//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_HellcatCannonShellHVAP extends DHCannonShellHVAP;

defaultproperties
{
    Speed=62525.0
    MaxSpeed=62525.0
    DHPenetrationTable(10)=6.7
    ShellDiameter=7.62
    BallisticCoefficient=0.888 //TODO: pls find correct BC

    //Damage
    ImpactDamage=425
    ShellImpactDamage=class'DH_Vehicles.DH_ShermanM4A176WCannonShellDamageHVAP'
    HullFireChance=0.3
    EngineFireChance=0.43

    //Penetration
    DHPenetrationTable(0)=19.2
    DHPenetrationTable(1)=17.7
    DHPenetrationTable(2)=16.5
    DHPenetrationTable(3)=14.6
    DHPenetrationTable(4)=13.7
    DHPenetrationTable(5)=12.5
    DHPenetrationTable(6)=11.3
    DHPenetrationTable(7)=10.6
    DHPenetrationTable(8)=9.4
    DHPenetrationTable(9)=8.0
}
