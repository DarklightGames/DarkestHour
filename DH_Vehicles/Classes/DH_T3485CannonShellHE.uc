//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_T3485CannonShellHE extends DHCannonShellHE;

defaultproperties
{
    // Have changed several damage & similar properties to broadly comparable DH HE shells, as the RO values were at odds with them
    ShellDiameter=7.62
    BallisticCoefficient=1.55
    Speed=39832.0 // 660 m/s
    MaxSpeed=39832.0
    Damage=430.0 // 350 in RO
    DamageRadius=1300.0 // 750 in RO
    ImpactDamage=510 // 200 in RO
    ShellImpactDamage=class'DH_Vehicles.DH_ShermanM4A176WCannonShellDamageAP'
    PenetrationMag=1000.0
    Tag="O-365"

    DHPenetrationTable(0)=4.0
    DHPenetrationTable(1)=3.8
    DHPenetrationTable(2)=3.4
    DHPenetrationTable(3)=3.1
    DHPenetrationTable(4)=2.8
    DHPenetrationTable(5)=2.5
    DHPenetrationTable(6)=2.2
    DHPenetrationTable(7)=1.9
    DHPenetrationTable(8)=1.6
    DHPenetrationTable(9)=1.2
    DHPenetrationTable(10)=0.8

    bMechanicalAiming=true
    MechanicalRanges(0)=(Range=0,RangeValue=0.0)
    MechanicalRanges(1)=(Range=400,RangeValue=35.0)
    MechanicalRanges(2)=(Range=500,RangeValue=45.0)
    MechanicalRanges(3)=(Range=600,RangeValue=55.0)
    MechanicalRanges(4)=(Range=700,RangeValue=65.0)
    MechanicalRanges(5)=(Range=800,RangeValue=75.0)
    MechanicalRanges(6)=(Range=900,RangeValue=85.0)
    MechanicalRanges(7)=(Range=1000,RangeValue=96.0)
    MechanicalRanges(8)=(Range=1200,RangeValue=117.0)
    MechanicalRanges(9)=(Range=1400,RangeValue=139.0)
    MechanicalRanges(10)=(Range=1600,RangeValue=168.0)
    MechanicalRanges(11)=(Range=1800,RangeValue=199.0)
    MechanicalRanges(12)=(Range=2000,RangeValue=226.0)
    MechanicalRanges(13)=(Range=2200,RangeValue=256.0)
    MechanicalRanges(14)=(Range=2400,RangeValue=290.0)
    MechanicalRanges(15)=(Range=2600,RangeValue=327.0)
    MechanicalRanges(16)=(Range=2800,RangeValue=365.0)
    MechanicalRanges(17)=(Range=3000,RangeValue=403.0)
    MechanicalRanges(18)=(Range=3200,RangeValue=449.0)
    MechanicalRanges(19)=(Range=3400,RangeValue=495.0)
    MechanicalRanges(20)=(Range=3600,RangeValue=540.0)
    MechanicalRanges(21)=(Range=3800,RangeValue=592.0)

    bOpticalAiming=true // just a visual range indicator on the side; doesn't actually alter the aiming point
    OpticalRanges(0)=(Range=0,RangeValue=0.369)
    OpticalRanges(1)=(Range=400,RangeValue=0.3565)
    OpticalRanges(2)=(Range=500,RangeValue=0.349)
    OpticalRanges(3)=(Range=600,RangeValue=0.343)
    OpticalRanges(4)=(Range=700,RangeValue=0.336)
    OpticalRanges(5)=(Range=800,RangeValue=0.3295)
    OpticalRanges(6)=(Range=900,RangeValue=0.323)
    OpticalRanges(7)=(Range=1000,RangeValue=0.3165)
    OpticalRanges(8)=(Range=1200,RangeValue=0.303)
    OpticalRanges(9)=(Range=1400,RangeValue=0.291)
    OpticalRanges(10)=(Range=1600,RangeValue=0.278)
    OpticalRanges(11)=(Range=1800,RangeValue=0.265)
    OpticalRanges(12)=(Range=2000,RangeValue=0.252)
    OpticalRanges(13)=(Range=2200,RangeValue=0.239)
    OpticalRanges(14)=(Range=2400,RangeValue=0.226)
    OpticalRanges(15)=(Range=2600,RangeValue=0.213)
    OpticalRanges(16)=(Range=2800,RangeValue=0.200)
    OpticalRanges(17)=(Range=3000,RangeValue=0.187)
    OpticalRanges(18)=(Range=3200,RangeValue=0.174)
    OpticalRanges(19)=(Range=3400,RangeValue=0.161)
    OpticalRanges(20)=(Range=3600,RangeValue=0.148)
    OpticalRanges(21)=(Range=3800,RangeValue=0.135)
}
