//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_JacksonCannonShellHE extends DH_ROTankCannonShellHE;

defaultproperties
{
    DHPenetrationTable(0)=5.200000
    DHPenetrationTable(1)=4.900000
    DHPenetrationTable(2)=4.300000
    DHPenetrationTable(3)=4.000000
    DHPenetrationTable(4)=3.800000
    DHPenetrationTable(5)=3.200000
    DHPenetrationTable(6)=3.000000
    DHPenetrationTable(7)=2.700000
    DHPenetrationTable(8)=2.300000
    DHPenetrationTable(9)=1.900000
    DHPenetrationTable(10)=1.500000
    ShellDiameter=9.000000
    PenetrationMag=1020.000000
    ShellImpactDamage=class'DH_Vehicles.DH_JacksonCannonShellDamageAP'
    ImpactDamage=510
    BallisticCoefficient=1.790000
    Speed=49609.000000
    MaxSpeed=49609.000000
    Damage=450.000000
    DamageRadius=1570.000000
    MyDamageType=class'DH_Vehicles.DH_JacksonCannonShellDamageHE'
    Tag="M71 HE"
}
