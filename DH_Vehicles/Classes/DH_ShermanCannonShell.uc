//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ShermanCannonShell extends DH_ROTankCannonShell;

defaultproperties
{
    DHPenetrationTable(0)=8.800000
    DHPenetrationTable(1)=8.500000
    DHPenetrationTable(2)=8.100000
    DHPenetrationTable(3)=7.700000
    DHPenetrationTable(4)=7.300000
    DHPenetrationTable(5)=6.900000
    DHPenetrationTable(6)=6.500000
    DHPenetrationTable(7)=6.200000
    DHPenetrationTable(8)=5.900000
    DHPenetrationTable(9)=5.300000
    DHPenetrationTable(10)=4.700000
    ShellDiameter=7.500000
    ShellImpactDamage=class'DH_Vehicles.DH_ShermanCannonShellDamageAP'
    ImpactDamage=540
    BallisticCoefficient=1.735000
    Speed=37358.000000
    MaxSpeed=37358.000000
    Tag="M61 APC"
}
