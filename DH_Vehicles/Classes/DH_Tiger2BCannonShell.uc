//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Tiger2BCannonShell extends DHGermanCannonShell;

defaultproperties
{
    Speed=60352.0
    MaxSpeed=60352.0
    ShellDiameter=8.8
    BallisticCoefficient=3.8 //TODO: find correct BC

    ImpactDamage=1150  //109 gramms TNT filler
    HullFireChance=0.5
    EngineFireChance=0.98

    //Penetration
    DHPenetrationTable(0)=25.7
    DHPenetrationTable(1)=24.9
    DHPenetrationTable(2)=23.5
    DHPenetrationTable(3)=22.2
    DHPenetrationTable(4)=21.0
    DHPenetrationTable(5)=19.6
    DHPenetrationTable(6)=18.8
    DHPenetrationTable(7)=18.3
    DHPenetrationTable(8)=17.6
    DHPenetrationTable(9)=16.4
    DHPenetrationTable(10)=15.3

    //Gunsight adjustments
    bMechanicalAiming=true
    MechanicalRanges(1)=(Range=100,RangeValue=8.0)
    MechanicalRanges(2)=(Range=200,RangeValue=10.0)
    MechanicalRanges(3)=(Range=300,RangeValue=22.0)
    MechanicalRanges(4)=(Range=400,RangeValue=26.0)
    MechanicalRanges(5)=(Range=500,RangeValue=30.0)
    MechanicalRanges(6)=(Range=600,RangeValue=36.0)
    MechanicalRanges(7)=(Range=700,RangeValue=42.0)
    MechanicalRanges(8)=(Range=800,RangeValue=44.0)
    MechanicalRanges(9)=(Range=900,RangeValue=52.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=56.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=62.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=66.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=74.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=82.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=88.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=94.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=100.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=106.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=112.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=118.0)
    MechanicalRanges(21)=(Range=2200,RangeValue=130.0)
    MechanicalRanges(22)=(Range=2400,RangeValue=141.0)
    MechanicalRanges(23)=(Range=2600,RangeValue=153.0)
    MechanicalRanges(24)=(Range=2800,RangeValue=164.0)
    MechanicalRanges(25)=(Range=3000,RangeValue=179.0)
    MechanicalRanges(26)=(Range=3200,RangeValue=222.0)
    MechanicalRanges(27)=(Range=3400,RangeValue=244.0)
    MechanicalRanges(28)=(Range=3600,RangeValue=262.0)
    MechanicalRanges(29)=(Range=3800,RangeValue=282.0)
    MechanicalRanges(30)=(Range=4000,RangeValue=304.0)
}
