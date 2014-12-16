//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_JacksonCannonShellHVAP extends DH_ROTankCannonShellHVAP; // Matt: extended DH_ROTankCannonShellHVAP90, but now a deprecated class

defaultproperties
{
    MechanicalRanges(1)=(Range=400)
    MechanicalRanges(2)=(Range=800)
    MechanicalRanges(3)=(Range=1200)
    MechanicalRanges(4)=(Range=1600)
    MechanicalRanges(5)=(Range=2000)
    MechanicalRanges(6)=(Range=2400)
    MechanicalRanges(7)=(Range=2800)
    MechanicalRanges(8)=(Range=3200)
    MechanicalRanges(9)=(Range=4200)
    bMechanicalAiming=true
    DHPenetrationTable(0)=30.600000
    DHPenetrationTable(1)=29.500000
    DHPenetrationTable(2)=27.799999
    DHPenetrationTable(3)=26.200001
    DHPenetrationTable(4)=24.600000
    DHPenetrationTable(5)=23.200001
    DHPenetrationTable(6)=21.799999
    DHPenetrationTable(7)=17.900000
    DHPenetrationTable(8)=14.700000
    DHPenetrationTable(9)=13.100000
    DHPenetrationTable(10)=11.800000
    ShellDiameter=9.000000
    ShellImpactDamage=class'DH_Vehicles.DH_JacksonCannonShellDamageHVAP'
    ImpactDamage=525
    BallisticCoefficient=1.564000
    SpeedFudgeScale=0.400000
    Speed=61619.000000
    MaxSpeed=61619.000000
    Tag="M304 HVAP"
}
