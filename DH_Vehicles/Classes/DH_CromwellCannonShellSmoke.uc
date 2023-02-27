//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_CromwellCannonShellSmoke extends DHCannonShellSmokeWP;

defaultproperties
{
    Speed=27943.0
    MaxSpeed=27943.0

    //Gunsight adjustment
    MechanicalRanges(0)=(RangeValue=16.0)
    MechanicalRanges(1)=(Range=200,RangeValue=36.0)
    MechanicalRanges(2)=(Range=400,RangeValue=68.0)
    MechanicalRanges(3)=(Range=600,RangeValue=96.0)
    MechanicalRanges(4)=(Range=800,RangeValue=136.0)
    MechanicalRanges(5)=(Range=1000,RangeValue=176.0)
    MechanicalRanges(6)=(Range=1200,RangeValue=228.0)
    MechanicalRanges(7)=(Range=1400,RangeValue=292.0)
    MechanicalRanges(8)=(Range=1600,RangeValue=352.0)
    MechanicalRanges(9)=(Range=1800,RangeValue=412.0)
    MechanicalRanges(10)=(Range=2000,RangeValue=476.0)
    MechanicalRanges(11)=(Range=2200,RangeValue=556.0)
    MechanicalRanges(12)=(Range=2400,RangeValue=640.0)
    MechanicalRanges(13)=(Range=2600,RangeValue=726.0)
    MechanicalRanges(14)=(Range=2800,RangeValue=828.0)
    MechanicalRanges(15)=(Range=3000,RangeValue=938.0)
    MechanicalRanges(16)=(Range=3200,RangeValue=1064.0)
    bMechanicalAiming=true
    DHPenetrationTable(0)=0.2
    DHPenetrationTable(1)=0.2
    DHPenetrationTable(2)=0.2
    DHPenetrationTable(3)=0.2
    DHPenetrationTable(4)=0.1
    ShellDiameter=7.5
    BallisticCoefficient=1.686
}
