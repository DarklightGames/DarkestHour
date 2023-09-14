//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JagdpanzerIVL48CannonShellSmoke extends DHCannonShellSmoke;

defaultproperties
{
    Speed=33073.0
    MaxSpeed=33073.0
    ShellDiameter=7.5
    BallisticCoefficient=2.1

    //Effects
    CoronaClass=class'DH_Effects.DHShellTracer_OrangeLarge'
    ShellTrailClass=class'DH_Effects.DHShellTrail_YellowOrange'

    bDebugInImperial=false

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
    MechanicalRanges(21)=(Range=2200,RangeValue=528.0)
    MechanicalRanges(22)=(Range=2400,RangeValue=588.0)
    MechanicalRanges(23)=(Range=2600,RangeValue=648.0)
    MechanicalRanges(24)=(Range=2800,RangeValue=708.0)
    MechanicalRanges(25)=(Range=3000,RangeValue=768.0)
    bMechanicalAiming=true
}
