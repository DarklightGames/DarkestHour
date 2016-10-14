//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_T3476CannonShell extends DHCannonShellAPBC;

defaultproperties
{
    ShellDiameter=7.62
    BallisticCoefficient=1.55
    Speed=39529 // 655 m/s
    MaxSpeed=39529
    ImpactDamage=580 // 350 in RO, but have matched to Sherman 76mm AP shell
    ShellImpactDamage=class'DH_Vehicles.DH_ShermanM4A176WCannonShellDamageAP'
    Tag="BR-350B" // standard mid-late war APBC shell
    bOpticalAiming=true
    bMechanicalAiming=true // TODO: investigate this (it's from RO), as this cannon does not have mech aiming

    DHPenetrationTable(0)=8.8
    DHPenetrationTable(1)=8.0
    DHPenetrationTable(2)=7.4
    DHPenetrationTable(3)=6.7
    DHPenetrationTable(4)=5.9
    DHPenetrationTable(5)=5.2
    DHPenetrationTable(6)=4.8
    DHPenetrationTable(7)=4.3
    DHPenetrationTable(8)=3.8
    DHPenetrationTable(9)=3.1
    DHPenetrationTable(10)=2.4

    OpticalRanges(0)=(Range=0,RangeValue=0.410)
    OpticalRanges(1)=(Range=200,RangeValue=0.417)
    OpticalRanges(2)=(Range=400,RangeValue=0.425)
    OpticalRanges(3)=(Range=600,RangeValue=0.432)
    OpticalRanges(4)=(Range=800,RangeValue=0.440)
    OpticalRanges(5)=(Range=1000,RangeValue=0.449)
    OpticalRanges(6)=(Range=1200,RangeValue=0.459)
    OpticalRanges(7)=(Range=1400,RangeValue=0.469)
    OpticalRanges(8)=(Range=1600,RangeValue=0.483)
    OpticalRanges(9)=(Range=1800,RangeValue=0.497)
    OpticalRanges(10)=(Range=2000,RangeValue=0.511)
    OpticalRanges(11)=(Range=2200,RangeValue=0.526)
    OpticalRanges(12)=(Range=2400,RangeValue=0.542)
    OpticalRanges(13)=(Range=2600,RangeValue=0.560)
    OpticalRanges(14)=(Range=2800,RangeValue=0.5785)
    OpticalRanges(15)=(Range=3000,RangeValue=0.596)
    OpticalRanges(16)=(Range=3200,RangeValue=0.616)
    OpticalRanges(17)=(Range=3400,RangeValue=0.638)
    OpticalRanges(18)=(Range=3600,RangeValue=0.660)
    OpticalRanges(19)=(Range=3800,RangeValue=0.680)
    OpticalRanges(20)=(Range=4000,RangeValue=0.703)
    OpticalRanges(21)=(Range=4200,RangeValue=0.725)
    OpticalRanges(22)=(Range=4400,RangeValue=0.746)
    OpticalRanges(23)=(Range=4600,RangeValue=0.768)
    OpticalRanges(24)=(Range=4800,RangeValue=0.791)
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
    // RO TODO - dial in the rest of these ranges
    MechanicalRanges(21)=(Range=4200,RangeValue=0)
    MechanicalRanges(22)=(Range=4400,RangeValue=0)
    MechanicalRanges(23)=(Range=4600,RangeValue=0)
    MechanicalRanges(24)=(Range=4800,RangeValue=0)
    MechanicalRanges(25)=(Range=5000,RangeValue=0)
}
