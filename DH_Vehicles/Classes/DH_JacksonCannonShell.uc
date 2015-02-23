//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_JacksonCannonShell extends DH_ROTankCannonShell;

defaultproperties
{
    DHPenetrationTable(0)=16.9
    DHPenetrationTable(1)=16.799999
    DHPenetrationTable(2)=16.4
    DHPenetrationTable(3)=15.7
    DHPenetrationTable(4)=15.1
    DHPenetrationTable(5)=14.4
    DHPenetrationTable(6)=13.8
    DHPenetrationTable(7)=13.3
    DHPenetrationTable(8)=12.7
    DHPenetrationTable(9)=11.5
    DHPenetrationTable(10)=10.4
    ShellDiameter=9.0
    ShellImpactDamage=class'DH_Vehicles.DH_JacksonCannonShellDamageAP'
    ImpactDamage=700
    BallisticCoefficient=2.134
    Speed=49127.0
    MaxSpeed=49127.0
    Tag="M82 APC"
}
