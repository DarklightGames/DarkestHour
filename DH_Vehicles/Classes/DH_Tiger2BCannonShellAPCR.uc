//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Tiger2BCannonShellAPCR extends DHCannonShellAPDS;

defaultproperties

{
    Speed=68198.0
    MaxSpeed=68198.0
    SpeedFudgeScale=0.4
    ShellDiameter=8.8
    BallisticCoefficient=1.527 //TODO: find correct BC - this is grossly incorrect

    //Damage
    ImpactDamage=555
    HullFireChance=0.38
    EngineFireChance=0.7

    //Effects
    CoronaClass=class'DH_Effects.DHShellTracer_Orange'
    ShellTrailClass=class'DH_Effects.DHShellTrail_YellowOrange'

    bDebugInImperial=false

    //Penetration
    DHPenetrationTable(0)=29.9
    DHPenetrationTable(1)=29.8
    DHPenetrationTable(2)=29.6
    DHPenetrationTable(3)=27.6
    DHPenetrationTable(4)=26.9
    DHPenetrationTable(5)=24.4
    DHPenetrationTable(6)=22.1
    DHPenetrationTable(7)=21.3
    DHPenetrationTable(8)=19.4
    DHPenetrationTable(9)=18.3
    DHPenetrationTable(10)=17.6

    //Gunsight adjustments
    bMechanicalAiming=true
    MechanicalRanges(0)=(RangeValue=8.0)
    MechanicalRanges(1)=(Range=100,RangeValue=12.0)
    MechanicalRanges(2)=(Range=200,RangeValue=16.0)
    MechanicalRanges(3)=(Range=300,RangeValue=20.0)
    MechanicalRanges(4)=(Range=400,RangeValue=24.0)
    MechanicalRanges(5)=(Range=500,RangeValue=28.0)
    MechanicalRanges(6)=(Range=600,RangeValue=34.0)
    MechanicalRanges(7)=(Range=700,RangeValue=40.0)
    MechanicalRanges(8)=(Range=800,RangeValue=48.0)
    MechanicalRanges(9)=(Range=900,RangeValue=56.0)
    MechanicalRanges(10)=(Range=1000,RangeValue=60.0)
    MechanicalRanges(11)=(Range=1100,RangeValue=60.0)
    MechanicalRanges(12)=(Range=1200,RangeValue=68.0)
    MechanicalRanges(13)=(Range=1300,RangeValue=76.0)
    MechanicalRanges(14)=(Range=1400,RangeValue=82.0)
    MechanicalRanges(15)=(Range=1500,RangeValue=84.0)
    MechanicalRanges(16)=(Range=1600,RangeValue=92.0)
    MechanicalRanges(17)=(Range=1700,RangeValue=96.0)
    MechanicalRanges(18)=(Range=1800,RangeValue=102.0)
    MechanicalRanges(19)=(Range=1900,RangeValue=108.0)
    MechanicalRanges(20)=(Range=2000,RangeValue=114.0)
    MechanicalRanges(21)=(Range=2200,RangeValue=126.0)
    MechanicalRanges(22)=(Range=2400,RangeValue=144.0)
    MechanicalRanges(23)=(Range=2600,RangeValue=158.0)
    MechanicalRanges(24)=(Range=2800,RangeValue=180.0)
    MechanicalRanges(25)=(Range=3000,RangeValue=200.0)
    MechanicalRanges(26)=(Range=3200,RangeValue=222.0)
    MechanicalRanges(27)=(Range=3400,RangeValue=244.0)
    MechanicalRanges(28)=(Range=3600,RangeValue=262.0)
    MechanicalRanges(29)=(Range=3800,RangeValue=282.0)
    MechanicalRanges(30)=(Range=4000,RangeValue=304.0)
}
