//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Pak40CannonShell extends DHGermanCannonShell;

defaultproperties
{
    Speed=45270.0
    MaxSpeed=45270.0
    ShellDiameter=7.5
    BallisticCoefficient=2.52 //TODO: pls, check

    //Damage
    ImpactDamage=700  //29 gramms TNT filler
    ShellImpactDamage=class'DH_Engine.DHShellAPGunImpactDamageType'
    HullFireChance=0.45
    EngineFireChance=0.85

    //Penetration
    DHPenetrationTable(0)=13.5
    DHPenetrationTable(1)=13.0
    DHPenetrationTable(2)=12.3
    DHPenetrationTable(3)=11.6
    DHPenetrationTable(4)=10.9
    DHPenetrationTable(5)=10.3
    DHPenetrationTable(6)=9.7
    DHPenetrationTable(7)=9.2
    DHPenetrationTable(8)=8.6
    DHPenetrationTable(9)=7.6
    DHPenetrationTable(10)=6.8

    //Gunsight adjustments
    MechanicalRanges(1)=(Range=100,RangeValue=16.0)
    MechanicalRanges(2)=(Range=200,RangeValue=22.0)
    MechanicalRanges(3)=(Range=300,RangeValue=32.0)
    MechanicalRanges(4)=(Range=400,RangeValue=40.0)
    MechanicalRanges(5)=(Range=500,RangeValue=50.0)
    MechanicalRanges(6)=(Range=600,RangeValue=60.0)
    MechanicalRanges(7)=(Range=700,RangeValue=72.0)
    MechanicalRanges(8)=(Range=800,RangeValue=82.0)
    MechanicalRanges(9)=(Range=900,RangeValue=92.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=102.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=114.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=128.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=138.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=150.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=162.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=176.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=188.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=204.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=216.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=230.0)
    bMechanicalAiming=true
}
