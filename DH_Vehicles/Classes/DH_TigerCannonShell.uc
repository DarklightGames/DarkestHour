//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_TigerCannonShell extends DHGermanCannonShell;

defaultproperties
{
    Speed=48281.0
    MaxSpeed=48281.0
    ShellDiameter=8.8
    BallisticCoefficient=3.3 //TODO: find correct BC

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
    bMechanicalAiming=true
    MechanicalRanges(1)=(Range=100,RangeValue=8.0)
    MechanicalRanges(2)=(Range=200,RangeValue=18.0)
    MechanicalRanges(3)=(Range=300,RangeValue=29.0)
    MechanicalRanges(4)=(Range=400,RangeValue=38.0)
    MechanicalRanges(5)=(Range=500,RangeValue=45.0)
    MechanicalRanges(6)=(Range=600,RangeValue=55.0)
    MechanicalRanges(7)=(Range=700,RangeValue=67.0)
    MechanicalRanges(8)=(Range=800,RangeValue=75.0)
    MechanicalRanges(9)=(Range=900,RangeValue=87.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=97.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=105.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=115.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=128.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=137.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=149.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=159.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=170.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=180.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=193.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=203.0)
    MechanicalRanges(21)=(Range=2200,RangeValue=225.0)
    MechanicalRanges(22)=(Range=2400,RangeValue=247.0)
    MechanicalRanges(23)=(Range=2600,RangeValue=277.0)
    MechanicalRanges(24)=(Range=2800,RangeValue=300.0)
    MechanicalRanges(25)=(Range=3000,RangeValue=330.0)
    MechanicalRanges(26)=(Range=3200,RangeValue=340.0)
    MechanicalRanges(27)=(Range=3400,RangeValue=365.0)
    MechanicalRanges(28)=(Range=3600,RangeValue=390.0)
    MechanicalRanges(29)=(Range=3800,RangeValue=415.0)
    MechanicalRanges(30)=(Range=4000,RangeValue=440.0)
}
