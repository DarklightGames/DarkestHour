//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ShermanM4A176WCannonShell extends DHCannonShell;

defaultproperties
{
    DHPenetrationTable(0)=12.5
    DHPenetrationTable(1)=12.1
    DHPenetrationTable(2)=11.6
    DHPenetrationTable(3)=11.1
    DHPenetrationTable(4)=10.6
    DHPenetrationTable(5)=10.1
    DHPenetrationTable(6)=9.7
    DHPenetrationTable(7)=9.3
    DHPenetrationTable(8)=8.9
    DHPenetrationTable(9)=8.7
    DHPenetrationTable(10)=7.4
    ShellDiameter=7.62
    bShatterProne=true
    ShellImpactDamage=class'DH_Vehicles.DH_ShermanM4A176WCannonShellDamageAP'
    ImpactDamage=580
    BallisticCoefficient=1.627
    Speed=47799.0
    MaxSpeed=47799.0
    Tag="M62 APC"
}
