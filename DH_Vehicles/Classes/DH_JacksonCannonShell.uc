//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_JacksonCannonShell extends DHCannonShell;

defaultproperties
{
    Speed=51480.0 //2800 fps or 853 m/s
    MaxSpeed=51480.0
    ShellDiameter=9.0
    BallisticCoefficient=3.85 //Correct - verified on range at 1000 yards

    //Damage
    ImpactDamage=700
    HullFireChance=0.45
    EngineFireChance=0.90
    //Penetration
    DHPenetrationTable(0)=16.9
    DHPenetrationTable(1)=16.8
    DHPenetrationTable(2)=16.4
    DHPenetrationTable(3)=15.7
    DHPenetrationTable(4)=15.1
    DHPenetrationTable(5)=14.4
    DHPenetrationTable(6)=13.8
    DHPenetrationTable(7)=13.3
    DHPenetrationTable(8)=12.7
    DHPenetrationTable(9)=11.5
    DHPenetrationTable(10)=10.4
}
