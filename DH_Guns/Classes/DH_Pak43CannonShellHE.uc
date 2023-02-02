//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Pak43CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=45264.0
    MaxSpeed=45264.0
    ShellDiameter=8.8
    BallisticCoefficient=3.25 //TODO: Pls check

    //Damage
    ImpactDamage=1000
    Damage=475.0   // 1002 gramms TNT
    ShellImpactDamage=class'DH_Engine.DHShellHEGunImpactDamageType'
    PenetrationMag=1020.0

    DamageRadius=1550.0
    MyDamageType=class'DH_Engine.DHShellHE88mmATDamageType'
    HullFireChance=1.0
    EngineFireChance=1.0

    bDebugInImperial=false

    //Effects
    bHasTracer=false
    bHasShellTrail=false

    //Penetration
    DHPenetrationTable(0)=5.2
    DHPenetrationTable(1)=4.9
    DHPenetrationTable(2)=4.3
    DHPenetrationTable(3)=4.0
    DHPenetrationTable(4)=3.8
    DHPenetrationTable(5)=3.2
    DHPenetrationTable(6)=3.0
    DHPenetrationTable(7)=2.7
    DHPenetrationTable(8)=2.3
    DHPenetrationTable(9)=1.9
    DHPenetrationTable(10)=1.5

    //Gunsight adjustment
    MechanicalRanges(1)=(Range=100,RangeValue=42.0)
    MechanicalRanges(2)=(Range=200,RangeValue=46.0)
    MechanicalRanges(3)=(Range=300,RangeValue=50.0)
    MechanicalRanges(4)=(Range=400,RangeValue=54.0)
    MechanicalRanges(5)=(Range=500,RangeValue=56.0)
    MechanicalRanges(6)=(Range=600,RangeValue=62.0)
    MechanicalRanges(7)=(Range=700,RangeValue=66.0)
    MechanicalRanges(8)=(Range=800,RangeValue=70.0)
    MechanicalRanges(9)=(Range=900,RangeValue=74.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=78.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=82.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=90.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=94.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=98.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=102.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=106.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=112.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=122.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=128.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=136.0)
    MechanicalRanges(21)=(Range=2200,RangeValue=148.0)
    MechanicalRanges(22)=(Range=2400,RangeValue=160.0)
    MechanicalRanges(23)=(Range=2600,RangeValue=176.0)
    MechanicalRanges(24)=(Range=2800,RangeValue=196.0)
    MechanicalRanges(25)=(Range=3000,RangeValue=216.0)
    bMechanicalAiming=true
}
