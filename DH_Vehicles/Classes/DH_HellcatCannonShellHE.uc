//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_HellcatCannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=47799.0
    MaxSpeed=47799.0
    ShellDiameter=7.62
    BallisticCoefficient=1.368 //TODO: pls find correct BC, this is terribly wrong

    //Damage
    ImpactDamage=450
    Damage=300.0  //410 gramms TNT
    DamageRadius=1000.0
    PenetrationMag=620.0
    HullFireChance=0.8
    EngineFireChance=0.8

    //Penetration
    DHPenetrationTable(0)=4.2
    DHPenetrationTable(1)=3.8
    DHPenetrationTable(2)=3.2
    DHPenetrationTable(3)=2.9
    DHPenetrationTable(4)=2.4
    DHPenetrationTable(5)=2.0
    DHPenetrationTable(6)=2.0
    DHPenetrationTable(7)=2.0
    DHPenetrationTable(8)=2.0
    DHPenetrationTable(9)=2.0
    DHPenetrationTable(10)=2.0
}
