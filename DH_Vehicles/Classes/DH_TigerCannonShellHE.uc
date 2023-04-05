//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_TigerCannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=49489.0
    MaxSpeed=49489.0
    ShellDiameter=8.8
    BallisticCoefficient=2.4 //TODO: find correct BC

    //Damage
    ImpactDamage=1000
    Damage=475.0   // 1002 gramms TNT
    DamageRadius=1550.0
    MyDamageType=class'DH_Engine.DHShellHE88mmDamageType'
    PenetrationMag=1020.0
    HullFireChance=1.0
    EngineFireChance=1.0

    //Effects
    bHasTracer=false
    bHasShellTrail=false

    bDebugInImperial=false

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

    //Gunsight adjustments
    bMechanicalAiming=true
    MechanicalRanges(1)=(Range=100,RangeValue=14.0)
    MechanicalRanges(2)=(Range=200,RangeValue=25.0)
    MechanicalRanges(3)=(Range=300,RangeValue=45.0)
    MechanicalRanges(4)=(Range=400,RangeValue=62.0)
    MechanicalRanges(5)=(Range=500,RangeValue=75.0)
    MechanicalRanges(6)=(Range=600,RangeValue=92.0)
    MechanicalRanges(7)=(Range=700,RangeValue=111.0)
    MechanicalRanges(8)=(Range=800,RangeValue=125.0)
    MechanicalRanges(9)=(Range=900,RangeValue=142.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=168.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=185.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=202.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=224.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=245.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=267.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=289.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=312.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=334.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=354.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=374.0)
    MechanicalRanges(21)=(Range=2200,RangeValue=427.0)
    MechanicalRanges(22)=(Range=2400,RangeValue=486.0)
    MechanicalRanges(23)=(Range=2600,RangeValue=539.0)
    MechanicalRanges(24)=(Range=2800,RangeValue=599.0)
    MechanicalRanges(25)=(Range=3000,RangeValue=662.0)
    MechanicalRanges(26)=(Range=3200,RangeValue=734.0)
    MechanicalRanges(27)=(Range=3400,RangeValue=800.0)
    MechanicalRanges(28)=(Range=3600,RangeValue=872.0)
    MechanicalRanges(29)=(Range=3800,RangeValue=949.0)
    MechanicalRanges(30)=(Range=4000,RangeValue=1028.0)
}
