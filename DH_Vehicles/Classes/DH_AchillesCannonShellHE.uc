//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_AchillesCannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=53351.0
    MaxSpeed=53351.0
    ShellDiameter=7.62
    BallisticCoefficient=2.45 //TODO: pls check

    //Damage
    ImpactDamage=500
    ShellImpactDamage=class'DH_Engine.DHShellHEGunImpactDamageType'
    PenetrationMag=800.0
    Damage=300.0   //580 gramms TNT
    DamageRadius=880.0
    MyDamageType=class'DH_Engine.DHShellHE75mmATDamageType'
    HullFireChance=0.8
    EngineFireChance=0.8

    //Penetration
    DHPenetrationTable(0)=4.5
    DHPenetrationTable(1)=4.2
    DHPenetrationTable(2)=3.8
    DHPenetrationTable(3)=3.2
    DHPenetrationTable(4)=2.9
    DHPenetrationTable(5)=2.4
    DHPenetrationTable(6)=2.0
    DHPenetrationTable(7)=2.0
    DHPenetrationTable(8)=2.0
    DHPenetrationTable(9)=2.0
    DHPenetrationTable(10)=2.0

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
