//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PanzerIVGEarlyCannonShell extends DHGermanCannonShell;

defaultproperties
{
    Speed=45270.0
    MaxSpeed=45270.0
    ShellDiameter=7.5
    BallisticCoefficient=2.52

    //Damage
    ImpactDamage=700  //29 gramms TNT filler
    ShellImpactDamage=class'DH_Engine.DHShellAPGunImpactDamageType'
    HullFireChance=0.45
    EngineFireChance=0.85

    //Penetration
    DHPenetrationTable(0)=13.3
    DHPenetrationTable(1)=12.8
    DHPenetrationTable(2)=12.1
    DHPenetrationTable(3)=11.4
    DHPenetrationTable(4)=10.7
    DHPenetrationTable(5)=10.1
    DHPenetrationTable(6)=9.5
    DHPenetrationTable(7)=9.0
    DHPenetrationTable(8)=8.5
    DHPenetrationTable(9)=7.5
    DHPenetrationTable(10)=6.7

    MechanicalRanges(1)=(Range=100,RangeValue=33.0)
    MechanicalRanges(2)=(Range=200,RangeValue=37.0)
    MechanicalRanges(3)=(Range=300,RangeValue=41.0)
    MechanicalRanges(4)=(Range=400,RangeValue=48.0)
    MechanicalRanges(5)=(Range=500,RangeValue=56.0)
    MechanicalRanges(6)=(Range=600,RangeValue=64.0)
    MechanicalRanges(7)=(Range=700,RangeValue=76.0)
    MechanicalRanges(8)=(Range=800,RangeValue=87.0)
    MechanicalRanges(9)=(Range=900,RangeValue=97.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=109.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=122.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=131.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=146.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=155.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=167.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=179.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=193.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=204.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=216.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=235.0)
    MechanicalRanges(21)=(Range=2200,RangeValue=258.0)
    MechanicalRanges(22)=(Range=2400,RangeValue=278.0)
    MechanicalRanges(23)=(Range=2600,RangeValue=298.0)
    MechanicalRanges(24)=(Range=2800,RangeValue=318.0)
    MechanicalRanges(25)=(Range=3000,RangeValue=338.0)
    bMechanicalAiming=true
}
