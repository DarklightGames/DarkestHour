//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_CromwellCannonShellHE extends DH_ROTankCannonShellHE;

defaultproperties
{
    MechanicalRanges(0)=(RangeValue=16.000000)
    MechanicalRanges(1)=(Range=200,RangeValue=36.000000)
    MechanicalRanges(2)=(Range=400,RangeValue=68.000000)
    MechanicalRanges(3)=(Range=600,RangeValue=96.000000)
    MechanicalRanges(4)=(Range=800,RangeValue=136.000000)
    MechanicalRanges(5)=(Range=1000,RangeValue=176.000000)
    MechanicalRanges(6)=(Range=1200,RangeValue=228.000000)
    MechanicalRanges(7)=(Range=1400,RangeValue=292.000000)
    MechanicalRanges(8)=(Range=1600,RangeValue=352.000000)
    MechanicalRanges(9)=(Range=1800,RangeValue=412.000000)
    MechanicalRanges(10)=(Range=2000,RangeValue=476.000000)
    MechanicalRanges(11)=(Range=2200,RangeValue=556.000000)
    MechanicalRanges(12)=(Range=2400,RangeValue=640.000000)
    MechanicalRanges(13)=(Range=2600,RangeValue=726.000000)
    MechanicalRanges(14)=(Range=2800,RangeValue=828.000000)
    MechanicalRanges(15)=(Range=3000,RangeValue=938.000000)
    MechanicalRanges(16)=(Range=3200,RangeValue=1064.000000)
    bMechanicalAiming=true
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
    ShellDiameter=7.500000
    PenetrationMag=1000.000000
    ShellImpactDamage=class'DH_Vehicles.DH_CromwellCannonShellDamageAP'
    ImpactDamage=475
    BallisticCoefficient=1.686000
    Speed=27943.000000
    MaxSpeed=27943.000000
    Damage=415.000000
    DamageRadius=1550.000000
    MyDamageType=class'DH_Vehicles.DH_CromwellCannonShellDamageHE'
    Tag="M48 HE"
}
