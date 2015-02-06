//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WolverineCannonShellHE extends DH_ROTankCannonShellHE;

defaultproperties
{
    DHPenetrationTable(0)=4.200000
    DHPenetrationTable(1)=3.800000
    DHPenetrationTable(2)=3.200000
    DHPenetrationTable(3)=2.900000
    DHPenetrationTable(4)=2.400000
    DHPenetrationTable(5)=2.000000
    DHPenetrationTable(6)=1.700000
    DHPenetrationTable(7)=1.300000
    DHPenetrationTable(8)=1.100000
    DHPenetrationTable(9)=1.000000
    DHPenetrationTable(10)=0.800000
    ShellDiameter=7.620000
    PenetrationMag=780.000000
    ShellImpactDamage=class'DH_Vehicles.DH_WolverineCannonShellDamageAP'
    ImpactDamage=450
    BallisticCoefficient=1.368000
    Speed=47799.000000
    MaxSpeed=47799.000000
    Damage=400.000000
    DamageRadius=1140.000000
    MyDamageType=class'DH_Vehicles.DH_WolverineCannonShellDamageHE'
    Tag="M42A1 HE"
}
