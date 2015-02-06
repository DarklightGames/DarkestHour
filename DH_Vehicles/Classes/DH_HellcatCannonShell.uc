//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_HellcatCannonShell extends DH_ROTankCannonShell;

defaultproperties
{
    DHPenetrationTable(0)=12.500000
    DHPenetrationTable(1)=12.100000
    DHPenetrationTable(2)=11.600000
    DHPenetrationTable(3)=11.100000
    DHPenetrationTable(4)=10.600000
    DHPenetrationTable(5)=10.100000
    DHPenetrationTable(6)=9.700000
    DHPenetrationTable(7)=9.300000
    DHPenetrationTable(8)=8.900000
    DHPenetrationTable(9)=8.700000
    DHPenetrationTable(10)=7.400000
    ShellDiameter=7.620000
    bShatterProne=true
    ShellImpactDamage=class'DH_Vehicles.DH_HellcatCannonShellDamageAP'
    ImpactDamage=580
    BallisticCoefficient=1.627000
    Speed=47799.000000
    MaxSpeed=47799.000000
    Tag="M62 APC"
}
