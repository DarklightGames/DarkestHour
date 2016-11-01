//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_T3476CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    // Have matched several damage & similar properties to Sherman 76mm HE shell, as the RO values were at odds with comparable DH shells
    ShellDiameter=7.62
    BallisticCoefficient=1.55
    Speed=39832.0 // 660 m/s
    MaxSpeed=39832.0
    Damage=400.0 // 350 in RO
    DamageRadius=1140.0 // 750 in RO
    ImpactDamage=450 // 200 in RO
    ShellImpactDamage=class'DH_Vehicles.DH_ShermanM4A176WCannonShellDamageAP'
    PenetrationMag=780.0 // 1000 in RO
    Tag="OF-350"

    DHPenetrationTable(0)=3.3
    DHPenetrationTable(1)=3.1
    DHPenetrationTable(2)=2.8
    DHPenetrationTable(3)=2.4
    DHPenetrationTable(4)=2.0
    DHPenetrationTable(5)=1.7
    DHPenetrationTable(6)=1.3
    DHPenetrationTable(7)=1.1
    DHPenetrationTable(8)=0.9
    DHPenetrationTable(9)=0.5
    DHPenetrationTable(10)=0.3

    bOpticalAiming=true
    OpticalRanges(0)=(Range=0,RangeValue=0.410)
    OpticalRanges(1)=(Range=200,RangeValue=0.418)
    OpticalRanges(2)=(Range=400,RangeValue=0.426)
    OpticalRanges(3)=(Range=600,RangeValue=0.4335)
    OpticalRanges(4)=(Range=800,RangeValue=0.443)
    OpticalRanges(5)=(Range=1000,RangeValue=0.4515)
    OpticalRanges(6)=(Range=1200,RangeValue=0.462)
    OpticalRanges(7)=(Range=1400,RangeValue=0.473)
    OpticalRanges(8)=(Range=1600,RangeValue=0.487)
    OpticalRanges(9)=(Range=1800,RangeValue=0.502)
    OpticalRanges(10)=(Range=2000,RangeValue=0.522)
    OpticalRanges(11)=(Range=2200,RangeValue=0.545)
    OpticalRanges(12)=(Range=2400,RangeValue=0.567)
    OpticalRanges(13)=(Range=2600,RangeValue=0.5925)
    OpticalRanges(14)=(Range=2800,RangeValue=0.620)
    OpticalRanges(15)=(Range=3000,RangeValue=0.649)
    OpticalRanges(16)=(Range=3200,RangeValue=0.680)
    OpticalRanges(17)=(Range=3400,RangeValue=0.711)
    OpticalRanges(18)=(Range=3600,RangeValue=0.744)
    OpticalRanges(19)=(Range=3800,RangeValue=0.778)
    OpticalRanges(20)=(Range=4000,RangeValue=0.813) // no range markings above 4000m for HE shell, so no adjustment beyond this
    OpticalRanges(21)=(Range=4200,RangeValue=0.813)
    OpticalRanges(22)=(Range=4400,RangeValue=0.813)
    OpticalRanges(23)=(Range=4600,RangeValue=0.813)
    OpticalRanges(24)=(Range=4800,RangeValue=0.813)
    OpticalRanges(25)=(Range=5000,RangeValue=0.813)

    bMechanicalAiming=true // this cannon doesn't actually have mechanical aiming, but believe this is a fudge to adjust for sight markings that are 'out'
    MechanicalRanges(0)=(Range=0,RangeValue=0.0)
    MechanicalRanges(1)=(Range=200,RangeValue=-15.0)
    MechanicalRanges(2)=(Range=400,RangeValue=-30.0)
    MechanicalRanges(3)=(Range=600,RangeValue=-40.0)
    MechanicalRanges(4)=(Range=800,RangeValue=-65.0)
    MechanicalRanges(5)=(Range=1000,RangeValue=-70.0)
    MechanicalRanges(6)=(Range=1200,RangeValue=-82.0)
    MechanicalRanges(7)=(Range=1400,RangeValue=-92.0)
    MechanicalRanges(8)=(Range=1600,RangeValue=-113.0)
    MechanicalRanges(9)=(Range=1800,RangeValue=-138.0)
    MechanicalRanges(10)=(Range=2000,RangeValue=-180.0)
    MechanicalRanges(11)=(Range=2200,RangeValue=-235.0)
    MechanicalRanges(12)=(Range=2400,RangeValue=-283.0)
    MechanicalRanges(13)=(Range=2600,RangeValue=-335.0)
    MechanicalRanges(14)=(Range=2800,RangeValue=-397.0)
    MechanicalRanges(15)=(Range=3000,RangeValue=-458.0)
    MechanicalRanges(16)=(Range=3200,RangeValue=-518.0)
    MechanicalRanges(17)=(Range=3400,RangeValue=-578.0)
    MechanicalRanges(18)=(Range=3600,RangeValue=-642.0)
    MechanicalRanges(19)=(Range=3800,RangeValue=-704.0)
    MechanicalRanges(20)=(Range=4000,RangeValue=-769.0)
    MechanicalRanges(21)=(Range=4200,RangeValue=-769.0)
    MechanicalRanges(22)=(Range=4400,RangeValue=-769.0)
    MechanicalRanges(23)=(Range=4600,RangeValue=-769.0)
    MechanicalRanges(24)=(Range=4800,RangeValue=-769.0)
    MechanicalRanges(25)=(Range=5000,RangeValue=-769.0)
}
