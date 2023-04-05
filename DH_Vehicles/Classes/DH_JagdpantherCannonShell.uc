//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JagdpantherCannonShell extends DHGermanCannonShell;

defaultproperties
{
    Speed=60352.0
    MaxSpeed=60352.0
    ShellDiameter=8.8
    BallisticCoefficient=3.8 //TODO: find correct BC

    //Damage
    ImpactDamage=975  //109 gramms TNT filler
    ShellImpactDamage=class'DH_Engine.DHShellAPGunImpactDamageType'
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
    MechanicalRanges(3)=(Range=300,RangeValue=4.0)
    MechanicalRanges(4)=(Range=400,RangeValue=8.0)
    MechanicalRanges(5)=(Range=500,RangeValue=12.0)
    MechanicalRanges(6)=(Range=600,RangeValue=16.0)
    MechanicalRanges(7)=(Range=700,RangeValue=23.0)
    MechanicalRanges(8)=(Range=800,RangeValue=28.0)
    MechanicalRanges(9)=(Range=900,RangeValue=32.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=35.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=40.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=46.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=52.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=60.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=65.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=70.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=75.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=80.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=86.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=92.0)
    MechanicalRanges(21)=(Range=2200,RangeValue=104.0)
    MechanicalRanges(22)=(Range=2400,RangeValue=120.0)
    MechanicalRanges(23)=(Range=2600,RangeValue=136.0)
    MechanicalRanges(24)=(Range=2800,RangeValue=156.0)
    MechanicalRanges(25)=(Range=3000,RangeValue=176.0)
    MechanicalRanges(26)=(Range=3200,RangeValue=196.0)
    MechanicalRanges(27)=(Range=3400,RangeValue=216.0)
    MechanicalRanges(28)=(Range=3600,RangeValue=238.0)
    MechanicalRanges(29)=(Range=3800,RangeValue=260.0)
    MechanicalRanges(30)=(Range=4000,RangeValue=282.0)
}
