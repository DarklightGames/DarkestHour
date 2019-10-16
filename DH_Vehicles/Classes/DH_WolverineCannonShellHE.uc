//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_WolverineCannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=47799.0
    MaxSpeed=47799.0
    ShellDiameter=7.62
    BallisticCoefficient=1.368 //TODO: find correct BC

    //Damage
    ImpactDamage=450
    Damage=400.0
    DamageRadius=1140.0
    PenetrationMag=780.0
    HullFireChance=0.32
    EngineFireChance=0.65

    //Penetration
    DHPenetrationTable(0)=4.2
    DHPenetrationTable(1)=3.8
    DHPenetrationTable(2)=3.2
    DHPenetrationTable(3)=2.9
    DHPenetrationTable(4)=2.4
    DHPenetrationTable(5)=2.0
    DHPenetrationTable(6)=1.7
    DHPenetrationTable(7)=1.3
    DHPenetrationTable(8)=1.1
    DHPenetrationTable(9)=1.0
    DHPenetrationTable(10)=0.8
}
