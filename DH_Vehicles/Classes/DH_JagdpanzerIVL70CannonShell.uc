//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JagdpanzerIVL70CannonShell extends DHGermanCannonShell;

defaultproperties
{
    Speed=55826.0
    MaxSpeed=55826.0
    ShellDiameter=7.5
    BallisticCoefficient=2.52

    //Damage
    ImpactDamage=750  //29 gramms TNT filler
    ShellImpactDamage=class'DH_Engine.DHShellAPGunImpactDamageType'
    HullFireChance=0.45
    EngineFireChance=0.85

    //Penetration
    DHPenetrationTable(0)=18.3
    DHPenetrationTable(1)=17.9
    DHPenetrationTable(2)=16.8
    DHPenetrationTable(3)=15.8
    DHPenetrationTable(4)=14.9
    DHPenetrationTable(5)=14.0
    DHPenetrationTable(6)=13.2
    DHPenetrationTable(7)=12.5
    DHPenetrationTable(8)=11.6
    DHPenetrationTable(9)=10.3
    DHPenetrationTable(10)=9.1

    MechanicalRanges(1)=(Range=100,RangeValue=4.0)
    MechanicalRanges(2)=(Range=200,RangeValue=12.0)
    MechanicalRanges(3)=(Range=300,RangeValue=18.0)
    MechanicalRanges(4)=(Range=400,RangeValue=25.0)
    MechanicalRanges(5)=(Range=500,RangeValue=32.0)
    MechanicalRanges(6)=(Range=600,RangeValue=40.0)
    MechanicalRanges(7)=(Range=700,RangeValue=47.0)
    MechanicalRanges(8)=(Range=800,RangeValue=55.0)
    MechanicalRanges(9)=(Range=900,RangeValue=62.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=74.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=80.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=88.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=96.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=104.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=109.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=122.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=123.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=138.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=142.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=149.0)
    MechanicalRanges(21)=(Range=2200,RangeValue=167.0)
    MechanicalRanges(22)=(Range=2400,RangeValue=189.0)
    MechanicalRanges(23)=(Range=2600,RangeValue=210.0)
    MechanicalRanges(24)=(Range=2800,RangeValue=227.0)
    MechanicalRanges(25)=(Range=3000,RangeValue=252.0)
    bMechanicalAiming=true
}
