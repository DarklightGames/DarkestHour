//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_AchillesCannonShell extends DHCannonShell;

defaultproperties
{
    Speed=53346.0 //2900 fps or 884 m/s
    MaxSpeed=53346.0
    ShellDiameter=7.62
    BallisticCoefficient=2.45

    // Damage
    ImpactDamage=580  //solid shell
    ShellImpactDamage=class'DH_Engine.DHShellAPGunImpactDamageType'
    HullFireChance=0.35
    EngineFireChance=0.75

    //Penetration
    DHPenetrationTable(0)=18.5
    DHPenetrationTable(1)=17.7
    DHPenetrationTable(2)=16.6
    DHPenetrationTable(3)=15.8
    DHPenetrationTable(4)=15.1
    DHPenetrationTable(5)=14.3
    DHPenetrationTable(6)=13.7
    DHPenetrationTable(7)=13.1
    DHPenetrationTable(8)=12.6
    DHPenetrationTable(9)=10.3
    DHPenetrationTable(10)=8.7

    //Gunsight adjustment
    MechanicalRanges(0)=(RangeValue=32.0)
    MechanicalRanges(1)=(Range=100,RangeValue=34.0)
    MechanicalRanges(2)=(Range=200,RangeValue=36.0)
    MechanicalRanges(3)=(Range=300,RangeValue=38.0)
    MechanicalRanges(4)=(Range=400,RangeValue=40.0)
    MechanicalRanges(5)=(Range=500,RangeValue=42.0)
    MechanicalRanges(6)=(Range=600,RangeValue=44.0)
    MechanicalRanges(7)=(Range=700,RangeValue=52.0)
    MechanicalRanges(8)=(Range=800,RangeValue=60.0)
    MechanicalRanges(9)=(Range=900,RangeValue=70.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=80.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=92.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=104.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=114.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=124.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=137.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=148.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=156.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=168.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=175.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=184.0)
    bMechanicalAiming=true
}
