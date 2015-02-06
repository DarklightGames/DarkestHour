//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ShermanCannonShellHE extends DH_ROTankCannonShellHE;

defaultproperties
{
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
    ShellImpactDamage=class'DH_Vehicles.DH_ShermanCannonShellDamageAP'
    ImpactDamage=475
    BallisticCoefficient=1.686000
    Speed=27943.000000
    MaxSpeed=27943.000000
    Damage=415.000000
    DamageRadius=1550.000000
    MyDamageType=class'DH_Vehicles.DH_ShermanCannonShellDamageHE'
    Tag="M48 HE"
}
