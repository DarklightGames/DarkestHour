//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_JacksonCannonShellAP extends DHCannonShell;

defaultproperties
{
    DHPenetrationTable(0)=18.8
    DHPenetrationTable(1)=17.9
    DHPenetrationTable(2)=16.3
    DHPenetrationTable(3)=15.0
    DHPenetrationTable(4)=13.7
    DHPenetrationTable(5)=12.5
    DHPenetrationTable(6)=11.5
    DHPenetrationTable(7)=10.5
    DHPenetrationTable(8)=9.6
    DHPenetrationTable(9)=8.1
    DHPenetrationTable(10)=6.8
    ShellDiameter=9.0
    ShellImpactDamage=class'DH_Vehicles.DH_JacksonCannonShellDamageAPShot'
    ImpactDamage=625
    BallisticCoefficient=1.564
    Speed=49609.0
    MaxSpeed=49609.0
    Tag="M77 AP"
}
