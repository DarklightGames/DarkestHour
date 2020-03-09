//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DH_LeIG18CannonShellHEAT extends DHCannonShellHEAT;

defaultproperties
{
    Speed=12674.0      // 210 m/s
    MaxSpeed=12674.0
    SpeedFudgeScale=1.0
    ShellDiameter=7.5
    BallisticCoefficient=2.1 //TODO: pls, check

    //Damage
    ImpactDamage=650 //same as Panzer III M HEAT
    Damage=450.0
    DamageRadius=200.0
    HullFireChance=50.0
    EngineFireChance=85.0

    bDebugInImperial=false

    //Penetration
    DHPenetrationTable(0)=7.5
    DHPenetrationTable(1)=7.5
    DHPenetrationTable(2)=7.5
    DHPenetrationTable(3)=7.5
    DHPenetrationTable(4)=7.5
    DHPenetrationTable(5)=7.5
    DHPenetrationTable(6)=7.5
    DHPenetrationTable(7)=7.5
    DHPenetrationTable(8)=7.5
    DHPenetrationTable(9)=7.5
    DHPenetrationTable(10)=7.5

    //Gunsight adjustments
    MechanicalRanges(1)=(Range=100,RangeValue=28.0)
    MechanicalRanges(2)=(Range=200,RangeValue=40.0)
    MechanicalRanges(3)=(Range=300,RangeValue=58.0)
    MechanicalRanges(4)=(Range=400,RangeValue=78.0)
    MechanicalRanges(5)=(Range=500,RangeValue=94.0)
    MechanicalRanges(6)=(Range=600,RangeValue=114.0)
    MechanicalRanges(7)=(Range=700,RangeValue=134.0)
    MechanicalRanges(8)=(Range=800,RangeValue=154.0)
    MechanicalRanges(9)=(Range=900,RangeValue=180.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=200.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=224.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=250.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=274.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=302.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=328.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=352.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=378.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=408.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=438.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=468.0)
    bMechanicalAiming=true
}
