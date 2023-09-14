//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Flak88CannonShell extends DHGermanCannonShell;

defaultproperties
{
    Speed=48281.0
    MaxSpeed=48281.0
    ShellDiameter=8.8
    BallisticCoefficient=3.3 //pls, check

    //Damage
    ImpactDamage=975  //109 gramms TNT filler
    HullFireChance=0.5
    EngineFireChance=0.98

    //Penetration
    DHPenetrationTable(0)=16.2
    DHPenetrationTable(1)=15.8
    DHPenetrationTable(2)=15.1
    DHPenetrationTable(3)=14.4
    DHPenetrationTable(4)=13.8
    DHPenetrationTable(5)=13.2
    DHPenetrationTable(6)=12.6
    DHPenetrationTable(7)=12.2
    DHPenetrationTable(8)=11.6
    DHPenetrationTable(9)=10.6
    DHPenetrationTable(10)=9.7

    //Gunsight adjustments
    MechanicalRanges(1)=(Range=100,RangeValue=14.0)
    MechanicalRanges(2)=(Range=200,RangeValue=20.0)
    MechanicalRanges(3)=(Range=300,RangeValue=26.0)
    MechanicalRanges(4)=(Range=400,RangeValue=40.0)
    MechanicalRanges(5)=(Range=500,RangeValue=44.0)
    MechanicalRanges(6)=(Range=600,RangeValue=52.0)
    MechanicalRanges(7)=(Range=700,RangeValue=62.0)
    MechanicalRanges(8)=(Range=800,RangeValue=74.0)
    MechanicalRanges(9)=(Range=900,RangeValue=84.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=90.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=106.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=112.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=126.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=132.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=148.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=154.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=166.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=180.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=194.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=200.0)
    MechanicalRanges(21)=(Range=2200,RangeValue=220.0)
    MechanicalRanges(22)=(Range=2400,RangeValue=240.0)
    MechanicalRanges(23)=(Range=2600,RangeValue=259.0)
    MechanicalRanges(24)=(Range=2800,RangeValue=278.0)
    MechanicalRanges(25)=(Range=3000,RangeValue=298.0)
    bMechanicalAiming=true
}
