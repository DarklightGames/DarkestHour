//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_T3476CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    Tag="OF-350"
    ShellDiameter=7.62
    PenetrationMag=1000.000000
    //BB ShellImpactDamage=Class'DH_Vehicles.DH_T3476CannonShellDamageAP'
    ImpactDamage=475
    BallisticCoefficient=2.5
    Speed=39832 //660 M/S
    MaxSpeed=39832
    Damage=415.000000
    DamageRadius=1550.000000
    //BB MyDamageType=Class'DH_Vehicles.DH_T3476CannonShellDamageHE'

    bDebugBallistics=False
    bOpticalAiming=True
    bMechanicalAiming=True

    DHPenetrationTable(0)=3.300000
    DHPenetrationTable(1)=3.100000
    DHPenetrationTable(2)=2.800000
    DHPenetrationTable(3)=2.400000
    DHPenetrationTable(4)=2.000000
    DHPenetrationTable(5)=1.700000
    DHPenetrationTable(6)=1.300000
    DHPenetrationTable(7)=1.100000
    DHPenetrationTable(8)=0.900000
    DHPenetrationTable(9)=0.500000
    DHPenetrationTable(10)=0.300000

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
    OpticalRanges(20)=(Range=4000,RangeValue=0.813)
    OpticalRanges(21)=(Range=4200,RangeValue=0.813)
    OpticalRanges(22)=(Range=4400,RangeValue=0.813)
    OpticalRanges(23)=(Range=4600,RangeValue=0.813)
    OpticalRanges(24)=(Range=4800,RangeValue=0.813)
    OpticalRanges(25)=(Range=5000,RangeValue=0.813)

    MechanicalRanges(0)=(Range=0,RangeValue=0)
    MechanicalRanges(1)=(Range=200,RangeValue=0)
    MechanicalRanges(2)=(Range=400,RangeValue=0)
    MechanicalRanges(3)=(Range=600,RangeValue=0)
    MechanicalRanges(4)=(Range=800,RangeValue=0)
    MechanicalRanges(5)=(Range=1000,RangeValue=0)
    MechanicalRanges(6)=(Range=1200,RangeValue=0)
    MechanicalRanges(7)=(Range=1400,RangeValue=0)
    MechanicalRanges(8)=(Range=1600,RangeValue=0)
    MechanicalRanges(9)=(Range=1800,RangeValue=0)
    MechanicalRanges(10)=(Range=2000,RangeValue=0)
    MechanicalRanges(11)=(Range=2200,RangeValue=0)
    MechanicalRanges(12)=(Range=2400,RangeValue=0)
    MechanicalRanges(13)=(Range=2600,RangeValue=0)
    MechanicalRanges(14)=(Range=2800,RangeValue=0)
    MechanicalRanges(15)=(Range=3000,RangeValue=0)
    MechanicalRanges(16)=(Range=3200,RangeValue=0)
    MechanicalRanges(17)=(Range=3400,RangeValue=0)
    MechanicalRanges(18)=(Range=3600,RangeValue=0)
    MechanicalRanges(19)=(Range=3800,RangeValue=0)
    //Range below is an estimate because it hit the ceiling on the test map
    MechanicalRanges(20)=(Range=4000,RangeValue=0)
    // TODO - dial in the rest of these ranges
    MechanicalRanges(21)=(Range=4200,RangeValue=0)
    MechanicalRanges(22)=(Range=4400,RangeValue=0)
    MechanicalRanges(23)=(Range=4600,RangeValue=0)
    MechanicalRanges(24)=(Range=4800,RangeValue=0)
    MechanicalRanges(25)=(Range=5000,RangeValue=0)
}
