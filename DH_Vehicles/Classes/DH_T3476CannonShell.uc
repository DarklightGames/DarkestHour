//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_T3476CannonShell extends DHCannonShell;

defaultproperties
{
    MechanicalRanges(0)=(Range=0,RangeValue=0)
    MechanicalRanges(1)=(Range=200,RangeValue=0)
    MechanicalRanges(2)=(Range=400,RangeValue=0)
    MechanicalRanges(3)=(Range=600,RangeValue=0)
    MechanicalRanges(4)=(Range=800,RangeValue=0)
    MechanicalRanges(5)=(Range=1000,RangeValue=0)
    MechanicalRanges(6)=(Range=1200,RangeValue=0)
    MechanicalRanges(7)=(Range=1400,RangeValue=0)
    MechanicalRanges(8)=(Range=1600,RangeValue=0)
    MechanicalRanges(9)=(Range=1800,RangeValue=-110)
    MechanicalRanges(10)=(Range=2000,RangeValue=-125)
    MechanicalRanges(11)=(Range=2200,RangeValue=-150)
    MechanicalRanges(12)=(Range=2400,RangeValue=-160)
    MechanicalRanges(13)=(Range=2600,RangeValue=-173)
    MechanicalRanges(14)=(Range=2800,RangeValue=-200)
    MechanicalRanges(15)=(Range=3000,RangeValue=-195)
    MechanicalRanges(16)=(Range=3200,RangeValue=-205)
    MechanicalRanges(17)=(Range=3400,RangeValue=-215)
    MechanicalRanges(18)=(Range=3600,RangeValue=-225)
    MechanicalRanges(19)=(Range=3800,RangeValue=-235)
    MechanicalRanges(20)=(Range=4000,RangeValue=-245)
    // TODO - dial in the rest of these ranges
    MechanicalRanges(21)=(Range=4200,RangeValue=0)
    MechanicalRanges(22)=(Range=4400,RangeValue=0)
    MechanicalRanges(23)=(Range=4600,RangeValue=0)
    MechanicalRanges(24)=(Range=4800,RangeValue=0)
    MechanicalRanges(25)=(Range=5000,RangeValue=0)
    bMechanicalAiming=True
    DHPenetrationTable(0)=8.8  //100
    DHPenetrationTable(1)=8.0  //250
    DHPenetrationTable(2)=7.4  //500
    DHPenetrationTable(3)=6.7  //750
    DHPenetrationTable(4)=5.9  //1000
    DHPenetrationTable(5)=5.2  //1250
    DHPenetrationTable(6)=4.8  //1500
    DHPenetrationTable(7)=4.3  //1750
    DHPenetrationTable(8)=3.8  //2000
    DHPenetrationTable(9)=3.1  //2500
    DHPenetrationTable(10)=2.4 //3000
    ShellDiameter=7.62
    ImpactDamage=580
    BallisticCoefficient=2.5
    Speed=39529 //655 M/S
    MaxSpeed=39529
    Tag="BR-350B" //standard mid-late war APBC shell
}
