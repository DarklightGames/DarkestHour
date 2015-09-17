//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WolverineCannonShell extends DHCannonShell;

defaultproperties
{
    DHPenetrationTable(0)=12.4
    DHPenetrationTable(1)=12.1
    DHPenetrationTable(2)=11.5
    DHPenetrationTable(3)=10.9
    DHPenetrationTable(4)=10.3
    DHPenetrationTable(5)=9.8
    DHPenetrationTable(6)=9.3
    DHPenetrationTable(7)=8.8
    DHPenetrationTable(8)=8.4
    DHPenetrationTable(9)=7.6
    DHPenetrationTable(10)=6.8
    ShellDiameter=7.62
    bShatterProne=true
    ShellImpactDamage=class'DH_Vehicles.DH_ShermanM4A176WCannonShellDamageAP'
    ImpactDamage=580
    BallisticCoefficient=1.627
    Speed=47799.0
    MaxSpeed=47799.0
    Tag="M62 APC"
}
