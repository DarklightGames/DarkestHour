//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JagdpantherCannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Speed=45264.0
    MaxSpeed=45264.0
    ShellDiameter=8.8
    BallisticCoefficient=3.25

    //Damage
    ImpactDamage=550
    Damage=475.0
    DamageRadius=1550.0
    MyDamageType=class'DH_Engine.DHShellHE88mmDamageType'
    PenetrationMag=1020.0
    HullFireChance=0.4
    EngineFireChance=0.55

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

    bDebugInImperial=false

    bMechanicalAiming=true
    MechanicalRanges(3)=(Range=300,RangeValue=12.0)
    MechanicalRanges(4)=(Range=400,RangeValue=24.0)
    MechanicalRanges(5)=(Range=500,RangeValue=32.0)
    MechanicalRanges(6)=(Range=600,RangeValue=40.0)
    MechanicalRanges(7)=(Range=700,RangeValue=50.0)
    MechanicalRanges(8)=(Range=800,RangeValue=60.0)
    MechanicalRanges(9)=(Range=900,RangeValue=70.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=80.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=90.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=100.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=112.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=124.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=136.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=148.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=160.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=172.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=184.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=196.0)
    MechanicalRanges(21)=(Range=2200,RangeValue=208.0)
    MechanicalRanges(22)=(Range=2400,RangeValue=220.0)
    MechanicalRanges(23)=(Range=2600,RangeValue=232.0)
    MechanicalRanges(24)=(Range=2800,RangeValue=244.0)
    MechanicalRanges(25)=(Range=3000,RangeValue=256.0)
    MechanicalRanges(26)=(Range=3200,RangeValue=268.0)
    MechanicalRanges(27)=(Range=3400,RangeValue=280.0)
    MechanicalRanges(28)=(Range=3600,RangeValue=292.0)
    MechanicalRanges(29)=(Range=3800,RangeValue=304.0)
    MechanicalRanges(30)=(Range=4000,RangeValue=316.0)
}
